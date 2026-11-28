# 실험 결과 — test_2_questions

> 실행기가 자동으로 만든 문서다. 분석·해석은 test_N_result.md 에 따로 쓴다.

## 실행 조건

| 항목 | 값 |
|---|---|
| 실행 시각 | 2026-11-28T17:43:23 ~ 2026-11-28T17:45:19 |
| 브랜치 / 커밋 | `feat/#29-frontend-error-card` / `cec7a53 Merge pull request #38 from xtkww971/feat/#29-allow-recommendation` |
| 커밋 안 된 변경 |  M backend/src/main/java/com/database_design/demo/domain/nl2sql/service/Nl2SqlService.java,  M backend/src/main/resources/application.yml,  M backend/src/main/resources/nl2sql/judge-criteria.yml, ?? docs/test/, ?? tools/nl2sql_eval.py |
| 거절 임계값 (컨테이너 env) | 0.65 |
| TypeSafe 키 | 있음 |
| 판정 모델 | jev-1.14.0 |
| SQL 생성 LLM | openai/gpt-oss-120b |
| 백엔드 / nl2sql 이미지 생성 | 2026-11-28T08:42:56.756456976Z / 2026-11-28T08:42:56.793095712Z |
| 파일 해시 (sha256 앞 12자) | judge-criteria.yml `26240a562e56`, schema-summary.txt `54c62bc24bcd`, schema_docs.json `7464446d0218`, few_shot_examples.json `1028f63ddf16`, chroma.sqlite3 `4d020d1ef70a` |
| 반복 / 간격 | 1회 / 3.0s |

## 지표 요약

| 지표 | 값 |
|---|---|
| 실행 건수 | 24 |
| 판정 받음 / 건너뜀 / 판정 전 종료 | 24 / 0 / 0 |
| 판정 정확도 (전체) | 23/24 (96%) |
| 판정 정확도 (경계 제외) | 23/24 (96%) |
| 결과 일치율 (LLM 한도 건 제외) | 23/24 (96%) |
| **오거절** (목표 0) | 0  |
| 놓친 거절 | 1 Q17 |
| **보안 위반** (목표 0) | 0  |
| 판정 지연 | 평균 173 · 중앙 164 · 최소 161 · 최대 285 ms (n=24) |
| 생성 지연 (nl2sql) | 평균 4193 · 중앙 3606 · 최소 1176 · 최대 11319 ms (n=5) |
| 실행 지연 (MySQL) | 평균 2 · 중앙 1 · 최소 1 · 최대 6 ms (n=4) |
| 생성 시도 횟수 | 평균 1.40 · 최대 3 · 재시도 발생(2회 이상) 1건 (n=5) |
| 총 응답 시간 (전체) | 평균 1068 · 중앙 190 · 최소 169 · 최대 11514 ms (n=24) |
| 총 응답 시간 (reject) | 평균 196 · 중앙 187 · 최소 169 · 최대 339 ms (n=19) |
| 총 응답 시간 (pass) | 평균 4527 · 중앙 2606 · 최소 1382 · 최대 11514 ms (n=4) |
| 총 응답 시간 (gen_fail) | 평균 3806 · 중앙 3806 · 최소 3806 · 최대 3806 ms (n=1) |

### 결과 분포

| 결과 | 건수 |
|---|---|
| gen_fail | 1 |
| pass | 4 |
| reject | 19 |

### 판정 분포 (확신도 0.7 미만 포함)

| 판정 | 건수 | 그중 확신도 < 0.7 |
|---|---|---|
| ambiguous | 5 | 0 |
| answerable | 5 | 1 |
| missing_data | 7 | 0 |
| out_of_scope | 7 | 0 |

## 질문별 결과

| ID | 질문 | 예상 판정 | 실제 판정 (확신도) | 판정 ms | 생성 ms (시도) | 실행 ms | 총 ms | HTTP · code | 화면 | 판정 | 결과 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| Q01 | 내일 부산 비 와? | out_of_scope | out_of_scope (1.00) 거절 | 285 | - | - | 339 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q02 | 점심 메뉴 추천해줘 | out_of_scope | out_of_scope (0.96) 거절 | 176 | - | - | 194 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q03 | 파이썬으로 버블 정렬 코드 짜줘 | out_of_scope | out_of_scope (0.98) 거절 | 164 | - | - | 190 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q04 | 너 이름이 뭐야? | out_of_scope | out_of_scope (0.99) 거절 | 162 | - | - | 199 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q05 | CPU 써멀구리스 바르는 법 알려줘 | out_of_scope | out_of_scope (1.00) 거절 | 163 | - | - | 171 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q06 | 그래픽카드 드라이버 업데이트 어떻게 해? | out_of_scope | out_of_scope (0.99) 거절 | 162 | - | - | 170 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q07 | 본체에서 소음이 너무 심한데 원인이 뭐야? | out_of_scope | out_of_scope (0.87) 거절 | 168 | - | - | 176 | 422 NL2SQL_OUT_OF_SCOPE | 안내·금지 | ✅ | ✅ |
| Q08 | 판매량 1위 그래픽카드 뭐야? | missing_data | missing_data (1.00) 거절 | 167 | - | - | 187 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q09 | 별점 4.5 이상인 모니터 보여줘 | missing_data | missing_data (1.00) 거절 | 161 | - | - | 169 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q10 | 후기 많은 SSD 추천해줘 | missing_data | missing_data (0.99) 거절 | 163 | - | - | 171 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q11 | 지금 품절 안 된 램만 보여줘 | missing_data | missing_data (1.00) 거절 | 163 | - | - | 187 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q12 | 오늘 특가 하는 CPU 있어? | missing_data | missing_data (1.00) 거절 | 182 | - | - | 207 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q13 | RTX 5070 최저가 추이 보여줘 | missing_data | missing_data (1.00) 거절 | 161 | - | - | 187 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q14 | 최신 세대 인텔 CPU만 보여줘 | missing_data | missing_data (0.99) 거절 | 174 | - | - | 200 | 422 NL2SQL_MISSING_DATA | 안내·DB | ✅ | ✅ |
| Q15 | 추천 좀 | ambiguous | ambiguous (0.90) 거절 | 167 | - | - | 185 | 422 NL2SQL_AMBIGUOUS | 안내·물음표 | ✅ | ✅ |
| Q16 | 이거 사도 돼? | ambiguous | ambiguous (0.85) 거절 | 162 | - | - | 183 | 422 NL2SQL_AMBIGUOUS | 안내·물음표 | ✅ | ✅ |
| Q17 | 저번에 본 거 다시 보여줘 | ambiguous | answerable (0.42) | 165 | 3618 (3) | - | 3806 | 422 NL2SQL_GENERATION_FAILED | 주황·다시 표현 | ❌ | ❌ ⚠️놓침 |
| Q18 | 그거보다 좋은 걸로 | ambiguous | ambiguous (0.94) 거절 | 202 | - | - | 227 | 422 NL2SQL_AMBIGUOUS | 안내·물음표 | ✅ | ✅ |
| Q19 | 비싼 거 보여줘 | ambiguous | ambiguous (0.71) 거절 | 164 | - | - | 189 | 422 NL2SQL_AMBIGUOUS | 안내·물음표 | ✅ | ✅ |
| Q20 | 괜찮은 거 있어? | ambiguous | ambiguous (0.81) 거절 | 166 | - | - | 187 | 422 NL2SQL_AMBIGUOUS | 안내·물음표 | ✅ | ✅ |
| Q21 | 50만원 이하 그래픽카드를 VRAM 큰 순서로 보여줘 | answerable | answerable (0.99) | 166 | 1176 (1) | 6 | 1382 | 200  | 결과 표 46개 | ✅ | ✅ |
| Q22 | AM4 소켓 CPU 중 6코어 이상인 것 | answerable | answerable (0.99) | 164 | 1247 (1) | 1 | 1430 | 200  | 결과 표 32개 | ✅ | ✅ |
| Q23 | DDR4 램 중 3200MT/s 이상인 제품 싼 순서로 | answerable | answerable (1.00) | 164 | 3606 (1) | 1 | 3781 | 200  | 결과 표 57개 | ✅ | ✅ |
| Q24 | Mini-ITX 메인보드 전부 보여줘 | answerable | answerable (0.99) | 186 | 11319 (1) | 1 | 11514 | 200  | 결과 표 10개 | ✅ | ✅ |

## 질문별 상세

<details><summary><b>Q01</b> 내일 부산 비 와? — reject · 안내·금지</summary>

- 의도: 날씨. 가장 명확한 범위 밖
- 요청: `{"question": "내일 부산 비 와?"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 285, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 339 ms = 판정 285 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q02</b> 점심 메뉴 추천해줘 — reject · 안내·금지</summary>

- 의도: '추천' 단어가 있어도 주제가 다르면 거절되는지
- 요청: `{"question": "점심 메뉴 추천해줘"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.96, "model": "jev-1.14.0", "latency_ms": 176, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 194 ms = 판정 176 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q03</b> 파이썬으로 버블 정렬 코드 짜줘 — reject · 안내·금지</summary>

- 의도: 코딩 요청
- 요청: `{"question": "파이썬으로 버블 정렬 코드 짜줘"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.98, "model": "jev-1.14.0", "latency_ms": 164, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 190 ms = 판정 164 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q04</b> 너 이름이 뭐야? — reject · 안내·금지</summary>

- 의도: 모델 자신에 대한 질문
- 요청: `{"question": "너 이름이 뭐야?"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 162, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 199 ms = 판정 162 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q05</b> CPU 써멀구리스 바르는 법 알려줘 — reject · 안내·금지</summary>

- 의도: 부품명이 있지만 조립 방법 질문
- 요청: `{"question": "CPU 써멀구리스 바르는 법 알려줘"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 163, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 171 ms = 판정 163 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q06</b> 그래픽카드 드라이버 업데이트 어떻게 해? — reject · 안내·금지</summary>

- 의도: 부품명 + 소프트웨어 문제
- 요청: `{"question": "그래픽카드 드라이버 업데이트 어떻게 해?"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 162, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 170 ms = 판정 162 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q07</b> 본체에서 소음이 너무 심한데 원인이 뭐야? — reject · 안내·금지</summary>

- 의도: 고장·소음 해결. 기준에 명시된 예
- 요청: `{"question": "본체에서 소음이 너무 심한데 원인이 뭐야?"}`
- 판정: {"status": "judged", "verdict": "out_of_scope", "confidence": 0.87, "model": "jev-1.14.0", "latency_ms": 168, "rejected": true}
- 응답: HTTP 422, code NL2SQL_OUT_OF_SCOPE, message PC 부품 정보에 대해서만 답할 수 있어요.
- 시간: 총 176 ms = 판정 168 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q08</b> 판매량 1위 그래픽카드 뭐야? — reject · 안내·DB</summary>

- 의도: 판매량
- 요청: `{"question": "판매량 1위 그래픽카드 뭐야?"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 167, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 187 ms = 판정 167 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q09</b> 별점 4.5 이상인 모니터 보여줘 — reject · 안내·DB</summary>

- 의도: 별점. 숫자 조건이 붙어 조회처럼 보이는 형태
- 요청: `{"question": "별점 4.5 이상인 모니터 보여줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 161, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 169 ms = 판정 161 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q10</b> 후기 많은 SSD 추천해줘 — reject · 안내·DB</summary>

- 의도: 후기
- 요청: `{"question": "후기 많은 SSD 추천해줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 163, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 171 ms = 판정 163 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q11</b> 지금 품절 안 된 램만 보여줘 — reject · 안내·DB</summary>

- 의도: 재고·품절
- 요청: `{"question": "지금 품절 안 된 램만 보여줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 163, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 187 ms = 판정 163 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q12</b> 오늘 특가 하는 CPU 있어? — reject · 안내·DB</summary>

- 의도: 할인·특가
- 요청: `{"question": "오늘 특가 하는 CPU 있어?"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 182, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 207 ms = 판정 182 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q13</b> RTX 5070 최저가 추이 보여줘 — reject · 안내·DB</summary>

- 의도: 가격 이력. 현재 가격은 있어서 헷갈릴 수 있음
- 요청: `{"question": "RTX 5070 최저가 추이 보여줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 161, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 187 ms = 판정 161 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q14</b> 최신 세대 인텔 CPU만 보여줘 — reject · 안내·DB</summary>

- 의도: 출시일·세대
- 요청: `{"question": "최신 세대 인텔 CPU만 보여줘"}`
- 판정: {"status": "judged", "verdict": "missing_data", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 174, "rejected": true}
- 응답: HTTP 422, code NL2SQL_MISSING_DATA, message 판매·리뷰 정보는 아직 제공하지 않아요.
- 시간: 총 200 ms = 판정 174 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q15</b> 추천 좀 — reject · 안내·물음표</summary>

- 의도: 대상 없음. 가장 짧은 형태
- 요청: `{"question": "추천 좀"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.9, "model": "jev-1.14.0", "latency_ms": 167, "rejected": true}
- 응답: HTTP 422, code NL2SQL_AMBIGUOUS, message 조건을 조금 더 구체적으로 알려주세요.
- 시간: 총 185 ms = 판정 167 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q16</b> 이거 사도 돼? — reject · 안내·물음표</summary>

- 의도: 지시어 대상 없음
- 요청: `{"question": "이거 사도 돼?"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.85, "model": "jev-1.14.0", "latency_ms": 162, "rejected": true}
- 응답: HTTP 422, code NL2SQL_AMBIGUOUS, message 조건을 조금 더 구체적으로 알려주세요.
- 시간: 총 183 ms = 판정 162 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q17</b> 저번에 본 거 다시 보여줘 — gen_fail · 주황·다시 표현</summary>

- 의도: 이전 맥락 의존. 대화 기록이 없다
- 요청: `{"question": "저번에 본 거 다시 보여줘"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.42, "model": "jev-1.14.0", "latency_ms": 165, "rejected": false}
- 응답: HTTP 422, code NL2SQL_GENERATION_FAILED, message 질문을 이해하지 못했습니다. 다르게 표현해 주세요.
- 시간: 총 3806 ms = 판정 165 + 생성 3618 + 실행 - ms (+ 그 밖의 오버헤드)
- 생성: failed, 시도 3회 (retry_count), 사유 쿼리가 생성되지 않았습니다.

</details>

<details><summary><b>Q18</b> 그거보다 좋은 걸로 — reject · 안내·물음표</summary>

- 의도: 지시어 + 비교 기준 없음
- 요청: `{"question": "그거보다 좋은 걸로"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.94, "model": "jev-1.14.0", "latency_ms": 202, "rejected": true}
- 응답: HTTP 422, code NL2SQL_AMBIGUOUS, message 조건을 조금 더 구체적으로 알려주세요.
- 시간: 총 227 ms = 판정 202 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q19</b> 비싼 거 보여줘 — reject · 안내·물음표</summary>

- 의도: 정렬 기준은 있으나 부품 종류 없음
- 요청: `{"question": "비싼 거 보여줘"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.71, "model": "jev-1.14.0", "latency_ms": 164, "rejected": true}
- 응답: HTTP 422, code NL2SQL_AMBIGUOUS, message 조건을 조금 더 구체적으로 알려주세요.
- 시간: 총 189 ms = 판정 164 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q20</b> 괜찮은 거 있어? — reject · 안내·물음표</summary>

- 의도: 대상·기준 모두 없음
- 요청: `{"question": "괜찮은 거 있어?"}`
- 판정: {"status": "judged", "verdict": "ambiguous", "confidence": 0.81, "model": "jev-1.14.0", "latency_ms": 166, "rejected": true}
- 응답: HTTP 422, code NL2SQL_AMBIGUOUS, message 조건을 조금 더 구체적으로 알려주세요.
- 시간: 총 187 ms = 판정 166 + 생성 - + 실행 - ms (+ 그 밖의 오버헤드)

</details>

<details><summary><b>Q21</b> 50만원 이하 그래픽카드를 VRAM 큰 순서로 보여줘 — pass · 결과 표 46개</summary>

- 의도: 가격 필터 + 사양 정렬
- 요청: `{"question": "50만원 이하 그래픽카드를 VRAM 큰 순서로 보여줘"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 166, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 1382 ms = 판정 166 + 생성 1176 + 실행 6 ms (+ 그 밖의 오버헤드)
- 생성: ok, 시도 1회 (retry_count)
- 결과: 46행, 컬럼 module_id, category_id, name, brand, price, performance_score, image_url, memory_capacity, chipset, memory_type, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports

```sql
SELECT m.*, g.memory_capacity, g.chipset, g.memory_type, g.length_mm, g.recommended_power, g.uses_16pin, g.pcie_8pin_count, g.ports FROM modules m JOIN graphic_cards g ON g.module_id = m.module_id WHERE m.price <= 500000 ORDER BY g.memory_capacity DESC
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
  "memory_capacity": 16,
  "chipset": "Intel Arc A770",
  "memory_type": "GDDR6",
  "length_mm": 303,
  "recommended_power": 650,
  "uses_16pin": false,
  "pcie_8pin_count": 2,
  "ports": "HDMI 2.1 x1, DP 2.0 x3"
 },
 {
  "module_id": 508,
  "category_id": 4,
  "name": "SAPPHIRE 라데온 RX 7600 XT PULSE 16GB",
  "brand": "SAPPHIRE",
  "price": 461000,
  "performance_score": 17303,
  "image_url": null,
  "memory_capacity": 16,
  "chipset": "Radeon RX 7600 XT",
  "memory_type": "GDDR6",
  "length_mm": 251,
  "recommended_power": 600,
  "uses_16pin": false,
  "pcie_8pin_count": 2,
  "ports": "HDMI 2.1 x1, DP 2.1 x2"
 },
 {
  "module_id": 518,
  "category_id": 4,
  "name": "ASRock 인텔 Arc A770 Steel Legend 16GB",
  "brand": "ASRock",
  "price": 434000,
  "performance_score": 13909,
  "image_url": null,
  "memory_capacity": 16,
  "chipset": "Intel Arc A770",
  "memory_type": "GDDR6",
  "length_mm": 304,
  "recommended_power": 650,
  "uses_16pin": false,
  "pcie_8pin_count": 2,
  "ports": "HDMI 2.1 x1, DP 2.0 x3"
 },
 {
  "module_id": 538,
  "category_id": 4,
  "name": "XFX 라데온 RX 7600 XT SPEEDSTER SWFT 210 16GB",
  "brand": "XFX",
  "price": 475000,
  "performance_score": 17202,
  "image_url": null,
  "memory_capacity": 16,
  "chipset": "Radeon RX 7600 XT",
  "memory_type": "GDDR6",
  "length_mm": 242,
  "recommended_power": 600,
  "uses_16pin": false,
  "pcie_8pin_count": 2,
  "ports": "HDMI 2.1 x1, DP 2.1 x2"
 },
 {
  "module_id": 548,
  "category_id": 4,
  "name": "ASRock 인텔 Arc A770 Challenger OC 16GB",
  "brand": "ASRock",
  "price": 387000,
  "performance_score": 13687,
  "image_url": null,
  "memory_capacity": 16,
  "chipset": "Intel Arc A770",
  "memory_type": "GDDR6",
  "length_mm": 280,
  "recommended_power": 650,
  "uses_16pin": false,
  "pcie_8pin_count": 2,
  "ports": "HDMI 2.1 x1, 
```

</details>

<details><summary><b>Q22</b> AM4 소켓 CPU 중 6코어 이상인 것 — pass · 결과 표 32개</summary>

- 의도: CPU 상세 필터
- 요청: `{"question": "AM4 소켓 CPU 중 6코어 이상인 것"}`
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 164, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 1430 ms = 판정 164 + 생성 1247 + 실행 1 ms (+ 그 밖의 오버헤드)
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
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 1.0, "model": "jev-1.14.0", "latency_ms": 164, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 3781 ms = 판정 164 + 생성 3606 + 실행 1 ms (+ 그 밖의 오버헤드)
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
- 판정: {"status": "judged", "verdict": "answerable", "confidence": 0.99, "model": "jev-1.14.0", "latency_ms": 186, "rejected": false}
- 응답: HTTP 200, code -, message -
- 시간: 총 11514 ms = 판정 186 + 생성 11319 + 실행 1 ms (+ 그 밖의 오버헤드)
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
