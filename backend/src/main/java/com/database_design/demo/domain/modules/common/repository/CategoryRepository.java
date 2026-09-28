package com.database_design.demo.domain.modules.common.repository;

import com.database_design.demo.domain.modules.ProductCategory;
import com.database_design.demo.domain.modules.common.entity.Category;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {

    Optional<Category> findByName(ProductCategory name);
}
