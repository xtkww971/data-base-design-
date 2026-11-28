# AI 추천 견적에 서로 호환되지 않는 부품이 섞여 나옴

> 작성일: 2026-11-28
> 상태: **조치 중 (1/4)**. 조치 1 스키마 설명 문구 수정 완료 → [조치 기록](nl2sql-incompatible-build-fix-schema-docs.md)
> 관련: [nl2sql-flow.md](../nl2sql-flow.md), [nl2sql-edge-cases.md](../nl2sql-edge-cases.md) 1-1·1-9, [04-부품별-제약조건.md](../스키마%20설계/04-부품별-제약조건.md)

## 한 줄 요약

DB 데이터나 제약조건 문제가 아니다. **LLM 에 넘기는 프롬프트가 "호환 뷰를 써라"와 "스키마에 없는 걸 쓰지 마라"를 동시에 말하고 있어서** LLM 이 실행마다 둘 중 하나를 고르고, 호환 뷰를 쓰지 않은 SQL 도 검증을 그대로 통과해 화면까지 간다.

---

## 1. 증상

추천 페이지 간편 입력에서 프로그램 `배틀그라운드`, 예산 `100~150만원`으로 요청한 뒤 결과 부품을 장바구니에 담으면 호환성 오류가 뜬다.

```
램 규격(DDR5)과 메인보드 메모리 규격(DDR4)이 달라요.
CPU 소켓(LGA1700)과 메인보드 소켓(AM4)이 달라요.
```

같은 요청을 다시 보내면 정상 견적이 나올 때도 있다.

## 2. 재현

백엔드에 프론트와 같은 요청을 보냈다.

```json
POST /api/nl2sql/query
{
  "question": "배틀그라운드 용도로 100만원~150만원 예산의 컴퓨터 견적 맞춰줘.",
  "programs": ["배틀그라운드"],
  "budgetMin": 1000000,
  "budgetMax": 1500000
}
```

| 회차 | 호환 뷰 사용 | CPU | 메인보드 | 램 | 결과 |
|---|---|---|---|---|---|
| 1 | O (`v_cpu_board_compat` → `v_ram_board_compat` → `v_gpu_power_compat`) | i5-14600KF (LGA1700) | ASRock H610M-HVS (LGA1700, DDR4) | DDR4-3600 16GB | ✅ 호환 |
| 2 | X | i5-14600KF (LGA1700) | ASUS PRIME A520M-E (**AM4**, DDR4) | **DDR5**-6000 32GB | ❌ 소켓·메모리 규격 불일치 |
| 3 | — | — | — | — | nl2sql 응답 오류 (7절) |
| 4 | X | 2회차와 같음 | 2회차와 같음 | 2회차와 같음 | ❌ |

정상(1회차) SQL은 앞에서 고른 부품에 맞춰 다음 부품을 고른다.

```sql
cpu   AS (SELECT ... FROM cpus ... LIMIT 1),
board AS (SELECT v.board_id ... FROM v_cpu_board_compat v JOIN cpu ON cpu.module_id = v.cpu_id ... LIMIT 1),
ram   AS (SELECT v.ram_id   ... FROM v_ram_board_compat v JOIN board ON board.module_id = v.board_id ... LIMIT 1),
psu   AS (SELECT v.power_id ... FROM v_gpu_power_compat v JOIN gpu ON gpu.module_id = v.gpu_id ... LIMIT 1)
```

오류(2·4회차) SQL은 부품마다 "예산 안에서 성능이 가장 높은 것"을 **서로 상관없이** 하나씩 고른다.

```sql
ram   AS (SELECT r.module_id FROM rams r JOIN modules m ... WHERE r.capacity >= 16 AND m.price <= 150000 ... LIMIT 1),
board AS (SELECT m.module_id FROM modules m JOIN categories ct ... WHERE ct.category_name = 'MAINBOARD' AND m.price <= 150000 ... LIMIT 1),
power AS (SELECT m.module_id FROM modules m JOIN categories ct ... WHERE ct.category_name = 'POWER'     AND m.price <= 150000 ... LIMIT 1)
```

---

## 3. 배제한 원인: DB 데이터·제약조건

데이터를 바꾼 적이 있어서 DB가 꼬였을 가능성을 먼저 확인했다. **모두 정상이었다.**

| 확인 항목 | 방법 | 결과 |
|---|---|---|
| Flyway 적용 상태 | `flyway_schema_history` 조회 | V1~V7 모두 `success = 1` (2026-11-02 적용). 백엔드가 기동 시 체크섬 검증을 통과하므로 적용 후 파일 변경도 없음 |
| 제약조건 누락 | 마이그레이션 파일의 제약 이름과 `information_schema.TABLE_CONSTRAINTS` 비교 | 파일의 CHECK·FK·UNIQUE 전부 DB에 있음. `NOT ENFORCED` 없음. 호환 뷰 7개 모두 있음 |
| FK 위반 행 (FK 검사를 끄고 넣은 경우) | 소켓, 메모리 규격, 보드 소켓-메모리 조합, 칩셋-소켓을 LEFT JOIN 으로 검사 | 0건 |
| 상세 행·카테고리 불일치 | `modules` 와 부품별 상세 테이블 대조 | 0건 |
| 제품명과 스펙 컬럼 불일치 | 램 이름의 DDR4/DDR5·용량·키트 수, CPU 세대별 소켓, F 모델 내장그래픽, GPU VRAM | 0건 |
| 시드 파일과 DB 차이 | 임시 DB에 V1~V7 + 현재 `db/seed/dummy_modules.sql` 적재 후 테이블 16개를 `EXCEPT` 로 행 단위 비교 | 0건 (1,200개 일치) |
| 뷰 판정 | 2회차의 조합을 호환 뷰에 직접 질의 | 14600KF + A520M-E → 비호환, A520M-E + DDR5 램 → 비호환 (뷰는 정확함) |

즉 **DB는 호환 여부를 정확히 알고 있다.** 문제는 LLM 이 그 뷰를 쓰지 않는 SQL 을 만들 때가 있다는 것이다.

---

## 4. 원인 분석

잘못된 견적이 화면까지 가려면 아래 네 단계를 모두 지나야 한다. 지금은 네 곳 모두 막는 장치가 없다.

```mermaid
flowchart LR
    A["① 스키마 검색<br/>호환 뷰가 빠짐"] --> B["② SQL 생성<br/>프롬프트 규칙 충돌<br/>→ 실행마다 해석이 갈림"]
    B --> C["③ 검증<br/>문법만 확인"]
    C --> D["④ 실행·응답<br/>결과 호환성 확인 없음"]
    D --> E["장바구니에서<br/>처음 발견"]
```

### ① 질문에 "견적"이 들어가면 호환 뷰가 스키마에서 빠진다

[retriever.py](../../nl2sql/tools/retriever.py) 의 `get_schema()` 는 `modules`, `categories` 를 항상 넣고, 나머지 **4개**를 질문 원문과의 임베딩 유사도로 고른다. 검색 결과를 실제로 뽑아 보면 다음과 같다.

| 질문 | 유사도로 고른 4개 |
|---|---|
| 배틀그라운드 용도로 100만원~150만원 예산의 컴퓨터 **견적** 맞춰줘. | `builds`, `v_build_warnings`, `cpus`, `graphic_cards` |
| 배틀그라운드 할건데 150만원 이하로 **견적** 맞춰줘 (few-shot 예시 질문 그대로) | `v_build_warnings`, `warning_rules`, `build_storages`, `cpus` |
| 배틀그라운드 용도로 150만원 이하 컴퓨터 맞춰줘 ("견적" 뺌) | `main_boards`, `cpus`, `graphic_cards`, `rams` |

- [schema_docs.json](../../nl2sql/data/schema_docs.json) 에서 `builds` 설명이 "유저가 저장한 PC **견적**…"이라서, "견적"이 들어간 질문은 **저장 견적용 테이블**(`builds`, `build_storages`, `v_build_warnings`, `warning_rules`)과 가장 가깝게 잡힌다.
- 4자리를 이 테이블들이 차지하므로 `main_boards`, `rams`, `power`와 호환 뷰 `v_cpu_board_compat`·`v_ram_board_compat`·`v_gpu_power_compat` 가 **모두 빠진다.**
- 프론트 간편 입력은 질문 문장을 항상 `…컴퓨터 견적 맞춰줘.` 로 만든다 ([RecommendationPage.jsx](../../frontend/src/pages/RecommendationPage.jsx) `buildPromptFromForm`). 그래서 **간편 입력으로 보낸 견적 요청은 매번 이 상태가 된다.**
- 검색은 결정적이다. 같은 질문을 두 번 검색해도 결과가 같았다. 따라서 ①은 "가끔"이 아니라 **항상** 일어난다.

### ② 프롬프트가 서로 반대되는 두 가지를 동시에 요구한다

[query_generator.py](../../nl2sql/src/nodes/query_generator.py) 가 LLM 에 넘기는 내용을 보면 다음과 같다.

| 프롬프트 요소 | 내용 | LLM 에게 주는 신호 |
|---|---|---|
| 스키마 (①의 결과) | 메인보드·램·파워 테이블, 호환 뷰 **없음** | 호환 뷰는 쓸 수 없다 |
| few-shot 예시 3개 | 1·2번째 예시(#0 배틀그라운드 150만원, #1 프리미어 프로 200만원)가 **호환 뷰 3개로 부품을 엮는 SQL** | 호환 뷰로 엮어라 |
| 규칙 2 | "스키마에 없는 테이블/컬럼명을 지어내지 마세요." | 스키마에 없는 뷰는 쓰지 마라 |
| 규칙 5 | "스키마 정보가 부족하더라도 예시 쿼리문을 참고하여 쿼리를 생성하세요." | 예시를 따라라 |
| 규칙 1~10 | 부품 호환성에 대한 규칙 **없음** | (호환이 필수라는 신호 없음) |

LLM 이 보기에 다음 두 답이 모두 규칙에 맞다.

- **해석 A (예시를 따름, 규칙 5):** 예시처럼 호환 뷰로 CPU → 보드 → 램 → 파워를 엮는다. → 정상 견적 (1회차)
- **해석 B (스키마를 따름, 규칙 2):** 스키마에 있는 `modules`·`categories` 만으로 부품을 하나씩 고른다. → 비호환 견적 (2·4회차)

2·4회차 SQL에서 메인보드와 파워를 `modules JOIN categories WHERE category_name = 'MAINBOARD'` 처럼 **스키마에 있는 테이블만으로** 고른 것이 해석 B를 따른 흔적이다. 그리고 "호환되는 부품이어야 한다"는 규칙이 어디에도 없으므로, LLM 에게는 해석 B 가 틀린 답이 아니다.

### 왜 "매번"이 아니라 "가끔"인가

모델 설정은 `temperature=0` 이고 ①의 검색 결과도 매번 같다. 그런데도 결과가 달라지는 이유는 다음과 같다.

- `temperature=0` 은 출력을 고정해 주지 않는다. 호스팅 추론 서버는 요청을 묶어서(batch) 처리하는데, 묶이는 방식에 따라 부동소수점 계산 순서가 달라져 같은 입력에도 다른 토큰이 나올 수 있다.
- 지금 모델(`openai/gpt-oss-120b`)은 답을 내기 전에 추론 토큰을 길게 생성하는 모델이라, 앞쪽의 작은 차이가 뒤로 갈수록 커진다.
- 무엇보다 ②에서 두 해석의 근거가 비슷하게 강하다. 한쪽이 분명히 맞는 상황이면 작은 차이로는 답이 바뀌지 않는다. 하지만 지금처럼 거의 동점이면 작은 차이만으로도 A와 B가 뒤집힌다.

정리하면 **①과 ②가 잘못된 SQL 이 나올 수 있는 조건을 만들고, 출력이 고정되지 않는 성질이 그것을 "가끔" 터지게 한다.** 출력이 고정되지 않는 성질은 없앨 수 없다. 따라서 고칠 대상은 ①·②와, 그다음 단계인 ③·④다.

### ③ 검증 단계는 문법만 본다

[validator.py](../../nl2sql/src/nodes/validator.py) → `validate_sql()` 은 금지어 검사와 `EXPLAIN` 만 한다. 비호환 견적 SQL 도 **문법적으로는 올바른 SELECT** 이므로 첫 시도에 통과한다. 재시도(`MAX_RETRY = 3`)가 걸릴 기회도 없다.

### ④ 실행 결과의 호환성을 확인하는 곳이 없다

- 백엔드([Nl2SqlService.java](../../backend/src/main/java/com/database_design/demo/domain/nl2sql/service/Nl2SqlService.java))는 받은 SQL 을 실행하고 결과를 그대로 돌려준다.
- DB에 있는 견적 제약(`ck_builds_b1_socket`, `ck_builds_b2_memory_spec` 등)은 **`builds` 테이블에 INSERT 할 때만** 검사된다. 조회 결과에는 적용되지 않는다.
- 그래서 비호환이 처음 드러나는 곳이 프론트 장바구니의 [compatibility.js](../../frontend/src/utils/compatibility.js) 다. 장바구니는 제 역할을 했다. 다만 너무 늦은 단계에서 발견되는 것이다.

---

## 5. 영향 범위

- 간편 입력으로 보낸 **모든 견적 요청**: 질문에 항상 "견적"이 들어가므로 ①이 항상 일어난다.
- 메모리 규격뿐 아니라 CPU-보드 **소켓**, GPU-파워 **용량·커넥터** 불일치도 같은 이유로 나올 수 있다. 재현한 2회차에서는 소켓과 메모리 규격이 동시에 틀렸다.
- 자연어 입력이라도 "견적"이 들어가면 같다. "견적"이 없는 질문은 메인보드·램은 잡히지만, 호환 뷰가 잡힌다는 보장은 없다.

## 6. 해결 방향 (작업 예정)

막는 위치가 다른 방법들이라 **하나만 하면 안 되고, 함께 적용해야 한다.**

| 위치 | 방법 | 효과 | 비고 |
|---|---|---|---|
| ① 스키마 검색 | 견적 요청이면 `main_boards`, `rams`, `power`, 호환 뷰 3개를 `modules`·`categories` 처럼 **항상 포함** | 규칙 충돌의 원인 제거 | 견적 요청 판별 기준 필요 (`programs`/예산이 있거나 질문 유형 분류) |
| ① 스키마 문서 | `builds` 계열 설명을 "**저장된** 견적" 위주로 고쳐 추천 질문과 덜 겹치게 함 | 엉뚱한 테이블이 자리를 차지하는 것 완화 | ✅ 2026-11-28 적용. 호환 뷰 설명 보강과 함께 적용 → [조치 기록](nl2sql-incompatible-build-fix-schema-docs.md) |
| ② 프롬프트 | 규칙 추가: "여러 부품으로 견적을 구성할 때는 반드시 `v_cpu_board_compat`·`v_ram_board_compat`·`v_gpu_power_compat` 로 앞에서 고른 부품과 엮을 것" | 해석 B 를 명시적으로 틀린 답으로 만듦 | 규칙 2·5 충돌도 함께 정리 |
| ③ 검증 | 견적 SQL 의 실행 결과를 호환 뷰로 확인하고, 실패하면 오류 내용과 함께 재생성 | 잘못된 SQL 이 나와도 사용자에게 가기 전에 걸러짐 | 가장 확실한 안전장치 |
| ④ 백엔드 | 응답 전에 결과 조합의 호환성을 확인하고, 실패하면 별도 오류 코드 반환 | 최후 방어선 | ③과 둘 중 하나 이상 |

## 7. 함께 발견한 것

- **문서와 코드 불일치:** [nl2sql-flow.md](../nl2sql-flow.md) 가 스키마 검색을 "5개 (유사도 3개)"로 적고 있었다. 코드는 커밋 `fix(retriever.py): 스키마 유사도 검색 결과 수 1개 증가 (5 → 6)` 이후 6개(유사도 4개)다. 이번에 문서를 고쳤다.
- **간헐적 `NL2SQL_UNAVAILABLE`:** 재현 3회차에서 nl2sql 이 JSON 이 아닌 응답(`application/octet-stream`)을 돌려줘 백엔드가 읽지 못했다. 원인은 조사하지 않았다.
- **장바구니가 질문 간에 누적됨:** 장바구니는 같은 카테고리 부품을 바꿔 넣지 않고 계속 추가한다. 이전 질문에서 담은 부품이 남아 있으면 이번 견적이 정상이어도 호환성 오류가 뜰 수 있다. 이번 건의 원인은 아니지만(재현은 장바구니 없이 API 응답만으로 했다) 함께 볼 부분이다.

## 8. 확인 방법

```bash
# 같은 요청 반복 (Git Bash 기준, 한글이 깨지지 않게 파일로 보냄)
curl -s -X POST http://localhost:8080/api/nl2sql/query \
  -H "Content-Type: application/json; charset=utf-8" \
  --data-binary @request.json

# 질문별 스키마 검색 결과 (nl2sql 컨테이너 안에서)
MSYS_NO_PATHCONV=1 docker exec -i -w /app dbd-nl2sql python -c \
  "import re; from tools.retriever import get_schema; \
   print(re.findall(r'\"table\": \"([^\"]+)\"', get_schema('배틀그라운드 할건데 150만원 이하로 견적 맞춰줘')))"
```

```sql
-- 응답에 나온 보드와 램이 호환인지 확인 (0이면 비호환)
SELECT EXISTS (
  SELECT 1 FROM v_ram_board_compat v
  JOIN modules r ON r.module_id = v.ram_id
  JOIN modules b ON b.module_id = v.board_id
  WHERE b.name = 'ASUS PRIME A520M-E'
    AND r.name LIKE 'TeamGroup T-Force Vulcan DDR5-6000%'
) AS compatible;
```
