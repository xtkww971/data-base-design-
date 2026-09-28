package com.database_design.demo.domain.modules.CPU.dto;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.CPU.entity.CPU;
import com.database_design.demo.domain.modules.ProductCategory;

/**
 * CPU 상세 조회 응답 DTO.
 * 공통 필드는 BaseProductDetail 을 구현하고, CPU 고유 스펙은 specs 에 담는다.
 */
public record CpuDetailResponse(
        Long id,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        Specs specs) implements BaseProductDetail {

    /**
     * CPU 고유 스펙.
     */
    public record Specs(
            String socket,
            Integer cores,
            Integer threads,
            Boolean hasGraphics,
            String clockSpeed) {
    }

    public static CpuDetailResponse from(CPU cpu) {
        return new CpuDetailResponse(
                cpu.getId(),
                cpu.getProductCategory(),
                cpu.getName(),
                cpu.getBrand(),
                cpu.getPrice(),
                cpu.getImageUrl(),
                new Specs(
                        cpu.getSocket(),
                        cpu.getCores(),
                        cpu.getThreads(),
                        cpu.getHasGraphics(),
                        cpu.getClockSpeed()));
    }
}
