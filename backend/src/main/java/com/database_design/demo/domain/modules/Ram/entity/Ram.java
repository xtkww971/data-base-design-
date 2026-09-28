package com.database_design.demo.domain.modules.Ram.entity;

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
 * 램 상세 스펙. 공통 속성(name, brand, price, imageUrl)은 modules 테이블에 있다.
 */
@Table(name = "rams")
@Entity
@PrimaryKeyJoinColumn(name = "module_id")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Ram extends ProductModule {

    @Column(name = "memory_spec", nullable = false, length = 10)
    private String memorySpec;

    @Column(name = "capacity", nullable = false)
    private Integer capacity;

    @Column(name = "clock", nullable = false)
    private Integer clock;

    @Column(name = "package_count", nullable = false)
    private Integer packageCount;

    @Builder
    private Ram(Category category, String name, String brand, Integer price, String imageUrl, String memorySpec,
            Integer capacity, Integer clock, Integer packageCount) {
        super(category, name, brand, price, imageUrl);
        this.memorySpec = memorySpec;
        this.capacity = capacity;
        this.clock = clock;
        this.packageCount = packageCount;
    }

    public void update(String name, String brand, Integer price, String imageUrl, String memorySpec, Integer capacity,
            Integer clock, Integer packageCount) {
        updateModule(name, brand, price, imageUrl);
        this.memorySpec = memorySpec;
        this.capacity = capacity;
        this.clock = clock;
        this.packageCount = packageCount;
    }
}
