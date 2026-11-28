package com.database_design.demo.global.config;

import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;

/**
 * 질문의 처리 가능 여부를 판정하는 TypeSafe Jev 호출 설정 (ADR 0004).
 *
 * <p>apiKey 가 비어 있으면 판정을 건너뛴다. 키 없이도 기존 동작 그대로 돌아가야 하므로
 * 설정 자체를 필수로 만들지 않는다.
 *
 * @param apiKey              TYPESAFE_API_KEY. 비어 있으면 판정을 건너뛴다
 * @param baseUrl             API 호스트
 * @param model               모델 ID. 버전을 핀으로 박는다. jev-latest 를 쓰면 릴리스에 따라
 *                            판정이 조용히 바뀌어 confidenceThreshold 실측값이 의미를 잃는다
 * @param connectTimeout      연결 타임아웃
 * @param readTimeout         응답 타임아웃. 넘기면 판정 없이 진행한다(fail-open)
 * @param confidenceThreshold 이 값 이상일 때만 거절한다. 오거절이 가장 큰 위험이라
 *                            거절 쪽에만 높은 확신을 요구한다
 * @param criteriaLocation    판정 기준 파일 위치. 스프링 Resource 표기를 쓰므로
 *                            PoC 때 {@code file:./criteria-v2.yml} 처럼 재빌드 없이 갈아끼울 수 있다
 * @param schemaLocation      판정 근거로 보낼 스키마 요약 파일 위치. 기준 파일과 짝이라 같이 둔다
 */
@ConfigurationProperties(prefix = "typesafe")
public record TypeSafeProperties(
        String apiKey,
        String baseUrl,
        String model,
        Duration connectTimeout,
        Duration readTimeout,
        double confidenceThreshold,
        String criteriaLocation,
        String schemaLocation) {

    public boolean hasApiKey() {
        return apiKey != null && !apiKey.isBlank();
    }
}
