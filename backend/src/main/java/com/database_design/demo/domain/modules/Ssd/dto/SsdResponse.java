package com.database_design.demo.domain.modules.Ssd.dto;

import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.Ssd.entity.Ssd;

/**
 * SSD 목록 / 단건 응답 DTO.
 */
public record SsdResponse(
        Long moduleId,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        String formFactor,
        Integer capacity,
        Integer readSpeed,
        Integer writeSpeed) {

    public static SsdResponse from(Ssd ssd) {
        return new SsdResponse(
                ssd.getId(),
                ssd.getProductCategory(),
                ssd.getName(),
                ssd.getBrand(),
                ssd.getPrice(),
                ssd.getImageUrl(),
                ssd.getFormFactor(),
                ssd.getCapacity(),
                ssd.getReadSpeed(),
                ssd.getWriteSpeed());
    }
}
