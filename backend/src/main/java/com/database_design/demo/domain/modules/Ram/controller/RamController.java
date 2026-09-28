package com.database_design.demo.domain.modules.Ram.controller;

import com.database_design.demo.domain.modules.Ram.dto.RamDetailResponse;
import com.database_design.demo.domain.modules.Ram.dto.RamRequest;
import com.database_design.demo.domain.modules.Ram.dto.RamResponse;
import com.database_design.demo.domain.modules.Ram.service.RamService;
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
@RequestMapping("/api/modules/rams")
public class RamController {

    @Autowired
    private final RamService ramService;

    @PostMapping
    public ResponseEntity<RamResponse> create(@Valid @RequestBody RamRequest request) {
        return ResponseEntity.ok(ramService.create(request));
    }

    @GetMapping
    public ResponseEntity<List<RamResponse>> getAll() {
        return ResponseEntity.ok(ramService.getAll());
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<RamResponse> get(@PathVariable Long moduleId) {
        return ResponseEntity.ok(ramService.get(moduleId));
    }

    /**
     * 프론트엔드 상세 페이지용. 공통 필드 + specs 형태로 내려간다.
     */
    @GetMapping("/{moduleId}/detail")
    public ResponseEntity<RamDetailResponse> getDetail(@PathVariable Long moduleId) {
        return ResponseEntity.ok(ramService.getDetail(moduleId));
    }

    @PutMapping("/{moduleId}")
    public ResponseEntity<RamResponse> update(@PathVariable Long moduleId,
            @Valid @RequestBody RamRequest request) {
        return ResponseEntity.ok(ramService.update(moduleId, request));
    }

    @DeleteMapping("/{moduleId}")
    public ResponseEntity<Void> delete(@PathVariable Long moduleId) {
        ramService.delete(moduleId);
        return ResponseEntity.noContent().build();
    }
}
