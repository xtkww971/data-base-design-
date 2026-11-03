package com.database_design.demo.domain.nl2sql.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import java.io.Serializable;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * nl_query_modules 의 복합 PK (query_id, module_id).
 */
@Embeddable
@Getter
@EqualsAndHashCode
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class NlQueryModuleId implements Serializable {

    @Column(name = "query_id")
    private Long queryId;

    @Column(name = "module_id")
    private Long moduleId;
}
