package com.database_design.demo.domain.modules.Ssd.entity;

import com.database_design.demo.domain.modules.common.entity.Category;
import com.database_design.demo.domain.modules.common.entity.ProductModule;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * SSD 상세 스펙. 공통 속성(name, brand, price, imageUrl)은 modules 테이블에 있다.
 */
@Table(name = "ssds")
@Entity
@PrimaryKeyJoinColumn(name = "module_id")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Ssd extends ProductModule {

    @Column(name = "form_factor", nullable = false, length = 20)
    private String formFactor;

    @Column(name = "capacity", nullable = false)
    private Integer capacity;

    @Column(name = "read_speed", nullable = false)
    private Integer readSpeed;

    @Column(name = "write_speed", nullable = false)
    private Integer writeSpeed;

    @Builder
    private Ssd(Category category, String name, String brand, Integer price, String imageUrl, String formFactor,
            Integer capacity, Integer readSpeed, Integer writeSpeed) {
        super(category, name, brand, price, imageUrl);
        this.formFactor = formFactor;
        this.capacity = capacity;
        this.readSpeed = readSpeed;
        this.writeSpeed = writeSpeed;
    }

    public void update(String name, String brand, Integer price, String imageUrl, String formFactor, Integer capacity,
            Integer readSpeed, Integer writeSpeed) {
        updateModule(name, brand, price, imageUrl);
        this.formFactor = formFactor;
        this.capacity = capacity;
        this.readSpeed = readSpeed;
        this.writeSpeed = writeSpeed;
    }
}
