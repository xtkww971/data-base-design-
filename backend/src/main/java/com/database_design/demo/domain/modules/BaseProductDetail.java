package com.database_design.demo.domain.modules;

/**
 * 모든 부품 상세 조회 응답이 공통으로 가지는 필드.
 * 각 부품의 XxxDetailResponse 가 이 인터페이스를 구현하고, 부품 고유 스펙은 specs 로 따로 담는다.
 */
public interface BaseProductDetail {

    /** 부품 식별자. */
    Long id();

    /** 부품 카테고리. */
    ProductCategory category();

    /** 제품명 (예: AMD 라이젠5 5세대 7500F). */
    String name();

    /** 제조사 (예: AMD). */
    String brand();

    /** 현재 기준 최저가 가격. */
    Integer price();

    /** 제품 큰 이미지 URL. */
    String imageUrl();
}
