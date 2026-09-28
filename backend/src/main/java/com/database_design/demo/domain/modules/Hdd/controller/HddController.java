package com.database_design.demo.domain.modules.Hdd.controller;

import com.database_design.demo.domain.modules.Hdd.dto.HddDetailResponse;
import com.database_design.demo.domain.modules.Hdd.dto.HddRequest;
import com.database_design.demo.domain.modules.Hdd.dto.HddResponse;
import com.database_design.demo.domain.modules.Hdd.service.HddService;
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
@RequestMapping("/api/modules/hdds")
public class HddController {

    @Autowired
    private final HddService hddService;

    @PostMapping
    public ResponseEntity<HddResponse> create(@Valid @RequestBody HddRequest request) {
        return ResponseEntity.ok(hddService.create(request));
    }

    @GetMapping
    public ResponseEntity<List<HddResponse>> getAll() {
        return ResponseEntity.ok(hddService.getAll());
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<HddResponse> get(@PathVariable Long moduleId) {
        return ResponseEntity.ok(hddService.get(moduleId));
    }

    /**
     * 프론트엔드 상세 페이지용. 공통 필드 + specs 형태로 내려간다.
     */
    @GetMapping("/{moduleId}/detail")
    public ResponseEntity<HddDetailResponse> getDetail(@PathVariable Long moduleId) {
        return ResponseEntity.ok(hddService.getDetail(moduleId));
    }

    @PutMapping("/{moduleId}")
    public ResponseEntity<HddResponse> update(@PathVariable Long moduleId,
            @Valid @RequestBody HddRequest request) {
        return ResponseEntity.ok(hddService.update(moduleId, request));
    }

    @DeleteMapping("/{moduleId}")
    public ResponseEntity<Void> delete(@PathVariable Long moduleId) {
        hddService.delete(moduleId);
        return ResponseEntity.noContent().build();
    }
}
