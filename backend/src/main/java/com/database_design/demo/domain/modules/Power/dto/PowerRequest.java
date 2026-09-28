package com.database_design.demo.domain.modules.Power.dto;

import com.database_design.demo.domain.modules.Power.entity.Power;
import com.database_design.demo.domain.modules.common.entity.Category;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

/**
 * 파워 등록 / 수정 요청 DTO.
 */
public record PowerRequest(
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

        @NotNull(message = "정격 출력(W)은 필수입니다.")
        @Positive(message = "정격 출력(W)은 0보다 커야 합니다.")
        Integer ratedPower,

        @NotBlank(message = "80PLUS 인증 등급은 필수입니다.")
        @Size(max = 20, message = "80PLUS 인증 등급은 20자 이하여야 합니다.")
        String certification,

        @NotBlank(message = "파워 규격은 필수입니다.")
        @Size(max = 20, message = "파워 규격은 20자 이하여야 합니다.")
        String formFactor) {

    public Power toEntity(Category category) {
        return Power.builder()
                .category(category)
                .name(name)
                .brand(brand)
                .price(price)
                .imageUrl(imageUrl)
                .ratedPower(ratedPower)
                .certification(certification)
                .formFactor(formFactor)
                .build();
    }
}
