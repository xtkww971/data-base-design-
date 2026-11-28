package com.database_design.demo.global.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestClient;

// 질문의 처리 가능 여부 판정(TypeSafe Jev) 호출용 클라이언트. ADR 0004
@Configuration
@EnableConfigurationProperties(TypeSafeProperties.class)
public class TypeSafeConfig {

    /**
     * nl2sqlRestClient 와 타입이 같으므로 주입은 파라미터 이름(typeSafeRestClient)으로 구분한다.
     */
    @Bean
    public RestClient typeSafeRestClient(TypeSafeProperties properties) {
        SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
        requestFactory.setConnectTimeout(properties.connectTimeout());
        // 판정은 100ms 대로 끝나는 호출이다. 늦으면 기다리지 않고 판정 없이 진행한다(fail-open).
        requestFactory.setReadTimeout(properties.readTimeout());

        return RestClient.builder()
                .baseUrl(properties.baseUrl())
                .requestFactory(requestFactory)
                .build();
    }
}
