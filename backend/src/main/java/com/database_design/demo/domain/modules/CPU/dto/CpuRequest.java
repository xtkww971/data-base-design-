package com.database_design.demo.domain.modules.CPU.dto;

import com.database_design.demo.domain.modules.CPU.entity.CPU;
import com.database_design.demo.domain.modules.common.entity.Category;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

/**
 * CPU 등록 / 수정 요청 DTO.
 */
public record CpuRequest(
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

        @NotNull(message = "코어 수는 필수입니다.")
        @Positive(message = "코어 수는 0보다 커야 합니다.")
        Integer cores,

        @NotNull(message = "스레드 수는 필수입니다.")
        @Positive(message = "스레드 수는 0보다 커야 합니다.")
        Integer threads,

        @NotNull(message = "내장 그래픽 유무는 필수입니다.")
        Boolean hasGraphics,

        @NotBlank(message = "동작 클럭은 필수입니다.")
        @Size(max = 20, message = "동작 클럭은 20자 이하여야 합니다.")
        String clockSpeed) {

    public CPU toEntity(Category category) {
        return CPU.builder()
                .category(category)
                .name(name)
                .brand(brand)
                .price(price)
                .imageUrl(imageUrl)
                .socket(socket)
                .cores(cores)
                .threads(threads)
                .hasGraphics(hasGraphics)
                .clockSpeed(clockSpeed)
                .build();
    }
}
