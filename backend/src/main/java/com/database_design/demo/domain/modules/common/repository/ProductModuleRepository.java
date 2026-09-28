package com.database_design.demo.domain.modules.common.repository;

import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.common.entity.ProductModule;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

/**
 * 카테고리를 가리지 않고 모든 부품을 조회한다.
 * JOINED 상속이라 한 번의 쿼리로 각 상세 테이블까지 조인해 실제 타입(CPU, Ram ...)으로 꺼내준다.
 */
@Repository
public interface ProductModuleRepository extends JpaRepository<ProductModule, Long> {

    /**
     * @param category null 이면 전체 카테고리
     * @param pattern  소문자로 바꾸고 %...% 를 붙인 LIKE 패턴 (이스케이프 문자 '!'). null 이면 검색어 조건 없음
     */
    @Query(value = """
            select m from ProductModule m
            join fetch m.category c
            where (:category is null or c.name = :category)
              and (:pattern is null
                   or lower(m.name) like :pattern escape '!'
                   or lower(m.brand) like :pattern escape '!')
            """,
            countQuery = """
            select count(m) from ProductModule m
            join m.category c
            where (:category is null or c.name = :category)
              and (:pattern is null
                   or lower(m.name) like :pattern escape '!'
                   or lower(m.brand) like :pattern escape '!')
            """)
    Page<ProductModule> search(@Param("category") ProductCategory category,
            @Param("pattern") String pattern,
            Pageable pageable);
}
