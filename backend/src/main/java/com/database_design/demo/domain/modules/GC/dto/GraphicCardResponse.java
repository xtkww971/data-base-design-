package com.database_design.demo.domain.modules.GC.dto;

import com.database_design.demo.domain.modules.GC.entity.GraphicCard;
import com.database_design.demo.domain.modules.ProductCategory;

/**
 * 그래픽카드 목록 / 단건 응답 DTO.
 */
public record GraphicCardResponse(
        Long moduleId,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        String chipset,
        String memoryType,
        Integer memoryCapacity,
        Integer length,
        Integer recommendedPower,
        String ports) {

    public static GraphicCardResponse from(GraphicCard graphicCard) {
        return new GraphicCardResponse(
                graphicCard.getId(),
                graphicCard.getProductCategory(),
                graphicCard.getName(),
                graphicCard.getBrand(),
                graphicCard.getPrice(),
                graphicCard.getImageUrl(),
                graphicCard.getChipset(),
                graphicCard.getMemoryType(),
                graphicCard.getMemoryCapacity(),
                graphicCard.getLength(),
                graphicCard.getRecommendedPower(),
                graphicCard.getPorts());
    }
}
