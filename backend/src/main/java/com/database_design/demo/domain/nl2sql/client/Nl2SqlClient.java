package com.database_design.demo.domain.nl2sql.client;

import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;

/**
 * nl2sql 서비스의 POST /query 를 호출해 자연어 질문을 SQL 로 변환한다.
 */
@Slf4j
@AllArgsConstructor
@Component
public class Nl2SqlClient {

    @Autowired
    private final RestClient nl2sqlRestClient;

    public GeneratedQuery generate(String question) {
        try {
            GeneratedQuery result = nl2sqlRestClient.post()
                    .uri("/query")
                    .contentType(MediaType.APPLICATION_JSON)
                    .body(new QueryRequest(question))
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

    private record QueryRequest(String question) {
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
