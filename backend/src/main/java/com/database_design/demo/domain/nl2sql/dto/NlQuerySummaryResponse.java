package com.database_design.demo.domain.nl2sql.dto;

import com.database_design.demo.domain.nl2sql.entity.NlQuery;
import com.database_design.demo.domain.nl2sql.entity.NlQueryStatus;
import java.time.LocalDateTime;

/**
 * 사이드바 질문 내역의 한 줄. 결과 표는 항목을 고를 때 상세 API 로 받는다.
 */
public record NlQuerySummaryResponse(
        Long queryId,
        String question,
        NlQueryStatus status,
        LocalDateTime createdAt) {

    public static NlQuerySummaryResponse from(NlQuery query) {
        return new NlQuerySummaryResponse(query.getId(), query.getQuestion(), query.getStatus(), query.getCreatedAt());
    }
}
