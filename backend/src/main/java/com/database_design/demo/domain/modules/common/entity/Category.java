package com.database_design.demo.domain.modules.common.entity;

import com.database_design.demo.domain.modules.ProductCategory;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 부품 카테고리. 행은 마이그레이션(V3)에서 8개를 미리 넣어두고 애플리케이션은 조회만 한다.
 */
@Table(name = "categories")
@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "category_id")
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "category_name", nullable = false, unique = true, length = 20)
    private ProductCategory name;
}
