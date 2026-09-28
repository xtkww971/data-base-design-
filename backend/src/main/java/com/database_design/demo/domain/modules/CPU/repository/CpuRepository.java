package com.database_design.demo.domain.modules.CPU.repository;

import com.database_design.demo.domain.modules.CPU.entity.CPU;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CpuRepository extends JpaRepository<CPU, Long> {
}
