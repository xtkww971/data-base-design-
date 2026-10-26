-- 자연어 질의 기록. 설계: docs/스키마 설계/02-자연어-질의-스키마-설계.md
-- nl_queries      : 질문 1건 = 1행. 성공·실패 모두 저장하고, 성공 시 결과 표를 JSON 스냅샷으로 보존한다.
-- nl_query_modules: 성공한 결과에 포함된 부품(module_id)을 modules 와 다시 연결한다.

CREATE TABLE nl_queries
(
    query_id           BIGINT        NOT NULL AUTO_INCREMENT,
    user_id            BIGINT        NULL,
    question           VARCHAR(500)  NOT NULL,
    status             VARCHAR(20)   NOT NULL,
    verdict            VARCHAR(20)   NULL,
    verdict_confidence DECIMAL(4, 3) NULL,
    generated_sql      TEXT          NULL,
    retry_count        TINYINT       NOT NULL DEFAULT 0,
    result_snapshot    JSON          NULL,
    error_message      VARCHAR(500)  NULL,
    latency_ms         INT           NULL,
    created_at         DATETIME(6)   NOT NULL,
    deleted_at         DATETIME(6)   NULL,
    PRIMARY KEY (query_id),
    -- 질문 내역: WHERE user_id = ? AND deleted_at IS NULL ORDER BY created_at DESC
    KEY idx_nl_queries_user_created (user_id, created_at),
    CONSTRAINT fk_nl_queries_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE SET NULL,
    CONSTRAINT ck_nl_queries_status
        CHECK (status IN ('SUCCESS', 'UNANSWERABLE', 'GENERATION_FAILED', 'EXECUTION_FAILED')),
    CONSTRAINT ck_nl_queries_success_has_result
        CHECK (status <> 'SUCCESS' OR (generated_sql IS NOT NULL AND result_snapshot IS NOT NULL))
) DEFAULT CHARSET = utf8mb4;

-- row_no: 결과 안에서의 순서(1부터). 같은 부품이 여러 행에 나오면 첫 위치만 저장한다.
CREATE TABLE nl_query_modules
(
    query_id  BIGINT NOT NULL,
    module_id BIGINT NOT NULL,
    row_no    INT    NOT NULL,
    PRIMARY KEY (query_id, module_id),
    KEY idx_nl_query_modules_module_id (module_id),
    CONSTRAINT fk_nl_query_modules_query FOREIGN KEY (query_id) REFERENCES nl_queries (query_id) ON DELETE CASCADE,
    CONSTRAINT fk_nl_query_modules_module FOREIGN KEY (module_id) REFERENCES modules (module_id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;
