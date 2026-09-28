-- V2 에서 만든 부품 테이블을 공통 테이블(modules) 기반 상세 테이블로 재구성한다.
-- 각 상세 테이블의 PK 는 modules.module_id 를 그대로 쓰는 1:1 식별 관계이고,
-- 컬럼은 프론트엔드 DTO 문서(work.txt)의 specs 를 그대로 반영한다.
-- V2 의 부품 테이블에는 아직 운영 데이터가 없어 그대로 드롭한다.

DROP TABLE IF EXISTS cpus;
DROP TABLE IF EXISTS main_boards;
DROP TABLE IF EXISTS rams;
DROP TABLE IF EXISTS graphic_cards;
DROP TABLE IF EXISTS power;
DROP TABLE IF EXISTS memory;
DROP TABLE IF EXISTS monitors;

CREATE TABLE cpus
(
    module_id    BIGINT      NOT NULL,
    socket       VARCHAR(20) NOT NULL,
    cores        INT         NOT NULL,
    threads      INT         NOT NULL,
    has_graphics BIT(1)      NOT NULL,
    clock_speed  VARCHAR(20) NOT NULL,
    PRIMARY KEY (module_id),
    CONSTRAINT fk_cpus_module FOREIGN KEY (module_id) REFERENCES modules (module_id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

CREATE TABLE main_boards
(
    module_id    BIGINT      NOT NULL,
    socket       VARCHAR(20) NOT NULL,
    form_factor  VARCHAR(20) NOT NULL,
    memory_spec  VARCHAR(10) NOT NULL,
    memory_slots INT         NOT NULL,
    chipset      VARCHAR(30) NOT NULL,
    PRIMARY KEY (module_id),
    CONSTRAINT fk_main_boards_module FOREIGN KEY (module_id) REFERENCES modules (module_id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- capacity 단위: GB, clock 단위: MHz
CREATE TABLE rams
(
    module_id     BIGINT      NOT NULL,
    memory_spec   VARCHAR(10) NOT NULL,
    capacity      INT         NOT NULL,
    clock         INT         NOT NULL,
    package_count INT         NOT NULL,
    PRIMARY KEY (module_id),
    CONSTRAINT fk_rams_module FOREIGN KEY (module_id) REFERENCES modules (module_id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- memory_capacity 단위: GB, length_mm 단위: mm, recommended_power 단위: W
CREATE TABLE graphic_cards
(
    module_id         BIGINT       NOT NULL,
    chipset           VARCHAR(50)  NOT NULL,
    memory_type       VARCHAR(20)  NOT NULL,
    memory_capacity   INT          NOT NULL,
    length_mm         INT          NOT NULL,
    recommended_power INT          NOT NULL,
    ports             VARCHAR(100) NOT NULL,
    PRIMARY KEY (module_id),
    CONSTRAINT fk_graphic_cards_module FOREIGN KEY (module_id) REFERENCES modules (module_id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- rated_power 단위: W
CREATE TABLE power
(
    module_id     BIGINT      NOT NULL,
    rated_power   INT         NOT NULL,
    certification VARCHAR(20) NOT NULL,
    form_factor   VARCHAR(20) NOT NULL,
    PRIMARY KEY (module_id),
    CONSTRAINT fk_power_module FOREIGN KEY (module_id) REFERENCES modules (module_id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- capacity 단위: GB, read_speed / write_speed 단위: MB/s
CREATE TABLE ssds
(
    module_id   BIGINT      NOT NULL,
    form_factor VARCHAR(20) NOT NULL,
    capacity    INT         NOT NULL,
    read_speed  INT         NOT NULL,
    write_speed INT         NOT NULL,
    PRIMARY KEY (module_id),
    CONSTRAINT fk_ssds_module FOREIGN KEY (module_id) REFERENCES modules (module_id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- capacity 단위: TB, buffer_memory 단위: MB
CREATE TABLE hdds
(
    module_id      BIGINT      NOT NULL,
    interface_type VARCHAR(20) NOT NULL,
    capacity       INT         NOT NULL,
    rpm            INT         NOT NULL,
    buffer_memory  INT         NOT NULL,
    PRIMARY KEY (module_id),
    CONSTRAINT fk_hdds_module FOREIGN KEY (module_id) REFERENCES modules (module_id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;

-- screen_size 단위: 인치, refresh_rate 단위: Hz
CREATE TABLE monitors
(
    module_id    BIGINT        NOT NULL,
    screen_size  DECIMAL(4, 1) NOT NULL,
    resolution   VARCHAR(30)   NOT NULL,
    panel_type   VARCHAR(20)   NOT NULL,
    refresh_rate INT           NOT NULL,
    aspect_ratio VARCHAR(10)   NOT NULL,
    PRIMARY KEY (module_id),
    CONSTRAINT fk_monitors_module FOREIGN KEY (module_id) REFERENCES modules (module_id) ON DELETE CASCADE
) DEFAULT CHARSET = utf8mb4;
