package com.database_design.demo.domain.modules.Ram.dto;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.Ram.entity.Ram;

/**
 * 램 상세 조회 응답 DTO.
 * 공통 필드는 BaseProductDetail 을 구현하고, 램 고유 스펙은 specs 에 담는다.
 */
public record RamDetailResponse(
        Long id,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        Specs specs) implements BaseProductDetail {

    /**
     * 램 고유 스펙.
     */
    public record Specs(
            String memorySpec,
            Integer capacity,
            Integer clock,
            Integer packageCount) {
    }

    public static RamDetailResponse from(Ram ram) {
        return new RamDetailResponse(
                ram.getId(),
                ram.getProductCategory(),
                ram.getName(),
                ram.getBrand(),
                ram.getPrice(),
                ram.getImageUrl(),
                new Specs(
                        ram.getMemorySpec(),
                        ram.getCapacity(),
                        ram.getClock(),
                        ram.getPackageCount()));
    }
}
