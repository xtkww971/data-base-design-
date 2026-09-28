package com.database_design.demo.domain.modules.Ram.dto;

import com.database_design.demo.domain.modules.Ram.entity.Ram;
import com.database_design.demo.domain.modules.common.entity.Category;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

/**
 * 램 등록 / 수정 요청 DTO.
 */
public record RamRequest(
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

        @NotBlank(message = "메모리 규격은 필수입니다.")
        @Size(max = 10, message = "메모리 규격은 10자 이하여야 합니다.")
        String memorySpec,

        @NotNull(message = "용량(GB)은 필수입니다.")
        @Positive(message = "용량(GB)은 0보다 커야 합니다.")
        Integer capacity,

        @NotNull(message = "동작 클럭(MHz)은 필수입니다.")
        @Positive(message = "동작 클럭(MHz)은 0보다 커야 합니다.")
        Integer clock,

        @NotNull(message = "패키지 개수는 필수입니다.")
        @Positive(message = "패키지 개수는 0보다 커야 합니다.")
        Integer packageCount) {

    public Ram toEntity(Category category) {
        return Ram.builder()
                .category(category)
                .name(name)
                .brand(brand)
                .price(price)
                .imageUrl(imageUrl)
                .memorySpec(memorySpec)
                .capacity(capacity)
                .clock(clock)
                .packageCount(packageCount)
                .build();
    }
}
