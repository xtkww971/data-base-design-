package com.database_design.demo.domain.modules.Ssd.controller;

import com.database_design.demo.domain.modules.Ssd.dto.SsdDetailResponse;
import com.database_design.demo.domain.modules.Ssd.dto.SsdRequest;
import com.database_design.demo.domain.modules.Ssd.dto.SsdResponse;
import com.database_design.demo.domain.modules.Ssd.service.SsdService;
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
@RequestMapping("/api/modules/ssds")
public class SsdController {

    @Autowired
    private final SsdService ssdService;

    @PostMapping
    public ResponseEntity<SsdResponse> create(@Valid @RequestBody SsdRequest request) {
        return ResponseEntity.ok(ssdService.create(request));
    }

    @GetMapping
    public ResponseEntity<List<SsdResponse>> getAll() {
        return ResponseEntity.ok(ssdService.getAll());
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<SsdResponse> get(@PathVariable Long moduleId) {
        return ResponseEntity.ok(ssdService.get(moduleId));
    }

    /**
     * 프론트엔드 상세 페이지용. 공통 필드 + specs 형태로 내려간다.
     */
    @GetMapping("/{moduleId}/detail")
    public ResponseEntity<SsdDetailResponse> getDetail(@PathVariable Long moduleId) {
        return ResponseEntity.ok(ssdService.getDetail(moduleId));
    }

    @PutMapping("/{moduleId}")
    public ResponseEntity<SsdResponse> update(@PathVariable Long moduleId,
            @Valid @RequestBody SsdRequest request) {
        return ResponseEntity.ok(ssdService.update(moduleId, request));
    }

    @DeleteMapping("/{moduleId}")
    public ResponseEntity<Void> delete(@PathVariable Long moduleId) {
        ssdService.delete(moduleId);
        return ResponseEntity.noContent().build();
    }
}
