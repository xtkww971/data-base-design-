package com.database_design.demo.domain.nl2sql.service;

import com.database_design.demo.domain.nl2sql.dto.NlQueryDetailResponse;
import com.database_design.demo.domain.nl2sql.dto.NlQueryDetailResponse.QueryError;
import com.database_design.demo.domain.nl2sql.dto.NlQuerySummaryResponse;
import com.database_design.demo.domain.nl2sql.dto.Verdict;
import com.database_design.demo.domain.nl2sql.entity.NlQuery;
import com.database_design.demo.domain.nl2sql.repository.NlQueryRepository;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tools.jackson.databind.ObjectMapper;

/**
 * 추천 페이지 사이드바의 질문 내역. 로그인한 유저 본인의 질문만 다룬다.
 * 남의 질문이나 삭제된 질문은 없는 것으로 본다(NL_QUERY_NOT_FOUND).
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NlQueryHistoryService {

    private final NlQueryRepository nlQueryRepository;
    private final ObjectMapper objectMapper;

    /** 최근 50개. 최신순 */
    public List<NlQuerySummaryResponse> list(Long userId) {
        return nlQueryRepository.findTop50ByUser_IdAndDeletedAtIsNullOrderByCreatedAtDescIdDesc(userId).stream()
                .map(NlQuerySummaryResponse::from)
                .toList();
    }

    /** 그때 보여 준 결과(또는 안내·오류 문구)를 다시 돌려준다. SQL 을 다시 실행하지 않는다. */
    public NlQueryDetailResponse get(Long userId, Long queryId) {
        NlQuery query = findOwned(userId, queryId);
        if (query.getResultSnapshot() != null) {
            ResultSnapshot snapshot = objectMapper.readValue(query.getResultSnapshot(), ResultSnapshot.class);
            return new NlQueryDetailResponse(query.getId(), query.getQuestion(), query.getStatus(),
                    query.getCreatedAt(), snapshot.toResponse(query.getQuestion(), query.getGeneratedSql(),
                    query.getId()), null);
        }
        return new NlQueryDetailResponse(query.getId(), query.getQuestion(), query.getStatus(),
                query.getCreatedAt(), null, QueryError.of(errorCodeOf(query)));
    }

    /** 사이드바에서 지운다. 품질 평가 자료로 남기기 위해 소프트 삭제한다. */
    @Transactional
    public void delete(Long userId, Long queryId) {
        findOwned(userId, queryId).delete();
    }

    private NlQuery findOwned(Long userId, Long queryId) {
        return nlQueryRepository.findByIdAndUser_IdAndDeletedAtIsNull(queryId, userId)
                .orElseThrow(() -> new BusinessException(ErrorCode.NL_QUERY_NOT_FOUND));
    }

    /** 실패한 질문에 그때 응답했던 에러 코드. 거절은 판정별로 문구가 다르다. */
    static ErrorCode errorCodeOf(NlQuery query) {
        return switch (query.getStatus()) {
            case UNANSWERABLE -> Verdict.from(query.getVerdict())
                    .flatMap(Verdict::errorCode)
                    .orElse(ErrorCode.NL2SQL_GENERATION_FAILED);
            case EXECUTION_FAILED -> ErrorCode.NL2SQL_EXECUTION_FAILED;
            case GENERATION_FAILED, SUCCESS -> ErrorCode.NL2SQL_GENERATION_FAILED;
        };
    }
}
