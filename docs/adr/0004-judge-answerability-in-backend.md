# 0004: 답할 수 없는 질문 판정을 백엔드(Spring)에서 수행

* **날짜:** 2026-11-28
* **작성자:** 이도현
* **상태:** 제안됨 (기획, 아직 구현 안 함)

## 1. Context (배경)

ADR-0003에서 **처리할 수 없는 질문을 SQL 생성 전에 걸러내기로** 하고, 판정 모델로
TypeSafe의 Jev를 쓰기로 했다. 다만 그 문서는 판정자를 **nl2sql 그래프의 노드**
(`schema_retriever` 다음, `example_retriever` 이전)로 두는 전제로 쓰였다.
남은 것은 **그 판정을 어느 서비스가 호출하는가**다.

지금 흐름은 이렇다.

```
프론트 → POST /api/nl2sql/query → Nl2SqlService
                                    ├─ Nl2SqlClient → nl2sql POST /query  (LangGraph, 재시도 최대 3회)
                                    └─ JdbcTemplate 로 생성된 SQL 실행 → NlQueryResponse
```

여기서 두 가지가 눈에 걸린다.

* **SQL을 실제로 실행하는 곳은 백엔드다.** nl2sql은 문자열을 만들어 돌려줄 뿐이고,
  그 문자열을 DB에 던지는 쪽은 `Nl2SqlService.query()`다. 즉 "이 질문에 답하지 않는다"를
  **집행하는 주체는 백엔드**인데, 판정을 nl2sql 안에 두면 판정과 집행이 서로 다른 서비스로 갈린다.
* **거절할 질문에도 nl2sql 호출이 1회 들어간다.** 판정이 그래프 안에 있으면 답할 수 없는
  질문도 일단 nl2sql까지 가서 벡터 검색(`schema_retriever`)을 하고 나서야 걸린다.
  거절 자체는 LLM 생성 호출을 아끼지만, HTTP 1회 + 임베딩 검색 1회는 그대로 쓴다.

또한 백엔드에는 판정 결과를 담을 자리가 이미 있다.

* `NlQueryStatus`에 `UNANSWERABLE`이 **이미 정의돼 있고** 아직 아무도 쓰지 않는다.
  `nl_queries.status`의 CHECK 제약에도 들어가 있다.
* `ErrorCode`에는 `NL2SQL_UNAVAILABLE` / `NL2SQL_GENERATION_FAILED` / `NL2SQL_EXECUTION_FAILED`가
  있고, 프론트는 이 포맷(`GlobalExceptionHandler`)만 읽는다. 판정 결과를 사용자에게 보이려면
  어차피 이 체계로 번역해야 한다.

반대로 백엔드에는 **스키마 정보가 없다.** ADR-0003의 설계는 검색된 `schema_info`를 Jev의
`state`에 넣는 것이었는데, 백엔드는 벡터 DB를 모른다. 이 점이 이 결정의 유일한 실질적 손해이고,
아래에서 따로 다룬다.

## 2. Decision (결정)

**Jev 판정은 백엔드에서 호출한다. nl2sql 그래프는 건드리지 않는다.
판정은 `Nl2SqlService.query()`의 첫 단계이고, 거절은 백엔드가 집행한다.**

ADR-0003에서 정한 것(판정 모델 = Jev, 질문 유형 = `choice` 5종, 확신도 기반 분기, fail-open)은
그대로 유지한다. 이 문서는 **위치와 계약만** 정한다.

### 호출 위치

```
Nl2SqlService.query()
 1. AnswerabilityJudge.judge(question, programs, budget)   ← 신규
 2. answerable 이 아니면 여기서 종료 (nl2sql 호출 없음)
 3. Nl2SqlClient.generate(...)
 4. SQL 실행
```

판정이 가장 앞에 오기 때문에 거절되는 질문은 **nl2sql HTTP 호출도, 벡터 검색도, LLM 생성도
한 번도 일어나지 않는다.**

### 구성 요소

| 클래스 | 위치 | 역할 |
| --- | --- | --- |
| `AnswerabilityJudgeClient` | `domain/nl2sql/client` | Jev REST 호출. `Nl2SqlClient`와 같은 `RestClient` 패턴 |
| `Verdict` (enum) | `domain/nl2sql/dto` | `ANSWERABLE`, `OUT_OF_SCOPE`, `MISSING_DATA`, `AMBIGUOUS`, `RECOMMENDATION` |
| `JudgeResult` (record) | `domain/nl2sql/dto` | `verdict`, `confidence`, `skipped` |
| `TypeSafeProperties` | `global/config` | `typesafe.api-key`, `base-url`, `model`, `timeout`, `confidence-threshold` |

**Java SDK는 없다.** TypeSafe는 Python(`typesafe-sdk`)과 TypeScript(`@typesafe-ai/sdk`)만 내놓았다.
그래서 `RestClient`로 raw HTTP를 쓴다. 이미 `Nl2SqlClient`가 같은 방식이라 새로 들일 것은 없다.

### 호출 계약

```
POST https://api.typesafe.ai/v1/systemone
Authorization: Bearer ${TYPESAFE_API_KEY}
Content-Type: application/json

{
  "model": "jev-1.14.0",
  "state": {
    "question": "<사용자 질문>",
    "programs": ["배그"],
    "budget": "1000000~2000000",
    "schema": "<백엔드 리소스의 스키마 요약>"
  },
  "questions": {
    "verdict": {
      "type": "choice",
      "instructions": "PC 부품 쇼핑몰 DB에 대한 SQL 조회 한 번으로 `question`에 답할 수 있는지 판단한다. 판단 근거는 `schema`에 적힌 테이블과 컬럼으로 한정한다.",
      "criteria": {
        "answerable": "schema 의 테이블·컬럼으로 조회해 답할 수 있음",
        "out_of_scope": "PC 부품·쇼핑몰과 무관한 질문",
        "missing_data": "주제는 맞지만 판매량·리뷰 등 schema 에 없는 데이터가 필요함",
        "ambiguous": "조건이 모호해 하나의 SQL 로 확정할 수 없음",
        "recommendation": "예산에 맞춘 견적 조합 등 여러 부품을 골라 조합해야 하는 요청"
      }
    }
  }
}
```

응답은 `{ "model", "answers": { "verdict": { "type": "choice", "choice", "confidence", "probabilities" } }, "usage": { "input_tokens", "output_tokens" } }` 형태다.
`choice`는 `criteria`의 키가 그대로 돌아오고, `confidence`는 0~1이다.

* **모델 ID는 핀으로 박는다.** `jev-latest`는 릴리스에 따라 판정이 조용히 바뀐다.
  `confidence` 임계값을 실측으로 정하는데 모델이 밑에서 흔들리면 그 숫자가 의미를 잃는다.
  올릴 때는 `GET /v1/models`로 확인하고 평가 세트를 다시 돌린다.
* **질문 ID(`verdict`)는 모델에 전달되지 않는다.** 판단 기준은 전부 `instructions`와 `criteria`에 적는다.

### 분기 규칙

ADR-0003의 표를 그대로 집행한다.

| 판정 | 처리 |
| --- | --- |
| `answerable` | `Nl2SqlClient.generate()` 로 진행 |
| 그 외 + `confidence ≥ 0.7` | `BusinessException(NL2SQL_UNANSWERABLE)`. nl2sql 호출 안 함 |
| 그 외 + `confidence < 0.7` | 거절하지 않고 진행 |
| 호출 실패·타임아웃(1초)·키 없음 | 판정 없이 진행 (fail-open) |

거절할 때만 높은 확신을 요구한다. **오거절이 이 기능의 가장 큰 위험**이기 때문이다.
0.7은 시작값이고 ADR-0003의 PoC 결과로 조정한다. 임계값은 설정값으로 둬서 재배포 없이 바꾼다.

### 응답 계약

판정 결과는 **별도 필드가 아니라 기존 에러 체계로** 내보낸다. 프론트가 이미 `GlobalExceptionHandler`
포맷만 읽고 있어서, 성공 응답에 `verdict`를 끼우면 프론트가 두 갈래를 읽어야 한다.

* `ErrorCode.NL2SQL_UNANSWERABLE` 추가. 상태 코드는 `422 UNPROCESSABLE_CONTENT`
  (`NL2SQL_GENERATION_FAILED`와 같은 급. 서버 잘못이 아니고 질문이 범위 밖이다).
* **사용자 문구는 판정별로 고정한다.** Jev는 이유 문장을 생성하지 않는다.

  | 판정 | 문구 |
  | --- | --- |
  | `out_of_scope` | "PC 부품 정보에 대해서만 답할 수 있어요." |
  | `missing_data` | "판매·리뷰 정보는 아직 제공하지 않아요." |
  | `ambiguous` | "조건을 조금 더 구체적으로 알려주세요." |
  | `recommendation` | "견적 조합 추천은 아직 준비 중이에요. 부품별로 찾아보시겠어요?" |

* `NlQueryResponse`는 **바꾸지 않는다.** 거절은 성공 응답이 아니라 예외 경로다.
* 판정으로 걸린 질문은 `NlQueryStatus.UNANSWERABLE`로 기록한다. 이미 있던 값에 처음으로 쓰임이 생긴다.

### 스키마 요약을 백엔드에 둔다

백엔드는 벡터 DB를 모르므로 검색된 스키마를 `state`에 넣을 수 없다. 대신
**고정된 스키마 요약 한 덩이**를 백엔드 리소스(`src/main/resources/nl2sql/schema-summary.txt`)에 두고
매 요청에 같은 값을 보낸다. 테이블·뷰가 26개뿐이고, 판정에 필요한 것은
"무엇을 조회할 수 있는가"의 윤곽이지 컬럼 타입이 아니다.

* **`users`는 요약에서 뺀다.** `schema_docs.json`에는 들어 있지만, 판정자에게 회원 테이블을
  알려줄 이유가 없다. 이건 ADR-0003의 "보안 경계가 아님" 항목과 별개로 지금 당장 할 수 있는 조치다.
* `schema_docs.json`이 바뀌면 이 파일도 같이 고쳐야 한다. **중복이다.** 아래 단점에 적는다.

### 설정

* 루트 `.env`에 `TYPESAFE_API_KEY` 추가. `.env`는 이미 git 추적 대상이 아니다.
* docker compose `backend` 서비스에 `TYPESAFE_API_KEY: ${TYPESAFE_API_KEY:-}` 전달.
  `nl2sql` 서비스에는 넣지 않는다.
* **키가 비어 있으면 판정을 건너뛴다.** 팀원 로컬이 키 없이도 지금과 똑같이 돌아가야 한다.
* 키는 코드·문서·이슈·커밋에 넣지 않는다.

### 만들지 않는 것

* **판정 결과 캐시를 만들지 않는다.** 호출이 100ms대이고 질문이 매번 다르다.
* **판정을 재시도하지 않는다.** fail-open이므로 실패하면 그냥 진행하는 것이 재시도보다 싸다.
* **`score`/`noul` 질문을 섞지 않는다.** 지금 필요한 판단은 5지 분류 하나다.
* **nl2sql 그래프에 노드를 추가하지 않는다.** ADR-0003의 `answerability_judge` 노드 설계는 접는다.

## 3. Consequences (결과 및 영향)

### 🟢 장점

* **판정하는 곳과 집행하는 곳이 같다.** SQL을 실행하는 주체가 실행 여부를 결정한다.
  nl2sql이 무엇을 돌려주든 백엔드가 막을 수 있고, 판정을 우회하는 경로가 생기지 않는다.
* **거절되는 질문은 nl2sql을 아예 거치지 않는다.** HTTP 1회, 임베딩 검색 1회, LLM 생성 최대 3회가
  모두 사라진다. ADR-0003의 노드 배치보다 더 앞에서 끊긴다.
* **nl2sql 서비스가 그대로다.** 그래프, `GraphState`, `QueryResponse`를 건드리지 않으므로
  nl2sql 품질 평가(`nl2sql-quality-eval-v3.md`)의 기준선이 유지된다. 판정 도입 전후를 같은 세트로 비교할 수 있다.
* **에러 계약이 하나로 유지된다.** 프론트는 `NL2SQL_UNANSWERABLE` 코드 하나만 더 다루면 되고,
  성공 응답 스키마는 바뀌지 않는다.
* **외부 의존이 한 서비스에만 생긴다.** Python 쪽에 키를 내리지 않아서 nl2sql 컨테이너는 외부
  판정 API를 모른다.
* **쓰이지 않던 `UNANSWERABLE` 상태에 쓰임이 생긴다.** 스키마에만 있던 값이 실제 기록으로 채워진다.

### 🔴 단점 / 개선안

* **스키마 설명이 두 곳에 중복된다.** `nl2sql/data/schema_docs.json`과 백엔드
  `schema-summary.txt`가 따로 산다. 한쪽만 고치면 판정 기준이 실제 DB와 어긋나고,
  **그 어긋남이 조용하다**(판정은 계속 나오고, 틀린 쪽으로 나온다).
  * 지금은 사람이 맞춘다. 요약이 짧고 테이블 수가 적어서 감당된다.
  * 어긋남이 실제로 나기 시작하면 nl2sql에 `GET /schema-summary`를 열고 백엔드가 기동 시
    한 번 받아 캐시하는 쪽으로 옮긴다. **이 결정을 되돌릴 필요는 없다** — 요약을 어디서
    가져오는지만 바뀐다.
* **판정이 검색된 스키마를 못 본다.** ADR-0003은 질문별로 검색된 `schema_info`를 넣는 설계였다.
  고정 요약은 질문과 무관하게 같아서 `ambiguous` 판정의 품질이 떨어질 수 있다.
  **오거절이 가장 큰 위험이고 `ambiguous`는 거절 쪽 판정이므로**, PoC에서 이 판정의 오거절률을
  따로 본다. 나쁘면 `ambiguous`만 임계값을 올리거나(예: 0.85) 거절 대상에서 뺀다.
* **지연이 모든 질문에 붙는다.** 답할 수 있는 질문도 판정 호출을 1회 더 한다.
  공개 수치는 70~500ms, 대부분 100ms대다. nl2sql 생성이 수 초인 것에 비하면 묻히지만
  **공짜는 아니다.** 타임아웃 1초를 넘기면 fail-open으로 흘린다.
* **한국어 판정 정확도가 확인되지 않았다.** TypeSafe 문서는 지원 언어를 명시하지 않는다.
  1.14가 다국어를 강화했다고만 적혀 있고 언어 목록은 없다. ADR-0003의 PoC(거절 대상 질문 20~30개 +
  `few_shot_examples.json`)를 **이 ADR이 Accepted 되기 전에** 반드시 돌린다.
  기대 이하면 ADR-0003의 차선책(Groq LLM Judge)으로 가는데, **이 ADR의 위치 결정은 그대로 쓴다.**
  판정자만 바뀌고 호출 위치는 백엔드다.
* **사용자 질문이 외부로 나간다.** 질문·프로그램·예산과 스키마 요약이 TypeSafe로 전송된다.
  개인정보는 포함하지 않지만(`users`를 요약에서 뺀 이유의 일부), 팀 차원에서 외부 전송을 허용하는지 확인한다.
* **오거절은 사용자에게 보이지 않는다.** 거절된 질문은 `UNANSWERABLE`로 기록되지만,
  그게 옳은 거절인지 오거절인지 기록만으로는 모른다. 판정·확신도를 로그에 남겨
  주기적으로 눈으로 본다. 자동 검출은 안 한다.
* **보안 경계가 아니다.** ADR-0003에 적힌 그대로다. 판정은 사용성 장치이고,
  회원 정보 노출은 **nl2sql 전용 DB 계정 권한**으로 막아야 한다.
  요약에서 `users`를 뺀 것은 완화일 뿐 차단이 아니다. 이건 별 이슈로 다룬다.

## 4. 참고자료

### 내부 문서

* [ADR-0003](./0003-decision-jev-for-unanswerable-questions.md) —
  **무엇으로** 판정할지(Jev, `choice` 5종, 확신도 기반 분기, fail-open). 이 문서는 그 판정을
  **어디서** 호출할지를 정한다. 대체가 아니다. 다만 거기 적힌 `answerability_judge` **노드 배치는 접는다.**
* [ADR-0001](./0001-decision-langgraph-for-nl2sql.md) —
  LangGraph 선정. 판정을 그래프 밖으로 뺐으므로 LangSmith 트레이스에 판정이 남지 않는다.
  판정 로그는 백엔드가 남긴다.
* [nl2sql-flow.md](../nl2sql-flow.md) — 현재 호출 흐름. 판정 단계가 이 앞에 붙는다.
* [nl2sql-edge-cases.md](../nl2sql-edge-cases.md) — 거절 대상 질문의 출처. PoC 평가 세트의 재료다.
* [nl2sql-quality-eval-v3.md](../nl2sql-quality-eval-v3.md) — 50건 실측 기준선.
  nl2sql을 건드리지 않기로 한 덕에 이 수치와 직접 비교된다.

### 코드

* `Nl2SqlService.query()` — 판정이 들어갈 자리. 지금은 `nl2SqlClient.generate()`가 첫 줄이다.
* `Nl2SqlClient` — `RestClient` 호출 패턴과 예외 번역(`HttpServerErrorException` / `RestClientException`)의 본.
  판정 클라이언트도 같은 모양으로 만든다.
* `ErrorCode` — `NL2SQL_UNANSWERABLE`을 추가할 곳. nl2sql 구역이 이미 나뉘어 있다.
* `NlQueryStatus.UNANSWERABLE` — 정의돼 있으나 아직 쓰이지 않는 값.
* `nl2sql/src/graph.py` — **바꾸지 않는다.** 이 결정의 핵심이 그것이다.
* `nl2sql/data/schema_docs.json` — 스키마 요약의 원본. 26개 항목(테이블 + 뷰).

### 외부 자료

* TypeSafe `POST /v1/systemone` — 엔드포인트와 `model` / `state` / `questions` 요청 구조,
  `answers` / `confidence` / `probabilities` / `usage` 응답 구조.
* Jev `choice` 제약 — `criteria` 1~255개. 지금 5개라 여유가 크다.
* 컨텍스트 예산 — 기본 `state` + 질문 합계 약 64k 토큰. 스키마 요약을 한 덩이로 보내도 남는다.
* 공개 오류 코드 — 401(키), 422(검증), 429(레이트 리밋), 529(과부하).
  **모두 fail-open 대상이다.** 429/529를 재시도하지 않는 근거는 위 "만들지 않는 것"에 있다.
* Java SDK 없음 — Python / TypeScript / Vercel AI SDK만 제공. raw HTTP를 쓰는 근거.
