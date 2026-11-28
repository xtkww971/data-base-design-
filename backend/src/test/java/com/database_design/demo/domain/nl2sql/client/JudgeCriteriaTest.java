package com.database_design.demo.domain.nl2sql.client;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import com.database_design.demo.domain.nl2sql.dto.Verdict;
import com.database_design.demo.global.config.TypeSafeProperties;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.Map;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.ResourceLoader;

/**
 * 판정 기준 파일과 {@link Verdict} 가 어긋나지 않는지 고정한다.
 * 어긋나면 Jev 가 돌려준 choice 를 해석할 수 없어 판정이 통째로 버려진다.
 */
class JudgeCriteriaTest {

    private static final ResourceLoader LOADER = new DefaultResourceLoader();

    private static TypeSafeProperties propertiesWith(String location) {
        return new TypeSafeProperties("key", "https://api.typesafe.ai", "jev-1.14.0",
                Duration.ofSeconds(1), Duration.ofSeconds(1), 0.7, location,
                "classpath:nl2sql/schema-summary.txt");
    }

    private static JudgeCriteria load(String location) {
        return new JudgeCriteria(LOADER, propertiesWith(location));
    }

    @Test
    @DisplayName("실제 기준 파일을 읽어 Jev questions 본문을 만든다")
    void loadsBundledCriteria() {
        JudgeCriteria criteria = load("classpath:nl2sql/judge-criteria.yml");

        Map<String, Object> questions = criteria.questions();
        assertThat(questions).containsOnlyKeys(JudgeCriteria.QUESTION_KEY);

        @SuppressWarnings("unchecked")
        Map<String, Object> question = (Map<String, Object>) questions.get(JudgeCriteria.QUESTION_KEY);
        assertThat(question.get("type")).isEqualTo("choice");
        assertThat((String) question.get("instructions")).isNotBlank();

        @SuppressWarnings("unchecked")
        Map<String, Object> rules = (Map<String, Object>) question.get("criteria");
        // 기준 파일의 키와 Verdict 가 1:1 이어야 한다.
        assertThat(rules.keySet()).containsExactlyInAnyOrderElementsOf(Verdict.keys());
        assertThat(rules.values()).allSatisfy(value -> assertThat((String) value).isNotBlank());
    }

    @Test
    @DisplayName("기준 파일의 모든 criteria 키가 Verdict 로 해석된다")
    void everyCriteriaKeyMapsToVerdict() {
        JudgeCriteria criteria = load("classpath:nl2sql/judge-criteria.yml");

        @SuppressWarnings("unchecked")
        Map<String, Object> question =
                (Map<String, Object>) criteria.questions().get(JudgeCriteria.QUESTION_KEY);
        @SuppressWarnings("unchecked")
        Map<String, Object> rules = (Map<String, Object>) question.get("criteria");

        assertThat(rules.keySet()).allSatisfy(key -> assertThat(Verdict.from(key)).isPresent());
    }

    @Test
    @DisplayName("criteria 키가 Verdict 와 다르면 기동을 실패시킨다")
    void rejectsCriteriaKeyMismatch(@TempDir Path dir) throws IOException {
        Path file = write(dir, """
                verdict:
                  type: choice
                  instructions: 판단해라
                  criteria:
                    answerable: 답할 수 있음
                    nonsense: 없는 판정
                """);

        assertThatThrownBy(() -> load(file.toUri().toString()))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("criteria 키가 Verdict 와 다릅니다");
    }

    @Test
    @DisplayName("type 이 choice 가 아니면 기동을 실패시킨다")
    void rejectsNonChoiceType(@TempDir Path dir) throws IOException {
        Path file = write(dir, """
                verdict:
                  type: score
                  instructions: 판단해라
                  criteria:
                    answerable: 답할 수 있음
                """);

        assertThatThrownBy(() -> load(file.toUri().toString()))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("type");
    }

    @Test
    @DisplayName("instructions 가 비어 있으면 기동을 실패시킨다")
    void rejectsBlankInstructions(@TempDir Path dir) throws IOException {
        Path file = write(dir, """
                verdict:
                  type: choice
                  instructions: "  "
                  criteria:
                    answerable: 답할 수 있음
                """);

        assertThatThrownBy(() -> load(file.toUri().toString()))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("instructions");
    }

    @Test
    @DisplayName("파일이 없으면 기동을 실패시킨다")
    void rejectsMissingFile() {
        assertThatThrownBy(() -> load("classpath:nl2sql/no-such-file.yml"))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("찾을 수 없습니다");
    }

    private static Path write(Path dir, String content) throws IOException {
        Path file = dir.resolve("criteria.yml");
        Files.writeString(file, content);
        return file;
    }
}
