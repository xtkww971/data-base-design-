-- CPU, 메인 보드, RAM, 글카, 파워, SSD, HDD, 모니터
-- 가격은 '원' 단위 정수로 저장한다.

CREATE TABLE cpus
(
    cpu_id  BIGINT       NOT NULL AUTO_INCREMENT,
    name    VARCHAR(100) NOT NULL,
    price   INT          NOT NULL,
    socket  VARCHAR(20)  NOT NULL,
    cores   INT          NOT NULL,
    threads INT          NOT NULL,
    PRIMARY KEY (cpu_id)
) DEFAULT CHARSET = utf8mb4;

CREATE TABLE main_boards
(
    main_board_id BIGINT       NOT NULL AUTO_INCREMENT,
    name          VARCHAR(100) NOT NULL,
    price         INT          NOT NULL,
    socket        VARCHAR(20)  NOT NULL,
    chipset       VARCHAR(30)  NOT NULL,
    form_factor   VARCHAR(20)  NOT NULL,
    memory_type   VARCHAR(10)  NOT NULL,
    PRIMARY KEY (main_board_id)
) DEFAULT CHARSET = utf8mb4;

CREATE TABLE rams
(
    ram_id      BIGINT       NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100) NOT NULL,
    price       INT          NOT NULL,
    memory_type VARCHAR(10)  NOT NULL,
    capacity_gb INT          NOT NULL,
    speed_mhz   INT          NOT NULL,
    PRIMARY KEY (ram_id)
) DEFAULT CHARSET = utf8mb4;

CREATE TABLE graphic_cards
(
    graphic_card_id BIGINT       NOT NULL AUTO_INCREMENT,
    name            VARCHAR(100) NOT NULL,
    price           INT          NOT NULL,
    chipset         VARCHAR(50)  NOT NULL,
    vram_gb         INT          NOT NULL,
    tdp_watt        INT          NOT NULL,
    PRIMARY KEY (graphic_card_id)
) DEFAULT CHARSET = utf8mb4;

CREATE TABLE power
(
    power_id          BIGINT       NOT NULL AUTO_INCREMENT,
    name              VARCHAR(100) NOT NULL,
    price             INT          NOT NULL,
    wattage           INT          NOT NULL,
    efficiency_rating VARCHAR(20)  NOT NULL,
    PRIMARY KEY (power_id)
) DEFAULT CHARSET = utf8mb4;

-- SSD 와 HDD 는 속성이 같아 storage_type 으로 구분
CREATE TABLE memory
(
    memory_id    BIGINT       NOT NULL AUTO_INCREMENT,
    name         VARCHAR(100) NOT NULL,
    price        INT          NOT NULL,
    storage_type VARCHAR(10)  NOT NULL,
    capacity_gb  INT          NOT NULL,
    interface    VARCHAR(20)  NOT NULL,
    PRIMARY KEY (memory_id)
) DEFAULT CHARSET = utf8mb4;

CREATE TABLE monitors
(
    monitor_id      BIGINT        NOT NULL AUTO_INCREMENT,
    name            VARCHAR(100)  NOT NULL,
    price           INT           NOT NULL,
    size_inch       DECIMAL(4, 1) NOT NULL,
    resolution      VARCHAR(20)   NOT NULL,
    refresh_rate_hz INT           NOT NULL,
    PRIMARY KEY (monitor_id)
) DEFAULT CHARSET = utf8mb4;
