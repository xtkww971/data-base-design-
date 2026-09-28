package com.database_design.demo.domain.modules.GC.controller;

import com.database_design.demo.domain.modules.GC.dto.GraphicCardDetailResponse;
import com.database_design.demo.domain.modules.GC.dto.GraphicCardRequest;
import com.database_design.demo.domain.modules.GC.dto.GraphicCardResponse;
import com.database_design.demo.domain.modules.GC.service.GraphicCardService;
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
@RequestMapping("/api/modules/graphic-cards")
public class GraphicCardController {

    @Autowired
    private final GraphicCardService graphicCardService;

    @PostMapping
    public ResponseEntity<GraphicCardResponse> create(@Valid @RequestBody GraphicCardRequest request) {
        return ResponseEntity.ok(graphicCardService.create(request));
    }

    @GetMapping
    public ResponseEntity<List<GraphicCardResponse>> getAll() {
        return ResponseEntity.ok(graphicCardService.getAll());
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<GraphicCardResponse> get(@PathVariable Long moduleId) {
        return ResponseEntity.ok(graphicCardService.get(moduleId));
    }

    /**
     * 프론트엔드 상세 페이지용. 공통 필드 + specs 형태로 내려간다.
     */
    @GetMapping("/{moduleId}/detail")
    public ResponseEntity<GraphicCardDetailResponse> getDetail(@PathVariable Long moduleId) {
        return ResponseEntity.ok(graphicCardService.getDetail(moduleId));
    }

    @PutMapping("/{moduleId}")
    public ResponseEntity<GraphicCardResponse> update(@PathVariable Long moduleId,
            @Valid @RequestBody GraphicCardRequest request) {
        return ResponseEntity.ok(graphicCardService.update(moduleId, request));
    }

    @DeleteMapping("/{moduleId}")
    public ResponseEntity<Void> delete(@PathVariable Long moduleId) {
        graphicCardService.delete(moduleId);
        return ResponseEntity.noContent().build();
    }
}
