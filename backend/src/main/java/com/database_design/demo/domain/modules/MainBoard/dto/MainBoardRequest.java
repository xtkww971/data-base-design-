package com.database_design.demo.domain.modules.MainBoard.dto;

import com.database_design.demo.domain.modules.MainBoard.entity.MainBoard;
import com.database_design.demo.domain.modules.common.entity.Category;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

/**
 * 메인보드 등록 / 수정 요청 DTO.
 */
public record MainBoardRequest(
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

        @NotBlank(message = "소켓은 필수입니다.")
        @Size(max = 20, message = "소켓은 20자 이하여야 합니다.")
        String socket,

        @NotBlank(message = "폼팩터는 필수입니다.")
        @Size(max = 20, message = "폼팩터는 20자 이하여야 합니다.")
        String formFactor,

        @NotBlank(message = "메모리 규격은 필수입니다.")
        @Size(max = 10, message = "메모리 규격은 10자 이하여야 합니다.")
        String memorySpec,

        @NotNull(message = "메모리 슬롯 개수는 필수입니다.")
        @Positive(message = "메모리 슬롯 개수는 0보다 커야 합니다.")
        Integer memorySlots,

        @NotBlank(message = "칩셋은 필수입니다.")
        @Size(max = 30, message = "칩셋은 30자 이하여야 합니다.")
        String chipset) {

    public MainBoard toEntity(Category category) {
        return MainBoard.builder()
                .category(category)
                .name(name)
                .brand(brand)
                .price(price)
                .imageUrl(imageUrl)
                .socket(socket)
                .formFactor(formFactor)
                .memorySpec(memorySpec)
                .memorySlots(memorySlots)
                .chipset(chipset)
                .build();
    }
}
