package com.database_design.demo.domain.modules.Power.dto;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.Power.entity.Power;
import com.database_design.demo.domain.modules.ProductCategory;

/**
 * 파워 상세 조회 응답 DTO.
 * 공통 필드는 BaseProductDetail 을 구현하고, 파워 고유 스펙은 specs 에 담는다.
 */
public record PowerDetailResponse(
        Long id,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        Specs specs) implements BaseProductDetail {

    /**
     * 파워 고유 스펙.
     */
    public record Specs(
            Integer ratedPower,
            String certification,
            String formFactor) {
    }

    public static PowerDetailResponse from(Power power) {
        return new PowerDetailResponse(
                power.getId(),
                power.getProductCategory(),
                power.getName(),
                power.getBrand(),
                power.getPrice(),
                power.getImageUrl(),
                new Specs(
                        power.getRatedPower(),
                        power.getCertification(),
                        power.getFormFactor()));
    }
}
