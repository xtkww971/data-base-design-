package com.database_design.demo.domain.modules.common.service;

import com.database_design.demo.domain.modules.BaseProductDetail;
import com.database_design.demo.domain.modules.CPU.dto.CpuDetailResponse;
import com.database_design.demo.domain.modules.CPU.entity.CPU;
import com.database_design.demo.domain.modules.GC.dto.GraphicCardDetailResponse;
import com.database_design.demo.domain.modules.GC.entity.GraphicCard;
import com.database_design.demo.domain.modules.Hdd.dto.HddDetailResponse;
import com.database_design.demo.domain.modules.Hdd.entity.Hdd;
import com.database_design.demo.domain.modules.MainBoard.dto.MainBoardDetailResponse;
import com.database_design.demo.domain.modules.MainBoard.entity.MainBoard;
import com.database_design.demo.domain.modules.Monitor.dto.MonitorDetailResponse;
import com.database_design.demo.domain.modules.Monitor.entity.Monitor;
import com.database_design.demo.domain.modules.Power.dto.PowerDetailResponse;
import com.database_design.demo.domain.modules.Power.entity.Power;
import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.Ram.dto.RamDetailResponse;
import com.database_design.demo.domain.modules.Ram.entity.Ram;
import com.database_design.demo.domain.modules.Ssd.dto.SsdDetailResponse;
import com.database_design.demo.domain.modules.Ssd.entity.Ssd;
import com.database_design.demo.domain.modules.common.dto.PageResponse;
import com.database_design.demo.domain.modules.common.dto.ProductSearchRequest;
import com.database_design.demo.domain.modules.common.entity.ProductModule;
import com.database_design.demo.domain.modules.common.repository.ProductModuleRepository;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import java.util.Locale;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 프론트 검색 페이지용 부품 통합 검색. 카테고리가 섞인 목록을 각 부품의 상세 응답(specs 포함) 형태로 내려준다.
 */
@AllArgsConstructor
@Service
@Transactional(readOnly = true)
public class ProductSearchService {

    private static final String ALL_CATEGORY = "ALL";

    @Autowired
    private final ProductModuleRepository productModuleRepository;

    public PageResponse<BaseProductDetail> search(ProductSearchRequest request) {
        PageRequest pageable = PageRequest.of(request.page(), request.size(), Sort.by(Sort.Direction.ASC, "id"));
        return PageResponse.of(
                productModuleRepository.search(toCategory(request.category()), toLikePattern(request.searchTerm()),
                        pageable),
                this::toDetail);
    }

    /**
     * 비어 있거나 ALL 이면 null(전체). 대소문자는 구분하지 않는다.
     */
    private ProductCategory toCategory(String category) {
        if (category == null || category.isBlank() || ALL_CATEGORY.equalsIgnoreCase(category.trim())) {
            return null;
        }
        try {
            return ProductCategory.valueOf(category.trim().toUpperCase(Locale.ROOT));
        } catch (IllegalArgumentException e) {
            throw new BusinessException(ErrorCode.INVALID_CATEGORY);
        }
    }

    /**
     * 검색어를 부분 일치 LIKE 패턴으로 바꾼다. 사용자가 입력한 %, _ 는 와일드카드가 아니라 글자로 취급한다.
     */
    private String toLikePattern(String searchTerm) {
        if (searchTerm == null || searchTerm.isBlank()) {
            return null;
        }
        String escaped = searchTerm.trim().toLowerCase(Locale.ROOT)
                .replace("!", "!!")
                .replace("%", "!%")
                .replace("_", "!_");
        return "%" + escaped + "%";
    }

    private BaseProductDetail toDetail(ProductModule module) {
        if (module instanceof CPU cpu) {
            return CpuDetailResponse.from(cpu);
        }
        if (module instanceof MainBoard mainBoard) {
            return MainBoardDetailResponse.from(mainBoard);
        }
        if (module instanceof Ram ram) {
            return RamDetailResponse.from(ram);
        }
        if (module instanceof GraphicCard graphicCard) {
            return GraphicCardDetailResponse.from(graphicCard);
        }
        if (module instanceof Power power) {
            return PowerDetailResponse.from(power);
        }
        if (module instanceof Ssd ssd) {
            return SsdDetailResponse.from(ssd);
        }
        if (module instanceof Hdd hdd) {
            return HddDetailResponse.from(hdd);
        }
        if (module instanceof Monitor monitor) {
            return MonitorDetailResponse.from(monitor);
        }
        throw new IllegalStateException("상세 응답으로 변환할 수 없는 부품 타입입니다: " + module.getClass().getName());
    }
}
