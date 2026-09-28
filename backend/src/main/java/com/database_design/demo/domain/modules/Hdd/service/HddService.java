package com.database_design.demo.domain.modules.Hdd.service;

import com.database_design.demo.domain.modules.Hdd.dto.HddDetailResponse;
import com.database_design.demo.domain.modules.Hdd.dto.HddRequest;
import com.database_design.demo.domain.modules.Hdd.dto.HddResponse;
import com.database_design.demo.domain.modules.Hdd.entity.Hdd;
import com.database_design.demo.domain.modules.Hdd.repository.HddRepository;
import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.common.entity.Category;
import com.database_design.demo.domain.modules.common.service.CategoryProvider;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import java.util.List;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@AllArgsConstructor
@Service
@Transactional(readOnly = true)
public class HddService {

    @Autowired
    private final HddRepository hddRepository;

    @Autowired
    private final CategoryProvider categoryProvider;

    @Transactional
    public HddResponse create(HddRequest request) {
        Category category = categoryProvider.get(ProductCategory.HDD);
        return HddResponse.from(hddRepository.save(request.toEntity(category)));
    }

    public List<HddResponse> getAll() {
        return hddRepository.findAll().stream()
                .map(HddResponse::from)
                .toList();
    }

    public HddResponse get(Long moduleId) {
        return HddResponse.from(findById(moduleId));
    }

    public HddDetailResponse getDetail(Long moduleId) {
        return HddDetailResponse.from(findById(moduleId));
    }

    @Transactional
    public HddResponse update(Long moduleId, HddRequest request) {
        Hdd hdd = findById(moduleId);
        hdd.update(request.name(), request.brand(), request.price(), request.imageUrl(), request.interfaceType(),
            request.capacity(), request.rpm(), request.bufferMemory());
        return HddResponse.from(hdd);
    }

    @Transactional
    public void delete(Long moduleId) {
        hddRepository.delete(findById(moduleId));
    }

    private Hdd findById(Long moduleId) {
        return hddRepository.findById(moduleId)
                .orElseThrow(() -> new BusinessException(ErrorCode.HDD_NOT_FOUND));
    }
}
