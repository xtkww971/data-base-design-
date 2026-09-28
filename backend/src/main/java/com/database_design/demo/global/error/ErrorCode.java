package com.database_design.demo.global.error;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {

    // 공통 - GlobalExceptionHandler 에서 처리한다.
    INVALID_INPUT(HttpStatus.BAD_REQUEST, "입력값이 올바르지 않습니다."),
    INVALID_TYPE(HttpStatus.BAD_REQUEST, "요청 값의 타입이 올바르지 않습니다."),
    RESOURCE_NOT_FOUND(HttpStatus.NOT_FOUND, "요청한 리소스를 찾을 수 없습니다."),
    METHOD_NOT_ALLOWED(HttpStatus.METHOD_NOT_ALLOWED, "지원하지 않는 HTTP 메서드입니다."),
    DATA_INTEGRITY_VIOLATION(HttpStatus.CONFLICT, "데이터 제약 조건을 위반했습니다."),
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "서버 내부 오류가 발생했습니다."),

    // 유저
    DUPLICATE_LOGIN_ID(HttpStatus.CONFLICT, "이미 사용 중인 아이디입니다."),
    LOGIN_FAILED(HttpStatus.UNAUTHORIZED, "아이디 또는 비밀번호가 올바르지 않습니다."),
    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 유저입니다."),

    // 부품(모듈) 공통
    CATEGORY_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 부품 카테고리입니다."),
    INVALID_CATEGORY(HttpStatus.BAD_REQUEST, "지원하지 않는 부품 카테고리입니다."),

    // 부품(모듈) - CPU
    CPU_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 CPU입니다."),

    // 부품(모듈) - 메인보드
    MAINBOARD_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 메인보드입니다."),

    // 부품(모듈) - 램
    RAM_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 램입니다."),

    // 부품(모듈) - 그래픽카드
    GPU_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 그래픽카드입니다."),

    // 부품(모듈) - 파워
    POWER_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 파워입니다."),

    // 부품(모듈) - SSD
    SSD_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 SSD입니다."),

    // 부품(모듈) - HDD
    HDD_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 HDD입니다."),

    // 부품(모듈) - 모니터
    MONITOR_NOT_FOUND(HttpStatus.NOT_FOUND, "존재하지 않는 모니터입니다.");

    private final HttpStatus status;
    private final String message;

    ErrorCode(HttpStatus status, String message) {
        this.status = status;
        this.message = message;
    }
}
