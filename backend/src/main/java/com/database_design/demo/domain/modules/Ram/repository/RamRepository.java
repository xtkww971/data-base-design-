package com.database_design.demo.domain.modules.Ram.repository;

import com.database_design.demo.domain.modules.Ram.entity.Ram;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RamRepository extends JpaRepository<Ram, Long> {
}
