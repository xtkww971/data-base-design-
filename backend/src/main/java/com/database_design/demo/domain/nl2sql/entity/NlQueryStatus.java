package com.database_design.demo.domain.nl2sql.entity;

/**
 * 자연어 질의 처리 결과. nl_queries.status 의 CHECK 제약과 값을 맞춘다.
 * nl2sql 서버 장애(NL2SQL_UNAVAILABLE)는 질문의 성질이 아니라서 저장하지 않으므로 상태가 없다.
 */
public enum NlQueryStatus {
    SUCCESS,
    UNANSWERABLE,
    GENERATION_FAILED,
    EXECUTION_FAILED
}
