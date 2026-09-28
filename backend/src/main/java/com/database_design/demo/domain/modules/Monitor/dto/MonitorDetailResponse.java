package com.database_design.demo.domain.modules.Monitor.dto;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.Monitor.entity.Monitor;
import com.database_design.demo.domain.modules.ProductCategory;
import java.math.BigDecimal;

/**
 * 모니터 상세 조회 응답 DTO.
 * 공통 필드는 BaseProductDetail 을 구현하고, 모니터 고유 스펙은 specs 에 담는다.
 */
public record MonitorDetailResponse(
        Long id,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        Specs specs) implements BaseProductDetail {

    /**
     * 모니터 고유 스펙.
     */
    public record Specs(
            BigDecimal screenSize,
            String resolution,
            String panelType,
            Integer refreshRate,
            String aspectRatio) {
    }

    public static MonitorDetailResponse from(Monitor monitor) {
        return new MonitorDetailResponse(
                monitor.getId(),
                monitor.getProductCategory(),
                monitor.getName(),
                monitor.getBrand(),
                monitor.getPrice(),
                monitor.getImageUrl(),
                new Specs(
                        monitor.getScreenSize(),
                        monitor.getResolution(),
                        monitor.getPanelType(),
                        monitor.getRefreshRate(),
                        monitor.getAspectRatio()));
    }
}
