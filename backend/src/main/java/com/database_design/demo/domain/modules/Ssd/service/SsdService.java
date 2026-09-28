package com.database_design.demo.domain.modules.Ssd.service;

import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.Ssd.dto.SsdDetailResponse;
import com.database_design.demo.domain.modules.Ssd.dto.SsdRequest;
import com.database_design.demo.domain.modules.Ssd.dto.SsdResponse;
import com.database_design.demo.domain.modules.Ssd.entity.Ssd;
import com.database_design.demo.domain.modules.Ssd.repository.SsdRepository;
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
public class SsdService {

    @Autowired
    private final SsdRepository ssdRepository;

    @Autowired
    private final CategoryProvider categoryProvider;

    @Transactional
    public SsdResponse create(SsdRequest request) {
        Category category = categoryProvider.get(ProductCategory.SSD);
        return SsdResponse.from(ssdRepository.save(request.toEntity(category)));
    }

    public List<SsdResponse> getAll() {
        return ssdRepository.findAll().stream()
                .map(SsdResponse::from)
                .toList();
    }

    public SsdResponse get(Long moduleId) {
        return SsdResponse.from(findById(moduleId));
    }

    public SsdDetailResponse getDetail(Long moduleId) {
        return SsdDetailResponse.from(findById(moduleId));
    }

    @Transactional
    public SsdResponse update(Long moduleId, SsdRequest request) {
        Ssd ssd = findById(moduleId);
        ssd.update(request.name(), request.brand(), request.price(), request.imageUrl(), request.formFactor(),
            request.capacity(), request.readSpeed(), request.writeSpeed());
        return SsdResponse.from(ssd);
    }

    @Transactional
    public void delete(Long moduleId) {
        ssdRepository.delete(findById(moduleId));
    }

    private Ssd findById(Long moduleId) {
        return ssdRepository.findById(moduleId)
                .orElseThrow(() -> new BusinessException(ErrorCode.SSD_NOT_FOUND));
    }
}
