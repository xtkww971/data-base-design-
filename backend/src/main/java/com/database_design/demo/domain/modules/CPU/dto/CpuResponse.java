package com.database_design.demo.domain.modules.CPU.dto;

import com.database_design.demo.domain.modules.CPU.entity.CPU;
import com.database_design.demo.domain.modules.ProductCategory;

/**
 * CPU 목록 / 단건 응답 DTO.
 */
public record CpuResponse(
        Long moduleId,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        String socket,
        Integer cores,
        Integer threads,
        Boolean hasGraphics,
        String clockSpeed) {

    public static CpuResponse from(CPU cpu) {
        return new CpuResponse(
                cpu.getId(),
                cpu.getProductCategory(),
                cpu.getName(),
                cpu.getBrand(),
                cpu.getPrice(),
                cpu.getImageUrl(),
                cpu.getSocket(),
                cpu.getCores(),
                cpu.getThreads(),
                cpu.getHasGraphics(),
                cpu.getClockSpeed());
    }
}
