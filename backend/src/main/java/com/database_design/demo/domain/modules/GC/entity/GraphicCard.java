package com.database_design.demo.domain.modules.GC.entity;

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
 * 그래픽카드 상세 스펙. 공통 속성(name, brand, price, imageUrl)은 modules 테이블에 있다.
 */
@Table(name = "graphic_cards")
@Entity
@PrimaryKeyJoinColumn(name = "module_id")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class GraphicCard extends ProductModule {

    @Column(name = "chipset", nullable = false, length = 50)
    private String chipset;

    @Column(name = "memory_type", nullable = false, length = 20)
    private String memoryType;

    @Column(name = "memory_capacity", nullable = false)
    private Integer memoryCapacity;

    @Column(name = "length_mm", nullable = false)
    private Integer length;

    @Column(name = "recommended_power", nullable = false)
    private Integer recommendedPower;

    @Column(name = "ports", nullable = false, length = 100)
    private String ports;

    @Builder
    private GraphicCard(Category category, String name, String brand, Integer price, String imageUrl, String chipset,
            String memoryType, Integer memoryCapacity, Integer length, Integer recommendedPower, String ports) {
        super(category, name, brand, price, imageUrl);
        this.chipset = chipset;
        this.memoryType = memoryType;
        this.memoryCapacity = memoryCapacity;
        this.length = length;
        this.recommendedPower = recommendedPower;
        this.ports = ports;
    }

    public void update(String name, String brand, Integer price, String imageUrl, String chipset, String memoryType,
            Integer memoryCapacity, Integer length, Integer recommendedPower, String ports) {
        updateModule(name, brand, price, imageUrl);
        this.chipset = chipset;
        this.memoryType = memoryType;
        this.memoryCapacity = memoryCapacity;
        this.length = length;
        this.recommendedPower = recommendedPower;
        this.ports = ports;
    }
}
