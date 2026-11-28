package com.database_design.demo.domain.nl2sql.client;

import com.database_design.demo.domain.nl2sql.dto.Verdict;
import com.database_design.demo.global.config.TypeSafeProperties;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Component;
import org.yaml.snakeyaml.LoaderOptions;
import org.yaml.snakeyaml.Yaml;
import org.yaml.snakeyaml.constructor.SafeConstructor;

/**
 * 판정 기준(judge-criteria.yml)을 읽어 Jev 의 questions 본문으로 들고 있는다 (ADR 0004).
 *
 * <p>파일 내용이 요청 본문 그대로다. 변환하지 않는 이유는 변환 코드가 끼면 파일에 적힌 문장과
 * 모델이 읽는 문장이 달라질 수 있기 때문이다.
 *
 * <p>기동 시 한 번 읽고 검사한다. criteria 키가 {@link Verdict} 와 어긋나면 기동을 실패시킨다.
 * 판정은 실패해도 fail-open 으로 넘기지만, 기준 파일이 깨진 것은 런타임 상황이 아니라
 * 고치다 틀린 것이므로 조용히 넘기면 판정이 계속 틀린 쪽으로 나온다.
 */
@Slf4j
@Component
public class JudgeCriteria {

    /** 질문 키. Jev 응답의 answers 에서 이 이름으로 결과를 찾는다. */
    public static final String QUESTION_KEY = "verdict";

    private static final String TYPE_CHOICE = "choice";

    private final Map<String, Object> questions;

    public JudgeCriteria(ResourceLoader resourceLoader, TypeSafeProperties properties) {
        this.questions = load(resourceLoader, properties.criteriaLocation());
        log.info("판정 기준을 읽었습니다. location={} criteria={}",
                properties.criteriaLocation(), Verdict.keys());
    }

    /**
     * Jev 요청의 questions 에 그대로 넣을 값. 호출마다 같은 값이라 한 번 읽고 재사용한다.
     */
    public Map<String, Object> questions() {
        return questions;
    }

    private static Map<String, Object> load(ResourceLoader resourceLoader, String location) {
        Resource resource = resourceLoader.getResource(location);
        if (!resource.exists()) {
            throw new IllegalStateException("판정 기준 파일을 찾을 수 없습니다: " + location);
        }

        Map<String, Object> root;
        try (InputStream in = resource.getInputStream()) {
            // 경로를 설정으로 바꿀 수 있으므로 임의 태그를 해석하지 않는 SafeConstructor 를 쓴다.
            Yaml yaml = new Yaml(new SafeConstructor(new LoaderOptions()));
            root = yaml.load(in);
        } catch (IOException e) {
            throw new IllegalStateException("판정 기준 파일을 읽을 수 없습니다: " + location, e);
        }

        validate(root, location);
        return Collections.unmodifiableMap(new LinkedHashMap<>(root));
    }

    private static void validate(Map<String, Object> root, String location) {
        if (root == null || root.isEmpty()) {
            throw new IllegalStateException("판정 기준 파일이 비어 있습니다: " + location);
        }
        if (!root.keySet().equals(Set.of(QUESTION_KEY))) {
            throw new IllegalStateException("판정 기준 파일의 최상위 키는 '%s' 하나여야 합니다. 현재: %s (%s)"
                    .formatted(QUESTION_KEY, root.keySet(), location));
        }

        Map<?, ?> question = asMap(root.get(QUESTION_KEY), QUESTION_KEY, location);

        if (!TYPE_CHOICE.equals(question.get("type"))) {
            throw new IllegalStateException("판정 질문의 type 은 '%s' 여야 합니다. 현재: %s (%s)"
                    .formatted(TYPE_CHOICE, question.get("type"), location));
        }
        requireText(question.get("instructions"), "instructions", location);

        Map<?, ?> criteria = asMap(question.get("criteria"), "criteria", location);
        Set<String> actual = new TreeSet<>();
        for (Map.Entry<?, ?> entry : criteria.entrySet()) {
            String key = String.valueOf(entry.getKey());
            actual.add(key);
            requireText(entry.getValue(), "criteria." + key, location);
        }

        // 키가 어긋나면 Jev 가 돌려준 choice 를 Verdict 로 해석할 수 없다.
        if (!actual.equals(new TreeSet<>(Verdict.keys()))) {
            throw new IllegalStateException(
                    "판정 기준의 criteria 키가 Verdict 와 다릅니다. 기대: %s, 현재: %s (%s)"
                            .formatted(new TreeSet<>(Verdict.keys()), actual, location));
        }
    }

    private static Map<?, ?> asMap(Object value, String field, String location) {
        if (!(value instanceof Map<?, ?> map) || map.isEmpty()) {
            throw new IllegalStateException(
                    "판정 기준의 '%s' 는 비어 있지 않은 맵이어야 합니다. (%s)".formatted(field, location));
        }
        return map;
    }

    private static void requireText(Object value, String field, String location) {
        if (!(value instanceof String text) || text.isBlank()) {
            throw new IllegalStateException(
                    "판정 기준의 '%s' 는 비어 있지 않은 문자열이어야 합니다. (%s)".formatted(field, location));
        }
    }
}
