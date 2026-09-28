package com.database_design.demo.domain.modules.Ssd.dto;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.Ssd.entity.Ssd;

/**
 * SSD 상세 조회 응답 DTO.
 * 공통 필드는 BaseProductDetail 을 구현하고, SSD 고유 스펙은 specs 에 담는다.
 */
public record SsdDetailResponse(
        Long id,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        Specs specs) implements BaseProductDetail {

    /**
     * SSD 고유 스펙.
     */
    public record Specs(
            String formFactor,
            Integer capacity,
            Integer readSpeed,
            Integer writeSpeed) {
    }

    public static SsdDetailResponse from(Ssd ssd) {
        return new SsdDetailResponse(
                ssd.getId(),
                ssd.getProductCategory(),
                ssd.getName(),
                ssd.getBrand(),
                ssd.getPrice(),
                ssd.getImageUrl(),
                new Specs(
                        ssd.getFormFactor(),
                        ssd.getCapacity(),
                        ssd.getReadSpeed(),
                        ssd.getWriteSpeed()));
    }
}
