package com.database_design.demo.domain.nl2sql.dto;

import java.util.List;
import java.util.Map;

/**
 * 자연어 질의 처리 결과.
 * rows 의 각 항목은 columns 순서를 유지하는 { 컬럼명: 값 } 형태다.
 *
 * @param queryId 질문 내역(nl_queries)에 저장된 id. 저장하지 못했으면 null 이고, 결과는 그대로 보여 준다.
 */
public record NlQueryResponse(
        String question,
        String sql,
        List<String> columns,
        List<Map<String, Object>> rows,
        int rowCount,
        Long queryId) {

    public NlQueryResponse withQueryId(Long queryId) {
        return new NlQueryResponse(question, sql, columns, rows, rowCount, queryId);
    }
}
