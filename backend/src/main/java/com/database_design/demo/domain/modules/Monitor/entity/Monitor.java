package com.database_design.demo.domain.modules.Monitor.entity;

import com.database_design.demo.domain.modules.common.entity.Category;
import com.database_design.demo.domain.modules.common.entity.ProductModule;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.PrimaryKeyJoinColumn;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 모니터 상세 스펙. 공통 속성(name, brand, price, imageUrl)은 modules 테이블에 있다.
 */
@Table(name = "monitors")
@Entity
@PrimaryKeyJoinColumn(name = "module_id")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Monitor extends ProductModule {

    @Column(name = "screen_size", nullable = false, precision = 4, scale = 1)
    private BigDecimal screenSize;

    @Column(name = "resolution", nullable = false, length = 30)
    private String resolution;

    @Column(name = "panel_type", nullable = false, length = 20)
    private String panelType;

    @Column(name = "refresh_rate", nullable = false)
    private Integer refreshRate;

    @Column(name = "aspect_ratio", nullable = false, length = 10)
    private String aspectRatio;

    @Builder
    private Monitor(Category category, String name, String brand, Integer price, String imageUrl,
            BigDecimal screenSize, String resolution, String panelType, Integer refreshRate, String aspectRatio) {
        super(category, name, brand, price, imageUrl);
        this.screenSize = screenSize;
        this.resolution = resolution;
        this.panelType = panelType;
        this.refreshRate = refreshRate;
        this.aspectRatio = aspectRatio;
    }

    public void update(String name, String brand, Integer price, String imageUrl, BigDecimal screenSize,
            String resolution, String panelType, Integer refreshRate, String aspectRatio) {
        updateModule(name, brand, price, imageUrl);
        this.screenSize = screenSize;
        this.resolution = resolution;
        this.panelType = panelType;
        this.refreshRate = refreshRate;
        this.aspectRatio = aspectRatio;
    }
}
