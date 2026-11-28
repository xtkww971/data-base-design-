# 실험 결과 — test_1_questions

> 실행기가 자동으로 만든 문서다. 분석·해석은 test_N_result.md 에 따로 쓴다.

## 실행 조건

| 항목 | 값 |
|---|---|
| 실행 시각 | 2026-11-28T17:27:25 ~ - |
| 브랜치 / 커밋 | `feat/#29-frontend-error-card` / `cec7a53 Merge pull request #38 from xtkww971/feat/#29-allow-recommendation` |
| 커밋 안 된 변경 |  M backend/src/main/java/com/database_design/demo/domain/nl2sql/service/Nl2SqlService.java,  M backend/src/main/resources/application.yml, ?? docs/test/, ?? tools/nl2sql_eval.py |
| 거절 임계값 (컨테이너 env) | 0.7 |
| TypeSafe 키 | 있음 |
| 판정 모델 | jev-1.14.0 |
| SQL 생성 LLM | openai/gpt-oss-120b |
| 백엔드 / nl2sql 이미지 생성 | 2026-11-28T08:27:14.222683104Z / 2026-11-28T08:02:01.661384174Z |
| 파일 해시 (sha256 앞 12자) | judge-criteria.yml `322f639cdc41`, schema-summary.txt `54c62bc24bcd`, schema_docs.json `7464446d0218`, few_shot_examples.json `1028f63ddf16`, chroma.sqlite3 `4d020d1ef70a` |
| 반복 / 간격 | 1회 / 3.0s |

## 지표 요약

| 지표 | 값 |
|---|---|
| 실행 건수 | 32 |
| 판정 받음 / 건너뜀 / 판정 전 종료 | 32 / 0 / 0 |
| 판정 정확도 (전체) | 31/32 (97%) |
| 판정 정확도 (경계 제외) | 30/31 (97%) |
| 결과 일치율 (LLM 한도 건 제외) | 29/32 (91%) |
| **오거절** (목표 0) | 0  |
| 놓친 거절 | 3 Q02, Q17, Q19 |
| **보안 위반** (목표 0) | 0  |
| 판정 지연 | 평균 188 · 중앙 178 · 최소 162 · 최대 383 ms (n=32) |
| 생성 지연 (nl2sql) | 평균 11097 · 중앙 10636 · 최소 2613 · 최대 21826 ms (n=14) |
| 실행 지연 (MySQL) | 평균 2 · 중앙 1 · 최소 0 · 최대 6 ms (n=12) |
| 생성 시도 횟수 | 평균 1.29 · 최대 3 · 재시도 발생(2회 이상) 2건 (n=14) |
| 총 응답 시간 (전체) | 평균 5065 · 중앙 226 · 최소 171 · 최대 22037 ms (n=32) |
| 총 응답 시간 (reject) | 평균 199 · 중앙 188 · 최소 171 · 최대 332 ms (n=18) |
| 총 응답 시간 (pass) | 평균 12693 · 중앙 11693 · 최소 3984 · 최대 22037 ms (n=12) |
| 총 응답 시간 (gen_fail) | 평균 3086 · 중앙 3086 · 최소 2807 · 최대 3365 ms (n=2) |

### 결과 분포

| 결과 | 건수 |
|---|---|
| gen_fail | 2 |
| pass | 12 |
| reject | 18 |

### 판정 분포 (확신도 0.7 미만 포함)

| 판정 | 건수 | 그중 확신도 < 0.7 |
|---|---|---|
| ambiguous | 5 | 1 |
| answerable | 12 | 1 |
| missing_data | 8 | 0 |
| out_of_scope | 7 | 1 |

## 질문별 결과

| ID | 질문 | 예상 판정 | 실제 판정 (확신도) | 판정 ms | 생성 ms (시도) | 실행 ms | 총 ms | HTTP · code | 화면 | 판정 | 결과 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Q01 | 내일 부산 비 와? | out_of_scope | out_of_scope (1.00) 거절 | 270 | - | - | 332 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q02 | 점심 메뉴 추천해줘 | out_of_scope | out_of_scope (0.68) | 162 | 2613 (3) | - | 2807 | 422 NL2SQL_GENERATION_FAILED | 주황·다시 표현 | ✅ | ❌ ⚠️놓침 |
| Q03 | 파이썬으로 버블 정렬 코드 짜줘 | out_of_scope | out_of_scope (0.98) 거절 | 189 | - | - | 219 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q04 | 너 이름이 뭐야? | out_of_scope | out_of_scope (0.99) 거절 | 165 | - | - | 187 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q05 | CPU 써멀구리스 바르는 법 알려줘 | out_of_scope | out_of_scope (1.00) 거절 | 178 | - | - | 199 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q06 | 그래픽카드 드라이버 업데이트 어떻게 해? | out_of_scope | out_of_scope (0.99) 거절 | 173 | - | - | 197 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q07 | 본체에서 소음이 너무 심한데 원인이 뭐야? | out_of_scope | out_of_scope (0.90) 거절 | 163 | - | - | 185 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q08 | 판매량 1위 그래픽카드 뭐야? | missing_data | missing_data (1.00) 거절 | 167 | - | - | 174 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q09 | 별점 4.5 이상인 모니터 보여줘 | missing_data | missing_data (1.00) 거절 | 166 | - | - | 174 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q10 | 후기 많은 SSD 추천해줘 | missing_data | missing_data (0.98) 거절 | 175 | - | - | 186 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q11 | 지금 품절 안 된 램만 보여줘 | missing_data | missing_data (1.00) 거절 | 173 | - | - | 198 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q12 | 오늘 특가 하는 CPU 있어? | missing_data | missing_data (1.00) 거절 | 179 | - | - | 188 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q13 | RTX 5070 최저가 추이 보여줘 | missing_data | missing_data (1.00) 거절 | 174 | - | - | 182 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q14 | 최신 세대 인텔 CPU만 보여줘 | missing_data | missing_data (0.99) 거절 | 172 | - | - | 201 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q15 | 추천 좀 | ambiguous | ambiguous (0.92) 거절 | 175 | - | - | 183 | 422 NL2SQL_AMBIGUOUS | 안내·물음표 | ✅ | ✅ |
| Q16 | 이거 사도 돼? | ambiguous | ambiguous (0.82) 거절 | 170 | - | - | 189 | 422 NL2SQL_AMBIGUOUS | 안내·물음표 | ✅ | ✅ |
| Q17 | 저번에 본 거 다시 보여줘 | ambiguous | answerable (0.39) | 212 | 3133 (3) | - | 3365 | 422 NL2SQL_GENERATION_FAILED | 주황·다시 표현 | ❌ | ❌ ⚠️놓침 |
| Q18 | 그거보다 좋은 걸로 | ambiguous | ambiguous (0.94) 거절 | 217 | - | - | 233 | 422 NL2SQL_AMBIGUOUS | 안내·물음표 | ✅ | ✅ |
| Q19 | 비싼 거 보여줘 | ambiguous | ambiguous (0.68) | 162 | 7306 (1) | 5 | 7497 | 200  | 결과 표 100개 (100행 잘림 가능) | ✅ | ❌ ⚠️놓침 |
| Q20 | 괜찮은 거 있어? | ambiguous | ambiguous (0.82) 거절 | 179 | - | - | 186 | 422 NL2SQL_AMBIGUOUS | 안내·물음표 | ✅ | ✅ |
| Q21 | 50만원 이하 그래픽카드를 VRAM 큰 순서로 보여줘 | answerable | answerable (0.99) | 163 | 3798 (1) | 1 | 3984 | 200  | 결과 표 46개 | ✅ | ✅ |
| Q22 | AM4 소켓 CPU 중 6코어 이상인 것 | answerable | answerable (0.99) | 182 | 21826 (1) | 1 | 22037 | 200  | 결과 표 32개 | ✅ | ✅ |
| Q23 | DDR4 램 중 3200MT/s 이상인 제품 싼 순서로 | answerable | answerable (1.00) | 194 | 7439 (1) | 1 | 7660 | 200  | 결과 표 57개 | ✅ | ✅ |
| Q24 | Mini-ITX 메인보드 전부 보여줘 | answerable | answerable (0.99) | 188 | 18305 (1) | 1 | 18511 | 200  | 결과 표 10개 | ✅ | ✅ |
| Q25 | 850W 이상 플래티넘 등급 파워 알려줘 | answerable | answerable (0.99) | 185 | 17882 (1) | 1 | 18090 | 200  | 결과 표 17개 | ✅ | ✅ |
| Q26 | M.2 SSD 중 쓰기 속도가 가장 빠른 3개 | answerable | answerable (0.91) | 182 | 16911 (1) | 0 | 17112 | 200  | 결과 표 3개 | ✅ | ✅ |
| Q27 | 7200RPM HDD 중 4TB 이상 | answerable | answerable (0.99) | 192 | 13178 (1) | 1 | 13388 | 200  | 결과 표 100개 (100행 잘림 가능) | ✅ | ✅ |
| Q28 | 32인치 4K 모니터 보여줘 | answerable | answerable (0.95) | 189 | 10296 (1) | 1 | 10507 | 200  | 0행 | ✅ | ✅ |
| Q29 | i5-13600K에 맞는 메인보드 중 경고 없는 것 | answerable | answerable (0.92) | 192 | 9912 (1) | 6 | 10143 | 200  | 결과 표 27개 | ✅ | ✅ |
| Q30 | RTX 5070에 충분한 파워 중 가장 싼 3개 | answerable | answerable (0.79) | 184 | 11780 (1) | 1 | 11997 | 200  | 결과 표 3개 | ✅ | ✅ |
| Q31 | 제조사별 메인보드 평균 가격 | answerable | answerable (1.00) | 383 | 10977 (1) | 1 | 11389 | 200  | 결과 표 4개 | ✅ | ✅ |
| Q42 | RTX 5070 실제 소비전력 몇 W야? | missing_data | missing_data (1.00) 거절 | 164 | - | - | 171 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |

## 질문별 상세

<details><summary><b>Q01</b> 내일 부산 비 와? — reject · 안내·금지</summary>

- 의도: 날씨. 가장 명확한 범위 밖
- 요청: `{"question": "내일 부산 비 와?"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 270, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 332 ms = 판정 270 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q02</b> 점심 메뉴 추천해줘 — gen_fail · 주황·다시 표현</summary>

- 의도: '추천' 단어가 있어도 주제가 다르면 거절되는지
- 요청: `{"question": "점심 메뉴 추천해줘"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.68, "model": "jev-1.14.0", "latency_ms": 162, "rejected": false}
- 응답: HTTP 422, code NL2SQL_GENERATION_FAILED, message 질문을 이해하지 못했습니다. 다르게 표현해 주세요.
- 시간: 총 2807 ms = 판정 162 + 생성 2613 + 실행 - ms (+ 그 밖의 오버헤드)
- 생성: failed, 시도 3회 (retry_count), 사유 쿼리가 생성되지 않았습니다.

</details>

<details><summary><b>Q03</b> 파이썬으로 버블 정렬 코드 짜줘 — reject · 안내·금지</summary>

- 의도: 코딩 요청
- 요청: `{"question": "파이썬으로 버블 정렬 코드 짜줘"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.98, "model": "jev-1.14.0", "latency_ms": 189, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 219 ms = 판정 189 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q04</b> 너 이름이 뭐야? — reject · 안내·금지</summary>

- 의도: 모델 자신에 대한 질문
- 요청: `{"question": "너 이름이 뭐야?"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 165, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 187 ms = 판정 165 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q05</b> CPU 써멀구리스 바르는 법 알려줘 — reject · 안내·금지</summary>

- 의도: 부품명이 있지만 조립 방법 질문
- 요청: `{"question": "CPU 써멀구리스 바르는 법 알려줘"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 178, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 199 ms = 판정 178 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q06</b> 그래픽카드 드라이버 업데이트 어떻게 해? — reject · 안내·금지</summary>

- 의도: 부품명 + 소프트웨어 문제
- 요청: `{"question": "그래픽카드 드라이버 업데이트 어떻게 해?"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 173, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 197 ms = 판정 173 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q07</b> 본체에서 소음이 너무 심한데 원인이 뭐야? — reject · 안내·금지</summary>

- 의도: 고장·소음 해결. 기준에 명시된 예
- 요청: `{"question": "본체에서 소음이 너무 심한데 원인이 뭐야?"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.9, "model": "jev-1.14.0", "latency_ms": 163, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 185 ms = 판정 163 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q08</b> 판매량 1위 그래픽카드 뭐야? — reject · 안내·DB</summary>

- 의도: 판매량
- 요청: `{"question": "판매량 1위 그래픽카드 뭐야?"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 167, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 174 ms = 판정 167 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q09</b> 별점 4.5 이상인 모니터 보여줘 — reject · 안내·DB</summary>

- 의도: 별점. 숫자 조건이 붙어 조회처럼 보이는 형태
- 요청: `{"question": "별점 4.5 이상인 모니터 보여줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 166, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 174 ms = 판정 166 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q10</b> 후기 많은 SSD 추천해줘 — reject · 안내·DB</summary>

- 의도: 후기
- 요청: `{"question": "후기 많은 SSD 추천해줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 0.98, "model": "jev-1.14.0", "latency_ms": 175, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 186 ms = 판정 175 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q11</b> 지금 품절 안 된 램만 보여줘 — reject · 안내·DB</summary>

- 의도: 재고·품절
- 요청: `{"question": "지금 품절 안 된 램만 보여줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 173, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 198 ms = 판정 173 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q12</b> 오늘 특가 하는 CPU 있어? — reject · 안내·DB</summary>

- 의도: 할인·특가
- 요청: `{"question": "오늘 특가 하는 CPU 있어?"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 179, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 188 ms = 판정 179 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q13</b> RTX 5070 최저가 추이 보여줘 — reject · 안내·DB</summary>

- 의도: 가격 이력. 현재 가격은 있어서 헷갈릴 수 있음
- 요청: `{"question": "RTX 5070 최저가 추이 보여줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 174, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 182 ms = 판정 174 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q14</b> 최신 세대 인텔 CPU만 보여줘 — reject · 안내·DB</summary>

- 의도: 출시일·세대
- 요청: `{"question": "최신 세대 인텔 CPU만 보여줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 172, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 201 ms = 판정 172 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q15</b> 추천 좀 — reject · 안내·물음표</summary>

- 의도: 대상 없음. 가장 짧은 형태
- 요청: `{"question": "추천 좀"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.92, "model": "jev-1.14.0", "latency_ms": 175, "rejected": true}
- 응답: HTTP 422, code NL2SQL_AMBIGUOUS, message 조건을 조금 더 구체적으로 알려주세요.
- 시간: 총 183 ms = 판정 175 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q16</b> 이거 사도 돼? — reject · 안내·물음표</summary>

- 의도: 지시어 대상 없음
- 요청: `{"question": "이거 사도 돼?"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.82, "model": "jev-1.14.0", "latency_ms": 170, "rejected": true}
- 응답: HTTP 422, code NL2SQL_AMBIGUOUS, message 조건을 조금 더 구체적으로 알려주세요.
- 시간: 총 189 ms = 판정 170 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q17</b> 저번에 본 거 다시 보여줘 — gen_fail · 주황·다시 표현</summary>

- 의도: 이전 맥락 의존. 대화 기록이 없다
- 요청: `{"question": "저번에 본 거 다시 보여줘"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.39, "model": "jev-1.14.0", "latency_ms": 212, "rejected": false}
- 응답: HTTP 422, code NL2SQL_GENERATION_FAILED, message 질문을 이해하지 못했습니다. 다르게 표현해 주세요.
- 시간: 총 3365 ms = 판정 212 + 생성 3133 + 실행 - ms (+ 그 밖의 오버헤드)
- 생성: failed, 시도 3회 (retry_count), 사유 쿼리가 생성되지 않았습니다.

</details>

<details><summary><b>Q18</b> 그거보다 좋은 걸로 — reject · 안내·물음표</summary>

- 의도: 지시어 + 비교 기준 없음
- 요청: `{"question": "그거보다 좋은 걸로"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.94, "model": "jev-1.14.0", "latency_ms": 217, "rejected": true}
- 응답: HTTP 422, code NL2SQL_AMBIGUOUS, message 조건을 조금 더 구체적으로 알려주세요.
- 시간: 총 233 ms = 판정 217 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q19</b> 비싼 거 보여줘 — pass · 결과 표 100개 (100행 잘림 가능)</summary>

- 의도: 정렬 기준은 있으나 부품 종류 없음
- 요청: `{"question": "비싼 거 보여줘"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.68, "model": "jev-1.14.0", "latency_ms": 162, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 7497 ms = 판정 162 + 생성 7306 + 실행 5 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 100행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url

```sql
SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_url FROM modules m ORDER BY m.price DESC
```

```json
[
 {
  "module_id": 535,
  "category_id": 4,
  "name": "GIGABYTE 지포스 RTX 5090 AORUS MASTER 32GB",
  "brand": "GIGABYTE",
  "price": 4788000,
  "performance_score": 40228,
  "image_url": null
 },
 {
  "module_id": 473,
  "category_id": 4,
  "name": "ASUS TUF Gaming 지포스 RTX 5090 OC 32GB",
  "brand": "ASUS",
  "price": 4759000,
  "performance_score": 39932,
  "image_url": null
 },
 {
  "module_id": 567,
  "category_id": 4,
  "name": "ASUS ROG STRIX 지포스 RTX 5090 OC 32GB",
  "brand": "ASUS",
  "price": 4696000,
  "performance_score": 40243,
  "image_url": null
 },
 {
  "module_id": 505,
  "category_id": 4,
  "name": "MSI 지포스 RTX 5090 게이밍 X 트리오 32GB",
  "brand": "MSI",
  "price": 4614000,
  "performance_score": 40334,
  "image_url": null
 },
 {
  "module_id": 595,
  "category_id": 4,
  "name": "GIGABYTE 지포스 RTX 5090 WINDFORCE OC 32GB",
  "brand": "GIGABYTE",
  "price": 3922000,
  "performance_score": 39084,
  "image_url": null
 }
]
```

</details>

<details><summary><b>Q20</b> 괜찮은 거 있어? — reject · 안내·물음표</summary>

- 의도: 대상·기준 모두 없음
- 요청: `{"question": "괜찮은 거 있어?"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.82, "model": "jev-1.14.0", "latency_ms": 179, "rejected": true}
- 응답: HTTP 422, code NL2SQL_AMBIGUOUS, message 조건을 조금 더 구체적으로 알려주세요.
- 시간: 총 186 ms = 판정 179 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q21</b> 50만원 이하 그래픽카드를 VRAM 큰 순서로 보여줘 — pass · 결과 표 46개</summary>

- 의도: 가격 필터 + 사양 정렬
- 요청: `{"question": "50만원 이하 그래픽카드를 VRAM 큰 순서로 보여줘"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 163, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 3984 ms = 판정 163 + 생성 3798 + 실행 1 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 46행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url, memory_capacity

```sql
SELECT m.*, g.memory_capacity FROM modules m JOIN graphic_cards g ON g.module_id = m.module_id WHERE m.price <= 500000 ORDER BY g.memory_capacity DESC
```

```json
[
 {
  "module_id": 486,
  "category_id": 4,
  "name": "Sparkle 인텔 Arc A770 TITAN OC 16GB",
  "brand": "Sparkle",
  "price": 434000,
  "performance_score": 13816,
  "image_url": null,
  "memory_capacity": 16
 },
 {
  "module_id": 508,
  "category_id": 4,
  "name": "SAPPHIRE 라데온 RX 7600 XT PULSE 16GB",
  "brand": "SAPPHIRE",
  "price": 461000,
  "performance_score": 17303,
  "image_url": null,
  "memory_capacity": 16
 },
 {
  "module_id": 518,
  "category_id": 4,
  "name": "ASRock 인텔 Arc A770 Steel Legend 16GB",
  "brand": "ASRock",
  "price": 434000,
  "performance_score": 13909,
  "image_url": null,
  "memory_capacity": 16
 },
 {
  "module_id": 538,
  "category_id": 4,
  "name": "XFX 라데온 RX 7600 XT SPEEDSTER SWFT 210 16GB",
  "brand": "XFX",
  "price": 475000,
  "performance_score": 17202,
  "image_url": null,
  "memory_capacity": 16
 },
 {
  "module_id": 548,
  "category_id": 4,
  "name": "ASRock 인텔 Arc A770 Challenger OC 16GB",
  "brand": "ASRock",
  "price": 387000,
  "performance_score": 13687,
  "image_url": null,
  "memory_capacity": 16
 }
]
```

</details>

<details><summary><b>Q22</b> AM4 소켓 CPU 중 6코어 이상인 것 — pass · 결과 표 32개</summary>

- 의도: CPU 상세 필터
- 요청: `{"question": "AM4 소켓 CPU 중 6코어 이상인 것"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 182, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 22037 ms = 판정 182 + 생성 21826 + 실행 1 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 32행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url

```sql
SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_url FROM modules m JOIN cpus c ON c.module_id = m.module_id WHERE c.socket = 'AM4' AND c.cores >= 6
```

```json
[
 {
  "module_id": 82,
  "category_id": 1,
  "name": "AMD 라이젠5 3600",
  "brand": "AMD",
  "price": 109000,
  "performance_score": 17800,
  "image_url": null
 },
 {
  "module_id": 83,
  "category_id": 1,
  "name": "AMD 라이젠5 3600X",
  "brand": "AMD",
  "price": 129000,
  "performance_score": 18300,
  "image_url": null
 },
 {
  "module_id": 84,
  "category_id": 1,
  "name": "AMD 라이젠5 3600XT",
  "brand": "AMD",
  "price": 139000,
  "performance_score": 18800,
  "image_url": null
 },
 {
  "module_id": 85,
  "category_id": 1,
  "name": "AMD 라이젠5 4500",
  "brand": "AMD",
  "price": 89000,
  "performance_score": 16300,
  "image_url": null
 },
 {
  "module_id": 86,
  "category_id": 1,
  "name": "AMD 라이젠5 4600G",
  "brand": "AMD",
  "price": 109000,
  "performance_score": 16400,
  "image_url": null
 }
]
```

</details>

<details><summary><b>Q23</b> DDR4 램 중 3200MT/s 이상인 제품 싼 순서로 — pass · 결과 표 57개</summary>

- 의도: 램 규격·클럭
- 요청: `{"question": "DDR4 램 중 3200MT/s 이상인 제품 싼 순서로"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 194, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 7660 ms = 판정 194 + 생성 7439 + 실행 1 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 57행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url, memory_spec, capacity, clock, package_count

```sql
SELECT m.*, r.memory_spec, r.capacity, r.clock, r.package_count FROM modules m JOIN rams r ON r.module_id = m.module_id WHERE r.memory_spec = 'DDR4' AND r.clock >= 3200 ORDER BY m.price ASC
```

```json
[
 {
  "module_id": 307,
  "category_id": 3,
  "name": "삼성전자 DDR4-3200 8GB",
  "brand": "삼성전자",
  "price": 29000,
  "performance_score": 25600,
  "image_url": null,
  "memory_spec": "DDR4",
  "capacity": 8,
  "clock": 3200,
  "package_count": 1
 },
 {
  "module_id": 345,
  "category_id": 3,
  "name": "마이크론 Crucial DDR4-3200 8GB",
  "brand": "마이크론",
  "price": 29000,
  "performance_score": 25600,
  "image_url": null,
  "memory_spec": "DDR4",
  "capacity": 8,
  "clock": 3200,
  "package_count": 1
 },
 {
  "module_id": 336,
  "category_id": 3,
  "name": "SK하이닉스 DDR4-3200 8GB",
  "brand": "SK하이닉스",
  "price": 29000,
  "performance_score": 25600,
  "image_url": null,
  "memory_spec": "DDR4",
  "capacity": 8,
  "clock": 3200,
  "package_count": 1
 },
 {
  "module_id": 430,
  "category_id": 3,
  "name": "Kingston FURY Beast DDR4-3200 CL16 8GB",
  "brand": "Kingston",
  "price": 30000,
  "performance_score": 25600,
  "image_url": null,
  "memory_spec": "DDR4",
  "capacity": 8,
  "clock": 3200,
  "package_count": 1
 },
 {
  "module_id": 434,
  "category_id": 3,
  "name": "Kingston FURY Beast DDR4-3600 CL18 8GB",
  "brand": "Kingston",
  "price": 32000,
  "performance_score": 28800,
  "image_url": null,
  "memory_spec": "DDR4",
  "capacity": 8,
  "clock": 3600,
  "package_count": 1
 }
]
```

</details>

<details><summary><b>Q24</b> Mini-ITX 메인보드 전부 보여줘 — pass · 결과 표 10개</summary>

- 의도: 폼팩터 필터. '전부'가 100행 제한과 만나는지
- 요청: `{"question": "Mini-ITX 메인보드 전부 보여줘"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 188, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 18511 ms = 판정 188 + 생성 18305 + 실행 1 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 10행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url, module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset

```sql
SELECT m.*, mb.* FROM modules m JOIN main_boards mb ON mb.module_id = m.module_id WHERE mb.form_factor = 'Mini-ITX'
```

```json
[
 {
  "module_id": 155,
  "category_id": 2,
  "name": "GIGABYTE A620I AX",
  "brand": "GIGABYTE",
  "price": 195000,
  "performance_score": null,
  "image_url": null,
  "socket": "AM5",
  "form_factor": "Mini-ITX",
  "memory_spec": "DDR5",
  "memory_slots": 2,
  "max_memory_gb": 96,
  "has_video_output": true,
  "chipset": "A620"
 },
 {
  "module_id": 161,
  "category_id": 2,
  "name": "ASUS ROG STRIX Z790-I GAMING WIFI",
  "brand": "ASUS",
  "price": 589000,
  "performance_score": null,
  "image_url": null,
  "socket": "LGA1700",
  "form_factor": "Mini-ITX",
  "memory_spec": "DDR5",
  "memory_slots": 2,
  "max_memory_gb": 96,
  "has_video_output": true,
  "chipset": "Z790"
 },
 {
  "module_id": 196,
  "category_id": 2,
  "name": "ASUS ROG STRIX B760-I GAMING WIFI",
  "brand": "ASUS",
  "price": 309000,
  "performance_score": null,
  "image_url": null,
  "socket": "LGA1700",
  "form_factor": "Mini-ITX",
  "memory_spec": "DDR5",
  "memory_slots": 2,
  "max_memory_gb": 96,
  "has_video_output": true,
  "chipset": "B760"
 },
 {
  "module_id": 208,
  "category_id": 2,
  "name": "GIGABYTE B760I AORUS PRO DDR4",
  "brand": "GIGABYTE",
  "price": 249000,
  "performance_score": null,
  "image_url": null,
  "socket": "LGA1700",
  "form_factor": "Mini-ITX",
  "memory_spec": "DDR4",
  "memory_slots": 2,
  "max_memory_gb": 64,
  "has_video_output": true,
  "chipset": "B760"
 },
 {
  "module_id": 213,
  "category_id": 2,
  "name": "ASRock B760M-ITX/D4 WiFi",
  "brand": "ASRock",
  "price": 189000,
  "performance_score": null,
  "image_url": null,
  "socket": "LGA1700",
  "form_factor": "Mini-ITX",
  "memory_spec": "DDR4",
  "memory_slots": 2,
  "max_memory_gb": 64,
  "has_video_output": true,
  "chipset": "B760"
 }
]
```

</details>

<details><summary><b>Q25</b> 850W 이상 플래티넘 등급 파워 알려줘 — pass · 결과 표 17개</summary>

- 의도: 출력 + 인증 등급
- 요청: `{"question": "850W 이상 플래티넘 등급 파워 알려줘"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 185, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 18090 ms = 판정 185 + 생성 17882 + 실행 1 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 17행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url, rated_power, certification, has_16pin, pcie_8pin_count, form_factor

```sql
SELECT m.*, p.rated_power, p.certification, p.has_16pin, p.pcie_8pin_count, p.form_factor FROM modules m JOIN power p ON p.module_id = m.module_id WHERE p.rated_power >= 850 AND p.certification = '80PLUS PLATINUM' ORDER BY m.price ASC
```

```json
[
 {
  "module_id": 629,
  "category_id": 5,
  "name": "시소닉 VERTEX PX-850 PLATINUM",
  "brand": "시소닉",
  "price": 227000,
  "performance_score": 92,
  "image_url": null,
  "rated_power": 850,
  "certification": "80PLUS PLATINUM",
  "has_16pin": true,
  "pcie_8pin_count": 4,
  "form_factor": "ATX"
 },
 {
  "module_id": 663,
  "category_id": 5,
  "name": "슈퍼플라워 LEADEX PLATINUM SE 1000W",
  "brand": "슈퍼플라워",
  "price": 232000,
  "performance_score": 92,
  "image_url": null,
  "rated_power": 1000,
  "certification": "80PLUS PLATINUM",
  "has_16pin": false,
  "pcie_8pin_count": 6,
  "form_factor": "ATX"
 },
 {
  "module_id": 696,
  "category_id": 5,
  "name": "be quiet! STRAIGHT POWER 12 850W PLATINUM",
  "brand": "be quiet!",
  "price": 235000,
  "performance_score": 92,
  "image_url": null,
  "rated_power": 850,
  "certification": "80PLUS PLATINUM",
  "has_16pin": true,
  "pcie_8pin_count": 4,
  "form_factor": "ATX"
 },
 {
  "module_id": 630,
  "category_id": 5,
  "name": "시소닉 VERTEX PX-1000 PLATINUM",
  "brand": "시소닉",
  "price": 252000,
  "performance_score": 92,
  "image_url": null,
  "rated_power": 1000,
  "certification": "80PLUS PLATINUM",
  "has_16pin": true,
  "pcie_8pin_count": 6,
  "form_factor": "ATX"
 },
 {
  "module_id": 697,
  "category_id": 5,
  "name": "be quiet! STRAIGHT POWER 12 1000W PLATINUM",
  "brand": "be quiet!",
  "price": 262000,
  "performance_score": 92,
  "image_url": null,
  "rated_power": 1000,
  "certification": "80PLUS PLATINUM",
  "has_16pin": true,
  "pcie_8pin_count": 6,
  "form_factor": "ATX"
 }
]
```

</details>

<details><summary><b>Q26</b> M.2 SSD 중 쓰기 속도가 가장 빠른 3개 — pass · 결과 표 3개</summary>

- 의도: SSD 폼팩터 + 정렬 + LIMIT
- 요청: `{"question": "M.2 SSD 중 쓰기 속도가 가장 빠른 3개"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.91, "model": "jev-1.14.0", "latency_ms": 182, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 17112 ms = 판정 182 + 생성 16911 + 실행 0 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 3행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url, write_speed

```sql
SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_url, s.write_speed FROM modules m JOIN ssds s ON s.module_id = m.module_id WHERE s.form_factor = 'M.2 2280' ORDER BY s.write_speed DESC LIMIT 3
```

```json
[
 {
  "module_id": 871,
  "category_id": 6,
  "name": "WD Black SN8100 M.2 NVMe 1TB",
  "brand": "Western Digital",
  "price": 205000,
  "performance_score": 93691,
  "image_url": null,
  "write_speed": 14000
 },
 {
  "module_id": 872,
  "category_id": 6,
  "name": "WD Black SN8100 M.2 NVMe 2TB",
  "brand": "Western Digital",
  "price": 395000,
  "performance_score": 98002,
  "image_url": null,
  "write_speed": 14000
 },
 {
  "module_id": 873,
  "category_id": 6,
  "name": "WD Black SN8100 M.2 NVMe 4TB",
  "brand": "Western Digital",
  "price": 775000,
  "performance_score": 97608,
  "image_url": null,
  "write_speed": 14000
 }
]
```

</details>

<details><summary><b>Q27</b> 7200RPM HDD 중 4TB 이상 — pass · 결과 표 100개 (100행 잘림 가능)</summary>

- 의도: HDD 회전수·용량
- 요청: `{"question": "7200RPM HDD 중 4TB 이상"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 192, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 13388 ms = 판정 192 + 생성 13178 + 실행 1 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 100행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url, module_id, interface_type, capacity, rpm, buffer_memory

```sql
SELECT m.*, h.* FROM modules m JOIN hdds h ON h.module_id = m.module_id WHERE h.rpm = 7200 AND h.capacity >= 4
```

```json
[
 {
  "module_id": 906,
  "category_id": 7,
  "name": "Seagate IronWolf 7200/256M 12TB",
  "brand": "Seagate",
  "price": 389000,
  "performance_score": 1549,
  "image_url": null,
  "interface_type": "SATA3",
  "capacity": 12,
  "rpm": 7200,
  "buffer_memory": 256
 },
 {
  "module_id": 923,
  "category_id": 7,
  "name": "WD Red Plus 7200/256M 10TB",
  "brand": "Western Digital",
  "price": 380000,
  "performance_score": 2024,
  "image_url": null,
  "interface_type": "SATA3",
  "capacity": 10,
  "rpm": 7200,
  "buffer_memory": 256
 },
 {
  "module_id": 924,
  "category_id": 7,
  "name": "WD Red Plus 7200/256M 12TB",
  "brand": "Western Digital",
  "price": 448000,
  "performance_score": 2019,
  "image_url": null,
  "interface_type": "SATA3",
  "capacity": 12,
  "rpm": 7200,
  "buffer_memory": 256
 },
 {
  "module_id": 926,
  "category_id": 7,
  "name": "WD Red Pro 7200/256M 4TB",
  "brand": "Western Digital",
  "price": 192000,
  "performance_score": 1261,
  "image_url": null,
  "interface_type": "SATA3",
  "capacity": 4,
  "rpm": 7200,
  "buffer_memory": 256
 },
 {
  "module_id": 927,
  "category_id": 7,
  "name": "WD Red Pro 7200/256M 6TB",
  "brand": "Western Digital",
  "price": 268000,
  "performance_score": 1432,
  "image_url": null,
  "interface_type": "SATA3",
  "capacity": 6,
  "rpm": 7200,
  "buffer_memory": 256
 }
]
```

</details>

<details><summary><b>Q28</b> 32인치 4K 모니터 보여줘 — pass · 0행</summary>

- 의도: '4K' 를 해상도 값으로 바꾸는지
- 요청: `{"question": "32인치 4K 모니터 보여줘"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.95, "model": "jev-1.14.0", "latency_ms": 189, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 10507 ms = 판정 189 + 생성 10296 + 실행 1 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 0행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url, screen_size, resolution, panel_type, refresh_rate, aspect_ratio

```sql
SELECT m.*, mo.screen_size, mo.resolution, mo.panel_type, mo.refresh_rate, mo.aspect_ratio FROM modules m JOIN monitors mo ON mo.module_id = m.module_id WHERE mo.screen_size = 32 AND mo.resolution = '3840x2160' ORDER BY m.price ASC
```

</details>

<details><summary><b>Q29</b> i5-13600K에 맞는 메인보드 중 경고 없는 것 — pass · 결과 표 27개</summary>

- 의도: 호환 뷰 + 경고 뷰 조합
- 요청: `{"question": "i5-13600K에 맞는 메인보드 중 경고 없는 것"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.92, "model": "jev-1.14.0", "latency_ms": 192, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 10143 ms = 판정 192 + 생성 9912 + 실행 6 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 27행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url

```sql
SELECT m.* FROM v_cpu_board_compat v JOIN modules m ON m.module_id = v.board_id LEFT JOIN v_cpu_board_warnings w ON w.cpu_id = v.cpu_id AND w.board_id = v.board_id WHERE v.cpu_id = (SELECT mc.module_id FROM modules mc JOIN cpus c ON c.module_id = mc.module_id WHERE mc.name LIKE '%i5-13600K%' LIMIT 1) AND w.warning_code IS NULL
```

```json
[
 {
  "module_id": 164,
  "category_id": 2,
  "name": "ASUS PRIME Z790-P WIFI D4",
  "brand": "ASUS",
  "price": 299000,
  "performance_score": null,
  "image_url": null
 },
 {
  "module_id": 169,
  "category_id": 2,
  "name": "MSI PRO Z790-P WIFI DDR4",
  "brand": "MSI",
  "price": 279000,
  "performance_score": null,
  "image_url": null
 },
 {
  "module_id": 176,
  "category_id": 2,
  "name": "ASRock Z790M PG Lightning/D4",
  "brand": "ASRock",
  "price": 229000,
  "performance_score": null,
  "image_url": null
 },
 {
  "module_id": 177,
  "category_id": 2,
  "name": "ASUS PRIME Z690-P D4",
  "brand": "ASUS",
  "price": 239000,
  "performance_score": null,
  "image_url": null
 },
 {
  "module_id": 179,
  "category_id": 2,
  "name": "MSI PRO Z690-A DDR4",
  "brand": "MSI",
  "price": 249000,
  "performance_score": null,
  "image_url": null
 }
]
```

</details>

<details><summary><b>Q30</b> RTX 5070에 충분한 파워 중 가장 싼 3개 — pass · 결과 표 3개</summary>

- 의도: v_gpu_power_compat
- 요청: `{"question": "RTX 5070에 충분한 파워 중 가장 싼 3개"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.79, "model": "jev-1.14.0", "latency_ms": 184, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 11997 ms = 판정 184 + 생성 11780 + 실행 1 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 3행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url, rated_power, certification, has_16pin, pcie_8pin_count, form_factor

```sql
SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_url, p.rated_power, p.certification, p.has_16pin, p.pcie_8pin_count, p.form_factor FROM power p JOIN modules m ON m.module_id = p.module_id WHERE p.module_id IN (SELECT v.power_id FROM v_gpu_power_compat v JOIN graphic_cards g ON g.module_id = v.gpu_id WHERE g.chipset = 'GeForce RTX 5070') ORDER BY m.price ASC LIMIT 3
```

```json
[
 {
  "module_id": 602,
  "category_id": 5,
  "name": "FSP HYPER K PRO 700W 80PLUS STANDARD",
  "brand": "FSP",
  "price": 62000,
  "performance_score": 80,
  "image_url": null,
  "rated_power": 700,
  "certification": "80PLUS STANDARD",
  "has_16pin": false,
  "pcie_8pin_count": 2,
  "form_factor": "ATX"
 },
 {
  "module_id": 707,
  "category_id": 5,
  "name": "맥스엘리트 MAXWELL BANGBANG 700W 80PLUS STANDARD",
  "brand": "맥스엘리트",
  "price": 86000,
  "performance_score": 80,
  "image_url": null,
  "rated_power": 700,
  "certification": "80PLUS STANDARD",
  "has_16pin": false,
  "pcie_8pin_count": 2,
  "form_factor": "ATX"
 },
 {
  "module_id": 674,
  "category_id": 5,
  "name": "잘만 MegaMax 700W 80PLUS STANDARD",
  "brand": "잘만",
  "price": 91000,
  "performance_score": 80,
  "image_url": null,
  "rated_power": 700,
  "certification": "80PLUS STANDARD",
  "has_16pin": false,
  "pcie_8pin_count": 2,
  "form_factor": "ATX"
 }
]
```

</details>

<details><summary><b>Q31</b> 제조사별 메인보드 평균 가격 — pass · 결과 표 4개</summary>

- 의도: 집계. 화면 매퍼가 집계 결과를 못 그릴 수 있음(엣지 1-6)
- 요청: `{"question": "제조사별 메인보드 평균 가격"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 383, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 11389 ms = 판정 383 + 생성 10977 + 실행 1 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 4행, 컬럼 brand, avg_price

```sql
SELECT m.brand, AVG(m.price) AS avg_price FROM modules m JOIN main_boards mb ON mb.module_id = m.module_id GROUP BY m.brand
```

```json
[
 {
  "brand": "MSI",
  "avg_price": 276666.6667
 },
 {
  "brand": "GIGABYTE",
  "avg_price": 273222.2222
 },
 {
  "brand": "ASRock",
  "avg_price": 228285.7143
 },
 {
  "brand": "ASUS",
  "avg_price": 326000.0
 }
]
```

</details>

<details><summary><b>Q42</b> RTX 5070 실제 소비전력 몇 W야? — reject · 안내·DB</summary>

- 의도: 권장 파워만 있고 실측값은 없음
- 요청: `{"question": "RTX 5070 실제 소비전력 몇 W야?"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 164, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 171 ms = 판정 164 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>
