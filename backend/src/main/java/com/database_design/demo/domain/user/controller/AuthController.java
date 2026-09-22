package com.database_design.demo.domain.user.controller;

import com.database_design.demo.domain.user.dto.LoginRequest;
import com.database_design.demo.domain.user.dto.SignUpRequest;
import com.database_design.demo.domain.user.dto.UserResponse;
import com.database_design.demo.domain.user.service.AuthService;
import jakarta.validation.Valid;
import java.util.Map;

import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private final AuthService authService;

    @PostMapping("/signup")
    public ResponseEntity<UserResponse> signUp(@Valid @RequestBody SignUpRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(authService.signUp(request));
    }

    @PostMapping("/login")
    public ResponseEntity<UserResponse> login(@Valid @RequestBody LoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    @GetMapping("/check-login-id")
    public ResponseEntity<Map<String, Boolean>> checkLoginId(@RequestParam String loginId) {
        return ResponseEntity.ok(Map.of("available", authService.isLoginIdAvailable(loginId)));
    }
}
