package com.database_design.demo.domain.modules.GC.dto;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.GC.entity.GraphicCard;
import com.database_design.demo.domain.modules.ProductCategory;

/**
 * 그래픽카드 상세 조회 응답 DTO.
 * 공통 필드는 BaseProductDetail 을 구현하고, 그래픽카드 고유 스펙은 specs 에 담는다.
 */
public record GraphicCardDetailResponse(
        Long id,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        Specs specs) implements BaseProductDetail {

    /**
     * 그래픽카드 고유 스펙.
     */
    public record Specs(
            String chipset,
            String memoryType,
            Integer memoryCapacity,
            Integer length,
            Integer recommendedPower,
            String ports) {
    }

    public static GraphicCardDetailResponse from(GraphicCard graphicCard) {
        return new GraphicCardDetailResponse(
                graphicCard.getId(),
                graphicCard.getProductCategory(),
                graphicCard.getName(),
                graphicCard.getBrand(),
                graphicCard.getPrice(),
                graphicCard.getImageUrl(),
                new Specs(
                        graphicCard.getChipset(),
                        graphicCard.getMemoryType(),
                        graphicCard.getMemoryCapacity(),
                        graphicCard.getLength(),
                        graphicCard.getRecommendedPower(),
                        graphicCard.getPorts()));
    }
}
