package com.database_design.demo.domain.nl2sql.dto;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * 질문의 처리 가능 여부 판정 결과 1건 (ADR 0004).
 *
 * @param verdict    판정. 건너뛰었으면 {@link Verdict#ANSWERABLE}
 * @param confidence 확신도 0~1. 건너뛰었으면 0
 * @param skipped    판정하지 못했는지 여부. 키가 없거나 호출이 실패했거나 응답을 해석할 수 없는 경우.
 *                   이때는 거절하지 않고 생성 단계로 진행한다(fail-open)
 */
public record JudgeResult(Verdict verdict, double confidence, boolean skipped) {

    /**
     * 판정하지 못했다. 호출부는 그대로 진행한다.
     * 이름이 {@code skipped} 가 아닌 이유는 레코드 접근자와 겹치기 때문이다.
     */
    public static JudgeResult notJudged() {
        return new JudgeResult(Verdict.ANSWERABLE, 0, true);
    }

    public static JudgeResult of(Verdict verdict, double confidence) {
        return new JudgeResult(verdict, confidence, false);
    }

    /**
     * 거절해야 하는지 판단한다.
     *
     * <p>거절할 수 있는 판정이고 확신도가 임계값 이상일 때만 거절한다.
     * 오거절이 이 기능의 가장 큰 위험이므로 거절 쪽에만 높은 확신을 요구한다.
     * 확신이 낮으면 거절하지 않고 생성해 본다.
     *
     * <p>{@code answerable} 과 {@code recommendation} 은 거절 대상이 아니다
     * ({@link Verdict#rejectable()}). 특히 추천 견적은 지원해야 하는 기능이라
     * 판정만 받고 생성으로 넘긴다.
     */
    public boolean shouldReject(double confidenceThreshold) {
        return !skipped && verdict.rejectable() && confidence >= confidenceThreshold;
    }

    /** nl_queries.verdict_confidence 가 DECIMAL(4,3) 이라 소수 세 자리로 맞춘다. */
    public BigDecimal confidenceAsDecimal() {
        return BigDecimal.valueOf(confidence).setScale(3, RoundingMode.HALF_UP);
    }
}
