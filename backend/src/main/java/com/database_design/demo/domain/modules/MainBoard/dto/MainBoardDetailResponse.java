package com.database_design.demo.domain.modules.MainBoard.dto;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.MainBoard.entity.MainBoard;
import com.database_design.demo.domain.modules.ProductCategory;

/**
 * 메인보드 상세 조회 응답 DTO.
 * 공통 필드는 BaseProductDetail 을 구현하고, 메인보드 고유 스펙은 specs 에 담는다.
 */
public record MainBoardDetailResponse(
        Long id,
        ProductCategory category,
        String name,
        String brand,
        Integer price,
        String imageUrl,
        Specs specs) implements BaseProductDetail {

    /**
     * 메인보드 고유 스펙.
     */
    public record Specs(
            String socket,
            String formFactor,
            String memorySpec,
            Integer memorySlots,
            String chipset) {
    }

    public static MainBoardDetailResponse from(MainBoard mainBoard) {
        return new MainBoardDetailResponse(
                mainBoard.getId(),
                mainBoard.getProductCategory(),
                mainBoard.getName(),
                mainBoard.getBrand(),
                mainBoard.getPrice(),
                mainBoard.getImageUrl(),
                new Specs(
                        mainBoard.getSocket(),
                        mainBoard.getFormFactor(),
                        mainBoard.getMemorySpec(),
                        mainBoard.getMemorySlots(),
                        mainBoard.getChipset()));
    }
}
