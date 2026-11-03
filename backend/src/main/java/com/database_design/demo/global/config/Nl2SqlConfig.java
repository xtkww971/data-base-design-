package com.database_design.demo.global.config;

import java.time.Duration;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestClient;

// 자연어 → SQL 변환 서비스(nl2sql, FastAPI) 호출용 클라이언트
@Configuration
public class Nl2SqlConfig {

    @Bean
    public RestClient nl2sqlRestClient(
            @Value("${nl2sql.base-url}") String baseUrl,
            @Value("${nl2sql.connect-timeout}") Duration connectTimeout,
            @Value("${nl2sql.read-timeout}") Duration readTimeout) {
        SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
        requestFactory.setConnectTimeout(connectTimeout);
        // LLM 호출 + 검증 재시도(최대 3회)까지 기다려야 하므로 넉넉하게 잡는다.
        requestFactory.setReadTimeout(readTimeout);

        return RestClient.builder()
                .baseUrl(baseUrl)
                .requestFactory(requestFactory)
                .build();
    }
}
