package com.database_design.demo.domain.modules.Ssd.repository;

import com.database_design.demo.domain.modules.Ssd.entity.Ssd;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SsdRepository extends JpaRepository<Ssd, Long> {
}
