package com.database_design.demo.domain.nl2sql.dto;

import com.database_design.demo.global.error.ErrorCode;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.Optional;
import java.util.Set;

/**
 * 질문의 처리 가능 여부 판정 결과 (ADR 0004).
 *
 * <p>{@link #key()} 는 judge-criteria.yml 의 criteria 키이자 Jev 가 돌려주는 choice 값이다.
 * 양쪽이 어긋나면 판정을 해석할 수 없으므로 기동 시 {@code JudgeCriteria} 가 맞는지 검사한다.
 *
 * <p>nl_queries.verdict 컬럼은 VARCHAR(20) 이므로 key 가 20자를 넘으면 안 된다.
 */
public enum Verdict {

    /** 조회로 답할 수 있다. SQL 생성 단계로 넘긴다. */
    ANSWERABLE("answerable", null),

    OUT_OF_SCOPE("out_of_scope", ErrorCode.NL2SQL_OUT_OF_SCOPE),
    MISSING_DATA("missing_data", ErrorCode.NL2SQL_MISSING_DATA),
    AMBIGUOUS("ambiguous", ErrorCode.NL2SQL_AMBIGUOUS),

    /**
     * 여러 부품을 조합해 PC 한 대를 구성해 달라는 요청.
     *
     * <p><b>거절하지 않는다.</b> 추천 견적은 지원해야 하는 기능이고, 추천 견적 페이지는
     * 간편 입력을 항상 이 형태의 질문으로 조립한다. 거절하면 그 페이지의 주 흐름이 막힌다.
     * few_shot_examples.json 도 견적 요청에 답하도록 예시를 들고 있고,
     * schema_docs.json 의 호환 뷰 설명도 견적을 맞출 때 쓰라고 안내한다.
     *
     * <p>판정은 그대로 받아 로그에 남긴다. 어떤 질문이 견적 요청으로 들어오는지 관찰하는 데
     * 쓰고, 거절은 하지 않는다.
     */
    RECOMMENDATION("recommendation", null);

    private final String key;
    private final ErrorCode errorCode;

    Verdict(String key, ErrorCode errorCode) {
        this.key = key;
        this.errorCode = errorCode;
    }

    public String key() {
        return key;
    }

    public boolean isAnswerable() {
        return this == ANSWERABLE;
    }

    /**
     * 사용자에게 보여 줄 안내 문구를 담은 에러 코드. Jev 는 이유 문장을 생성하지 않으므로
     * 판정별로 고정된 문구를 쓴다.
     *
     * <p>비어 있으면 그 판정으로는 거절하지 않는다는 뜻이다. 보여 줄 문구가 없다는 것과
     * 거절하지 않는다는 것이 같은 사실이라 따로 두지 않는다. ANSWERABLE 과 RECOMMENDATION
     * 이 여기에 해당한다.
     */
    public Optional<ErrorCode> errorCode() {
        return Optional.ofNullable(errorCode);
    }

    /** 이 판정으로 거절할 수 있는지. 보여 줄 안내 문구가 있는 판정만 거절한다. */
    public boolean rejectable() {
        return errorCode != null;
    }

    /**
     * Jev 가 돌려준 choice 값을 판정으로 바꾼다. 모르는 값이면 비어 있는 값을 돌려준다.
     * 호출부는 이 경우 거절하지 않고 진행한다(fail-open). 해석할 수 없는 판정으로 거절하는 것보다
     * 그냥 생성해 보는 편이 오거절을 줄인다.
     */
    public static Optional<Verdict> from(String key) {
        if (key == null) {
            return Optional.empty();
        }
        String normalized = key.trim().toLowerCase();
        return Arrays.stream(values())
                .filter(verdict -> verdict.key.equals(normalized))
                .findFirst();
    }

    /** judge-criteria.yml 의 criteria 키 집합과 비교하기 위한 값. 선언 순서를 유지한다. */
    public static Set<String> keys() {
        Set<String> keys = new LinkedHashSet<>();
        for (Verdict verdict : values()) {
            keys.add(verdict.key);
        }
        return keys;
    }
}
