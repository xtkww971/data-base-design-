package com.database_design.demo.domain.modules.CPU.entity;

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
 * CPU 상세 스펙. 공통 속성(name, brand, price, imageUrl)은 modules 테이블에 있다.
 */
@Table(name = "cpus")
@Entity
@PrimaryKeyJoinColumn(name = "module_id")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CPU extends ProductModule {

    @Column(name = "socket", nullable = false, length = 20)
    private String socket;

    @Column(name = "cores", nullable = false)
    private Integer cores;

    @Column(name = "threads", nullable = false)
    private Integer threads;

    @Column(name = "has_graphics", nullable = false)
    private Boolean hasGraphics;

    @Column(name = "clock_speed", nullable = false, length = 20)
    private String clockSpeed;

    @Builder
    private CPU(Category category, String name, String brand, Integer price, String imageUrl, String socket,
            Integer cores, Integer threads, Boolean hasGraphics, String clockSpeed) {
        super(category, name, brand, price, imageUrl);
        this.socket = socket;
        this.cores = cores;
        this.threads = threads;
        this.hasGraphics = hasGraphics;
        this.clockSpeed = clockSpeed;
    }

    public void update(String name, String brand, Integer price, String imageUrl, String socket, Integer cores,
            Integer threads, Boolean hasGraphics, String clockSpeed) {
        updateModule(name, brand, price, imageUrl);
        this.socket = socket;
        this.cores = cores;
        this.threads = threads;
        this.hasGraphics = hasGraphics;
        this.clockSpeed = clockSpeed;
    }
}
