package com.database_design.demo.domain.modules.Ssd.dto;

import com.database_design.demo.domain.modules.Ssd.entity.Ssd;
import com.database_design.demo.domain.modules.common.entity.Category;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

/**
 * SSD 등록 / 수정 요청 DTO.
 */
public record SsdRequest(
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

        @NotBlank(message = "규격은 필수입니다.")
        @Size(max = 20, message = "규격은 20자 이하여야 합니다.")
        String formFactor,

        @NotNull(message = "용량(GB)은 필수입니다.")
        @Positive(message = "용량(GB)은 0보다 커야 합니다.")
        Integer capacity,

        @NotNull(message = "순차 읽기 속도(MB/s)는 필수입니다.")
        @Positive(message = "순차 읽기 속도(MB/s)는 0보다 커야 합니다.")
        Integer readSpeed,

        @NotNull(message = "순차 쓰기 속도(MB/s)는 필수입니다.")
        @Positive(message = "순차 쓰기 속도(MB/s)는 0보다 커야 합니다.")
        Integer writeSpeed) {

    public Ssd toEntity(Category category) {
        return Ssd.builder()
                .category(category)
                .name(name)
                .brand(brand)
                .price(price)
                .imageUrl(imageUrl)
                .formFactor(formFactor)
                .capacity(capacity)
                .readSpeed(readSpeed)
                .writeSpeed(writeSpeed)
                .build();
    }
}
