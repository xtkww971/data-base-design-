package com.database_design.demo.domain.modules.Power.entity;

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
 * 파워 상세 스펙. 공통 속성(name, brand, price, imageUrl)은 modules 테이블에 있다.
 */
@Table(name = "power")
@Entity
@PrimaryKeyJoinColumn(name = "module_id")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Power extends ProductModule {

    @Column(name = "rated_power", nullable = false)
    private Integer ratedPower;

    @Column(name = "certification", nullable = false, length = 20)
    private String certification;

    @Column(name = "form_factor", nullable = false, length = 20)
    private String formFactor;

    @Builder
    private Power(Category category, String name, String brand, Integer price, String imageUrl, Integer ratedPower,
            String certification, String formFactor) {
        super(category, name, brand, price, imageUrl);
        this.ratedPower = ratedPower;
        this.certification = certification;
        this.formFactor = formFactor;
    }

    public void update(String name, String brand, Integer price, String imageUrl, Integer ratedPower,
            String certification, String formFactor) {
        updateModule(name, brand, price, imageUrl);
        this.ratedPower = ratedPower;
        this.certification = certification;
        this.formFactor = formFactor;
    }
}
