package com.database_design.demo.domain.modules.Monitor.controller;

import com.database_design.demo.domain.modules.Monitor.dto.MonitorDetailResponse;
import com.database_design.demo.domain.modules.Monitor.dto.MonitorRequest;
import com.database_design.demo.domain.modules.Monitor.dto.MonitorResponse;
import com.database_design.demo.domain.modules.Monitor.service.MonitorService;
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
@RequestMapping("/api/modules/monitors")
public class MonitorController {

    @Autowired
    private final MonitorService monitorService;

    @PostMapping
    public ResponseEntity<MonitorResponse> create(@Valid @RequestBody MonitorRequest request) {
        return ResponseEntity.ok(monitorService.create(request));
    }

    @GetMapping
    public ResponseEntity<List<MonitorResponse>> getAll() {
        return ResponseEntity.ok(monitorService.getAll());
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<MonitorResponse> get(@PathVariable Long moduleId) {
        return ResponseEntity.ok(monitorService.get(moduleId));
    }

    /**
     * 프론트엔드 상세 페이지용. 공통 필드 + specs 형태로 내려간다.
     */
    @GetMapping("/{moduleId}/detail")
    public ResponseEntity<MonitorDetailResponse> getDetail(@PathVariable Long moduleId) {
        return ResponseEntity.ok(monitorService.getDetail(moduleId));
    }

    @PutMapping("/{moduleId}")
    public ResponseEntity<MonitorResponse> update(@PathVariable Long moduleId,
            @Valid @RequestBody MonitorRequest request) {
        return ResponseEntity.ok(monitorService.update(moduleId, request));
    }

    @DeleteMapping("/{moduleId}")
    public ResponseEntity<Void> delete(@PathVariable Long moduleId) {
        monitorService.delete(moduleId);
        return ResponseEntity.noContent().build();
    }
}
