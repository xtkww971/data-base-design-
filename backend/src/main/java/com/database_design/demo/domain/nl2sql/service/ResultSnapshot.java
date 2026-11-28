package com.database_design.demo.domain.nl2sql.service;

import com.database_design.demo.domain.nl2sql.dto.NlQueryResponse;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * nl_queries.result_snapshot 에 저장하는 결과 표. { "columns": [...], "rows": [[...], ...] } 형태다.
 * 행마다 컬럼 이름을 반복하지 않으려고 값만 columns 순서대로 담는다.
 */
record ResultSnapshot(List<String> columns, List<List<Object>> rows) {

    static ResultSnapshot from(NlQueryResponse response) {
        List<List<Object>> rows = new ArrayList<>(response.rows().size());
        for (Map<String, Object> row : response.rows()) {
            List<Object> values = new ArrayList<>(response.columns().size());
            for (String column : response.columns()) {
                values.add(row.get(column));
            }
            rows.add(values);
        }
        return new ResultSnapshot(response.columns(), rows);
    }

    /** POST /query 응답과 같은 { 컬럼명: 값 } 행으로 되돌린다. */
    NlQueryResponse toResponse(String question, String sql, Long queryId) {
        List<Map<String, Object>> restored = new ArrayList<>(rows.size());
        for (List<Object> values : rows) {
            Map<String, Object> row = new LinkedHashMap<>();
            for (int i = 0; i < columns.size(); i++) {
                row.put(columns.get(i), i < values.size() ? values.get(i) : null);
            }
            restored.add(row);
        }
        return new NlQueryResponse(question, sql, columns, restored, restored.size(), queryId);
    }
}
