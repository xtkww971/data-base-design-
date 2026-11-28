package com.database_design.demo.domain.nl2sql.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;
import jakarta.validation.constraints.Size;
import java.util.List;

/**
 * 추천 견적 질의 요청. nl2sql 서비스의 QueryRequest 와 같은 정보를 받는다.
 * programs, budgetMin, budgetMax 는 간편 입력에서만 채워지므로 모두 선택 값이다.
 *
 * <p>userId 는 질문 내역(nl_queries)을 누구 것으로 저장할지 정한다. 비로그인이면 비워 보내고 user_id 가 NULL 로 저장된다.
 * 토큰·세션이 없어 프론트가 로그인한 유저 id 를 그대로 보낸다. nl2sql 서비스에는 전달하지 않는다.
 */
public record NlQueryRequest(
        @NotBlank(message = "질문을 입력해 주세요.")
        @Size(max = 500, message = "질문은 500자 이하로 입력해 주세요.")
        String question,

        @Size(max = 10, message = "프로그램은 10개 이하로 입력해 주세요.")
        List<@Size(max = 50, message = "프로그램 이름은 50자 이하로 입력해 주세요.") String> programs,

        @PositiveOrZero(message = "예산은 0원 이상이어야 합니다.")
        Integer budgetMin,

        @PositiveOrZero(message = "예산은 0원 이상이어야 합니다.")
        Integer budgetMax,

        @Positive(message = "유저 id 가 올바르지 않습니다.")
        Long userId) {

    /** 질문만 받던 기존 호출부와 테스트를 위한 생성자 */
    public NlQueryRequest(String question) {
        this(question, null, null, null, null);
    }

    /** 유저 없이(비로그인) 간편 입력까지 보내는 호출부와 테스트를 위한 생성자 */
    public NlQueryRequest(String question, List<String> programs, Integer budgetMin, Integer budgetMax) {
        this(question, programs, budgetMin, budgetMax, null);
    }
}
