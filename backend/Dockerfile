# 빌드 스테이지: 프로젝트가 고정한 Gradle 래퍼(9.7.1)로 빌드한다.
# 이미지의 gradle(8.x)은 Spring Boot 4.1.1 플러그인이 요구하는 Gradle 9를 만족하지 못한다.
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app
COPY . .
RUN chmod +x gradlew && ./gradlew bootJar -x test --no-daemon

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
