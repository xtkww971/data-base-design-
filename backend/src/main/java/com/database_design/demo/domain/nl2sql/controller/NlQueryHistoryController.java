package com.database_design.demo.domain.nl2sql.controller;

import com.database_design.demo.domain.nl2sql.dto.NlQueryDetailResponse;
import com.database_design.demo.domain.nl2sql.dto.NlQuerySummaryResponse;
import com.database_design.demo.domain.nl2sql.service.NlQueryHistoryService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * 추천 페이지 사이드바의 질문 내역 (nl_queries).
 * 토큰·세션이 없어 로그인한 유저 id 를 userId 파라미터로 받는다.
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/nl2sql/queries")
public class NlQueryHistoryController {

    private final NlQueryHistoryService historyService;

    /** GET /api/nl2sql/queries?userId=1 */
    @GetMapping
    public ResponseEntity<List<NlQuerySummaryResponse>> list(@RequestParam Long userId) {
        return ResponseEntity.ok(historyService.list(userId));
    }

    /** GET /api/nl2sql/queries/10?userId=1 */
    @GetMapping("/{queryId}")
    public ResponseEntity<NlQueryDetailResponse> get(@PathVariable Long queryId, @RequestParam Long userId) {
        return ResponseEntity.ok(historyService.get(userId, queryId));
    }

    /** DELETE /api/nl2sql/queries/10?userId=1 */
    @DeleteMapping("/{queryId}")
    public ResponseEntity<Void> delete(@PathVariable Long queryId, @RequestParam Long userId) {
        historyService.delete(userId, queryId);
        return ResponseEntity.noContent().build();
    }
}
