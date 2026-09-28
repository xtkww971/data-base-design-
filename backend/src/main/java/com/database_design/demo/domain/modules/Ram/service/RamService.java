package com.database_design.demo.domain.modules.Ram.service;

import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.Ram.dto.RamDetailResponse;
import com.database_design.demo.domain.modules.Ram.dto.RamRequest;
import com.database_design.demo.domain.modules.Ram.dto.RamResponse;
import com.database_design.demo.domain.modules.Ram.entity.Ram;
import com.database_design.demo.domain.modules.Ram.repository.RamRepository;
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
public class RamService {

    @Autowired
    private final RamRepository ramRepository;

    @Autowired
    private final CategoryProvider categoryProvider;

    @Transactional
    public RamResponse create(RamRequest request) {
        Category category = categoryProvider.get(ProductCategory.RAM);
        return RamResponse.from(ramRepository.save(request.toEntity(category)));
    }

    public List<RamResponse> getAll() {
        return ramRepository.findAll().stream()
                .map(RamResponse::from)
                .toList();
    }

    public RamResponse get(Long moduleId) {
        return RamResponse.from(findById(moduleId));
    }

    public RamDetailResponse getDetail(Long moduleId) {
        return RamDetailResponse.from(findById(moduleId));
    }

    @Transactional
    public RamResponse update(Long moduleId, RamRequest request) {
        Ram ram = findById(moduleId);
        ram.update(request.name(), request.brand(), request.price(), request.imageUrl(), request.memorySpec(),
            request.capacity(), request.clock(), request.packageCount());
        return RamResponse.from(ram);
    }

    @Transactional
    public void delete(Long moduleId) {
        ramRepository.delete(findById(moduleId));
    }

    private Ram findById(Long moduleId) {
        return ramRepository.findById(moduleId)
                .orElseThrow(() -> new BusinessException(ErrorCode.RAM_NOT_FOUND));
    }
}
