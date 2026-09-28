package com.database_design.demo.domain.modules.GC.service;

import com.database_design.demo.domain.modules.GC.dto.GraphicCardDetailResponse;
import com.database_design.demo.domain.modules.GC.dto.GraphicCardRequest;
import com.database_design.demo.domain.modules.GC.dto.GraphicCardResponse;
import com.database_design.demo.domain.modules.GC.entity.GraphicCard;
import com.database_design.demo.domain.modules.GC.repository.GCRepository;
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
public class GraphicCardService {

    @Autowired
    private final GCRepository gCRepository;

    @Autowired
    private final CategoryProvider categoryProvider;

    @Transactional
    public GraphicCardResponse create(GraphicCardRequest request) {
        Category category = categoryProvider.get(ProductCategory.GPU);
        return GraphicCardResponse.from(gCRepository.save(request.toEntity(category)));
    }

    public List<GraphicCardResponse> getAll() {
        return gCRepository.findAll().stream()
                .map(GraphicCardResponse::from)
                .toList();
    }

    public GraphicCardResponse get(Long moduleId) {
        return GraphicCardResponse.from(findById(moduleId));
    }

    public GraphicCardDetailResponse getDetail(Long moduleId) {
        return GraphicCardDetailResponse.from(findById(moduleId));
    }

    @Transactional
    public GraphicCardResponse update(Long moduleId, GraphicCardRequest request) {
        GraphicCard graphicCard = findById(moduleId);
        graphicCard.update(request.name(), request.brand(), request.price(), request.imageUrl(), request.chipset(),
            request.memoryType(), request.memoryCapacity(), request.length(), request.recommendedPower(),
            request.ports());
        return GraphicCardResponse.from(graphicCard);
    }

    @Transactional
    public void delete(Long moduleId) {
        gCRepository.delete(findById(moduleId));
    }

    private GraphicCard findById(Long moduleId) {
        return gCRepository.findById(moduleId)
                .orElseThrow(() -> new BusinessException(ErrorCode.GPU_NOT_FOUND));
    }
}
