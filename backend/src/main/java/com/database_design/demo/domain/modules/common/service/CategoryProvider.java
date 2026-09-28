package com.database_design.demo.domain.modules.common.service;

import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.common.entity.Category;
import com.database_design.demo.domain.modules.common.repository.CategoryRepository;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 부품 등록 시 붙일 카테고리를 찾아준다. 카테고리 행은 마이그레이션에서 넣으므로 조회만 한다.
 */
@AllArgsConstructor
@Service
@Transactional(readOnly = true)
public class CategoryProvider {

    @Autowired
    private final CategoryRepository categoryRepository;

    public Category get(ProductCategory name) {
        return categoryRepository.findByName(name)
                .orElseThrow(() -> new BusinessException(ErrorCode.CATEGORY_NOT_FOUND));
    }
}
