package com.database_design.demo.domain.user.dto;

import com.database_design.demo.domain.user.entity.User;
import java.time.LocalDateTime;

public record UserResponse(
        Long userId,
        String loginId,
        String nickname,
        LocalDateTime createdAt) {

    public static UserResponse from(User user) {
        return new UserResponse(user.getId(), user.getLoginId(), user.getNickname(), user.getCreatedAt());
    }
}
