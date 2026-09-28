package com.database_design.demo.global.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

// @CreatedDate 등 JPA Auditing 값 자동 입력 (User.createdAt)
@Configuration
@EnableJpaAuditing
public class JpaAuditingConfig {
}
