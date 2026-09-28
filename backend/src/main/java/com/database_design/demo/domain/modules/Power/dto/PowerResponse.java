package com.database_design.demo.domain.modules.Power.dto;

import com.database_design.demo.domain.modules.Power.entity.Power;
import com.database_design.demo.domain.modules.ProductCategory;

/**
 * 파워 목록 / 단건 응답 DTO.
 */
public record PowerResponse(
        Long moduleId,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        Integer ratedPower,
        String certification,
        String formFactor) {

    public static PowerResponse from(Power power) {
        return new PowerResponse(
                power.getId(),
                power.getProductCategory(),
                power.getName(),
                power.getBrand(),
                power.getPrice(),
                power.getImageUrl(),
                power.getRatedPower(),
                power.getCertification(),
                power.getFormFactor());
    }
}
