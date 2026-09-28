package com.database_design.demo.domain.modules.MainBoard.service;

import com.database_design.demo.domain.modules.MainBoard.dto.MainBoardDetailResponse;
import com.database_design.demo.domain.modules.MainBoard.dto.MainBoardRequest;
import com.database_design.demo.domain.modules.MainBoard.dto.MainBoardResponse;
import com.database_design.demo.domain.modules.MainBoard.entity.MainBoard;
import com.database_design.demo.domain.modules.MainBoard.repository.MainBoardRepository;
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
public class MainBoardService {

    @Autowired
    private final MainBoardRepository mainBoardRepository;

    @Autowired
    private final CategoryProvider categoryProvider;

    @Transactional
    public MainBoardResponse create(MainBoardRequest request) {
        Category category = categoryProvider.get(ProductCategory.MAINBOARD);
        return MainBoardResponse.from(mainBoardRepository.save(request.toEntity(category)));
    }

    public List<MainBoardResponse> getAll() {
        return mainBoardRepository.findAll().stream()
                .map(MainBoardResponse::from)
                .toList();
    }

    public MainBoardResponse get(Long moduleId) {
        return MainBoardResponse.from(findById(moduleId));
    }

    public MainBoardDetailResponse getDetail(Long moduleId) {
        return MainBoardDetailResponse.from(findById(moduleId));
    }

    @Transactional
    public MainBoardResponse update(Long moduleId, MainBoardRequest request) {
        MainBoard mainBoard = findById(moduleId);
        mainBoard.update(request.name(), request.brand(), request.price(), request.imageUrl(), request.socket(),
            request.formFactor(), request.memorySpec(), request.memorySlots(), request.chipset());
        return MainBoardResponse.from(mainBoard);
    }

    @Transactional
    public void delete(Long moduleId) {
        mainBoardRepository.delete(findById(moduleId));
    }

    private MainBoard findById(Long moduleId) {
        return mainBoardRepository.findById(moduleId)
                .orElseThrow(() -> new BusinessException(ErrorCode.MAINBOARD_NOT_FOUND));
    }
}
