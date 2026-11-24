package com.database_design.demo.domain.nl2sql.client;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.content;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.jsonPath;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient.GeneratedQuery;
import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import java.util.List;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

/**
 * nl2sql(FastAPI) 로 나가는 요청 본문이 파이썬 QueryRequest 의 필드명과 맞는지 고정한다.
 * 파이썬은 snake_case(budget_min, budget_max)를 쓰고, 없는 값은 보내지 않아 기본값(None)을 쓰게 한다.
 */
class Nl2SqlClientTest {

    private static final String RESPONSE = """
            {"query":"SELECT 1","error":"","retry_count":1}
            """;

    private record Fixture(Nl2SqlClient client, MockRestServiceServer server) {
    }

    private Fixture newClient() {
        RestClient.Builder builder = RestClient.builder().baseUrl("http://nl2sql:8000");
        MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
        return new Fixture(new Nl2SqlClient(builder.build()), server);
    }

    @Test
    @DisplayName("프로그램과 예산을 주면 파이썬 필드명(snake_case)으로 함께 보낸다")
    void sendsProgramsAndBudgetInSnakeCase() {
        Fixture fixture = newClient();
        fixture.server()
                .expect(requestTo("http://nl2sql:8000/query"))
                .andExpect(method(HttpMethod.POST))
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.question").value("게임용 PC 견적 추천해줘"))
                .andExpect(jsonPath("$.programs[0]").value("배그"))
                .andExpect(jsonPath("$.programs[1]").value("롤"))
                .andExpect(jsonPath("$.budget_min").value(1_000_000))
                .andExpect(jsonPath("$.budget_max").value(1_500_000))
                // 자바 필드명이 그대로 나가면 파이썬이 조용히 무시하므로 없는지 확인한다.
                .andExpect(jsonPath("$.budgetMin").doesNotExist())
                .andExpect(jsonPath("$.budgetMax").doesNotExist())
                .andRespond(withSuccess(RESPONSE, MediaType.APPLICATION_JSON));

        GeneratedQuery generated = fixture.client().generate(new NlQueryRequest(
                "게임용 PC 견적 추천해줘", List.of("배그", "롤"), 1_000_000, 1_500_000));

        fixture.server().verify();
        assertThat(generated.isValid()).isTrue();
        assertThat(generated.retryCount()).isEqualTo(1);
    }

    @Test
    @DisplayName("질문만 주면 나머지 필드는 보내지 않는다")
    void sendsQuestionOnlyWhenNoConditions() {
        Fixture fixture = newClient();
        fixture.server()
                .expect(requestTo("http://nl2sql:8000/query"))
                .andExpect(method(HttpMethod.POST))
                .andExpect(jsonPath("$.question").value("가장 비싼 그래픽카드 알려줘"))
                .andExpect(jsonPath("$.programs").doesNotExist())
                .andExpect(jsonPath("$.budget_min").doesNotExist())
                .andExpect(jsonPath("$.budget_max").doesNotExist())
                .andRespond(withSuccess(RESPONSE, MediaType.APPLICATION_JSON));

        fixture.client().generate(new NlQueryRequest("가장 비싼 그래픽카드 알려줘"));

        fixture.server().verify();
    }

    @Test
    @DisplayName("프로그램 목록이 비어 있으면 programs 를 보내지 않는다")
    void omitsEmptyProgramList() {
        Fixture fixture = newClient();
        fixture.server()
                .expect(requestTo("http://nl2sql:8000/query"))
                .andExpect(jsonPath("$.programs").doesNotExist())
                .andExpect(jsonPath("$.budget_max").value(2_000_000))
                .andRespond(withSuccess(RESPONSE, MediaType.APPLICATION_JSON));

        fixture.client().generate(new NlQueryRequest("추천해줘", List.of(), null, 2_000_000));

        fixture.server().verify();
    }
}
