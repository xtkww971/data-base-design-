package com.database_design.demo.domain.nl2sql.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.database_design.demo.domain.nl2sql.dto.NlQueryResponse;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import tools.jackson.databind.ObjectMapper;
import tools.jackson.databind.json.JsonMapper;

/**
 * 질문 내역을 다시 열었을 때 처음 응답과 같은 표가 나와야 한다.
 */
class ResultSnapshotTest {

    private final ObjectMapper objectMapper = JsonMapper.builder().build();

    @Test
    @DisplayName("저장한 스냅샷을 되돌리면 컬럼 순서와 값이 처음 응답과 같다")
    void roundTrip() {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("module_id", 3L);
        row.put("name", "Ryzen 5 7600");
        row.put("price", new BigDecimal("259000"));
        row.put("has_graphics", true);
        row.put("socket", null);
        NlQueryResponse original = new NlQueryResponse("질문", "SELECT 1",
                List.of("module_id", "name", "price", "has_graphics", "socket"), List.of(row), 1, null);

        String json = objectMapper.writeValueAsString(ResultSnapshot.from(original));
        NlQueryResponse restored = objectMapper.readValue(json, ResultSnapshot.class)
                .toResponse("질문", "SELECT 1", 10L);

        // 행은 컬럼 이름 없이 값 배열로 저장한다.
        assertThat(json).contains("\"rows\":[[3,\"Ryzen 5 7600\",259000,true,null]]");
        assertThat(restored.columns()).isEqualTo(original.columns());
        assertThat(restored.rows().get(0).keySet()).containsExactly("module_id", "name", "price", "has_graphics",
                "socket");
        assertThat(restored.rows().get(0)).containsEntry("name", "Ryzen 5 7600").containsEntry("socket", null);
        assertThat(restored.rowCount()).isEqualTo(1);
        assertThat(restored.queryId()).isEqualTo(10L);
    }

    @Test
    @DisplayName("결과가 0행이어도 컬럼은 남는다")
    void emptyResult() {
        NlQueryResponse original = new NlQueryResponse("질문", "SELECT 1", List.of("name"), List.of(), 0, null);

        NlQueryResponse restored = objectMapper.readValue(
                objectMapper.writeValueAsString(ResultSnapshot.from(original)), ResultSnapshot.class)
                .toResponse("질문", "SELECT 1", 1L);

        assertThat(restored.columns()).containsExactly("name");
        assertThat(restored.rows()).isEmpty();
    }
}
