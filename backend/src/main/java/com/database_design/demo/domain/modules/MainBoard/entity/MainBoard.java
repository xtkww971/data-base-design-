package com.database_design.demo.domain.modules.MainBoard.entity;

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
 * 메인보드 상세 스펙. 공통 속성(name, brand, price, imageUrl)은 modules 테이블에 있다.
 */
@Table(name = "main_boards")
@Entity
@PrimaryKeyJoinColumn(name = "module_id")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class MainBoard extends ProductModule {

    @Column(name = "socket", nullable = false, length = 20)
    private String socket;

    @Column(name = "form_factor", nullable = false, length = 20)
    private String formFactor;

    @Column(name = "memory_spec", nullable = false, length = 10)
    private String memorySpec;

    @Column(name = "memory_slots", nullable = false)
    private Integer memorySlots;

    @Column(name = "chipset", nullable = false, length = 30)
    private String chipset;

    @Builder
    private MainBoard(Category category, String name, String brand, Integer price, String imageUrl, String socket,
            String formFactor, String memorySpec, Integer memorySlots, String chipset) {
        super(category, name, brand, price, imageUrl);
        this.socket = socket;
        this.formFactor = formFactor;
        this.memorySpec = memorySpec;
        this.memorySlots = memorySlots;
        this.chipset = chipset;
    }

    public void update(String name, String brand, Integer price, String imageUrl, String socket, String formFactor,
            String memorySpec, Integer memorySlots, String chipset) {
        updateModule(name, brand, price, imageUrl);
        this.socket = socket;
        this.formFactor = formFactor;
        this.memorySpec = memorySpec;
        this.memorySlots = memorySlots;
        this.chipset = chipset;
    }
}
