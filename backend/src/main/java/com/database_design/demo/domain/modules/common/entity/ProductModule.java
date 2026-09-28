package com.database_design.demo.domain.modules.common.entity;

import com.database_design.demo.domain.modules.ProductCategory;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 모든 부품이 공유하는 공통 테이블(modules).
 * 부품별 고유 스펙 테이블은 module_id 를 PK 겸 FK 로 쓰는 1:1 식별 관계이므로 JOINED 전략으로 매핑한다.
 */
@Table(name = "modules")
@Entity
@Inheritance(strategy = InheritanceType.JOINED)
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public abstract class ProductModule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "module_id")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "brand", nullable = false, length = 50)
    private String brand;

    @Column(name = "price", nullable = false)
    private Integer price;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    protected ProductModule(Category category, String name, String brand, Integer price, String imageUrl) {
        this.category = category;
        this.name = name;
        this.brand = brand;
        this.price = price;
        this.imageUrl = imageUrl;
    }

    protected void updateModule(String name, String brand, Integer price, String imageUrl) {
        this.name = name;
        this.brand = brand;
        this.price = price;
        this.imageUrl = imageUrl;
    }

    /**
     * 응답 DTO 의 category 필드에 그대로 쓰는 카테고리 이름.
     */
    public ProductCategory getProductCategory() {
        return category.getName();
    }
}
