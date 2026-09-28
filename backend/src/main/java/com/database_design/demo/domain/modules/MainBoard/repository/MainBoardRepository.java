package com.database_design.demo.domain.modules.MainBoard.repository;

import com.database_design.demo.domain.modules.MainBoard.entity.MainBoard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MainBoardRepository extends JpaRepository<MainBoard, Long> {
}
