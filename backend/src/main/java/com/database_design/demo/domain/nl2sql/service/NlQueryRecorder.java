package com.database_design.demo.domain.nl2sql.service;

import com.database_design.demo.domain.modules.common.entity.ProductModule;
import com.database_design.demo.domain.modules.common.repository.ProductModuleRepository;
import com.database_design.demo.domain.nl2sql.dto.JudgeResult;
import com.database_design.demo.domain.nl2sql.dto.NlQueryResponse;
import com.database_design.demo.domain.nl2sql.entity.NlQuery;
import com.database_design.demo.domain.nl2sql.entity.NlQueryStatus;
import com.database_design.demo.domain.nl2sql.repository.NlQueryRepository;
import com.database_design.demo.domain.user.entity.User;
import com.database_design.demo.domain.user.repository.UserRepository;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import tools.jackson.databind.ObjectMapper;

/**
 * 질문 1건을 nl_queries 에 남긴다. 성공·실패 모두 저장한다.
 *
 * <p>질의는 읽기 전용 트랜잭션에서 실행되고 실패는 예외로 끝나므로, 기록은 그와 상관없이 커밋되도록 새 트랜잭션에서 한다.
 * 호출부는 기록 실패를 삼키고 응답을 그대로 돌려준다. 기록이 안 됐다고 사용자가 결과를 못 보면 안 된다.
 */
@Component
@RequiredArgsConstructor
public class NlQueryRecorder {

    private static final String MODULE_ID_COLUMN = "module_id";

    private final NlQueryRepository nlQueryRepository;
    private final UserRepository userRepository;
    private final ProductModuleRepository productModuleRepository;
    private final ObjectMapper objectMapper;

    /**
     * LLM 을 부르기 전에 유저를 확인한다. 없는 유저로 끝까지 돌린 뒤 저장에서 FK 로 실패하면 비용만 쓴다.
     * 비로그인(null)은 통과한다.
     */
    @Transactional(readOnly = true)
    public void requireUser(Long userId) {
        if (userId != null && !userRepository.existsById(userId)) {
            throw new BusinessException(ErrorCode.USER_NOT_FOUND);
        }
    }

    /** 성공한 질문. 결과 표를 스냅샷으로 남기고 결과에 나온 부품을 nl_query_modules 로 연결한다. */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Long recordSuccess(Long userId, String question, JudgeResult judged, int retryCount,
            NlQueryResponse response, int latencyMs) {
        String snapshot = objectMapper.writeValueAsString(ResultSnapshot.from(response));
        NlQuery query = NlQuery.success(userOrNull(userId), question, response.sql(), retryCount, snapshot,
                latencyMs);
        recordVerdict(query, judged);

        // IDENTITY 라 save 직후 id 가 있다. nl_query_modules 의 PK 에 query_id 가 들어가므로 저장 뒤에 연결한다.
        NlQuery saved = nlQueryRepository.save(query);
        linkModules(saved, response.rows());
        return saved.getId();
    }

    /** 실패한 질문. 생성 단계에서 실패했으면 sql 은 null 일 수 있다. */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public Long recordFailure(Long userId, String question, JudgeResult judged, NlQueryStatus status, String sql,
            int retryCount, String errorMessage, int latencyMs) {
        NlQuery query = NlQuery.failure(userOrNull(userId), question, status, sql, retryCount, errorMessage,
                latencyMs);
        recordVerdict(query, judged);
        return nlQueryRepository.save(query).getId();
    }

    private User userOrNull(Long userId) {
        return userId == null ? null : userRepository.getReferenceById(userId);
    }

    private void recordVerdict(NlQuery query, JudgeResult judged) {
        if (judged != null && !judged.skipped()) {
            query.recordVerdict(judged.verdict().key(), judged.confidenceAsDecimal());
        }
    }

    /**
     * 결과 행의 module_id 를 결과 순서대로 연결한다. 같은 부품은 처음 위치만 남는다.
     * AI 가 만든 SQL 이라 module_id 가 부품이 아닌 값일 수도 있어, 실제로 있는 부품만 연결한다.
     */
    private void linkModules(NlQuery query, List<Map<String, Object>> rows) {
        Map<Long, Integer> rowNoByModuleId = new LinkedHashMap<>();
        for (int i = 0; i < rows.size(); i++) {
            if (rows.get(i).get(MODULE_ID_COLUMN) instanceof Number id) {
                rowNoByModuleId.putIfAbsent(id.longValue(), i + 1);
            }
        }
        if (rowNoByModuleId.isEmpty()) {
            return;
        }

        Map<Long, ProductModule> modules = productModuleRepository.findAllById(rowNoByModuleId.keySet()).stream()
                .collect(Collectors.toMap(ProductModule::getId, Function.identity()));
        rowNoByModuleId.forEach((moduleId, rowNo) -> {
            ProductModule module = modules.get(moduleId);
            if (module != null) {
                query.addModule(module, rowNo);
            }
        });
    }
}
