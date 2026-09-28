package com.database_design.demo.global.error;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import java.util.HashMap;
import java.util.Map;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ErrorResponse> handleBusiness(BusinessException e) {
        ErrorCode code = e.getErrorCode();
        return toResponse(code);
    }

    /**
     * {@code @Valid} 로 검증한 @RequestBody DTO 가 제약 조건을 위반한 경우.
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidation(MethodArgumentNotValidException e) {
        Map<String, String> fieldErrors = new HashMap<>();
        for (FieldError error : e.getBindingResult().getFieldErrors()) {
            fieldErrors.putIfAbsent(error.getField(), error.getDefaultMessage());
        }
        return toResponse(ErrorCode.INVALID_INPUT, fieldErrors);
    }

    /**
     * {@code @Validated} 로 검증한 파라미터(PathVariable, RequestParam)가 제약 조건을 위반한 경우.
     */
    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<ErrorResponse> handleConstraintViolation(ConstraintViolationException e) {
        Map<String, String> fieldErrors = new HashMap<>();
        for (ConstraintViolation<?> violation : e.getConstraintViolations()) {
            fieldErrors.putIfAbsent(violation.getPropertyPath().toString(), violation.getMessage());
        }
        return toResponse(ErrorCode.INVALID_INPUT, fieldErrors);
    }

    /**
     * 필수 쿼리 파라미터가 빠진 경우.
     */
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ErrorResponse> handleMissingParameter(MissingServletRequestParameterException e) {
        return toResponse(ErrorCode.INVALID_INPUT, Map.of(e.getParameterName(), "필수 파라미터입니다."));
    }

    /**
     * 본문 JSON 을 파싱할 수 없는 경우(형식 오류, 숫자 자리에 문자열 등).
     */
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleNotReadable(HttpMessageNotReadableException e) {
        log.debug("요청 본문을 읽을 수 없습니다.", e);
        return toResponse(ErrorCode.INVALID_TYPE);
    }

    /**
     * 경로 변수나 파라미터를 대상 타입으로 변환할 수 없는 경우(예: /api/cpus/abc).
     */
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ErrorResponse> handleTypeMismatch(MethodArgumentTypeMismatchException e) {
        return toResponse(ErrorCode.INVALID_TYPE, Map.of(e.getName(), "값의 형식이 올바르지 않습니다."));
    }

    /**
     * 매핑되지 않은 경로로 요청한 경우.
     */
    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ErrorResponse> handleNoResource(NoResourceFoundException e) {
        return toResponse(ErrorCode.RESOURCE_NOT_FOUND);
    }

    /**
     * 경로는 있으나 해당 HTTP 메서드를 지원하지 않는 경우.
     */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ErrorResponse> handleMethodNotSupported(HttpRequestMethodNotSupportedException e) {
        return toResponse(ErrorCode.METHOD_NOT_ALLOWED);
    }

    /**
     * DB 제약 조건 위반(UNIQUE, NOT NULL, FK 등).
     */
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ErrorResponse> handleDataIntegrity(DataIntegrityViolationException e) {
        log.warn("데이터 제약 조건 위반", e);
        return toResponse(ErrorCode.DATA_INTEGRITY_VIOLATION);
    }

    /**
     * 위에서 잡히지 않은 모든 예외. 원인을 로그로 남기고 상세는 노출하지 않는다.
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleUnexpected(Exception e) {
        log.error("처리하지 못한 예외가 발생했습니다.", e);
        return toResponse(ErrorCode.INTERNAL_SERVER_ERROR);
    }

    private ResponseEntity<ErrorResponse> toResponse(ErrorCode code) {
        return ResponseEntity.status(code.getStatus()).body(ErrorResponse.of(code));
    }

    private ResponseEntity<ErrorResponse> toResponse(ErrorCode code, Map<String, String> fieldErrors) {
        return ResponseEntity.status(code.getStatus()).body(ErrorResponse.of(code, fieldErrors));
    }
}
