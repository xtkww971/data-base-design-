package com.database_design.demo.domain.nl2sql.client;

import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

/**
 * nl2sql 서비스의 POST /query 를 호출해 자연어 질문을 SQL 로 변환한다.
 */
@Slf4j
@Component
public class Nl2SqlClient {

    private final RestClient nl2sqlRestClient;

    /**
     * 판정용(typeSafeRestClient)과 타입이 같으므로 어느 빈인지 이름으로 못 박는다.
     * Lombok 생성자는 @Qualifier 를 생성자 파라미터로 옮겨 주지 않아 생성자를 직접 둔다.
     */
    public Nl2SqlClient(@Qualifier("nl2sqlRestClient") RestClient nl2sqlRestClient) {
        this.nl2sqlRestClient = nl2sqlRestClient;
    }

    public GeneratedQuery generate(NlQueryRequest request) {
        try {
            GeneratedQuery result = nl2sqlRestClient.post()
                    .uri("/query")
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(QueryRequest.from(request))
                    .retrieve()
                    .body(GeneratedQuery.class);

            if (result == null) {
                throw new BusinessException(ErrorCode.NL2SQL_UNAVAILABLE);
            }
            return result;
        } catch (HttpServerErrorException e) {
            // 서버에는 닿았지만 처리 중 실패한 경우. 연결 실패와 구분해 질문을 바꿔 보도록 안내한다.
            log.error("nl2sql 서비스가 질의 처리 중 오류를 반환했습니다. status={}", e.getStatusCode(), e);
            throw new BusinessException(ErrorCode.NL2SQL_GENERATION_FAILED);
        } catch (RestClientException e) {
            log.error("nl2sql 서비스 호출에 실패했습니다.", e);
            throw new BusinessException(ErrorCode.NL2SQL_UNAVAILABLE);
        }
    }

    /**
     * nl2sql 의 QueryRequest 와 맞춘 전송 형태. 파이썬 쪽 필드명이 snake_case 라 그대로 맞춘다.
     * 값이 없는 필드는 보내지 않고 파이썬 기본값(None)을 쓰게 한다.
     */
    @JsonInclude(JsonInclude.Include.NON_NULL)
    private record QueryRequest(
            String question,
            List<String> programs,
            @JsonProperty("budget_min") Integer budgetMin,
            @JsonProperty("budget_max") Integer budgetMax) {

        static QueryRequest from(NlQueryRequest request) {
            List<String> programs = request.programs() == null || request.programs().isEmpty()
                    ? null
                    : request.programs();
            return new QueryRequest(request.question(), programs, request.budgetMin(), request.budgetMax());
        }
    }

    public record GeneratedQuery(
            String query,
            String error,
            @JsonProperty("retry_count") int retryCount) {

        public boolean isValid() {
            return (error == null || error.isBlank()) && query != null && !query.isBlank();
        }
    }
}
