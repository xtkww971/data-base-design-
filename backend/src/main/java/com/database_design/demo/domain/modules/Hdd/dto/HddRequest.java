package com.database_design.demo.domain.modules.Hdd.dto;

import com.database_design.demo.domain.modules.Hdd.entity.Hdd;
import com.database_design.demo.domain.modules.common.entity.Category;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

/**
 * HDD 등록 / 수정 요청 DTO.
 */
public record HddRequest(
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

        @JsonProperty("interface")
        @NotBlank(message = "인터페이스는 필수입니다.")
        @Size(max = 20, message = "인터페이스는 20자 이하여야 합니다.")
        String interfaceType,

        @NotNull(message = "용량(TB)은 필수입니다.")
        @Positive(message = "용량(TB)은 0보다 커야 합니다.")
        Integer capacity,

        @NotNull(message = "회전수(RPM)는 필수입니다.")
        @Positive(message = "회전수(RPM)는 0보다 커야 합니다.")
        Integer rpm,

        @NotNull(message = "버퍼 용량(MB)은 필수입니다.")
        @Positive(message = "버퍼 용량(MB)은 0보다 커야 합니다.")
        Integer bufferMemory) {

    public Hdd toEntity(Category category) {
        return Hdd.builder()
                .category(category)
                .name(name)
                .brand(brand)
                .price(price)
                .imageUrl(imageUrl)
                .interfaceType(interfaceType)
                .capacity(capacity)
                .rpm(rpm)
                .bufferMemory(bufferMemory)
                .build();
    }
}
