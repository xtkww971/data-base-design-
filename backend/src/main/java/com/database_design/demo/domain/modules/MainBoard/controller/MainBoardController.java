package com.database_design.demo.domain.modules.MainBoard.controller;

import com.database_design.demo.domain.modules.MainBoard.dto.MainBoardDetailResponse;
import com.database_design.demo.domain.modules.MainBoard.dto.MainBoardRequest;
import com.database_design.demo.domain.modules.MainBoard.dto.MainBoardResponse;
import com.database_design.demo.domain.modules.MainBoard.service.MainBoardService;
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
@RequestMapping("/api/modules/main-boards")
public class MainBoardController {

    @Autowired
    private final MainBoardService mainBoardService;

    @PostMapping
    public ResponseEntity<MainBoardResponse> create(@Valid @RequestBody MainBoardRequest request) {
        return ResponseEntity.ok(mainBoardService.create(request));
    }

    @GetMapping
    public ResponseEntity<List<MainBoardResponse>> getAll() {
        return ResponseEntity.ok(mainBoardService.getAll());
    }

    @GetMapping("/{moduleId}")
    public ResponseEntity<MainBoardResponse> get(@PathVariable Long moduleId) {
        return ResponseEntity.ok(mainBoardService.get(moduleId));
    }

    /**
     * 프론트엔드 상세 페이지용. 공통 필드 + specs 형태로 내려간다.
     */
    @GetMapping("/{moduleId}/detail")
    public ResponseEntity<MainBoardDetailResponse> getDetail(@PathVariable Long moduleId) {
        return ResponseEntity.ok(mainBoardService.getDetail(moduleId));
    }

    @PutMapping("/{moduleId}")
    public ResponseEntity<MainBoardResponse> update(@PathVariable Long moduleId,
            @Valid @RequestBody MainBoardRequest request) {
        return ResponseEntity.ok(mainBoardService.update(moduleId, request));
    }

    @DeleteMapping("/{moduleId}")
    public ResponseEntity<Void> delete(@PathVariable Long moduleId) {
        mainBoardService.delete(moduleId);
        return ResponseEntity.noContent().build();
    }
}
