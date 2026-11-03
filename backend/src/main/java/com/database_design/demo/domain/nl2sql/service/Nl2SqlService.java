package com.database_design.demo.domain.nl2sql.service;

import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient;
import com.database_design.demo.domain.nl2sql.client.Nl2SqlClient.GeneratedQuery;
import com.database_design.demo.domain.nl2sql.dto.NlQueryRequest;
import com.database_design.demo.domain.nl2sql.dto.NlQueryResponse;
import com.database_design.demo.global.error.BusinessException;
import com.database_design.demo.global.error.ErrorCode;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.sql.DataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.JdbcUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
public class Nl2SqlService {

    // LLM 이 만든 쿼리라 결과가 과도하게 커지거나 오래 걸리지 않도록 막는다.
    private static final int MAX_ROWS = 100;
    private static final int QUERY_TIMEOUT_SECONDS = 10;

    private final Nl2SqlClient nl2SqlClient;
    private final JdbcTemplate jdbcTemplate;

    public Nl2SqlService(Nl2SqlClient nl2SqlClient, DataSource dataSource) {
        this.nl2SqlClient = nl2SqlClient;
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.jdbcTemplate.setMaxRows(MAX_ROWS);
        this.jdbcTemplate.setQueryTimeout(QUERY_TIMEOUT_SECONDS);
    }

    /**
     * 자연어 질문을 nl2sql 서비스로 SQL 변환한 뒤 실행해 결과를 돌려준다.
     * nl2sql 쪽에서 SELECT/WITH 만 통과시키지만, 한 번 더 막기 위해 읽기 전용 트랜잭션에서 실행한다.
     */
    @Transactional(readOnly = true)
    public NlQueryResponse query(NlQueryRequest request) {
        GeneratedQuery generated = nl2SqlClient.generate(request.question());

        if (!generated.isValid()) {
            log.warn("SQL 생성 실패 (retry_count={}): {}", generated.retryCount(), generated.error());
            throw new BusinessException(ErrorCode.NL2SQL_GENERATION_FAILED);
        }

        String sql = stripTrailingSemicolon(generated.query());
        try {
            return jdbcTemplate.query(sql, rs -> {
                ResultSetMetaData meta = rs.getMetaData();
                List<String> columns = new ArrayList<>();
                for (int i = 1; i <= meta.getColumnCount(); i++) {
                    columns.add(JdbcUtils.lookupColumnName(meta, i));
                }

                List<Map<String, Object>> rows = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    for (int i = 1; i <= columns.size(); i++) {
                        row.put(columns.get(i - 1), JdbcUtils.getResultSetValue(rs, i));
                    }
                    rows.add(row);
                }
                return new NlQueryResponse(request.question(), sql, columns, rows, rows.size());
            });
        } catch (DataAccessException e) {
            log.warn("생성된 SQL 실행 실패: {}", sql, e);
            throw new BusinessException(ErrorCode.NL2SQL_EXECUTION_FAILED);
        }
    }

    private String stripTrailingSemicolon(String sql) {
        String trimmed = sql.strip();
        return trimmed.endsWith(";") ? trimmed.substring(0, trimmed.length() - 1) : trimmed;
    }
}
