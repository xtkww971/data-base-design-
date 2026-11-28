package com.database_design.demo.domain.nl2sql.service;

import com.database_design.demo.domain.nl2sql.client.AnswerabilityJudgeClient;
import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient;
import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient.GeneratedQuery;
import com.database_design.demo.domain.nl2sql.dto.JudgeResult;
import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import com.database_design.demo.domain.nl2sql.dto.NlQueryResponse;
import com.database_design.demo.global.config.TypeSafeProperties;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import javax.sql.DataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.JdbcUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
public class Nl2SqlService {

    // LLM 이 만든 쿼리라 결과가 과도하게 커지거나 오래 걸리지 않도록 막는다.
    private static final int MAX_ROWS = 100;
    private static final int QUERY_TIMEOUT_SECONDS = 10;

    private final AnswerabilityJudgeClient judgeClient;
    private final Nl2SqlClient nl2SqlClient;
    private final TypeSafeProperties typeSafeProperties;
    private final JdbcTemplate jdbcTemplate;

    public Nl2SqlService(AnswerabilityJudgeClient judgeClient, Nl2SqlClient nl2SqlClient,
            TypeSafeProperties typeSafeProperties, DataSource dataSource) {
        this.judgeClient = judgeClient;
        this.nl2SqlClient = nl2SqlClient;
        this.typeSafeProperties = typeSafeProperties;
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcTemplate.setMaxRows(MAX_ROWS);
        this.jdbcTemplate.setQueryTimeout(QUERY_TIMEOUT_SECONDS);
    }

    /**
     * 자연어 질문을 판정해 걸러낸 뒤, nl2sql 서비스로 SQL 변환하고 실행해 결과를 돌려준다.
     * nl2sql 쪽에서 SELECT/WITH 만 통과시키지만, 한 번 더 막기 위해 읽기 전용 트랜잭션에서 실행한다.
     */
    @Transactional(readOnly = true)
    public NlQueryResponse query(NlQueryRequest request) {
        // 판정이 가장 앞에 있어서, 거절되는 질문은 nl2sql 호출도 벡터 검색도 일어나지 않는다.
        rejectIfUnanswerable(request);

        GeneratedQuery generated = nl2SqlClient.generate(request);

        if (!generated.isValid()) {
            log.warn("SQL 생성 실패 (retry_count={}): {}", generated.retryCount(), generated.error());
            throw new BusinessException(ErrorCode.NL2SQL_GENERATION_FAILED);
        }

        String sql = stripTrailingSemicolon(generated.query());
        try {
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
                return new NlQueryResponse(request.question(), sql, columns, rows, rows.size());
            });
        } catch (DataAccessException e) {
            log.warn("생성된 SQL 실행 실패: {}", sql, e);
            throw new BusinessException(ErrorCode.NL2SQL_EXECUTION_FAILED);
        }
    }

    /**
     * 조회로 답할 수 없는 질문을 SQL 생성 전에 끊는다 (ADR 0004).
     *
     * <p>거절은 판정이 {@code answerable} 이 아니고 확신도가 임계값 이상일 때만 한다.
     * 확신이 낮거나 판정하지 못했으면 그냥 생성해 본다. 오거절이 이 기능의 가장 큰 위험이다.
     */
    private void rejectIfUnanswerable(NlQueryRequest request) {
        JudgeResult judged = judgeClient.judge(request);
        if (!judged.shouldReject(typeSafeProperties.confidenceThreshold())) {
            return;
        }

        Optional<ErrorCode> errorCode = judged.verdict().errorCode();
        if (errorCode.isEmpty()) {
            // 거절 판정에는 항상 문구가 붙어 있어야 한다. 없으면 보여 줄 말이 없으므로 거절하지 않는다.
            log.warn("안내 문구가 없는 판정이라 거절하지 않습니다. verdict={}", judged.verdict().key());
            return;
        }

        // 오거절 점검용. 옳은 거절인지 기록만으로는 알 수 없어 질문을 함께 남긴다.
        log.info("판정으로 거절했습니다. verdict={} confidence={} question={}",
                judged.verdict().key(), judged.confidence(), request.question());
        throw new BusinessException(errorCode.get());
    }

    private String stripTrailingSemicolon(String sql) {
        String trimmed = sql.strip();
        return trimmed.endsWith(";") ? trimmed.substring(0, trimmed.length() - 1) : trimmed;
    }
}
