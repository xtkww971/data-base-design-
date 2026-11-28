package com.database_design.demo.domain.nl2sql.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

import com.database_design.demo.domain.nl2sql.client.AnswerabilityJudgeClient;
import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient;
import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient.GeneratedQuery;
import com.database_design.demo.domain.nl2sql.dto.JudgeResult;
import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import com.database_design.demo.domain.nl2sql.dto.Verdict;
import com.database_design.demo.domain.nl2sql.entity.NlQueryStatus;
import com.database_design.demo.global.config.TypeSafeProperties;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import java.time.Duration;
import javax.sql.DataSource;
import org.springframework.transaction.PlatformTransactionManager;
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

    private final NlQueryRecorder recorder = mock(NlQueryRecorder.class);

    private final Nl2SqlService service = new Nl2SqlService(
            judgeClient, nl2SqlClient, properties(), recorder, mock(DataSource.class),
            mock(PlatformTransactionManager.class));

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
            "AMBIGUOUS, NL2SQL_AMBIGUOUS"
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
    @DisplayName("recommendation 은 확신도가 높아도 거절하지 않고 생성 단계로 넘긴다")
    void neverRejectsRecommendation() {
        // 추천 견적은 지원해야 하는 기능이다. 추천 견적 페이지가 간편 입력을 항상 이 형태의
        // 질문으로 조립하므로, 거절하면 그 페이지의 주 흐름이 막힌다.
        when(judgeClient.judge(any())).thenReturn(JudgeResult.of(Verdict.RECOMMENDATION, 1.0));
        givenGenerationFails();

        NlQueryRequest request = new NlQueryRequest("300만원 안팎의 예산으로 컴퓨터 견적 맞춰줘.");
        assertThatThrownBy(() -> service.query(request))
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.NL2SQL_GENERATION_FAILED);

        // 생성까지 갔다는 것이 핵심이다. 거절했다면 nl2sql 을 거치지 않는다.
        verify(nl2SqlClient).generate(request);
    }

    @Test
    @DisplayName("거절 대상 판정은 안내 문구를 가진 것뿐이다")
    void onlyVerdictsWithMessageAreRejectable() {
        assertThat(Verdict.ANSWERABLE.rejectable()).isFalse();
        assertThat(Verdict.RECOMMENDATION.rejectable()).isFalse();
        assertThat(Verdict.OUT_OF_SCOPE.rejectable()).isTrue();
        assertThat(Verdict.MISSING_DATA.rejectable()).isTrue();
        assertThat(Verdict.AMBIGUOUS.rejectable()).isTrue();
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

    @Test
    @DisplayName("거절한 질문은 판정과 함께 UNANSWERABLE 로 남긴다")
    void recordsRejectedQuestion() {
        JudgeResult judged = JudgeResult.of(Verdict.OUT_OF_SCOPE, 0.9);
        when(judgeClient.judge(any())).thenReturn(judged);
        NlQueryRequest request = new NlQueryRequest("오늘 날씨 어때?", null, null, null, 7L);

        assertThatThrownBy(() -> service.query(request)).isInstanceOf(BusinessException.class);

        verify(recorder).recordFailure(eq(7L), eq("오늘 날씨 어때?"), eq(judged), eq(NlQueryStatus.UNANSWERABLE),
                isNull(), eq(0), eq("NL2SQL_OUT_OF_SCOPE"), anyInt());
    }

    @Test
    @DisplayName("SQL 생성에 실패한 질문은 GENERATION_FAILED 로 남긴다")
    void recordsGenerationFailure() {
        when(judgeClient.judge(any())).thenReturn(JudgeResult.notJudged());
        givenGenerationFails();

        assertThatThrownBy(() -> service.query(new NlQueryRequest("질문")))
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.NL2SQL_GENERATION_FAILED);

        verify(recorder).recordFailure(isNull(), eq("질문"), any(), eq(NlQueryStatus.GENERATION_FAILED),
                isNull(), eq(3), eq("생성 불가"), anyInt());
    }

    @Test
    @DisplayName("nl2sql 서버에 연결하지 못한 질문은 남기지 않는다")
    void doesNotRecordWhenNl2SqlUnavailable() {
        when(judgeClient.judge(any())).thenReturn(JudgeResult.notJudged());
        when(nl2SqlClient.generate(any())).thenThrow(new BusinessException(ErrorCode.NL2SQL_UNAVAILABLE));

        assertThatThrownBy(() -> service.query(new NlQueryRequest("질문")))
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.NL2SQL_UNAVAILABLE);

        verify(recorder, never()).recordFailure(any(), any(), any(), any(), any(), anyInt(), any(), anyInt());
    }

    @Test
    @DisplayName("기록에 실패해도 사용자에게는 원래 에러를 돌려준다")
    void recordingFailureDoesNotChangeResponse() {
        when(judgeClient.judge(any())).thenReturn(JudgeResult.of(Verdict.AMBIGUOUS, 0.9));
        when(recorder.recordFailure(any(), any(), any(), any(), any(), anyInt(), any(), anyInt()))
                .thenThrow(new IllegalStateException("DB down"));

        assertThatThrownBy(() -> service.query(new NlQueryRequest("좋은 거")))
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.NL2SQL_AMBIGUOUS);
    }

    @Test
    @DisplayName("없는 유저면 판정·생성 전에 끊는다")
    void rejectsUnknownUserBeforeCallingLlm() {
        doThrow(new BusinessException(ErrorCode.USER_NOT_FOUND)).when(recorder).requireUser(99L);

        assertThatThrownBy(() -> service.query(new NlQueryRequest("질문", null, null, null, 99L)))
                .extracting(e -> ((BusinessException) e).getErrorCode())
                .isEqualTo(ErrorCode.USER_NOT_FOUND);

        verifyNoInteractions(judgeClient, nl2SqlClient);
    }
}
