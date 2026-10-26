package com.database_design.demo.domain.nl2sql.controller;

import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import com.database_design.demo.domain.nl2sql.dto.NlQueryResponse;
import com.database_design.demo.domain.nl2sql.service.Nl2SqlService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@RequestMapping("/api/nl2sql")
public class Nl2SqlController {

    @Autowired
    private final Nl2SqlService nl2SqlService;

    /**
     * 추천 견적 페이지의 자연어 입력용. 예: POST /api/nl2sql/query  { "question": "30만원 이하 CPU 알려줘" }
     */
    @PostMapping("/query")
    public ResponseEntity<NlQueryResponse> query(@Valid @RequestBody NlQueryRequest request) {
        return ResponseEntity.ok(nl2SqlService.query(request));
    }
}
