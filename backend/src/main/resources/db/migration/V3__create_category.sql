-- 부품 카테고리 + 모든 부품이 공유하는 공통 테이블.
-- 공통 속성(name, brand, price, image_url)은 modules 에 한 번만 두고,
-- 부품별 고유 스펙은 V4 에서 만드는 상세 테이블이 module_id 로 1:1 참조한다.

CREATE TABLE categories
(
    category_id   BIGINT      NOT NULL AUTO_INCREMENT,
    category_name VARCHAR(20) NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY uk_categories_category_name (category_name)
) DEFAULT CHARSET = utf8mb4;

INSERT INTO categories (category_name)
VALUES ('CPU'),
       ('MAINBOARD'),
       ('RAM'),
       ('GPU'),
       ('POWER'),
       ('SSD'),
       ('HDD'),
       ('MONITOR');

-- 가격은 '원' 단위 정수로 저장한다.
CREATE TABLE modules
(
    module_id   BIGINT       NOT NULL AUTO_INCREMENT,
    category_id BIGINT       NOT NULL,
    name        VARCHAR(100) NOT NULL,
    brand       VARCHAR(50)  NOT NULL,
    price       INT          NOT NULL,
    image_url   VARCHAR(500) NULL,
    PRIMARY KEY (module_id),
    KEY idx_modules_category_id (category_id),
    KEY idx_modules_name (name),
    KEY idx_modules_brand (brand),
    CONSTRAINT fk_modules_category FOREIGN KEY (category_id) REFERENCES categories (category_id)
) DEFAULT CHARSET = utf8mb4;
