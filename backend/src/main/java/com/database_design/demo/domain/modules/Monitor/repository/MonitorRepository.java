package com.database_design.demo.domain.modules.Monitor.repository;

import com.database_design.demo.domain.modules.Monitor.entity.Monitor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MonitorRepository extends JpaRepository<Monitor, Long> {
}
