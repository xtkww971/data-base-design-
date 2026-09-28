package com.database_design.demo.domain.modules.GC.dto;

import com.database_design.demo.domain.modules.GC.entity.GraphicCard;
import com.database_design.demo.domain.modules.common.entity.Category;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

/**
 * 그래픽카드 등록 / 수정 요청 DTO.
 */
public record GraphicCardRequest(
        @NotBlank(message = "제품명은 필수입니다.")
        @Size(max = 100, message = "제품명은 100자 이하여야 합니다.")
        String name,

        @NotBlank(message = "제조사는 필수입니다.")
        @Size(max = 50, message = "제조사는 50자 이하여야 합니다.")
        String brand,

        @NotNull(message = "가격은 필수입니다.")
        @Positive(message = "가격은 0보다 커야 합니다.")
        Integer price,

        @Size(max = 500, message = "이미지 주소는 500자 이하여야 합니다.")
        String imageUrl,

        @NotBlank(message = "칩셋은 필수입니다.")
        @Size(max = 50, message = "칩셋은 50자 이하여야 합니다.")
        String chipset,

        @NotBlank(message = "메모리 종류는 필수입니다.")
        @Size(max = 20, message = "메모리 종류는 20자 이하여야 합니다.")
        String memoryType,

        @NotNull(message = "메모리 용량(GB)은 필수입니다.")
        @Positive(message = "메모리 용량(GB)은 0보다 커야 합니다.")
        Integer memoryCapacity,

        @NotNull(message = "가로 길이(mm)는 필수입니다.")
        @Positive(message = "가로 길이(mm)는 0보다 커야 합니다.")
        Integer length,

        @NotNull(message = "권장 파워 용량(W)은 필수입니다.")
        @Positive(message = "권장 파워 용량(W)은 0보다 커야 합니다.")
        Integer recommendedPower,

        @NotBlank(message = "출력 단자는 필수입니다.")
        @Size(max = 100, message = "출력 단자는 100자 이하여야 합니다.")
        String ports) {

    public GraphicCard toEntity(Category category) {
        return GraphicCard.builder()
                .category(category)
                .name(name)
                .brand(brand)
                .price(price)
                .imageUrl(imageUrl)
                .chipset(chipset)
                .memoryType(memoryType)
                .memoryCapacity(memoryCapacity)
                .length(length)
                .recommendedPower(recommendedPower)
                .ports(ports)
                .build();
    }
}
