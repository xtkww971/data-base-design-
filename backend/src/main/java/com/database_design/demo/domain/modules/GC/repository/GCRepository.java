package com.database_design.demo.domain.modules.GC.repository;

import com.database_design.demo.domain.modules.GC.entity.GraphicCard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GCRepository extends JpaRepository<GraphicCard, Long> {
}
