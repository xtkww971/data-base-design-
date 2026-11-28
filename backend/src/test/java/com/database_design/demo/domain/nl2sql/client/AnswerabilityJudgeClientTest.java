package com.database_design.demo.domain.nl2sql.client;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.content;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.header;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.jsonPath;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withServerError;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withStatus;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;

import com.database_design.demo.domain.nl2sql.dto.JudgeResult;
import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import com.database_design.demo.domain.nl2sql.dto.Verdict;
import com.database_design.demo.global.config.TypeSafeProperties;
import java.time.Duration;
import java.util.List;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

/**
 * 판정 호출의 요청 본문과 fail-open 동작을 고정한다.
 *
 * <p>state 의 필드 이름은 judge-criteria.yml 의 백틱 경로와 짝이라 바뀌면 판정 기준이 가리키는
 * 값이 사라진다. fail-open 은 판정이 안 될 때 질의가 막히지 않는다는 이 기능의 전제다.
 */
class AnswerabilityJudgeClientTest {

    private static final String BASE_URL = "https://api.typesafe.ai";
    private static final ResourceLoader RESOURCE_LOADER = new DefaultResourceLoader();

    private static final String ANSWERABLE_RESPONSE = """
            {"model":"jev-1.14.0",
             "answers":{"verdict":{"type":"choice","choice":"answerable","confidence":0.94,
                        "probabilities":{"answerable":0.94,"out_of_scope":0.02}}},
             "usage":{"input_tokens":812,"output_tokens":4}}
            """;

    private record Fixture(AnswerabilityJudgeClient client, MockRestServiceServer server) {
    }

    private static TypeSafeProperties properties(String apiKey) {
        return new TypeSafeProperties(apiKey, BASE_URL, "jev-1.14.0",
                Duration.ofSeconds(1), Duration.ofSeconds(1), 0.7,
                "classpath:nl2sql/judge-criteria.yml", "classpath:nl2sql/schema-summary.txt");
    }

    private static Fixture newClient(String apiKey) {
        TypeSafeProperties properties = properties(apiKey);
        RestClient.Builder builder = RestClient.builder().baseUrl(BASE_URL);
        MockRestServiceServer server = MockRestServiceServer.bindTo(builder).build();
        JudgeCriteria criteria = new JudgeCriteria(RESOURCE_LOADER, properties);
        return new Fixture(
                new AnswerabilityJudgeClient(builder.build(), properties, criteria, RESOURCE_LOADER),
                server);
    }

    @Test
    @DisplayName("질문과 스키마 요약, 기준 파일의 questions 를 그대로 보낸다")
    void sendsStateAndCriteria() {
        Fixture fixture = newClient("test-key");
        fixture.server()
                .expect(requestTo(BASE_URL + "/v1/systemone"))
                .andExpect(method(HttpMethod.POST))
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(header("Authorization", "Bearer test-key"))
                .andExpect(jsonPath("$.model").value("jev-1.14.0"))
                .andExpect(jsonPath("$.state.question").value("30만원 이하 CPU 알려줘"))
                // 기준 파일이 `schema` 로 가리키는 값. 비어 있으면 판정 근거가 사라진다.
                .andExpect(jsonPath("$.state.schema").exists())
                // users 는 요약에서 뺐다.
                .andExpect(jsonPath("$.state.schema").value(
                        org.hamcrest.Matchers.not(org.hamcrest.Matchers.containsString("users:"))))
                .andExpect(jsonPath("$.questions.verdict.type").value("choice"))
                .andExpect(jsonPath("$.questions.verdict.criteria.answerable").exists())
                .andExpect(jsonPath("$.questions.verdict.criteria.recommendation").exists())
                .andRespond(withSuccess(ANSWERABLE_RESPONSE, MediaType.APPLICATION_JSON));

        JudgeResult result = fixture.client().judge(new NlQueryRequest("30만원 이하 CPU 알려줘"));

        fixture.server().verify();
        assertThat(result.skipped()).isFalse();
        assertThat(result.verdict()).isEqualTo(Verdict.ANSWERABLE);
        assertThat(result.confidence()).isEqualTo(0.94);
    }

    @Test
    @DisplayName("간편 입력 조건을 기준 파일이 가리키는 이름으로 보낸다")
    void sendsProgramsAndBudgetWithCriteriaFieldNames() {
        Fixture fixture = newClient("test-key");
        fixture.server()
                .expect(requestTo(BASE_URL + "/v1/systemone"))
                .andExpect(jsonPath("$.state.programs[0]").value("배그"))
                .andExpect(jsonPath("$.state.budget_min").value(1_000_000))
                .andExpect(jsonPath("$.state.budget_max").value(2_000_000))
                // 자바 필드명이 그대로 나가면 기준 파일의 백틱 경로가 가리키는 값이 없어진다.
                .andExpect(jsonPath("$.state.budgetMin").doesNotExist())
                .andRespond(withSuccess(ANSWERABLE_RESPONSE, MediaType.APPLICATION_JSON));

        fixture.client().judge(new NlQueryRequest(
                "그래픽카드 추천해줘", List.of("배그", "  "), 1_000_000, 2_000_000));

        fixture.server().verify();
    }

    @Test
    @DisplayName("조건이 없으면 programs 와 예산을 보내지 않는다")
    void omitsAbsentConditions() {
        Fixture fixture = newClient("test-key");
        fixture.server()
                .expect(requestTo(BASE_URL + "/v1/systemone"))
                .andExpect(jsonPath("$.state.programs").doesNotExist())
                .andExpect(jsonPath("$.state.budget_min").doesNotExist())
                .andExpect(jsonPath("$.state.budget_max").doesNotExist())
                .andRespond(withSuccess(ANSWERABLE_RESPONSE, MediaType.APPLICATION_JSON));

        fixture.client().judge(new NlQueryRequest("가장 비싼 그래픽카드 알려줘"));

        fixture.server().verify();
    }

    @Test
    @DisplayName("거절 판정과 확신도를 그대로 돌려준다")
    void readsRejectVerdict() {
        Fixture fixture = newClient("test-key");
        fixture.server()
                .expect(requestTo(BASE_URL + "/v1/systemone"))
                .andRespond(withSuccess("""
                        {"model":"jev-1.14.0",
                         "answers":{"verdict":{"type":"choice","choice":"missing_data","confidence":0.91}}}
                        """, MediaType.APPLICATION_JSON));

        JudgeResult result = fixture.client().judge(new NlQueryRequest("가장 많이 팔린 상품 5개는?"));

        assertThat(result.skipped()).isFalse();
        assertThat(result.verdict()).isEqualTo(Verdict.MISSING_DATA);
        assertThat(result.shouldReject(0.7)).isTrue();
    }

    @Test
    @DisplayName("API 키가 없으면 호출하지 않고 건너뛴다")
    void skipsWithoutApiKey() {
        Fixture fixture = newClient("   ");

        JudgeResult result = fixture.client().judge(new NlQueryRequest("오늘 날씨 어때?"));

        // 호출이 없어야 한다. 기대한 요청을 등록하지 않았으므로 호출하면 실패한다.
        fixture.server().verify();
        assertThat(result.skipped()).isTrue();
        assertThat(result.shouldReject(0.7)).isFalse();
    }

    @Test
    @DisplayName("401 이면 판정 없이 진행한다")
    void failsOpenOnUnauthorized() {
        assertFailsOpen(withStatus(HttpStatus.UNAUTHORIZED));
    }

    @Test
    @DisplayName("429 면 재시도하지 않고 판정 없이 진행한다")
    void failsOpenOnRateLimit() {
        assertFailsOpen(withStatus(HttpStatus.TOO_MANY_REQUESTS));
    }

    @Test
    @DisplayName("서버 오류면 판정 없이 진행한다")
    void failsOpenOnServerError() {
        assertFailsOpen(withServerError());
    }

    @Test
    @DisplayName("응답에 판정 답이 없으면 판정 없이 진행한다")
    void failsOpenOnMissingAnswer() {
        Fixture fixture = newClient("test-key");
        fixture.server()
                .expect(requestTo(BASE_URL + "/v1/systemone"))
                .andRespond(withSuccess("{\"model\":\"jev-1.14.0\",\"answers\":{}}",
                        MediaType.APPLICATION_JSON));

        JudgeResult result = fixture.client().judge(new NlQueryRequest("질문"));

        assertThat(result.skipped()).isTrue();
    }

    @Test
    @DisplayName("모르는 판정 값이면 거절하지 않고 진행한다")
    void failsOpenOnUnknownVerdict() {
        Fixture fixture = newClient("test-key");
        fixture.server()
                .expect(requestTo(BASE_URL + "/v1/systemone"))
                .andRespond(withSuccess("""
                        {"model":"jev-1.14.0",
                         "answers":{"verdict":{"type":"choice","choice":"그런판정없음","confidence":0.99}}}
                        """, MediaType.APPLICATION_JSON));

        JudgeResult result = fixture.client().judge(new NlQueryRequest("질문"));

        assertThat(result.skipped()).isTrue();
        assertThat(result.shouldReject(0.7)).isFalse();
    }

    @Test
    @DisplayName("확신도가 없으면 0 으로 보아 거절하지 않는다")
    void treatsMissingConfidenceAsZero() {
        Fixture fixture = newClient("test-key");
        fixture.server()
                .expect(requestTo(BASE_URL + "/v1/systemone"))
                .andRespond(withSuccess("""
                        {"model":"jev-1.14.0",
                         "answers":{"verdict":{"type":"choice","choice":"out_of_scope"}}}
                        """, MediaType.APPLICATION_JSON));

        JudgeResult result = fixture.client().judge(new NlQueryRequest("질문"));

        assertThat(result.verdict()).isEqualTo(Verdict.OUT_OF_SCOPE);
        assertThat(result.confidence()).isZero();
        // 판정은 거절 쪽이지만 확신도가 없으므로 거절하지 않는다.
        assertThat(result.shouldReject(0.7)).isFalse();
    }

    private void assertFailsOpen(org.springframework.test.web.client.ResponseCreator response) {
        Fixture fixture = newClient("test-key");
        fixture.server()
                .expect(requestTo(BASE_URL + "/v1/systemone"))
                .andRespond(response);

        JudgeResult result = fixture.client().judge(new NlQueryRequest("질문"));

        fixture.server().verify();
        assertThat(result.skipped()).isTrue();
        assertThat(result.shouldReject(0.7)).isFalse();
    }
}
