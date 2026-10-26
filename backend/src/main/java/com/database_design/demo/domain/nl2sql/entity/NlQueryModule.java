package com.database_design.demo.domain.nl2sql.entity;

import com.database_design.demo.domain.modules.common.entity.ProductModule;
import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MapsId;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * 성공한 질의 결과에 포함된 부품. 결과 스냅샷(JSON)과 달리 modules 와 FK 로 연결돼 집계·조인이 가능하다.
 * 생성은 NlQuery.addModule 로만 한다.
 */
@Entity
@Table(name = "nl_query_modules")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class NlQueryModule {

    @EmbeddedId
    private NlQueryModuleId id;

    @MapsId("queryId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "query_id")
    private NlQuery query;

    @MapsId("moduleId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "module_id")
    private ProductModule module;

    @Column(name = "row_no", nullable = false)
    private Integer rowNo;

    NlQueryModule(NlQuery query, ProductModule module, int rowNo) {
        this.id = new NlQueryModuleId(query.getId(), module.getId());
        this.query = query;
        this.module = module;
        this.rowNo = rowNo;
    }
}
