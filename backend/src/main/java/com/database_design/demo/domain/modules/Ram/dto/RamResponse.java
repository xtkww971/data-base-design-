package com.database_design.demo.domain.modules.Ram.dto;

import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.Ram.entity.Ram;

/**
 * 램 목록 / 단건 응답 DTO.
 */
public record RamResponse(
        Long moduleId,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        String memorySpec,
        Integer capacity,
        Integer clock,
        Integer packageCount) {

    public static RamResponse from(Ram ram) {
        return new RamResponse(
                ram.getId(),
                ram.getProductCategory(),
                ram.getName(),
                ram.getBrand(),
                ram.getPrice(),
                ram.getImageUrl(),
                ram.getMemorySpec(),
                ram.getCapacity(),
                ram.getClock(),
                ram.getPackageCount());
    }
}
