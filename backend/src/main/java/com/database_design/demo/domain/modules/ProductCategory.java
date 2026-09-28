package com.database_design.demo.domain.modules;

/**
 * 부품 카테고리. 프론트의 BaseProductDetail.category 와 값이 1:1 로 대응한다.
 */
public enum ProductCategory {

    CPU,
    MAINBOARD,
    RAM,
    GPU,
    POWER,
    SSD,
    HDD,
    MONITOR
}
