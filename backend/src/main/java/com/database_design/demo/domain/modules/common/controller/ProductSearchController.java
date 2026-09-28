package com.database_design.demo.domain.modules.common.controller;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.common.dto.PageResponse;
import com.database_design.demo.domain.modules.common.dto.ProductSearchRequest;
import com.database_design.demo.domain.modules.common.service.ProductSearchService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@AllArgsConstructor
@RestController
@RequestMapping("/api/modules/search")
public class ProductSearchController {

    @Autowired
    private final ProductSearchService productSearchService;

    /**
     * 프론트엔드 검색 페이지용. 예: GET /api/modules/search?category=CPU&searchTerm=라이젠&page=0&size=20
     * content 의 각 항목은 카테고리별 XxxDetailResponse(공통 필드 + specs) 형태로 내려간다.
     */
    @GetMapping
    public ResponseEntity<PageResponse<BaseProductDetail>> search(@Valid @ModelAttribute ProductSearchRequest request) {
        return ResponseEntity.ok(productSearchService.search(request));
    }
}
