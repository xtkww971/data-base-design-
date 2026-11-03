배경:
추천 견적 페이지는 자연어 입력창 하나만 있었고, "AI 추천 분석" 버튼은 서버를 부르지 않고 1.8초 뒤 빈 결과(Null)를 보여주기만 했음.
사용할 프로그램·예산을 바로 입력할 수 있게 하고, 백엔드 자연어 질의 API(/api/nl2sql/query)에 연결함.
AI 결과를 부품별 카드로 보여주고 장바구니에 바로 담을 수 있게 함.

백엔드·AI 쪽은 이미 연결되어 있었음 (백엔드 → nl2sql → DB). 프론트에서 부르는 곳만 없었음.

todo :

1. 간편 입력 탭 추가 - OK

수정: pages/RecommendationPage.jsx, pages/RecommendationPage.css

입력창 위에 탭 추가: 간편 입력 | 자연어 입력. 기본은 간편 입력.
자연어 입력 탭은 기존 입력창 그대로.

간편 입력 구성:
- 사용할 프로그램: 칩 형태. Enter·쉼표로 추가, 빈 칸에서 Backspace 로 마지막 칩 삭제, 최대 5개.
  한글 조합 중 Enter 는 무시 (isComposing).
  추천 칩 9개(리그 오브 레전드, 배틀그라운드, 프리미어 프로 등)를 눌러 바로 추가.
- 예산: 최소 ~ 최대, 만원 단위. 한쪽만 입력해도 됨. 숫자만 입력, 5자리까지.
  구간 칩: ~100만원 / 100~150만원 / 150~200만원 / 200~300만원 / 300만원 이상
- 검증: 프로그램·예산 둘 다 비었거나 최소 > 최대면 빨간 문구.

백엔드가 자연어만 받기 때문에 폼 값을 문장으로 바꿔서 보냄.
예: "리그 오브 레전드, 배틀그라운드 용도로 100만원~150만원 예산의 컴퓨터 견적 맞춰줘."
원래 값은 질문 내역에 conditions 로 같이 저장 (NL2SQL 키워드 형식과 같음, 가격은 원 단위).
{ programs: ['리그 오브 레전드'], price: { min: 1000000, max: 1500000 } }
견적 API 가 생기면 이 값을 그대로 보내면 됨.

1-1. 프로그램 칸과 예산 칸 사이 간격

.recommendation-page__field + .recommendation-page__field
+ margin-top: 14px;
+ padding-top: 28px;
+ border-top: 1px solid rgba(148, 163, 184, 0.12);  구분선

2. AI API 연결 - OK

추가: api/nl2sqlApi.js
queryNl2Sql(question) -> POST /api/nl2sql/query { question }
응답: { question, sql, columns, rows, rowCount }
실패하면 백엔드 ErrorResponse 의 message 를 그대로 던짐.
예: "오늘 서울 날씨 어때?" -> 422 "질문을 이해하지 못했습니다. 다르게 표현해 주세요."

결과 패널 제목: "사용자가 구성한 컴퓨터 구성사항" -> "AI 분석 결과"
로딩 문구: "견적을 생성중입니다" -> "AI가 분석 중입니다"
AI 가 만든 SQL 은 "AI가 만든 SQL 보기" 를 눌러 펼쳐 볼 수 있음.

기존 configuration(부품별 칸, 전부 Null) 표시는 코드만 남겨둠. 견적 조합 응답이 생기면 다시 씀.

3. 질문 내역이 사라지는 버그 수정 - OK

원인: 질문 내역이 페이지 컴포넌트의 state 라서, 견적 검색으로 갔다 오면 페이지와 함께 초기화됨.
분석 중에 나가면 돌아오는 응답을 받을 곳이 없어 결과도 잃음.

추가: recommendation/historyStore.js
질문 내역을 컴포넌트 밖(localStorage, 키 recommendationHistory)에 둠. authStore.js 와 같은 방식.
- 다른 페이지에 갔다 와도, 새로고침해도 내역과 선택한 질문이 남음. 최근 20개까지.
- 분석 중에 다른 페이지로 가도 응답은 저장소에 들어옴.
- 분석 중에 새로고침하면 응답을 받을 수 없어서 "다시 시도해 주세요" 문구로 바꿔 둠.
- 항목: { id, date, prompt, conditions, status: loading | done | error, result, error }

내역 선택·삭제를 index 대신 id 로 처리하도록 변경.

4. 결과를 부품별 카드로 출력 - OK

결과 행을 부품별로 묶고 CPU -> 메인보드 -> 램 -> 그래픽카드 -> 파워 -> SSD -> HDD -> 모니터 순서로 보여줌.
묶음마다 제목과 개수 ("메인보드 27개"), 처음 6개만 카드로 보이고 "N개 더 보기" / "접기".
AI 가 정렬한 순서를 그대로 쓰므로 앞의 6개가 추천 상위.

카드: 이미지, 제품명(2줄까지), 가격, 핵심 스펙 칩, 담기 버튼.

부품별 핵심 스펙 (CATEGORY_SPECS 한 곳에서 정함):
- CPU: 코어, 스레드, 소켓
- 메인보드: 소켓, 메모리 규격, 칩셋
- 램: 메모리 규격, 용량, 클럭
- 그래픽카드: VRAM, 권장 파워
- 파워: 정격 출력, 인증
- SSD: 용량, 읽기 속도
- HDD: 용량, 회전수
- 모니터: 크기, 해상도, 주사율

값에 단위를 붙임: 16GB, 750W, 5600MT/s, 165Hz. 용량은 HDD 만 TB, 램·SSD 는 GB.
AI 가 조인하면서 붙이는 별칭(cpu_socket, mb_socket, mb_chipset)도 같은 스펙으로 인식.
조합 결과에서 같은 부품이 여러 행에 나오면 카드는 한 장만.
부품을 알 수 없는 결과(개수 집계 등)는 표로 보여줌.
다른 질문을 고르면 "더 보기" 펼침 상태가 처음으로 돌아감.

카테고리는 결과의 category_name, 없으면 category_id 로 판단 (V3 에서 넣은 순서 1~8).

추가: assets/dummyImages.js
카테고리별 더미 이미지 목록. 추천 페이지 카드와 장바구니가 같이 씀.
(SearchPage 에도 같은 목록이 따로 있음. 이번에는 건드리지 않음.)

5. 장바구니에 바로 담기 - OK

추가: cart/cartStore.js
장바구니를 localStorage(키 cartItems)에 보관. 어느 페이지에서 담아도 같은 장바구니.
addToCart(item) 은 이미 담긴 부품이면 수량만 늘림. 최대 99개.
항목: { id(module_id), category, name, brand, summary, price, quantity, imageUrl }

카드의 "담기" -> "담김 ✓". 결과 위에 "장바구니 보기 (n) ->" 링크.
summary 는 카드와 같은 핵심 스펙으로 만듦. 예: "DDR5 / 32GB / 6000MT/s"

수정: pages/CartPage.jsx
- 더미 부품 4개(DUMMY_CART_ITEMS) 삭제, cartStore 의 실제 항목을 보여줌. 처음엔 비어 있음.
- 수량 변경, 삭제, 전체 비우기도 cartStore 로.
- 이미지는 imageUrl, 없으면 카테고리별 더미 이미지.

6. 카드에서 상세 스펙 펼치기 - OK

카드 아래 "▶ 상세 스펙" 을 누르면 펼쳐짐 (▶ 가 ▼ 로 회전). 펼친 카드만 길어짐.
.recommendation-page__card-grid
+ align-items: start;  같은 줄의 다른 카드는 높이 그대로

처음 펼칠 때 부품 상세 API 로 전체 스펙을 받아옴. AI 결과에 스펙이 없어도 볼 수 있음.
한 번 받은 값은 카드가 기억해서 다시 펴도 다시 부르지 않음.
내용: 제조사, 카테고리별 스펙 전체, 성능 점수 (없으면 -)

추가: api/productApi.js 에 fetchProductDetail(category, moduleId)
-> GET /api/modules/{cpus | main-boards | rams | graphic-cards | powers | ssds | hdds | monitors}/{id}/detail

추가: utils/productSpecs.js
SearchPage 에 있던 getSpecEntries 를 그대로 옮김. 검색 페이지 상세 패널과 추천 카드가 같이 씀.
수정: 램 클럭 표기 MHz -> MT/s (값은 전송 속도. docs/스키마 설계/04-부품별-제약조건.md 1장)
검색 페이지 상세 패널 표기도 같이 바뀜.

참고: V7 에서 추가한 컬럼(보드 최대 메모리, 커넥터 수 등)은 상세 API 응답에 아직 없어서 안 나옴. 백엔드 DTO 수정 필요.
참고: SearchPage.jsx 의 formatSpecValue 는 원래부터 안 쓰여서 lint 오류가 남. 이번에 건드리지 않음.

7. 질문 내역 버튼이 헤더에 가려지는 문제 - OK

헤더 높이는 100px 인데 버튼이 top: 92px 이라 위쪽 8px 가 가려졌음.
.recommendation-page__sidebar-toggle
top: 92px -> 112px  헤더 아래로 12px

확인:
- lint, vite build 통과
- 헤드리스 브라우저로 확인: 간편 입력 화면, 실제 AI 결과를 넣은 카드 화면(메인보드 27개, 6장 + 21개 더 보기),
  담기 -> 담김 ✓ / 장바구니 보기 (1), 새로고침 후 질문 내역 유지, 빈 장바구니 화면,
  상세 스펙 펼침(메인보드: 제조사·소켓·폼팩터·메모리 규격·슬롯·칩셋), 질문 내역 버튼 위치

남은 문제 (백엔드·AI 쪽):
- 견적 질문("100만원 이하 견적 맞춰줘")에 견적 한 세트가 아니라 부품 목록이 나옴.
  AI 가 SELECT 하나로 답하는 구조라서. 같은 질문을 3번 보내면 램·SSD·CPU 섞인 목록 1번, CPU 100개 2번.
  예산 합계, 호환성(소켓·메모리 규격·파워) 검사가 없음. 백엔드 결과는 100행에서 잘림.
- AI 가 공통 테이블(modules)만 조회하면 스펙 값이 없어서 카드에 제품명·가격만 나옴.
- 이름 검색(LIKE '%7500F%')에 벌크·멀티팩 판매분이 같이 걸려 같은 보드가 두 번씩 나옴.
- 장바구니에 담긴 부품의 호환성 검사가 없음. AM5 CPU + LGA1700 보드를 담아도 경고 없음.
  호환성 규칙은 DB 에 있음 (V7, docs/스키마 설계/04-부품별-제약조건.md 4-3 판별 쿼리, 5-3 경고 뷰).
- 장바구니는 브라우저(localStorage)에만 저장. "견적 저장하기" 는 백엔드 견적 API(builds) 필요.

필요한 API (백엔드와 형식 합의 필요):
- 견적 조합: { programs, price { min, max } } -> { configuration: { cpu, motherboard, ram, gpu, power, ssd, ... }, totalPrice, warnings }
  configuration 의 키는 추천 페이지 결과 패널이 이미 쓰는 키와 같게.
- 호환성 검사: { cpuId, boardId, ramId, ramQuantity, gpuId, powerId } -> { violations: [B1~B9], warnings: [W1~W5] }

미확인: 검색 페이지의 "견적에 추가" 버튼은 아직 cartStore 와 연결하지 않음.
