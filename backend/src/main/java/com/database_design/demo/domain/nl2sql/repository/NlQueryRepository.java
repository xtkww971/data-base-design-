package com.database_design.demo.domain.nl2sql.repository;

import com.database_design.demo.domain.nl2sql.entity.NlQuery;
import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NlQueryRepository extends JpaRepository<NlQuery, Long> {

    /**
     * 사이드바 질문 내역. idx_nl_queries_user_created (user_id, created_at) 를 탄다.
     * 같은 시각에 저장된 질문은 나중에 저장된 것(id 가 큰 것)을 위에 둔다.
     */
    List<NlQuery> findTop50ByUser_IdAndDeletedAtIsNullOrderByCreatedAtDescIdDesc(Long userId);

    /** 본인 질문만 꺼낸다. 남의 질문이거나 삭제됐으면 비어 있다. */
    Optional<NlQuery> findByIdAndUser_IdAndDeletedAtIsNull(Long id, Long userId);
}
