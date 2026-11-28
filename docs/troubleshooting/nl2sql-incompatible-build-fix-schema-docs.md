# [조치 1] 스키마 설명 문구 수정: 견적 질문에 호환 뷰가 검색되도록

> 작성일: 2026-11-28
> 원인 분석: [nl2sql-incompatible-build.md](nl2sql-incompatible-build.md)
> 바꾼 파일: [nl2sql/data/schema_docs.json](../../nl2sql/data/schema_docs.json) (테이블 설명 문구만. 코드·DB 변경 없음)

## ⚠️ pull 받은 뒤 꼭 할 일

이 변경은 **코드를 받는 것만으로는 반영되지 않는다.** nl2sql 은 처음 켜질 때 설명 문구를 vectordb 에 저장해 두고 그 뒤로는 저장된 것만 쓰기 때문이다. 각자 PC 에서 아래를 한 번 실행한다.

```bash
# 프로젝트 루트에서
docker compose build nl2sql                       # 1. 새 설명 문구로 이미지 다시 만들기
docker compose stop nl2sql                        # 2. nl2sql 멈추기
MSYS_NO_PATHCONV=1 docker compose run --rm --no-deps --entrypoint sh nl2sql \
  -c 'rm -rf /app/vectordb/*'                     # 3. vectordb 비우기
docker compose up -d nl2sql                       # 4. 다시 켜면 vectordb 가 새로 만들어짐
```

- `MSYS_NO_PATHCONV=1` 은 Git Bash 에서만 필요하다. PowerShell·macOS 에서는 빼도 된다.
- 4번 뒤 `docker compose logs -f nl2sql` 에 `Uvicorn running` 이 보이면 끝이다. 처음 한 번은 임베딩을 새로 만드느라 조금 더 걸린다.

> **왜 `rm -rf nl2sql/vectordb` 로 지우지 않나?**
> Windows 에서 확인해 보니, 탐색기나 PowerShell 로 `nl2sql/vectordb` 를 열면 **비어 있는데 컨테이너 안에는 파일이 그대로 있었다.** 이 환경에서는 바인드 마운트한 파일이 Windows 폴더에 보이지 않는다. 그래서 호스트 폴더를 지워도 vectordb 가 초기화되지 않는다. 컨테이너 안에서 지우는 위 방법은 OS 와 관계없이 동작한다.

---

## 1. 한 줄 요약

"견적"이라는 단어가 **저장 기능용 테이블** 설명에만 들어 있어서, "견적 맞춰줘" 질문에 엉뚱한 테이블이 검색되고 있었다. 저장 기능 쪽에서는 "견적"을 빼고, 호환 뷰 쪽에는 "견적 추천에 쓴다"는 문장을 넣었다.

## 2. 왜 바꿨나

nl2sql 은 SQL 을 만들기 전에 테이블 설명 26개 중 **질문과 뜻이 가장 비슷한 4개**를 골라 LLM 에게 보여 준다. 데이터를 보는 것이 아니라 **설명 글끼리 비교**한다.

바꾸기 전에는 "견적"이라는 단어가 저장 기능 테이블에만 몰려 있었다.

| 테이블 | 무엇인가 | 설명에 "견적" |
|---|---|---|
| `builds`, `build_storages`, `v_build_warnings`, `warning_rules` | 사용자가 **저장해 둔** 구성 (아직 쓰는 코드 없음, 0행) | 많이 있음 |
| `v_cpu_board_compat`, `v_ram_board_compat`, `v_gpu_power_compat` | **새 견적을 짤 때** 서로 맞는 부품을 고르는 호환 뷰 | 없음 |

그래서 "견적 맞춰줘"라고 물으면 저장 기능 테이블이 4자리를 차지하고, 정작 필요한 호환 뷰는 LLM 에게 전달되지 않았다. 호환 뷰를 보지 못한 LLM 은 부품을 하나씩 따로 골랐고, 그 결과 DDR4 보드에 DDR5 램이 붙는 견적이 나왔다. 자세한 분석은 [원인 분석 문서](nl2sql-incompatible-build.md) 4절에 있다.

## 3. 무엇을 바꿨나

### A. 저장 기능 테이블: "견적" → "저장해 둔 구성"

| 테이블 | 바꾸기 전 | 바꾼 뒤 |
|---|---|---|
| `builds` | 유저가 저장한 PC 견적. 부품 칸마다… | 사용자가 마이페이지에 저장해 둔 PC 부품 구성 목록. '내가 저장한 구성' 조회에 사용. 칸마다 부품… |
| `builds` 컬럼 | 견적 번호 / 견적 제목 / 완성 견적 / 견적 저장 시각 | 저장 구성 번호 / 저장 구성 이름 / 완성 구성 / 저장 시각 |
| `build_storages` | 견적에 담긴 저장장치(SSD, HDD). 견적 하나에 여러 개 가능 | 저장해 둔 구성(builds)에 담긴 저장장치(SSD, HDD). 구성 하나에 여러 개 가능 |
| `build_storages` 컬럼 | 견적 번호, builds.build_id 참조… | 저장 구성 번호, builds.build_id 참조… |
| `v_build_warnings` | 뷰. 저장된 견적(builds)의 경고 목록… | 뷰. 저장해 둔 구성(builds)의 경고 목록… |
| `v_build_warnings` 컬럼 | 견적 번호, builds.build_id | 저장 구성 번호, builds.build_id |
| `warning_rules` | 견적 경고 규칙의 벌점과 안내 문구… | 부품 조합 경고 규칙의 벌점과 안내 문구… |

### B. 호환 뷰: "견적 추천에 쓴다"는 문장 추가

기존 문장은 그대로 두고, 가운데에 한 문장을 넣었다.

| 뷰 | 추가한 문장 |
|---|---|
| `v_cpu_board_compat` | PC 견적을 추천하거나 맞출 때 고른 CPU 에 맞는 메인보드를 이 뷰로 고른다. |
| `v_ram_board_compat` | PC 견적을 추천하거나 맞출 때 고른 메인보드에 맞는 램을 이 뷰로 고른다. |
| `v_gpu_power_compat` | PC 견적을 추천하거나 맞출 때 고른 그래픽카드에 맞는 파워를 이 뷰로 고른다. |

끝의 "…질문에 사용"은 "…질문에**도** 사용"으로 바꿨다.

### 문구를 고를 때 지킨 규칙

- **부정문을 쓰지 않는다.** `builds` 에 "견적 추천에는 쓰지 않음"이라고 쓰면 오히려 더 잘 검색된다. 임베딩은 "~하지 않음"을 잘 이해하지 못하고, 들어 있는 단어(견적, 추천)만 보고 비슷하다고 판단하기 때문이다.
- **A와 B를 함께 바꾼다.** 하나만 바꿨을 때는 효과가 작았다 (4절).
- 나중에 만들 "내가 저장한 견적 보기" 기능은 여전히 `builds` 를 찾을 수 있어야 한다.

## 4. 결과

### 검색 결과 (질문별로 LLM 에게 전달되는 4개)

| 질문 | 바꾸기 전 | 바꾼 뒤 |
|---|---|---|
| 배틀그라운드 용도로 100만원~150만원 예산의 컴퓨터 견적 맞춰줘. | builds, v_build_warnings, cpus, graphic_cards | **v_gpu_power_compat**, cpus, **v_cpu_board_compat**, **v_ram_board_compat** |
| 배틀그라운드 할건데 150만원 이하로 견적 맞춰줘 | v_build_warnings, warning_rules, build_storages, cpus | **v_gpu_power_compat**, cpus, warning_rules, rams |
| 프리미어 프로 용도로 200만원 이하 예산의 컴퓨터 견적 맞춰줘. | builds, v_gpu_power_compat, warning_rules, cpus | **v_gpu_power_compat**, **v_cpu_board_compat**, **v_ram_board_compat**, cpus |
| 사무용으로 80만원짜리 컴퓨터 견적 짜줘 | builds, power, build_storages, hdds | power, **v_cpu_board_compat**, **v_gpu_power_compat**, builds |
| 300만원 안팎의 예산으로 컴퓨터 견적 맞춰줘. | builds, v_build_warnings, build_storages, hdds | **v_cpu_board_compat**, **v_ram_board_compat**, **v_gpu_power_compat**, hdds |

견적 질문 5개를 합쳐 보면 다음과 같다.

| | 저장 기능 테이블이 차지한 자리 | 호환 뷰가 들어간 자리 |
|---|---|---|
| 바꾸기 전 | 12 | 1 |
| A만 적용 | 4 | 1 |
| B만 적용 | 9 | 9 |
| **A + B (적용)** | **2** | **12** |

다른 종류의 질문은 영향이 없거나 의도대로 바뀌었다.

| 질문 | 바꾼 뒤 |
|---|---|
| 내가 저장한 견적 목록 보여줘 | builds, memory_specs, v_build_warnings, sockets (저장 기능 테이블이 여전히 잡힘) |
| 라이젠5 7500F와 호환되는 메인보드 | 변화 없음 |
| VRAM 16GB 이상 그래픽카드 가격 | 4번째 자리만 cpu_memory_clocks → v_ram_board_compat (둘 다 이 질문에는 안 쓰임) |

### 실제 견적 결과

처음 문제가 된 요청(배틀그라운드, 100~150만원)을 백엔드에 보내고, 응답 부품 조합을 호환 뷰로 검사했다.

| | 호환 뷰를 쓴 SQL | 호환되는 견적 |
|---|---|---|
| 바꾸기 전 (2026-11-28) | 1 / 3 | 1 / 3 (나머지 1회는 nl2sql 응답 오류) |
| **바꾼 뒤** | **5 / 5** | **5 / 5** (CPU-보드, 램-보드, GPU-파워 모두 호환, 합계 1,273,000원) |

## 5. 이것만으로는 부족한 점

5번 모두 정상이었지만 이 문제가 해결된 것은 아니다.

- **아직 가끔 섞여 들어온다.** "배틀그라운드 할건데 150만원 이하로 견적 맞춰줘"에는 `warning_rules`가, "사무용으로 80만원짜리 컴퓨터 견적 짜줘"에는 `builds`가 아직 한 자리씩 남는다.
- **자리가 모자란다.** 견적에 필요한 테이블은 부품 5개(`cpus`, `main_boards`, `rams`, `graphic_cards`, `power`)와 호환 뷰 3개를 합쳐 8개인데, 자리는 4개다. 지금은 호환 뷰가 들어온 대신 `main_boards`, `rams`, `power`가 빠진다. LLM 이 few-shot 예시를 보고 메워 주고 있을 뿐이다.
- **LLM 출력은 고정되지 않는다.** 5번 연속 정상이어도 앞으로 계속 정상이라는 보장은 없다.

그래서 다음 조치가 남아 있다 ([원인 분석 문서](nl2sql-incompatible-build.md) 6절).

| 조치 | 내용 | 막는 단계 (원인 분석 4절) | 상태 |
|---|---|---|---|
| 1 | 스키마 설명 문구 수정 (이 문서) | ① 스키마 검색 | ✅ 완료 |
| 2 | 견적 요청이면 필수 테이블 8개를 검색과 관계없이 항상 포함 | ① 스키마 검색 | 예정 |
| 3 | 프롬프트에 "견적은 호환 뷰로 엮을 것" 규칙 추가, 규칙 2·5 충돌 정리 | ② SQL 생성 | 예정 |
| 4 | 결과 조합을 호환 뷰로 검사하고, 실패하면 재생성 | ③ 검증 | 예정 |

## 6. 확인 방법

**vectordb 가 새 설명으로 만들어졌는지 확인**

```bash
MSYS_NO_PATHCONV=1 docker exec -i -w /app dbd-nl2sql python -c \
  "from tools.retriever import schema_collection as c; \
   print(any('마이페이지에 저장해 둔' in d for d in c.get()['documents']))"
# True 가 나와야 한다. False 면 맨 위 '꼭 할 일'을 다시 한다.
```

**견적 질문의 검색 결과 확인**

```bash
MSYS_NO_PATHCONV=1 docker exec -i -w /app dbd-nl2sql python -c \
  "import re; from tools.retriever import get_schema; \
   print(re.findall(r'\"table\": \"([^\"]+)\"', get_schema('배틀그라운드 용도로 100만원~150만원 예산의 컴퓨터 견적 맞춰줘.'))[2:])"
# ['v_gpu_power_compat', 'cpus', 'v_cpu_board_compat', 'v_ram_board_compat']
```

**문구를 더 고쳐 보고 싶을 때**

실제 vectordb 를 건드리지 않고, 메모리 안에서 원본과 수정안의 검색 결과를 비교할 수 있다. 방법은 다음과 같다.

1. `chromadb.EphemeralClient()` 로 임시 컬렉션을 만든다.
2. 같은 임베딩 모델(`BAAI/bge-m3`)로 원본 설명과 수정한 설명을 각각 넣는다.
3. `get_schema()` 와 같은 조건(`modules`·`categories` 제외, 상위 4개)으로 검색해 결과를 비교한다.

이번 수정안도 이 방법으로 고른 뒤 적용했다.
