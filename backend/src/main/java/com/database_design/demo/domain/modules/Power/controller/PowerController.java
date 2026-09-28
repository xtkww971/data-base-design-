package com.database_design.demo.domain.modules.Power.controller;

import com.database_design.demo.domain.modules.Power.dto.PowerDetailResponse;
import com.database_design.demo.domain.modules.Power.dto.PowerRequest;
import com.database_design.demo.domain.modules.Power.dto.PowerResponse;
import com.database_design.demo.domain.modules.Power.service.PowerService;
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
@RequestMapping("/api/modules/powers")
public class PowerController {

    @Autowired
    private final PowerService powerService;

    @PostMapping
    public ResponseEntity<PowerResponse> create(@Valid @RequestBody PowerRequest request) {
        return ResponseEntity.ok(powerService.create(request));
    }

    @GetMapping
    public ResponseEntity<List<PowerResponse>> getAll() {
        return ResponseEntity.ok(powerService.getAll());
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<PowerResponse> get(@PathVariable Long moduleId) {
        return ResponseEntity.ok(powerService.get(moduleId));
    }

    /**
     * 프론트엔드 상세 페이지용. 공통 필드 + specs 형태로 내려간다.
     */
    @GetMapping("/{moduleId}/detail")
    public ResponseEntity<PowerDetailResponse> getDetail(@PathVariable Long moduleId) {
        return ResponseEntity.ok(powerService.getDetail(moduleId));
    }

    @PutMapping("/{moduleId}")
    public ResponseEntity<PowerResponse> update(@PathVariable Long moduleId,
            @Valid @RequestBody PowerRequest request) {
        return ResponseEntity.ok(powerService.update(moduleId, request));
    }

    @DeleteMapping("/{moduleId}")
    public ResponseEntity<Void> delete(@PathVariable Long moduleId) {
        powerService.delete(moduleId);
        return ResponseEntity.noContent().build();
    }
}
