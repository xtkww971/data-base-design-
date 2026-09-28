package com.database_design.demo.domain.modules.Monitor.dto;

import com.database_design.demo.domain.modules.Monitor.entity.Monitor;
import com.database_design.demo.domain.modules.common.entity.Category;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import java.math.BigDecimal;

/**
 * 모니터 등록 / 수정 요청 DTO.
 */
public record MonitorRequest(
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

        @NotNull(message = "화면 크기(인치)는 필수입니다.")
        @Positive(message = "화면 크기(인치)는 0보다 커야 합니다.")
        BigDecimal screenSize,

        @NotBlank(message = "해상도는 필수입니다.")
        @Size(max = 30, message = "해상도는 30자 이하여야 합니다.")
        String resolution,

        @NotBlank(message = "패널 종류는 필수입니다.")
        @Size(max = 20, message = "패널 종류는 20자 이하여야 합니다.")
        String panelType,

        @NotNull(message = "주사율(Hz)은 필수입니다.")
        @Positive(message = "주사율(Hz)은 0보다 커야 합니다.")
        Integer refreshRate,

        @NotBlank(message = "화면 비율은 필수입니다.")
        @Size(max = 10, message = "화면 비율은 10자 이하여야 합니다.")
        String aspectRatio) {

    public Monitor toEntity(Category category) {
        return Monitor.builder()
                .category(category)
                .name(name)
                .brand(brand)
                .price(price)
                .imageUrl(imageUrl)
                .screenSize(screenSize)
                .resolution(resolution)
                .panelType(panelType)
                .refreshRate(refreshRate)
                .aspectRatio(aspectRatio)
                .build();
    }
}
