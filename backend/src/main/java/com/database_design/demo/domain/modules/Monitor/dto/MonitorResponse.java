package com.database_design.demo.domain.modules.Monitor.dto;

import com.database_design.demo.domain.modules.Monitor.entity.Monitor;
import com.database_design.demo.domain.modules.ProductCategory;
import java.math.BigDecimal;

/**
 * 모니터 목록 / 단건 응답 DTO.
 */
public record MonitorResponse(
        Long moduleId,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        BigDecimal screenSize,
        String resolution,
        String panelType,
        Integer refreshRate,
        String aspectRatio) {

    public static MonitorResponse from(Monitor monitor) {
        return new MonitorResponse(
                monitor.getId(),
                monitor.getProductCategory(),
                monitor.getName(),
                monitor.getBrand(),
                monitor.getPrice(),
                monitor.getImageUrl(),
                monitor.getScreenSize(),
                monitor.getResolution(),
                monitor.getPanelType(),
                monitor.getRefreshRate(),
                monitor.getAspectRatio());
    }
}
