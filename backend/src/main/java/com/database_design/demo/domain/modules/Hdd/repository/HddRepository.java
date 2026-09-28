package com.database_design.demo.domain.modules.Hdd.repository;

import com.database_design.demo.domain.modules.Hdd.entity.Hdd;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface HddRepository extends JpaRepository<Hdd, Long> {
}
