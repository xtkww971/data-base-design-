package com.database_design.demo.domain.nl2sql.service;

import com.database_design.demo.domain.nl2sql.client.AnswerabilityJudgeClient;
import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient;
import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient.GeneratedQuery;
import com.database_design.demo.domain.nl2sql.dto.JudgeResult;
import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import com.database_design.demo.domain.nl2sql.dto.NlQueryResponse;
import com.database_design.demo.domain.nl2sql.entity.NlQueryStatus;
import com.database_design.demo.global.config.TypeSafeProperties;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Supplier;
import javax.sql.DataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.JdbcUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;

@Slf4j
@Service
public class Nl2SqlService {

    // LLM 이 만든 쿼리라 결과가 과도하게 커지거나 오래 걸리지 않도록 막는다.
    private static final int MAX_ROWS = 100;
    private static final int QUERY_TIMEOUT_SECONDS = 10;

    private final AnswerabilityJudgeClient judgeClient;
    private final Nl2SqlClient nl2SqlClient;
    private final TypeSafeProperties typeSafeProperties;
    private final NlQueryRecorder recorder;
    private final JdbcTemplate jdbcTemplate;
    // 생성된 SQL 만 읽기 전용 트랜잭션에서 돌린다. 질문 기록(NlQueryRecorder)은 쓰기라서 이 트랜잭션 밖에서 한다.
    private final TransactionTemplate readOnlyTransaction;

    public Nl2SqlService(AnswerabilityJudgeClient judgeClient, Nl2SqlClient nl2SqlClient,
            TypeSafeProperties typeSafeProperties, NlQueryRecorder recorder, DataSource dataSource,
            PlatformTransactionManager transactionManager) {
        this.judgeClient = judgeClient;
        this.nl2SqlClient = nl2SqlClient;
        this.typeSafeProperties = typeSafeProperties;
        this.recorder = recorder;
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcTemplate.setMaxRows(MAX_ROWS);
        this.jdbcTemplate.setQueryTimeout(QUERY_TIMEOUT_SECONDS);
        this.readOnlyTransaction = new TransactionTemplate(transactionManager);
        this.readOnlyTransaction.setReadOnly(true);
    }

    /**
     * 자연어 질문을 판정해 걸러낸 뒤, nl2sql 서비스로 SQL 변환하고 실행해 결과를 돌려준다.
     * nl2sql 쪽에서 SELECT/WITH 만 통과시키지만, 한 번 더 막기 위해 읽기 전용 트랜잭션에서 실행한다.
     *
     * <p>질문은 성공·실패 모두 nl_queries 에 남긴다(거절, 생성 실패, 실행 실패).
     * nl2sql 서버 장애(NL2SQL_UNAVAILABLE)는 질문의 성질이 아니라서 남기지 않는다.
     */
    public NlQueryResponse query(NlQueryRequest request) {
        long startedAt = System.nanoTime();
        recorder.requireUser(request.userId());

        // 판정이 가장 앞에 있어서, 거절되는 질문은 nl2sql 호출도 벡터 검색도 일어나지 않는다.
        JudgeResult judged = judgeClient.judge(request);
        Optional<ErrorCode> rejection = rejection(request, judged);
        if (rejection.isPresent()) {
            recordFailure(request, judged, NlQueryStatus.UNANSWERABLE, null, 0, rejection.get().name(), startedAt);
            throw new BusinessException(rejection.get());
        }

        // 아래 로그들은 실험 기록용이다(tools/nl2sql_eval.py 가 읽는다). 생성과 실행 시간을 나눠 보고,
        // 실패했을 때 어떤 SQL 이었는지 남긴다. SQL 은 여러 줄일 수 있어 항상 메시지 끝에 둔다.
        long generationStartedAt = System.nanoTime();
        GeneratedQuery generated = generate(request, judged, startedAt);
        long generationMs = elapsedMs(generationStartedAt);

        if (!generated.isValid()) {
            log.warn("SQL 생성 실패 (retry_count={} latency={}ms): {}",
                    generated.retryCount(), generationMs, generated.error());
            log.warn("생성에 실패한 마지막 SQL: {}", isBlank(generated.query()) ? "(없음)" : generated.query());
            recordFailure(request, judged, NlQueryStatus.GENERATION_FAILED,
                    isBlank(generated.query()) ? null : generated.query(), generated.retryCount(),
                    generated.error(), startedAt);
            throw new BusinessException(ErrorCode.NL2SQL_GENERATION_FAILED);
        }

        String sql = stripTrailingSemicolon(generated.query());
        // 로그만 보고도 어떤 질문의 SQL 인지 알 수 있게 질문을 함께 남긴다. SQL 은 여러 줄일 수 있어 맨 끝에 둔다.
        log.info("SQL 생성 완료 retry_count={} latency={}ms question={} sql={}",
                generated.retryCount(), generationMs, request.question(), sql);

        long executionStartedAt = System.nanoTime();
        NlQueryResponse response;
        try {
            response = readOnlyTransaction.execute(status -> execute(request.question(), sql));
        } catch (DataAccessException e) {
            log.warn("생성된 SQL 실행 실패 (latency={}ms): {}", elapsedMs(executionStartedAt), sql, e);
            recordFailure(request, judged, NlQueryStatus.EXECUTION_FAILED, sql, generated.retryCount(),
                    e.getMostSpecificCause().getMessage(), startedAt);
            throw new BusinessException(ErrorCode.NL2SQL_EXECUTION_FAILED);
        }
        log.info("SQL 실행 완료 rows={} latency={}ms", response.rowCount(), elapsedMs(executionStartedAt));

        NlQueryResponse finalResponse = response;
        Long queryId = record(() -> recorder.recordSuccess(request.userId(), request.question(), judged,
                generated.retryCount(), finalResponse, (int) elapsedMs(startedAt)));
        return response.withQueryId(queryId);
    }

    private NlQueryResponse execute(String question, String sql) {
        return jdbcTemplate.query(sql, rs -> {
            ResultSetMetaData meta = rs.getMetaData();
            List<String> columns = new ArrayList<>();
            for (int i = 1; i <= meta.getColumnCount(); i++) {
                columns.add(JdbcUtils.lookupColumnName(meta, i));
            }

            List<Map<String, Object>> rows = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= columns.size(); i++) {
                    row.put(columns.get(i - 1), JdbcUtils.getResultSetValue(rs, i));
                }
                rows.add(row);
            }
            return new NlQueryResponse(question, sql, columns, rows, rows.size(), null);
        });
    }

    /**
     * nl2sql 이 5xx 를 돌려주면 클라이언트가 NL2SQL_GENERATION_FAILED 로 바꿔 던진다. 질문 탓일 수 있어 기록한다.
     * 연결 실패(NL2SQL_UNAVAILABLE)는 질문과 무관한 장애라 기록하지 않는다.
     */
    private GeneratedQuery generate(NlQueryRequest request, JudgeResult judged, long startedAt) {
        try {
            return nl2SqlClient.generate(request);
        } catch (BusinessException e) {
            if (e.getErrorCode() == ErrorCode.NL2SQL_GENERATION_FAILED) {
                recordFailure(request, judged, NlQueryStatus.GENERATION_FAILED, null, 0,
                        "nl2sql 서비스가 오류를 반환했습니다.", startedAt);
            }
            throw e;
        }
    }

    /**
     * 조회로 답할 수 없는 질문을 SQL 생성 전에 끊는다 (ADR 0004). 끊어야 하면 안내할 에러 코드를 돌려준다.
     *
     * <p>거절은 판정이 {@code answerable} 이 아니고 확신도가 임계값 이상일 때만 한다.
     * 확신이 낮거나 판정하지 못했으면 그냥 생성해 본다. 오거절이 이 기능의 가장 큰 위험이다.
     */
    private Optional<ErrorCode> rejection(NlQueryRequest request, JudgeResult judged) {
        if (!judged.shouldReject(typeSafeProperties.confidenceThreshold())) {
            return Optional.empty();
        }

        // shouldReject 가 rejectable 판정만 통과시키므로 문구는 항상 있다.
        Optional<ErrorCode> errorCode = judged.verdict().errorCode();
        if (errorCode.isEmpty()) {
            log.warn("안내 문구가 없는 판정이라 거절하지 않습니다. verdict={}", judged.verdict().key());
            return Optional.empty();
        }

        // 오거절 점검용. 옳은 거절인지 기록만으로는 알 수 없어 질문을 함께 남긴다.
        log.info("판정으로 거절했습니다. verdict={} confidence={} question={}",
                judged.verdict().key(), judged.confidence(), request.question());
        return errorCode;
    }

    private void recordFailure(NlQueryRequest request, JudgeResult judged, NlQueryStatus status, String sql,
            int retryCount, String errorMessage, long startedAt) {
        record(() -> recorder.recordFailure(request.userId(), request.question(), judged, status, sql, retryCount,
                errorMessage, (int) elapsedMs(startedAt)));
    }

    /** 기록에 실패해도 사용자 응답은 그대로 보낸다. 저장된 id 를 돌려주고, 실패했으면 null. */
    private Long record(Supplier<Long> recording) {
        try {
            return recording.get();
        } catch (RuntimeException e) {
            log.warn("질문 내역을 저장하지 못했습니다.", e);
            return null;
        }
    }

    private String stripTrailingSemicolon(String sql) {
        String trimmed = sql.strip();
        return trimmed.endsWith(";") ? trimmed.substring(0, trimmed.length() - 1) : trimmed;
    }

    private static boolean isBlank(String value) {
        return value == null || value.isBlank();
    }

    private static long elapsedMs(long startedAtNanos) {
        return (System.nanoTime() - startedAtNanos) / 1_000_000;
    }
}
