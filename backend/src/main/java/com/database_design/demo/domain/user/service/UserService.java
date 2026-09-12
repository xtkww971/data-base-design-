package com.database_design.demo.domain.user.service;

import com.database_design.demo.domain.user.dto.UserResponse;
import com.database_design.demo.domain.user.entity.User;
import com.database_design.demo.domain.user.repository.UserRepository;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@AllArgsConstructor
@Service
@Transactional(readOnly = true)
public class UserService {

    @Autowired
    private final UserRepository userRepository;

    public UserResponse getUser(Long userId) {
        return UserResponse.from(findById(userId));
    }

    private User findById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.USER_NOT_FOUND));
    }
}
