package com.database_design.demo.domain.nl2sql.dto;

import com.database_design.demo.domain.nl2sql.entity.NlQueryStatus;
import com.database_design.demo.global.error.ErrorCode;
import java.time.LocalDateTime;

/**
 * 질문 내역 하나를 다시 볼 때의 응답. 성공이면 result, 실패면 error 만 채운다.
 *
 * @param result 저장해 둔 결과 스냅샷을 POST /query 응답과 같은 모양으로 되돌린 것
 * @param error  그때 사용자에게 보여 준 것과 같은 에러 코드·문구. 내부 디버깅용 error_message 는 노출하지 않는다.
 */
public record NlQueryDetailResponse(
        Long queryId,
        String question,
        NlQueryStatus status,
        LocalDateTime createdAt,
        NlQueryResponse result,
        QueryError error) {

    public record QueryError(String code, String message, int status) {

        public static QueryError of(ErrorCode errorCode) {
            return new QueryError(errorCode.name(), errorCode.getMessage(), errorCode.getStatus().value());
        }
    }
}
