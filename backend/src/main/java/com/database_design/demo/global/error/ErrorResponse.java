package com.database_design.demo.global.error;

import java.time.LocalDateTime;
import java.util.Map;

public record ErrorResponse(
        String code,
        String message,
        Map<String, String> fieldErrors,
        LocalDateTime timestamp) {

    public static ErrorResponse of(ErrorCode errorCode) {
        return new ErrorResponse(errorCode.name(), errorCode.getMessage(), Map.of(), LocalDateTime.now());
    }

    public static ErrorResponse of(ErrorCode errorCode, Map<String, String> fieldErrors) {
        return new ErrorResponse(errorCode.name(), errorCode.getMessage(), fieldErrors, LocalDateTime.now());
    }
}
