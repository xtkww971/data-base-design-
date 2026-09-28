package com.database_design.demo.domain.modules.MainBoard.dto;

import com.database_design.demo.domain.modules.MainBoard.entity.MainBoard;
import com.database_design.demo.domain.modules.ProductCategory;

/**
 * 메인보드 목록 / 단건 응답 DTO.
 */
public record MainBoardResponse(
        Long moduleId,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        String socket,
        String formFactor,
        String memorySpec,
        Integer memorySlots,
        String chipset) {

    public static MainBoardResponse from(MainBoard mainBoard) {
        return new MainBoardResponse(
                mainBoard.getId(),
                mainBoard.getProductCategory(),
                mainBoard.getName(),
                mainBoard.getBrand(),
                mainBoard.getPrice(),
                mainBoard.getImageUrl(),
                mainBoard.getSocket(),
                mainBoard.getFormFactor(),
                mainBoard.getMemorySpec(),
                mainBoard.getMemorySlots(),
                mainBoard.getChipset());
    }
}
