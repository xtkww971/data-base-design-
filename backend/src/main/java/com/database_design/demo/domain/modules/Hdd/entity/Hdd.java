package com.database_design.demo.domain.modules.Hdd.entity;

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
 * HDD 상세 스펙. 공통 속성(name, brand, price, imageUrl)은 modules 테이블에 있다.
 */
@Table(name = "hdds")
@Entity
@PrimaryKeyJoinColumn(name = "module_id")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Hdd extends ProductModule {

    @Column(name = "interface_type", nullable = false, length = 20)
    private String interfaceType;

    @Column(name = "capacity", nullable = false)
    private Integer capacity;

    @Column(name = "rpm", nullable = false)
    private Integer rpm;

    @Column(name = "buffer_memory", nullable = false)
    private Integer bufferMemory;

    @Builder
    private Hdd(Category category, String name, String brand, Integer price, String imageUrl, String interfaceType,
            Integer capacity, Integer rpm, Integer bufferMemory) {
        super(category, name, brand, price, imageUrl);
        this.interfaceType = interfaceType;
        this.capacity = capacity;
        this.rpm = rpm;
        this.bufferMemory = bufferMemory;
    }

    public void update(String name, String brand, Integer price, String imageUrl, String interfaceType,
            Integer capacity, Integer rpm, Integer bufferMemory) {
        updateModule(name, brand, price, imageUrl);
        this.interfaceType = interfaceType;
        this.capacity = capacity;
        this.rpm = rpm;
        this.bufferMemory = bufferMemory;
    }
}
