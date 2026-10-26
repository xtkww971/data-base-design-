package com.database_design.demo.domain.nl2sql.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record NlQueryRequest(
        @NotBlank(message = "질문을 입력해 주세요.")
        @Size(max = 500, message = "질문은 500자 이하로 입력해 주세요.")
        String question) {
}
