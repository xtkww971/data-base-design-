package com.database_design.demo.domain.modules.CPU.controller;

import com.database_design.demo.domain.modules.CPU.dto.CpuDetailResponse;
import com.database_design.demo.domain.modules.CPU.dto.CpuRequest;
import com.database_design.demo.domain.modules.CPU.dto.CpuResponse;
import com.database_design.demo.domain.modules.CPU.service.CpuService;
import jakarta.validation.Valid;
import java.util.List;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@RequestMapping("/api/modules/cpus")
public class CpuController {

    @Autowired
    private final CpuService cpuService;

    @PostMapping
    public ResponseEntity<CpuResponse> create(@Valid @RequestBody CpuRequest request) {
        return ResponseEntity.ok(cpuService.create(request));
    }

    @GetMapping
    public ResponseEntity<List<CpuResponse>> getAll() {
        return ResponseEntity.ok(cpuService.getAll());
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<CpuResponse> get(@PathVariable Long moduleId) {
        return ResponseEntity.ok(cpuService.get(moduleId));
    }

    /**
     * 프론트엔드 상세 페이지용. 공통 필드 + specs 형태로 내려간다.
     */
    @GetMapping("/{moduleId}/detail")
    public ResponseEntity<CpuDetailResponse> getDetail(@PathVariable Long moduleId) {
        return ResponseEntity.ok(cpuService.getDetail(moduleId));
    }

    @PutMapping("/{moduleId}")
    public ResponseEntity<CpuResponse> update(@PathVariable Long moduleId,
            @Valid @RequestBody CpuRequest request) {
        return ResponseEntity.ok(cpuService.update(moduleId, request));
    }

    @DeleteMapping("/{moduleId}")
    public ResponseEntity<Void> delete(@PathVariable Long moduleId) {
        cpuService.delete(moduleId);
        return ResponseEntity.noContent().build();
    }
}
