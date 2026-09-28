package com.database_design.demo.domain.modules.Power.service;

import com.database_design.demo.domain.modules.Power.dto.PowerDetailResponse;
import com.database_design.demo.domain.modules.Power.dto.PowerRequest;
import com.database_design.demo.domain.modules.Power.dto.PowerResponse;
import com.database_design.demo.domain.modules.Power.entity.Power;
import com.database_design.demo.domain.modules.Power.repository.PowerRepository;
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
public class PowerService {

    @Autowired
    private final PowerRepository powerRepository;

    @Autowired
    private final CategoryProvider categoryProvider;

    @Transactional
    public PowerResponse create(PowerRequest request) {
        Category category = categoryProvider.get(ProductCategory.POWER);
        return PowerResponse.from(powerRepository.save(request.toEntity(category)));
    }

    public List<PowerResponse> getAll() {
        return powerRepository.findAll().stream()
                .map(PowerResponse::from)
                .toList();
    }

    public PowerResponse get(Long moduleId) {
        return PowerResponse.from(findById(moduleId));
    }

    public PowerDetailResponse getDetail(Long moduleId) {
        return PowerDetailResponse.from(findById(moduleId));
    }

    @Transactional
    public PowerResponse update(Long moduleId, PowerRequest request) {
        Power power = findById(moduleId);
        power.update(request.name(), request.brand(), request.price(), request.imageUrl(), request.ratedPower(),
            request.certification(), request.formFactor());
        return PowerResponse.from(power);
    }

    @Transactional
    public void delete(Long moduleId) {
        powerRepository.delete(findById(moduleId));
    }

    private Power findById(Long moduleId) {
        return powerRepository.findById(moduleId)
                .orElseThrow(() -> new BusinessException(ErrorCode.POWER_NOT_FOUND));
    }
}
