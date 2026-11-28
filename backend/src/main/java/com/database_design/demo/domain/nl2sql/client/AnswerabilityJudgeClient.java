package com.database_design.demo.domain.nl2sql.client;

import com.database_design.demo.domain.nl2sql.dto.JudgeResult;
import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import com.database_design.demo.domain.nl2sql.dto.Verdict;
import com.database_design.demo.global.config.TypeSafeProperties;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.TimeUnit;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

/**
 * 질문에 조회로 답할 수 있는지 TypeSafe Jev 로 판정한다 (ADR 0004).
 *
 * <p>SQL 을 실제로 실행하는 주체가 백엔드이므로 실행 여부 판정도 백엔드에서 한다.
 * 이 호출이 SQL 생성보다 앞에 있어서, 거절되는 질문은 nl2sql 호출 자체가 일어나지 않는다.
 *
 * <p><b>이 클래스는 거절을 결정하지 않는다.</b> 판정과 확신도만 돌려주고,
 * 임계값을 적용해 거절할지는 호출부가 정한다.
 *
 * <p>판정에 실패하면 어떤 이유든 {@link JudgeResult#notJudged()} 를 돌려준다(fail-open).
 * 판정은 사용성 개선 장치라서, 판정이 안 되는 것 때문에 질의 자체가 막히면 안 된다.
 * 키 없음, 타임아웃, 401, 422, 429, 529, 해석할 수 없는 응답이 모두 여기에 해당한다.
 */
@Slf4j
@Component
public class AnswerabilityJudgeClient {

    private static final String SYSTEM_ONE_PATH = "/v1/systemone";

    private final RestClient restClient;
    private final TypeSafeProperties properties;
    private final JudgeCriteria criteria;
    private final String schemaSummary;

    public AnswerabilityJudgeClient(
            @Qualifier("typeSafeRestClient") RestClient restClient,
            TypeSafeProperties properties,
            JudgeCriteria criteria,
            ResourceLoader resourceLoader) {
        this.restClient = restClient;
        this.properties = properties;
        this.criteria = criteria;
        this.schemaSummary = readSchemaSummary(resourceLoader, properties.schemaLocation());
    }

    public JudgeResult judge(NlQueryRequest request) {
        if (!properties.hasApiKey()) {
            // 팀원 로컬이 키 없이도 기존 동작 그대로 돌아가야 한다.
            log.debug("TypeSafe API 키가 없어 판정을 건너뜁니다.");
            return JudgeResult.notJudged();
        }

        long startedAt = System.nanoTime();
        try {
            SystemOneResponse response = restClient.post()
                    .uri(SYSTEM_ONE_PATH)
                    .contentType(MediaType.APPLICATION_JSON)
                    .header(HttpHeaders.AUTHORIZATION, "Bearer " + properties.apiKey())
                    .body(buildBody(request))
                    .retrieve()
                    .body(SystemOneResponse.class);

            return interpret(response, elapsedMs(startedAt));
        } catch (Exception e) {
            // 재시도하지 않는다. fail-open 이므로 그냥 진행하는 것이 재시도보다 싸다.
            log.warn("판정 호출에 실패해 판정 없이 진행합니다. latency={}ms", elapsedMs(startedAt), e);
            return JudgeResult.notJudged();
        }
    }

    /**
     * Jev 요청 본문. questions 는 judge-criteria.yml 내용 그대로이고, state 만 요청마다 바뀐다.
     * 필드 이름은 기준 파일의 백틱 경로(`question`, `schema` 등)와 반드시 같아야 한다.
     */
    private Map<String, Object> buildBody(NlQueryRequest request) {
        Map<String, Object> state = new LinkedHashMap<>();
        state.put("question", request.question());

        List<String> programs = normalizePrograms(request.programs());
        if (!programs.isEmpty()) {
            state.put("programs", programs);
        }
        // 값이 없으면 보내지 않는다. 기준 파일에 "값이 없으면 오지 않는다"로 적어 두었다.
        if (request.budgetMin() != null) {
            state.put("budget_min", request.budgetMin());
        }
        if (request.budgetMax() != null) {
            state.put("budget_max", request.budgetMax());
        }
        state.put("schema", schemaSummary);

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("model", properties.model());
        body.put("state", state);
        body.put("questions", criteria.questions());
        return body;
    }

    private JudgeResult interpret(SystemOneResponse response, long latencyMs) {
        Answer answer = response == null || response.answers() == null
                ? null
                : response.answers().get(JudgeCriteria.QUESTION_KEY);
        if (answer == null) {
            log.warn("판정 응답에 '{}' 답이 없어 판정 없이 진행합니다. latency={}ms",
                    JudgeCriteria.QUESTION_KEY, latencyMs);
            return JudgeResult.notJudged();
        }

        Optional<Verdict> verdict = Verdict.from(answer.choice());
        if (verdict.isEmpty()) {
            // 기준 파일과 Verdict 는 기동 시 맞춰 두므로 보통 일어나지 않는다.
            // 그래도 해석할 수 없는 값으로 거절하는 것보다 생성해 보는 편이 오거절을 줄인다.
            log.warn("해석할 수 없는 판정이라 판정 없이 진행합니다. choice={} latency={}ms",
                    answer.choice(), latencyMs);
            return JudgeResult.notJudged();
        }

        double confidence = answer.confidence() == null ? 0 : answer.confidence();
        // 오거절 점검용. 판정과 확신도를 남겨 두고 주기적으로 눈으로 본다.
        log.info("판정 결과 verdict={} confidence={} model={} latency={}ms",
                verdict.get().key(), confidence, response.model(), latencyMs);
        return JudgeResult.of(verdict.get(), confidence);
    }

    private static List<String> normalizePrograms(List<String> programs) {
        if (programs == null) {
            return List.of();
        }
        return programs.stream()
                .filter(program -> program != null && !program.isBlank())
                .map(String::trim)
                .toList();
    }

    private static long elapsedMs(long startedAt) {
        return TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - startedAt);
    }

    private static String readSchemaSummary(ResourceLoader resourceLoader, String location) {
        Resource resource = resourceLoader.getResource(location);
        if (!resource.exists()) {
            throw new IllegalStateException("스키마 요약 파일을 찾을 수 없습니다: " + location);
        }
        try {
            String summary = resource.getContentAsString(StandardCharsets.UTF_8);
            if (summary.isBlank()) {
                throw new IllegalStateException("스키마 요약 파일이 비어 있습니다: " + location);
            }
            return summary;
        } catch (IOException e) {
            throw new IllegalStateException("스키마 요약 파일을 읽을 수 없습니다: " + location, e);
        }
    }

    /**
     * Jev 응답. probabilities 와 usage 는 쓰지 않으므로 받지 않는다.
     */
    @JsonIgnoreProperties(ignoreUnknown = true)
    record SystemOneResponse(String model, Map<String, Answer> answers) {
    }

    /**
     * choice 질문의 답. confidence 는 0~1 이고, 값이 없으면 0 으로 보아 거절하지 않는다.
     */
    @JsonIgnoreProperties(ignoreUnknown = true)
    record Answer(String type, String choice, Double confidence) {
    }
}
