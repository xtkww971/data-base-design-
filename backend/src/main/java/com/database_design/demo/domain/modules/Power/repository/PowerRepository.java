package com.database_design.demo.domain.modules.Power.repository;

import com.database_design.demo.domain.modules.Power.entity.Power;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PowerRepository extends JpaRepository<Power, Long> {
}
