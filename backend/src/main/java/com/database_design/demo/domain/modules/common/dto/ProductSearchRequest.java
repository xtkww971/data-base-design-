package com.database_design.demo.domain.modules.common.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Size;

/**
 * 부품 통합 검색 요청 DTO. 프론트의 ProductSearchQueryDto 와 필드명이 1:1 로 대응한다.
 * 쿼리 파라미터로 받으며, 값이 없으면 전체 카테고리 / 검색어 없음 / 0페이지 / 20개로 본다.
 */
public record ProductSearchRequest(
        /** 카테고리 필터 (예: "ALL", "CPU", "GPU"). 비어 있거나 ALL 이면 전체. */
        String category,

        /** 제품명, 브랜드 통합 검색어. */
        @Size(max = 100, message = "검색어는 100자 이하여야 합니다.")
        String searchTerm,

        /** 현재 페이지 (0부터 시작). */
        @Min(value = 0, message = "페이지는 0 이상이어야 합니다.")
        Integer page,

        /** 한 페이지의 카드 개수. */
        @Min(value = 1, message = "페이지 크기는 1 이상이어야 합니다.")
        @Max(value = 100, message = "페이지 크기는 100 이하여야 합니다.")
        Integer size) {

    private static final int DEFAULT_PAGE = 0;
    private static final int DEFAULT_SIZE = 20;

    public ProductSearchRequest {
        if (page == null) {
            page = DEFAULT_PAGE;
        }
        if (size == null) {
            size = DEFAULT_SIZE;
        }
    }
}
