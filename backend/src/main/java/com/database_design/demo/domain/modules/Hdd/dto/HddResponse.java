package com.database_design.demo.domain.modules.Hdd.dto;

import com.database_design.demo.domain.modules.Hdd.entity.Hdd;
import com.database_design.demo.domain.modules.ProductCategory;
import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * HDD 목록 / 단건 응답 DTO.
 */
public record HddResponse(
        Long moduleId,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        @JsonProperty("interface")
        String interfaceType,
        Integer capacity,
        Integer rpm,
        Integer bufferMemory) {

    public static HddResponse from(Hdd hdd) {
        return new HddResponse(
                hdd.getId(),
                hdd.getProductCategory(),
                hdd.getName(),
                hdd.getBrand(),
                hdd.getPrice(),
                hdd.getImageUrl(),
                hdd.getInterfaceType(),
                hdd.getCapacity(),
                hdd.getRpm(),
                hdd.getBufferMemory());
    }
}
