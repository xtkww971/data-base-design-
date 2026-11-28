package com.database_design.demo.domain.nl2sql.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import com.database_design.demo.domain.nl2sql.client.AnswerabilityJudgeClient;
import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient;
import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient.GeneratedQuery;
import com.database_design.demo.domain.nl2sql.dto.JudgeResult;
import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import com.database_design.demo.domain.nl2sql.dto.Verdict;
import com.database_design.demo.global.config.TypeSafeProperties;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import java.time.Duration;
import javax.sql.DataSource;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

/**
 * 판정 결과에 따라 거절할지 진행할지 고정한다 (ADR 0004).
 *
 * <p>거절되는 질문은 nl2sql 호출이 일어나지 않아야 한다. 그것이 판정을 그래프 노드가 아니라
 * 백엔드 앞단에 둔 이유다. 반대로 확신이 낮거나 판정하지 못했으면 거절하지 않아야 한다.
 * 오거절이 이 기능의 가장 큰 위험이다.
 */
class Nl2SqlServiceTest {

    private static final double THRESHOLD = 0.7;

    private final AnswerabilityJudgeClient judgeClient = mock(AnswerabilityJudgeClient.class);
    private final Nl2SqlClient nl2SqlClient = mock(Nl2SqlClient.class);

    private final Nl2SqlService service = new Nl2SqlService(
            judgeClient, nl2SqlClient, properties(), mock(DataSource.class));

    private static TypeSafeProperties properties() {
        return new TypeSafeProperties("key", "https://api.typesafe.ai", "jev-1.14.0",
                Duration.ofSeconds(1), Duration.ofSeconds(1), THRESHOLD,
                "classpath:nl2sql/judge-criteria.yml", "classpath:nl2sql/schema-summary.txt");
    }

    /** 판정을 통과한 뒤 어디까지 갔는지 보려고, 생성 실패로 끊어 거기까지 왔는지 확인한다. */
    private void givenGenerationFails() {
        when(nl2SqlClient.generate(any())).thenReturn(new GeneratedQuery("", "생성 불가", 3));
    }

    @ParameterizedTest(name = "{0} 판정이면 {1} 로 거절한다")
    @CsvSource({
            "OUT_OF_SCOPE, NL2SQL_OUT_OF_SCOPE",
            "MISSING_DATA, NL2SQL_MISSING_DATA",
            "AMBIGUOUS, NL2SQL_AMBIGUOUS",
            "RECOMMENDATION, NL2SQL_RECOMMENDATION"
    })
    void rejectsWithVerdictSpecificErrorCode(Verdict verdict, ErrorCode expected) {
        when(judgeClient.judge(any())).thenReturn(JudgeResult.of(verdict, 0.91));

        assertThatThrownBy(() -> service.query(new NlQueryRequest("질문")))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(expected);

        // 거절되는 질문은 nl2sql 을 아예 거치지 않는다.
        verifyNoInteractions(nl2SqlClient);
    }

    @Test
    @DisplayName("거절 문구는 판정별로 다르다")
    void rejectMessageDiffersByVerdict() {
        when(judgeClient.judge(any())).thenReturn(JudgeResult.of(Verdict.MISSING_DATA, 0.95));

        assertThatThrownBy(() -> service.query(new NlQueryRequest("가장 많이 팔린 상품 5개는?")))
                .hasMessage(ErrorCode.NL2SQL_MISSING_DATA.getMessage());
        assertThat(ErrorCode.NL2SQL_MISSING_DATA.getMessage())
                .isNotEqualTo(ErrorCode.NL2SQL_OUT_OF_SCOPE.getMessage());
    }

    @Test
    @DisplayName("answerable 이면 생성 단계로 넘긴다")
    void proceedsWhenAnswerable() {
        when(judgeClient.judge(any())).thenReturn(JudgeResult.of(Verdict.ANSWERABLE, 0.99));
        givenGenerationFails();

        NlQueryRequest request = new NlQueryRequest("30만원 이하 CPU 알려줘");
        assertThatThrownBy(() -> service.query(request))
                .isInstanceOf(BusinessException.class)
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.NL2SQL_GENERATION_FAILED);

        verify(nl2SqlClient).generate(request);
    }

    @Test
    @DisplayName("확신도가 임계값보다 낮으면 거절하지 않고 생성해 본다")
    void proceedsWhenConfidenceBelowThreshold() {
        when(judgeClient.judge(any())).thenReturn(JudgeResult.of(Verdict.AMBIGUOUS, 0.69));
        givenGenerationFails();

        assertThatThrownBy(() -> service.query(new NlQueryRequest("좋은 거 추천해줘")))
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.NL2SQL_GENERATION_FAILED);

        verify(nl2SqlClient).generate(any());
    }

    @Test
    @DisplayName("확신도가 임계값과 같으면 거절한다")
    void rejectsWhenConfidenceEqualsThreshold() {
        when(judgeClient.judge(any())).thenReturn(JudgeResult.of(Verdict.OUT_OF_SCOPE, THRESHOLD));

        assertThatThrownBy(() -> service.query(new NlQueryRequest("오늘 날씨 어때?")))
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.NL2SQL_OUT_OF_SCOPE);

        verifyNoInteractions(nl2SqlClient);
    }

    @Test
    @DisplayName("판정하지 못했으면 거절하지 않고 생성해 본다")
    void proceedsWhenNotJudged() {
        // 키가 없거나 호출이 실패한 경우. 판정이 없는 현재 동작으로 돌아간다.
        when(judgeClient.judge(any())).thenReturn(JudgeResult.notJudged());
        givenGenerationFails();

        assertThatThrownBy(() -> service.query(new NlQueryRequest("오늘 날씨 어때?")))
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.NL2SQL_GENERATION_FAILED);

        verify(nl2SqlClient).generate(any());
    }
}
