# NL2SQL 품질 평가 2차: 간편 입력 포함 실측 (2026-11-25)

> **목적**: 프로그램·예산 전달 경로(E-2)를 복구한 뒤 추천 파이프라인 품질을 다시 측정한다. 간편 입력(프로그램·예산 칸)과 자연어 질의를 섞어 실제 사용자와 같은 조건에서 본다.
> **방법**: 브라우저와 같은 경로(`POST http://localhost:3000/api/nl2sql/query`, frontend nginx → backend → nl2sql)로 질문을 순서대로 호출했다. 간편 입력 케이스는 `RecommendationPage.jsx`의 `buildPromptFromForm`과 같은 문장을 `question`에 넣고, `programs`, `budgetMin`, `budgetMax`도 함께 보냈다.
> **환경**: docker compose (`dbd-frontend` / `dbd-backend` / `dbd-nl2sql` / `dbd-mysql`), `dev` `c185a62` 기준으로 세 이미지를 모두 다시 빌드했다. LLM은 Groq `openai/gpt-oss-120b`(temperature 0)다.
> **데이터**: `modules` 1,200행 (카테고리 8종 × 150행), `performance_score`는 MAINBOARD만 전부 NULL이다.

---

## 1. 요약

| 지표 | 값 |
|---|---|
| 총 케이스 | 34 (간편 입력 13 / 자연어 21) |
| HTTP 200 | 34 (100%) |
| ✅ 정상 | 21 (**62%**) |
| ⚠️ 부분 성공 | 8 |
| ❌ 오답 | 5 (예산 초과 3, 집계 깨짐 2) |
| 평균 응답 | 26.55초 |
| 최장 / 최단 | 54.66초 (#17) / 4.55초 (#1) |

**한 줄 평가**: 자연어 견적은 1차보다 확실히 나아졌다(예산을 지킨 견적 5/5). 하지만 **간편 입력은 13건 중 4건만 정상**이다. 예산만 넣으면 예산을 2.6~3.8배 넘기고, 예산 없이 프로그램만 넣으면 항상 최고가 구성이 나온다.

### 유형별

| 유형 | 입력 방식 | n | ✅ | ⚠️ | ❌ | 성공률 |
|---|---|---|---|---|---|---|
| A. 프로그램 + 예산 | 간편 | 4 | 2 | 2 | 0 | 2/4 |
| B. 프로그램만 | 간편 | 4 | 0 | 4 | 0 | **0/4** |
| C. 예산만 | 간편 | 5 | 2 | 0 | **3** | 2/5 |
| D. 견적 요청 | 자연어 | 4 | 4 | 0 | 0 | 4/4 |
| E. 예산 표현 | 자연어 | 4 | 4 | 0 | 0 | 4/4 |
| F. 단일 부품 | 자연어 | 4 | 4 | 0 | 0 | 4/4 |
| G. 비교·집계 | 자연어 | 4 | 2 | 0 | 2 | 2/4 |
| H. 호환성 | 자연어 | 4 | 3 | 1 | 0 | 3/4 |
| I. 모호·구어체 | 자연어 | 1 | 0 | 1 | 0 | 0/1 |

> **간편 입력은 13건 중 4건만 정상이고, 자연어 견적·예산 표현은 8건 모두 정상이었다.** 구조화된 값을 주는 쪽이 오히려 결과가 나쁘다. 원인은 §4 N-1, N-3에 정리했다.

### 1차 평가 대비

| 1차 결함 | 이번 결과 | 상태 |
|---|---|---|
| E-2 프로그램·예산 미전달 | #1, #2에서 부품별 상한(게임 비율 20/10/10/40/10/10%)이 SQL에 그대로 들어감 | ✅ 해결 |
| E-3 예산을 사후 필터로 써서 0행 | 0행 케이스 **0건**. 모든 견적이 CTE마다 `price <=` 조건으로 고름 | ✅ 해결 |
| E-4 "안팎·정도"를 부품 단가로 오해 | #18 "100만원 안팎" → 90.9만, #19 "150만원 정도" → 142.8만 | ✅ 해결 |
| E-5 100행 상한 잘림 36% | 2/34 (6%), 둘 다 집계 질문(E-12 때문) | 🟡 대부분 해결 |
| E-9 `performance_score` 대부분 NULL | MAINBOARD 외 전부 채워짐 | 🟡 MAINBOARD만 남음 |
| E-11 컬럼 중복 | #30 `m.*, mb.*` → `module_id` 2번 | 🔴 남음 |
| E-12 규칙 8번이 집계를 깨뜨림 | #26, #27 `OVER()`로 100행 | 🔴 남음 |

---

## 2. 테스트 구성

| 입력 방식 | 보내는 값 | 그래프 분기 |
|---|---|---|
| 간편: 프로그램 + 예산 | `question`(자동 생성 문장) + `programs` + `budgetMin`/`budgetMax` | `program_spec_retriever` → `usage_classifier` → **PART_BUDGET_PROMPT** |
| 간편: 프로그램만 | `question` + `programs` | `program_spec_retriever` → `usage_classifier`(최대 예산이 없어 건너뜀) → PROGRAM_SPEC_PROMPT |
| 간편: 예산만 | `question` + `budgetMin`/`budgetMax` | `schema_retriever` 직행 → **BUDGET_PROMPT** (부품별 상한 없음) |
| 자연어 | `question`만 | `schema_retriever` 직행. 예산·용도는 LLM이 문장에서 추측 |

판정 기준:

- ✅ 정상: 견적이면 예산 안에서 필수 부품이 모두 나온 경우. 조회면 1~99행이고 조건이 맞은 경우.
- ⚠️ 부분: 결과는 나왔지만 부품 누락, 용도에 맞지 않는 과사양, 컬럼 중복 같은 문제가 있는 경우.
- ❌ 오답: 예산을 넘겼거나 질문에 답이 되지 않는 경우.

---

## 3. 케이스별 결과

### A. 간편-프로그램+예산 (4건)

| # | 간편 입력 값 | 판정 | 응답 | 행 | 비고 | 생성된 SQL (요약) |
|---|---|---|---|---|---|---|
| 1 | 프로그램: 리그 오브 레전드 / 예산: ~80만 | ✅ 정상 | 4.55s | 6 | 합계 70.7만 ≤ 80만, 부품별 상한(게임 비율) 적용 | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 2 | 프로그램: 오버워치 2, 디스코드 / 예산: 100만~150만 | ✅ 정상 | 49.81s | 6 | 합계 127.3만, 100~150만 범위 안 | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 3 | 프로그램: AutoCAD / 예산: 150만~ | ⚠️ 부분 | 19.51s | 6 | 최소 예산만 입력 → 상한 없음, 합계 705.5만 | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id OR…` |
| 4 | 프로그램: 엑셀, 한글 / 예산: ~60만 | ⚠️ 부분 | 37.34s | 4 | 합계 39.8만. 파워 누락 (상한 6만 < 최저가 6.2만) | `WITH cpu AS (SELECT m.module_id FROM modules m JOIN categories c ON m.category_id = c.cate…` |

### B. 간편-프로그램만 (4건)

| # | 간편 입력 값 | 판정 | 응답 | 행 | 비고 | 생성된 SQL (요약) |
|---|---|---|---|---|---|---|
| 5 | 프로그램: 발로란트 | ⚠️ 부분 | 19.7s | 6 | 예산 미입력 → 최고가 구성 712.5만 (발로란트에 과함) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 6 | 프로그램: 블렌더 | ⚠️ 부분 | 30.01s | 6 | 712.5만, #5와 거의 동일 구성 | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 7 | 프로그램: Visual Studio, Docker | ⚠️ 부분 | 32.1s | 4 | 216.3만, GPU·파워 누락 (SQL에 CTE 자체 없음) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 8 | 프로그램: 로스트아크, OBS | ⚠️ 부분 | 31.63s | 6 | 708.5만 최고가 구성 | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |

### C. 간편-예산만 (5건)

| # | 간편 입력 값 | 판정 | 응답 | 행 | 비고 | 생성된 SQL (요약) |
|---|---|---|---|---|---|---|
| 9 | 예산: 100만~150만 | ❌ 예산초과 | 35.22s | 6 | 합계 387.4만 / 상한 150만 (2.6배) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 10 | 예산: ~50만 | ❌ 예산초과 | 38.39s | 6 | 합계 191.6만 / 상한 50만 (3.8배) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 11 | 예산: 300만~ | ✅ 정상 | 35.23s | 6 | 712.5만 ≥ 300만 (상한 없음이 맞음) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id OR…` |
| 12 | 예산: ~1000만 | ✅ 정상 | 25.93s | 6 | 712.5만 ≤ 1000만 | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 13 | 예산: 80만~80만 | ❌ 예산초과 | 40.0s | 6 | 합계 268.9만 / 80만 (3.4배) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |

### D. 자연어-견적 (4건)

| # | 질문 | 판정 | 응답 | 행 | 비고 | 생성된 SQL (요약) |
|---|---|---|---|---|---|---|
| 14 | 150만원으로 게임용 컴퓨터 맞춰줘 | ✅ 정상 | 43.34s | 6 | 합계 127.3만 ≤ 150만, LLM이 부품별 상한 자체 산정 | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 15 | 대학생 과제용으로 무난한 컴퓨터 견적 짜줘 | ✅ 정상 | 32.62s | 5 | 62.7만, 내장그래픽 CPU + GPU 생략 | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 16 | 200만원 안쪽으로 영상편집용 PC 추천해줘 | ✅ 정상 | 40.67s | 6 | 합계 198.3만 ≤ 200만 | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 17 | 배그 풀옵 돌아가는 컴퓨터 견적 알려줘 | ✅ 정상 | 54.66s | 6 | 726.6만 고사양 (예산 없음) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |

### E. 자연어-예산표현 (4건)

| # | 질문 | 판정 | 응답 | 행 | 비고 | 생성된 SQL (요약) |
|---|---|---|---|---|---|---|
| 18 | 100만원 안팎으로 맞출 수 있는 견적 있어? | ✅ 정상 | 15.15s | 6 | 합계 90.9만 (100만 안팎) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 19 | 백오십만원 정도로 PC 구성해줘 | ✅ 정상 | 35.24s | 6 | 합계 142.8만 (150만 정도) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 20 | 최대 120만원까지 쓸 수 있어. 컴퓨터 추천해줘 | ✅ 정상 | 30.28s | 6 | 합계 83.9만 ≤ 120만 (예산을 덜 씀) | `WITH cpu AS (SELECT c.module_id FROM cpus c JOIN modules m ON m.module_id = c.module_id WH…` |
| 21 | 돈 아끼고 싶어. 최대한 싸게 컴퓨터 맞춰줘 | ✅ 정상 | 31.29s | 8 | 부품별 최저가 8종 75.8만 (HDD·모니터 포함) | `WITH cpu AS (SELECT m.module_id FROM modules m JOIN categories ct ON m.category_id = ct.ca…` |

### F. 자연어-단일부품 (4건)

| # | 질문 | 판정 | 응답 | 행 | 비고 | 생성된 SQL (요약) |
|---|---|---|---|---|---|---|
| 22 | 30만원 이하 그래픽카드 추천해줘 | ✅ 정상 | 19.34s | 5 | ≤30만 GPU 5개 (LIMIT 5 자체 판단) | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |
| 23 | AMD CPU 중에 가성비 좋은 거 알려줘 | ✅ 정상 | 20.61s | 66 | AMD CPU, 성능/가격 비율 정렬 | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |
| 24 | 32GB DDR5 램 보여줘 | ✅ 정상 | 18.64s | 33 | DDR5 AND 32GB | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |
| 25 | 2TB NVMe SSD 찾아줘 | ✅ 정상 | 6.61s | 34 | 2TB AND M.2 (NVMe를 M.2로 근사) | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |

### G. 자연어-비교집계 (4건)

| # | 질문 | 판정 | 응답 | 행 | 비고 | 생성된 SQL (요약) |
|---|---|---|---|---|---|---|
| 26 | 그래픽카드 평균 가격이 얼마야? | ❌ 집계깨짐 | 6.54s | 100 | AVG() OVER() → 100행 잘림, 평균 1개가 아님 | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |
| 27 | 제조사별로 CPU 몇 개씩 있어? | ❌ 집계깨짐 | 12.0s | 100 | COUNT(*) OVER(PARTITION BY brand) → 100행 | `SELECT m.*, COUNT(*) OVER (PARTITION BY m.brand) AS cpu_count FROM modules m JOIN cpus c O…` |
| 28 | 가장 비싼 메인보드 3개 보여줘 | ✅ 정상 | 6.73s | 3 | 가격 DESC LIMIT 3 | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |
| 29 | RTX 4060이랑 RTX 4070 가격 비교해줘 | ✅ 정상 | 25.97s | 31 | 두 칩셋 목록 가격순 (비교표는 아님) | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |

### H. 자연어-호환성 (4건)

| # | 질문 | 판정 | 응답 | 행 | 비고 | 생성된 SQL (요약) |
|---|---|---|---|---|---|---|
| 30 | AM5 소켓 메인보드 보여줘 | ⚠️ 부분 | 20.51s | 59 | m.*, mb.* → module_id 컬럼 중복 | `SELECT m.*, mb.* FROM modules m JOIN main_boards mb ON mb.module_id = m.module_id WHERE mb…` |
| 31 | i5-14400F에 맞는 메인보드 추천해줘 | ✅ 정상 | 25.51s | 74 | v_cpu_board_compat 호환 뷰 사용 | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |
| 32 | RTX 4080 쓰려면 파워 몇 와트 필요해? | ✅ 정상 | 15.64s | 6 | RTX 4080 6종 + recommended_power | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |
| 33 | DDR4 지원하는 인텔 메인보드 알려줘 | ✅ 정상 | 21.65s | 32 | LGA1700 + DDR4 (DB의 인텔 DDR4 보드 전부) | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |

### I. 모호·구어체 (1건)

| # | 질문 | 판정 | 응답 | 행 | 비고 | 생성된 SQL (요약) |
|---|---|---|---|---|---|---|
| 34 | 요즘 제일 잘나가는 거 | ⚠️ 부분 | 20.18s | 10 | performance_score 상위 10 → 전부 RAM (카테고리 간 스케일 차이) | `SELECT m.module_id, m.category_id, m.name, m.brand, m.price, m.performance_score, m.image_…` |

---

## 4. 발견된 결함 및 해결(코드 변경사항)


| No. | 문제 | 영향 | 해결 |
| :--- | :--- | :--- | :--- |
| 1 | 프로그램명이 들어오지 않으면 부품별 상한을 판단하지 못함 | 부품마다 상한을 budget_max로 잡고 견적을 짬 | BUDGET_PROMPT(프로그램명이 없을 때 쓰는 프롬프트)의 규칙 1을 "부품 가격의 합계가 최대 예산을 넘지 않도록 부품별 상한을 나눠 거세요"로 수정 |
| 2 | 예산이 없으면 용도와 상관없이 항상 최고가로 구성함 | 용도에 비해 스펙이 과한 견적이 나옴 | "가격 상한이 없을 경우 권장 사양을 만족하는 부품 중 가격이 낮은 순으로 견적을 생성하세요." 프롬프트 추가 |
| 3 | 부품별 상한이 그 카테고리 최저가보다 낮으면 해당 부품이 견적에서 빠짐 | 예) power 상한이 6만 원이고 판매 중인 최저가가 6.2만 원이면 power가 견적에 들어가지 않음 | format_part_budgets(부품별 상한 계산 함수)에서 상한을 max(비율 상한, 카테고리 최저가)로 변경. 카테고리별 최저가는 서버 시작 시 한 번만 조회 |
| 4 | 서로 다른 카테고리끼리 performance_score를 비교함 | 카테고리마다 점수 기준이 달라 비교 결과가 왜곡됨 | "performance_score는 같은 카테고리 안에서만 비교하세요" 규칙 추가 |
