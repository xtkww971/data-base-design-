package com.database_design.demo.domain.modules.Monitor.service;

import com.database_design.demo.domain.modules.Monitor.dto.MonitorDetailResponse;
import com.database_design.demo.domain.modules.Monitor.dto.MonitorRequest;
import com.database_design.demo.domain.modules.Monitor.dto.MonitorResponse;
import com.database_design.demo.domain.modules.Monitor.entity.Monitor;
import com.database_design.demo.domain.modules.Monitor.repository.MonitorRepository;
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
public class MonitorService {

    @Autowired
    private final MonitorRepository monitorRepository;

    @Autowired
    private final CategoryProvider categoryProvider;

    @Transactional
    public MonitorResponse create(MonitorRequest request) {
        Category category = categoryProvider.get(ProductCategory.MONITOR);
        return MonitorResponse.from(monitorRepository.save(request.toEntity(category)));
    }

    public List<MonitorResponse> getAll() {
        return monitorRepository.findAll().stream()
                .map(MonitorResponse::from)
                .toList();
    }

    public MonitorResponse get(Long moduleId) {
        return MonitorResponse.from(findById(moduleId));
    }

    public MonitorDetailResponse getDetail(Long moduleId) {
        return MonitorDetailResponse.from(findById(moduleId));
    }

    @Transactional
    public MonitorResponse update(Long moduleId, MonitorRequest request) {
        Monitor monitor = findById(moduleId);
        monitor.update(request.name(), request.brand(), request.price(), request.imageUrl(), request.screenSize(),
            request.resolution(), request.panelType(), request.refreshRate(), request.aspectRatio());
        return MonitorResponse.from(monitor);
    }

    @Transactional
    public void delete(Long moduleId) {
        monitorRepository.delete(findById(moduleId));
    }

    private Monitor findById(Long moduleId) {
        return monitorRepository.findById(moduleId)
                .orElseThrow(() -> new BusinessException(ErrorCode.MONITOR_NOT_FOUND));
    }
}
