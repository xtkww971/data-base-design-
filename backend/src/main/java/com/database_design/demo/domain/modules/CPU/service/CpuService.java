package com.database_design.demo.domain.modules.CPU.service;

import com.database_design.demo.domain.modules.CPU.dto.CpuDetailResponse;
import com.database_design.demo.domain.modules.CPU.dto.CpuRequest;
import com.database_design.demo.domain.modules.CPU.dto.CpuResponse;
import com.database_design.demo.domain.modules.CPU.entity.CPU;
import com.database_design.demo.domain.modules.CPU.repository.CpuRepository;
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
public class CpuService {

    @Autowired
    private final CpuRepository cpuRepository;

    @Autowired
    private final CategoryProvider categoryProvider;

    @Transactional
    public CpuResponse create(CpuRequest request) {
        Category category = categoryProvider.get(ProductCategory.CPU);
        return CpuResponse.from(cpuRepository.save(request.toEntity(category)));
    }

    public List<CpuResponse> getAll() {
        return cpuRepository.findAll().stream()
                .map(CpuResponse::from)
                .toList();
    }

    public CpuResponse get(Long moduleId) {
        return CpuResponse.from(findById(moduleId));
    }

    public CpuDetailResponse getDetail(Long moduleId) {
        return CpuDetailResponse.from(findById(moduleId));
    }

    @Transactional
    public CpuResponse update(Long moduleId, CpuRequest request) {
        CPU cpu = findById(moduleId);
        cpu.update(request.name(), request.brand(), request.price(), request.imageUrl(), request.socket(),
            request.cores(), request.threads(), request.hasGraphics(), request.clockSpeed());
        return CpuResponse.from(cpu);
    }

    @Transactional
    public void delete(Long moduleId) {
        cpuRepository.delete(findById(moduleId));
    }

    private CPU findById(Long moduleId) {
        return cpuRepository.findById(moduleId)
                .orElseThrow(() -> new BusinessException(ErrorCode.CPU_NOT_FOUND));
    }
}
