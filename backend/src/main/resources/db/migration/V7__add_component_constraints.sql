-- 부품 제약조건과 호환성 스키마. 상세 설계와 근거: docs/스키마 설계/04-부품별-제약조건.md
--   1. 값 제약       : 숫자 스펙이 0 이하로 저장되지 않게 한다 (CHECK)
--   2. A 단일 부품    : 소켓·메모리 규격·칩셋을 조회 테이블로 고정하고, 실제로 존재하는 조합만 허용한다 (FK)
--   3. 추가 스펙 컬럼 : 호환성·경고 판정에 필요한 컬럼 (B7~B9, W1~W5)
--   4. B 견적         : builds 에 스펙을 복사해 같은 행 안에서 비교한다 (복합 FK + CHECK)
--   5. W 경고         : 경고 규칙별 벌점과 안내 문구
--   6. 뷰             : 견적 없이 쓰는 판별 뷰·경고 뷰, 저장된 견적의 경고 뷰

-- ---------------------------------------------------------------------------
-- 1. 값 제약
-- ---------------------------------------------------------------------------

ALTER TABLE modules
    ADD CONSTRAINT ck_modules_price_nonnegative
        CHECK (price >= 0),
    ADD CONSTRAINT ck_modules_performance_score_nonnegative
        CHECK (performance_score >= 0);

ALTER TABLE cpus
    ADD CONSTRAINT ck_cpus_cores_positive
        CHECK (cores > 0),
    ADD CONSTRAINT ck_cpus_threads_gte_cores
        CHECK (threads >= cores);

ALTER TABLE main_boards
    ADD CONSTRAINT ck_main_boards_memory_slots_positive
        CHECK (memory_slots > 0);

ALTER TABLE rams
    ADD CONSTRAINT ck_rams_capacity_positive
        CHECK (capacity > 0),
    ADD CONSTRAINT ck_rams_clock_positive
        CHECK (clock > 0),
    ADD CONSTRAINT ck_rams_package_count_positive
        CHECK (package_count > 0);

ALTER TABLE graphic_cards
    ADD CONSTRAINT ck_graphic_cards_memory_capacity_positive
        CHECK (memory_capacity > 0),
    ADD CONSTRAINT ck_graphic_cards_length_positive
        CHECK (length_mm > 0),
    ADD CONSTRAINT ck_graphic_cards_recommended_power_positive
        CHECK (recommended_power > 0);

ALTER TABLE power
    ADD CONSTRAINT ck_power_rated_power_positive
        CHECK (rated_power > 0);

ALTER TABLE ssds
    ADD CONSTRAINT ck_ssds_capacity_positive
        CHECK (capacity > 0),
    ADD CONSTRAINT ck_ssds_read_speed_positive
        CHECK (read_speed > 0),
    ADD CONSTRAINT ck_ssds_write_speed_positive
        CHECK (write_speed > 0);

ALTER TABLE hdds
    ADD CONSTRAINT ck_hdds_capacity_positive
        CHECK (capacity > 0),
    ADD CONSTRAINT ck_hdds_rpm_positive
        CHECK (rpm > 0),
    ADD CONSTRAINT ck_hdds_buffer_memory_nonnegative
        CHECK (buffer_memory >= 0);

ALTER TABLE monitors
    ADD CONSTRAINT ck_monitors_screen_size_positive
        CHECK (screen_size > 0),
    ADD CONSTRAINT ck_monitors_refresh_rate_positive
        CHECK (refresh_rate > 0);

-- ---------------------------------------------------------------------------
-- 2. A 단일 부품 정합성 (A1~A3)
-- ---------------------------------------------------------------------------

CREATE TABLE sockets
(
    socket VARCHAR(20) NOT NULL,
    PRIMARY KEY (socket)
) DEFAULT CHARSET = utf8mb4;

CREATE TABLE memory_specs
(
    memory_spec VARCHAR(10) NOT NULL,
    PRIMARY KEY (memory_spec)
) DEFAULT CHARSET = utf8mb4;

-- A1: 소켓이 지원하는 메모리 규격. LGA1700 처럼 두 규격을 지원하면 행이 두 개다.
CREATE TABLE socket_memory_specs
(
    socket      VARCHAR(20) NOT NULL,
    memory_spec VARCHAR(10) NOT NULL,
    PRIMARY KEY (socket, memory_spec),
    KEY idx_socket_memory_specs_memory_spec (memory_spec),
    CONSTRAINT fk_socket_memory_specs_socket FOREIGN KEY (socket) REFERENCES sockets (socket),
    CONSTRAINT fk_socket_memory_specs_memory_spec FOREIGN KEY (memory_spec) REFERENCES memory_specs (memory_spec)
) DEFAULT CHARSET = utf8mb4;

-- A2: 칩셋이 속한 소켓. supports_cpu_oc 는 W4, rated_cpu_tdp_watt 는 W5 에 쓴다.
-- rated_cpu_tdp_watt: 칩셋이 상정하는 CPU TDP(W). 제한이 알려지지 않았으면 NULL
CREATE TABLE chipsets
(
    chipset            VARCHAR(30) NOT NULL,
    socket             VARCHAR(20) NOT NULL,
    supports_cpu_oc    BIT(1)      NOT NULL,
    rated_cpu_tdp_watt INT         NULL,
    PRIMARY KEY (chipset),
    UNIQUE KEY uk_chipsets_chipset_socket (chipset, socket),
    CONSTRAINT fk_chipsets_socket FOREIGN KEY (socket) REFERENCES sockets (socket),
    CONSTRAINT ck_chipsets_rated_cpu_tdp_positive CHECK (rated_cpu_tdp_watt > 0)
) DEFAULT CHARSET = utf8mb4;

INSERT INTO sockets (socket)
VALUES ('LGA1700'),
       ('AM4'),
       ('AM5');

INSERT INTO memory_specs (memory_spec)
VALUES ('DDR4'),
       ('DDR5');

INSERT INTO socket_memory_specs (socket, memory_spec)
VALUES ('LGA1700', 'DDR4'),
       ('LGA1700', 'DDR5'),
       ('AM4', 'DDR4'),
       ('AM5', 'DDR5');

-- CPU 오버클럭: 인텔은 Z 시리즈만, AMD 는 A 시리즈와 B840 을 뺀 칩셋
INSERT INTO chipsets (chipset, socket, supports_cpu_oc, rated_cpu_tdp_watt)
VALUES ('Z790', 'LGA1700', 1, NULL),
       ('Z690', 'LGA1700', 1, NULL),
       ('H770', 'LGA1700', 0, NULL),
       ('H670', 'LGA1700', 0, NULL),
       ('B760', 'LGA1700', 0, NULL),
       ('B660', 'LGA1700', 0, NULL),
       ('H610', 'LGA1700', 0, NULL),
       ('X870E', 'AM5', 1, NULL),
       ('X870', 'AM5', 1, NULL),
       ('B850', 'AM5', 1, NULL),
       ('B840', 'AM5', 0, NULL),
       ('X670E', 'AM5', 1, NULL),
       ('X670', 'AM5', 1, NULL),
       ('B650E', 'AM5', 1, NULL),
       ('B650', 'AM5', 1, NULL),
       ('A620', 'AM5', 0, 65),
       ('X570', 'AM4', 1, NULL),
       ('B550', 'AM4', 1, NULL),
       ('B450', 'AM4', 1, NULL),
       ('A520', 'AM4', 0, NULL);

-- A3: 상세 테이블이 조회 테이블을 참조
ALTER TABLE cpus
    ADD CONSTRAINT fk_cpus_socket FOREIGN KEY (socket) REFERENCES sockets (socket);

ALTER TABLE rams
    ADD CONSTRAINT fk_rams_memory_spec FOREIGN KEY (memory_spec) REFERENCES memory_specs (memory_spec);

-- A1, A2: 보드의 스펙 조합이 실제로 존재하는 조합인지
ALTER TABLE main_boards
    ADD CONSTRAINT fk_main_boards_socket_memory_spec
        FOREIGN KEY (socket, memory_spec) REFERENCES socket_memory_specs (socket, memory_spec),
    ADD CONSTRAINT fk_main_boards_chipset_socket
        FOREIGN KEY (chipset, socket) REFERENCES chipsets (chipset, socket);

-- ---------------------------------------------------------------------------
-- 3. 추가 스펙 컬럼
-- ---------------------------------------------------------------------------

-- B7: 보조전원 커넥터. pcie_8pin_count 는 카드가 요구하는 8핀 개수이고,
-- 16핀 카드는 동봉 어댑터가 요구하는 8핀 개수를 넣는다.
-- DEFAULT 0 은 기존 행을 채우기 위한 값이다. 부품 등록 API 는 아직 이 컬럼을 받지 않는다.
ALTER TABLE graphic_cards
    ADD COLUMN uses_16pin      BIT(1) NOT NULL DEFAULT 0 AFTER recommended_power,
    ADD COLUMN pcie_8pin_count INT    NOT NULL DEFAULT 0 AFTER uses_16pin,
    ADD CONSTRAINT ck_graphic_cards_pcie_8pin_count_nonnegative CHECK (pcie_8pin_count >= 0);

-- B7: 파워가 제공하는 커넥터
ALTER TABLE power
    ADD COLUMN has_16pin       BIT(1) NOT NULL DEFAULT 0 AFTER rated_power,
    ADD COLUMN pcie_8pin_count INT    NOT NULL DEFAULT 0 AFTER has_16pin,
    ADD CONSTRAINT ck_power_pcie_8pin_count_nonnegative CHECK (pcie_8pin_count >= 0);

-- B8: 보드 최대 메모리 용량(GB), B9: 보드 영상 출력 단자 유무. 모르면 NULL (판정하지 않음)
ALTER TABLE main_boards
    ADD COLUMN max_memory_gb    INT    NULL AFTER memory_slots,
    ADD COLUMN has_video_output BIT(1) NULL AFTER max_memory_gb,
    ADD CONSTRAINT ck_main_boards_max_memory_gb_positive CHECK (max_memory_gb > 0);

-- W4: 배수 제한이 풀린 CPU 인지, W5: CPU TDP(W). 모르면 NULL (경고하지 않음)
ALTER TABLE cpus
    ADD COLUMN tdp_watt      INT    NULL AFTER clock_speed,
    ADD COLUMN overclockable BIT(1) NULL AFTER tdp_watt,
    ADD CONSTRAINT ck_cpus_tdp_watt_positive CHECK (tdp_watt > 0);

-- W1, W2: CPU 가 공식 지원하는 메모리 클럭. 단위 MT/s.
-- 메모리 규격마다(인텔 DDR4/DDR5), 장착 모듈 수마다(2 DIMM / 4 DIMM) 다르다.
-- max_clock_4dimm 을 모르면 NULL (W2 판정 안 함)
CREATE TABLE cpu_memory_clocks
(
    cpu_id          BIGINT      NOT NULL,
    memory_spec     VARCHAR(10) NOT NULL,
    max_clock_2dimm INT         NOT NULL,
    max_clock_4dimm INT         NULL,
    PRIMARY KEY (cpu_id, memory_spec),
    KEY idx_cpu_memory_clocks_memory_spec (memory_spec),
    CONSTRAINT fk_cpu_memory_clocks_cpu FOREIGN KEY (cpu_id) REFERENCES cpus (module_id) ON DELETE CASCADE,
    CONSTRAINT fk_cpu_memory_clocks_memory_spec FOREIGN KEY (memory_spec) REFERENCES memory_specs (memory_spec),
    CONSTRAINT ck_cpu_memory_clocks_2dimm_positive CHECK (max_clock_2dimm > 0),
    CONSTRAINT ck_cpu_memory_clocks_4dimm_lte_2dimm CHECK (max_clock_4dimm <= max_clock_2dimm)
) DEFAULT CHARSET = utf8mb4;

-- ---------------------------------------------------------------------------
-- 4. B 견적 (선택지 1: builds + 복합 FK + CHECK)
-- ---------------------------------------------------------------------------

-- 복합 FK 의 참조 대상. module_id 가 이미 PK 라 UNIQUE 는 항상 만족한다.
ALTER TABLE cpus
    ADD UNIQUE KEY uk_cpus_compat (module_id, socket, has_graphics);
ALTER TABLE main_boards
    ADD UNIQUE KEY uk_main_boards_compat (module_id, socket, memory_spec, memory_slots),
    -- NULL 이 될 수 있는 컬럼은 따로 묶는다. 한 FK 에 섞으면 NULL 일 때 소켓·규격 검사까지 건너뛴다.
    ADD UNIQUE KEY uk_main_boards_limits (module_id, max_memory_gb, has_video_output);
ALTER TABLE rams
    ADD UNIQUE KEY uk_rams_compat (module_id, memory_spec, package_count, capacity);
ALTER TABLE graphic_cards
    ADD UNIQUE KEY uk_graphic_cards_compat (module_id, recommended_power, uses_16pin, pcie_8pin_count);
ALTER TABLE power
    ADD UNIQUE KEY uk_power_compat (module_id, rated_power, has_16pin, pcie_8pin_count);

-- 견적. 부품 칸마다 id 와 비교에 쓸 스펙을 함께 둔다. 스펙은 복합 FK 가 원본과 같은 값임을 보장한다.
-- status: DRAFT 는 빈 칸 허용, COMPLETE 는 필수 구성(B6)까지 검사
CREATE TABLE builds
(
    build_id               BIGINT       NOT NULL AUTO_INCREMENT,
    user_id                BIGINT       NOT NULL,
    title                  VARCHAR(100) NOT NULL,
    status                 VARCHAR(10)  NOT NULL DEFAULT 'DRAFT',
    cpu_id                 BIGINT       NULL,
    cpu_socket             VARCHAR(20)  NULL,
    cpu_has_graphics       BIT(1)       NULL,
    board_id               BIGINT       NULL,
    board_socket           VARCHAR(20)  NULL,
    board_memory_spec      VARCHAR(10)  NULL,
    board_memory_slots     INT          NULL,
    board_max_memory_gb    INT          NULL,
    board_has_video_output BIT(1)       NULL,
    ram_id                 BIGINT       NULL,
    ram_memory_spec        VARCHAR(10)  NULL,
    ram_package_count      INT          NULL,
    ram_capacity           INT          NULL,
    ram_quantity           INT          NULL,
    gpu_id                 BIGINT       NULL,
    gpu_recommended_power  INT          NULL,
    gpu_uses_16pin         BIT(1)       NULL,
    gpu_pcie_8pin_count    INT          NULL,
    power_id               BIGINT       NULL,
    power_rated_power      INT          NULL,
    power_has_16pin        BIT(1)       NULL,
    power_pcie_8pin_count  INT          NULL,
    created_at             DATETIME(6)  NOT NULL,
    PRIMARY KEY (build_id),
    -- 내 견적 목록: WHERE user_id = ? ORDER BY created_at DESC
    KEY idx_builds_user_created (user_id, created_at),
    CONSTRAINT fk_builds_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
    -- 참조 동작은 기본값(RESTRICT). CHECK 에 쓰인 컬럼에는 ON UPDATE/DELETE 동작을 걸 수 없다.
    CONSTRAINT fk_builds_cpu FOREIGN KEY (cpu_id, cpu_socket, cpu_has_graphics)
        REFERENCES cpus (module_id, socket, has_graphics),
    CONSTRAINT fk_builds_board FOREIGN KEY (board_id, board_socket, board_memory_spec, board_memory_slots)
        REFERENCES main_boards (module_id, socket, memory_spec, memory_slots),
    CONSTRAINT fk_builds_board_limits FOREIGN KEY (board_id, board_max_memory_gb, board_has_video_output)
        REFERENCES main_boards (module_id, max_memory_gb, has_video_output),
    CONSTRAINT fk_builds_ram FOREIGN KEY (ram_id, ram_memory_spec, ram_package_count, ram_capacity)
        REFERENCES rams (module_id, memory_spec, package_count, capacity),
    CONSTRAINT fk_builds_gpu FOREIGN KEY (gpu_id, gpu_recommended_power, gpu_uses_16pin, gpu_pcie_8pin_count)
        REFERENCES graphic_cards (module_id, recommended_power, uses_16pin, pcie_8pin_count),
    CONSTRAINT fk_builds_power FOREIGN KEY (power_id, power_rated_power, power_has_16pin, power_pcie_8pin_count)
        REFERENCES power (module_id, rated_power, has_16pin, pcie_8pin_count),

    CONSTRAINT ck_builds_status CHECK (status IN ('DRAFT', 'COMPLETE')),
    CONSTRAINT ck_builds_ram_quantity_positive CHECK (ram_quantity > 0),

    -- 짝 맞춤: id 와 복사한 스펙은 함께 채우거나 함께 비운다.
    -- 복합 FK 는 컬럼 중 하나라도 NULL 이면 검사를 건너뛰므로, 스펙만 비워 FK 를 우회하는 것을 막는다.
    CONSTRAINT ck_builds_cpu_pair CHECK (
        (cpu_id IS NULL) = (cpu_socket IS NULL)
            AND (cpu_id IS NULL) = (cpu_has_graphics IS NULL)),
    CONSTRAINT ck_builds_board_pair CHECK (
        (board_id IS NULL) = (board_socket IS NULL)
            AND (board_id IS NULL) = (board_memory_spec IS NULL)
            AND (board_id IS NULL) = (board_memory_slots IS NULL)),
    -- max_memory_gb, has_video_output 은 원본도 NULL 일 수 있어 보드가 없을 때 비어 있는지만 본다.
    CONSTRAINT ck_builds_board_limits_pair CHECK (
        board_id IS NOT NULL OR (board_max_memory_gb IS NULL AND board_has_video_output IS NULL)),
    CONSTRAINT ck_builds_ram_pair CHECK (
        (ram_id IS NULL) = (ram_memory_spec IS NULL)
            AND (ram_id IS NULL) = (ram_package_count IS NULL)
            AND (ram_id IS NULL) = (ram_capacity IS NULL)
            AND (ram_id IS NULL) = (ram_quantity IS NULL)),
    CONSTRAINT ck_builds_gpu_pair CHECK (
        (gpu_id IS NULL) = (gpu_recommended_power IS NULL)
            AND (gpu_id IS NULL) = (gpu_uses_16pin IS NULL)
            AND (gpu_id IS NULL) = (gpu_pcie_8pin_count IS NULL)),
    CONSTRAINT ck_builds_power_pair CHECK (
        (power_id IS NULL) = (power_rated_power IS NULL)
            AND (power_id IS NULL) = (power_has_16pin IS NULL)
            AND (power_id IS NULL) = (power_pcie_8pin_count IS NULL)),

    -- B1: CPU 소켓 = 보드 소켓
    CONSTRAINT ck_builds_b1_socket CHECK (
        cpu_id IS NULL OR board_id IS NULL OR cpu_socket = board_socket),
    -- B2: 램 규격 = 보드 메모리 규격 (DDR4 보드 + DDR5 램 금지)
    CONSTRAINT ck_builds_b2_memory_spec CHECK (
        ram_id IS NULL OR board_id IS NULL OR ram_memory_spec = board_memory_spec),
    -- B3: 램 총 모듈 수 <= 보드 슬롯 수
    CONSTRAINT ck_builds_b3_memory_slots CHECK (
        ram_id IS NULL OR board_id IS NULL OR ram_package_count * ram_quantity <= board_memory_slots),
    -- B5: 파워 정격 >= 그래픽카드 권장 파워
    CONSTRAINT ck_builds_b5_power CHECK (
        gpu_id IS NULL OR power_id IS NULL OR power_rated_power >= gpu_recommended_power),
    -- B6 (B4 포함): 완성 견적에는 CPU, 보드, 램, 파워가 있고, GPU 가 있거나 CPU 에 내장 그래픽이 있어야 한다
    CONSTRAINT ck_builds_b6_complete CHECK (
        status <> 'COMPLETE'
            OR (cpu_id IS NOT NULL AND board_id IS NOT NULL AND ram_id IS NOT NULL AND power_id IS NOT NULL
            AND (gpu_id IS NOT NULL OR cpu_has_graphics = 1))),
    -- B7: 파워 8핀 개수가 충분하거나, 16핀 카드를 16핀 파워에 바로 연결
    CONSTRAINT ck_builds_b7_power_connector CHECK (
        gpu_id IS NULL OR power_id IS NULL
            OR power_pcie_8pin_count >= gpu_pcie_8pin_count
            OR (gpu_uses_16pin = 1 AND power_has_16pin = 1)),
    -- B8: 램 총 용량 <= 보드 최대 메모리 용량 (보드 값을 모르면 판정 안 함)
    CONSTRAINT ck_builds_b8_memory_capacity CHECK (
        ram_id IS NULL OR board_id IS NULL OR board_max_memory_gb IS NULL
            OR ram_capacity * ram_quantity <= board_max_memory_gb),
    -- B9: 그래픽카드 없이 완성하면 보드에 영상 출력 단자가 있어야 한다 (보드 값을 모르면 판정 안 함)
    CONSTRAINT ck_builds_b9_video_output CHECK (
        status <> 'COMPLETE' OR gpu_id IS NOT NULL OR board_has_video_output = 1)
) DEFAULT CHARSET = utf8mb4;

-- 저장장치처럼 여러 개를 담는 부품
CREATE TABLE build_storages
(
    build_id  BIGINT NOT NULL,
    module_id BIGINT NOT NULL,
    quantity  INT    NOT NULL DEFAULT 1,
    PRIMARY KEY (build_id, module_id),
    KEY idx_build_storages_module_id (module_id),
    CONSTRAINT fk_build_storages_build FOREIGN KEY (build_id) REFERENCES builds (build_id) ON DELETE CASCADE,
    CONSTRAINT fk_build_storages_module FOREIGN KEY (module_id) REFERENCES modules (module_id),
    CONSTRAINT ck_build_storages_quantity_positive CHECK (quantity > 0)
) DEFAULT CHARSET = utf8mb4;

-- ---------------------------------------------------------------------------
-- 5. W 경고 규칙
-- ---------------------------------------------------------------------------

-- 경고 규칙별 벌점과 안내 문구. penalty 가 0 이면 정렬에 영향 없이 안내만 한다.
CREATE TABLE warning_rules
(
    warning_code VARCHAR(5)   NOT NULL,
    penalty      INT          NOT NULL,
    message      VARCHAR(200) NOT NULL,
    how_to_avoid VARCHAR(200) NOT NULL,
    PRIMARY KEY (warning_code),
    CONSTRAINT ck_warning_rules_penalty_nonnegative CHECK (penalty >= 0)
) DEFAULT CHARSET = utf8mb4;

INSERT INTO warning_rules (warning_code, penalty, message, how_to_avoid)
VALUES ('W1', 0, '램 클럭이 CPU 공식 지원 클럭보다 높습니다.',
        'BIOS 에서 XMP/EXPO 를 켜야 표기 속도로 동작합니다.'),
       ('W2', 20, '램 4개 장착 시 CPU 공식 지원 클럭이 낮아집니다.',
        '같은 총 용량의 2개짜리 키트 하나를 고르세요.'),
       ('W3', 30, '램 모듈이 1개라 싱글 채널로 동작합니다.',
        '같은 용량의 2개짜리 키트를 고르세요.'),
       ('W4', 20, '이 CPU 의 오버클럭 기능을 이 보드에서 쓸 수 없습니다.',
        'CPU 오버클럭을 지원하는 칩셋의 보드나 오버클럭 불가 CPU 를 고르세요.'),
       ('W5', 20, 'CPU 의 TDP 가 보드 칩셋이 상정하는 값보다 높아 성능이 제한될 수 있습니다.',
        '상위 칩셋의 보드를 고르세요.');

-- ---------------------------------------------------------------------------
-- 6. 뷰
-- ---------------------------------------------------------------------------

-- 견적 없이 쓰는 판별 뷰: 호환되는 쌍만 돌려준다. 뷰에 없는 쌍은 하드 규칙 위반이다.

-- B1: 소켓이 같은 CPU × 보드
CREATE VIEW v_cpu_board_compat AS
SELECT c.module_id AS cpu_id, mb.module_id AS board_id
FROM cpus c
         JOIN main_boards mb ON mb.socket = c.socket;

-- B2, B3, B8: 규격이 같고 키트 하나가 슬롯·최대 용량 안에 들어가는 램 × 보드
-- max_kits: 이 키트를 최대 몇 세트까지 담을 수 있는지 (B3, B8 의 수량 상한)
CREATE VIEW v_ram_board_compat AS
SELECT r.module_id AS ram_id,
       mb.module_id AS board_id,
       LEAST(mb.memory_slots DIV r.package_count,
             COALESCE(mb.max_memory_gb DIV r.capacity, mb.memory_slots DIV r.package_count)) AS max_kits
FROM rams r
         JOIN main_boards mb ON mb.memory_spec = r.memory_spec
WHERE r.package_count <= mb.memory_slots
  AND (mb.max_memory_gb IS NULL OR r.capacity <= mb.max_memory_gb);

-- 보드를 아직 고르지 않았을 때 CPU 의 소켓이 지원하는 규격의 램 (A1 + B1 + B2)
CREATE VIEW v_cpu_ram_compat AS
SELECT c.module_id AS cpu_id, r.module_id AS ram_id
FROM cpus c
         JOIN socket_memory_specs sms ON sms.socket = c.socket
         JOIN rams r ON r.memory_spec = sms.memory_spec;

-- B5, B7: 정격 출력과 보조전원 커넥터가 맞는 그래픽카드 × 파워
CREATE VIEW v_gpu_power_compat AS
SELECT g.module_id AS gpu_id, p.module_id AS power_id
FROM graphic_cards g
         JOIN power p ON p.rated_power >= g.recommended_power
WHERE p.pcie_8pin_count >= g.pcie_8pin_count
   OR (g.uses_16pin = 1 AND p.has_16pin = 1);

-- 견적 없이 쓰는 경고 뷰: 부품 쌍 단위. 정렬할 때 warning_rules 와 조인해 벌점을 더한다.

-- CPU × 보드 (W4, W5). 소켓이 맞는 쌍(B1 통과)만 대상
CREATE VIEW v_cpu_board_warnings AS
SELECT c.module_id AS cpu_id, mb.module_id AS board_id, 'W4' AS warning_code
FROM cpus c
         JOIN main_boards mb ON mb.socket = c.socket
         JOIN chipsets ch ON ch.chipset = mb.chipset
WHERE c.overclockable = 1
  AND ch.supports_cpu_oc = 0
UNION ALL
SELECT c.module_id, mb.module_id, 'W5'
FROM cpus c
         JOIN main_boards mb ON mb.socket = c.socket
         JOIN chipsets ch ON ch.chipset = mb.chipset
WHERE ch.rated_cpu_tdp_watt IS NOT NULL
  AND c.tdp_watt > ch.rated_cpu_tdp_watt;

-- CPU × 램 (W1, W2, W3). 키트 하나를 담는다고 가정한다.
-- cpu_memory_clocks 에는 CPU 가 지원하는 규격만 있으므로 조인 자체가 규격 호환을 보장한다.
CREATE VIEW v_cpu_ram_warnings AS
SELECT cm.cpu_id, r.module_id AS ram_id, 'W1' AS warning_code
FROM rams r
         JOIN cpu_memory_clocks cm ON cm.memory_spec = r.memory_spec
WHERE r.package_count <= 2
  AND r.clock > cm.max_clock_2dimm
UNION ALL
SELECT cm.cpu_id, r.module_id, 'W2'
FROM rams r
         JOIN cpu_memory_clocks cm ON cm.memory_spec = r.memory_spec
WHERE r.package_count > 2
  AND r.clock > cm.max_clock_4dimm
UNION ALL
SELECT cm.cpu_id, r.module_id, 'W3'
FROM rams r
         JOIN cpu_memory_clocks cm ON cm.memory_spec = r.memory_spec
WHERE r.package_count = 1;

-- 저장된 견적의 경고. 수량까지 반영한다.
CREATE VIEW v_build_warnings AS
SELECT b.build_id, 'W1' AS warning_code
FROM builds b
         JOIN rams r ON r.module_id = b.ram_id
         JOIN cpu_memory_clocks cm ON cm.cpu_id = b.cpu_id AND cm.memory_spec = b.ram_memory_spec
WHERE b.ram_package_count * b.ram_quantity <= 2
  AND r.clock > cm.max_clock_2dimm
UNION ALL
SELECT b.build_id, 'W2'
FROM builds b
         JOIN rams r ON r.module_id = b.ram_id
         JOIN cpu_memory_clocks cm ON cm.cpu_id = b.cpu_id AND cm.memory_spec = b.ram_memory_spec
WHERE b.ram_package_count * b.ram_quantity > 2
  AND r.clock > cm.max_clock_4dimm
UNION ALL
SELECT b.build_id, 'W3'
FROM builds b
WHERE b.ram_package_count * b.ram_quantity = 1
UNION ALL
SELECT b.build_id, 'W4'
FROM builds b
         JOIN cpus c ON c.module_id = b.cpu_id
         JOIN main_boards mb ON mb.module_id = b.board_id
         JOIN chipsets ch ON ch.chipset = mb.chipset
WHERE c.overclockable = 1
  AND ch.supports_cpu_oc = 0
UNION ALL
SELECT b.build_id, 'W5'
FROM builds b
         JOIN cpus c ON c.module_id = b.cpu_id
         JOIN main_boards mb ON mb.module_id = b.board_id
         JOIN chipsets ch ON ch.chipset = mb.chipset
WHERE ch.rated_cpu_tdp_watt IS NOT NULL
  AND c.tdp_watt > ch.rated_cpu_tdp_watt;
