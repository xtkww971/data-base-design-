package com.database_design.demo.domain.nl2sql.entity;

import com.database_design.demo.domain.modules.common.entity.ProductModule;
import com.database_design.demo.domain.user.entity.User;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

/**
 * 자연어 질의 1건. 성공·실패 모두 저장한다.
 * 성공 시 결과 표는 그때 보여 준 그대로 result_snapshot(JSON)에 남기는 의도된 반정규화이고,
 * 결과에 포함된 부품은 nl_query_modules 로 modules 와 다시 연결한다.
 */
@Entity
@Table(name = "nl_queries")
@EntityListeners(AuditingEntityListener.class)
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class NlQuery {

    private static final int ERROR_MESSAGE_MAX_LENGTH = 500;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "query_id")
    private Long id;

    // 비로그인 질의는 NULL
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "question", nullable = false, length = 500)
    private String question;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private NlQueryStatus status;

    // Jev 판정(ADR 0003). 판정을 건너뛰었으면 NULL
    @Column(name = "verdict", length = 20)
    private String verdict;

    @Column(name = "verdict_confidence", precision = 4, scale = 3)
    private BigDecimal verdictConfidence;

    // MySQL TEXT(최대 65,535바이트)
    @JdbcTypeCode(SqlTypes.LONGVARCHAR)
    @Column(name = "generated_sql", length = 65535)
    private String generatedSql;

    @JdbcTypeCode(SqlTypes.TINYINT)
    @Column(name = "retry_count", nullable = false)
    private Integer retryCount;

    // { "columns": [...], "rows": [[...], ...] } 형태의 JSON 문자열. 직렬화는 서비스에서 한다.
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "result_snapshot")
    private String resultSnapshot;

    // 내부 디버깅용. 화면에 노출하지 않는다.
    @Column(name = "error_message", length = ERROR_MESSAGE_MAX_LENGTH)
    private String errorMessage;

    @Column(name = "latency_ms")
    private Integer latencyMs;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @OneToMany(mappedBy = "query", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<NlQueryModule> modules = new ArrayList<>();

    private NlQuery(User user, String question, NlQueryStatus status, String generatedSql, Integer retryCount,
            String resultSnapshot, String errorMessage, Integer latencyMs) {
        this.user = user;
        this.question = question;
        this.status = status;
        this.generatedSql = generatedSql;
        this.retryCount = retryCount;
        this.resultSnapshot = resultSnapshot;
        this.errorMessage = truncate(errorMessage);
        this.latencyMs = latencyMs;
    }

    /**
     * 성공한 질의. DB CHECK 제약(ck_nl_queries_success_has_result)과 같이 SQL 과 결과가 반드시 있어야 한다.
     */
    public static NlQuery success(User user, String question, String generatedSql, int retryCount,
            String resultSnapshot, int latencyMs) {
        if (generatedSql == null || resultSnapshot == null) {
            throw new IllegalArgumentException("성공한 질의에는 SQL 과 결과 스냅샷이 필요합니다.");
        }
        return new NlQuery(user, question, NlQueryStatus.SUCCESS, generatedSql, retryCount, resultSnapshot, null,
                latencyMs);
    }

    /**
     * 실패한 질의. 생성 단계에서 실패했으면 generatedSql 은 NULL 일 수 있다.
     */
    public static NlQuery failure(User user, String question, NlQueryStatus status, String generatedSql,
            int retryCount, String errorMessage, int latencyMs) {
        if (status == NlQueryStatus.SUCCESS) {
            throw new IllegalArgumentException("실패 상태만 지정할 수 있습니다.");
        }
        return new NlQuery(user, question, status, generatedSql, retryCount, null, errorMessage, latencyMs);
    }

    public void recordVerdict(String verdict, BigDecimal confidence) {
        this.verdict = verdict;
        this.verdictConfidence = confidence;
    }

    /**
     * 결과에 포함된 부품을 결과 순서(rowNo, 1부터)와 함께 연결한다. 같은 부품은 처음 위치만 남긴다.
     */
    public void addModule(ProductModule module, int rowNo) {
        boolean exists = modules.stream().anyMatch(m -> m.getModule().getId().equals(module.getId()));
        if (!exists) {
            modules.add(new NlQueryModule(this, module, rowNo));
        }
    }

    // 사이드바 삭제. 품질 평가 자료로 남기기 위해 소프트 삭제한다.
    public void delete() {
        if (deletedAt == null) {
            deletedAt = LocalDateTime.now();
        }
    }

    public boolean isDeleted() {
        return deletedAt != null;
    }

    private static String truncate(String message) {
        if (message == null || message.length() <= ERROR_MESSAGE_MAX_LENGTH) {
            return message;
        }
        return message.substring(0, ERROR_MESSAGE_MAX_LENGTH);
    }
}
