package com.database_design.demo.domain.modules.Hdd.dto;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.Hdd.entity.Hdd;
import com.database_design.demo.domain.modules.ProductCategory;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * HDD 상세 조회 응답 DTO.
 * 공통 필드는 BaseProductDetail 을 구현하고, HDD 고유 스펙은 specs 에 담는다.
 */
public record HddDetailResponse(
        Long id,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        Specs specs) implements BaseProductDetail {

    /**
     * HDD 고유 스펙.
     */
    public record Specs(
            @JsonProperty("interface")
            String interfaceType,
            Integer capacity,
            Integer rpm,
            Integer bufferMemory) {
    }

    public static HddDetailResponse from(Hdd hdd) {
        return new HddDetailResponse(
                hdd.getId(),
                hdd.getProductCategory(),
                hdd.getName(),
                hdd.getBrand(),
                hdd.getPrice(),
                hdd.getImageUrl(),
                new Specs(
                        hdd.getInterfaceType(),
                        hdd.getCapacity(),
                        hdd.getRpm(),
                        hdd.getBufferMemory()));
    }
}
