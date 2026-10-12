배경:
데이터베이스를 이용하여 사용자가 원하는 품목을 검색하고 장바구니에 넣을 수 있는 페이지가 필요함. 

장바구니 기능은 차후 추가 예정이므로 나중에 장바구니 페이지가 만들어지면 라우팅 예정

todo : 

1. Search Page 전체적인 레이아웃 구성. - OK

2. 단일 품목 검색시 이미지가 컨테이너에 맞춰 늘어나는 버그 수정 - OK

2-1. 사진이 늘어나진 않으나 가격 텍스트가 따로 노는 버그
-
수정: Search-page_layout 에 align-items 속성 부여

수정: search-page__results 
  align-content: start;  추가: 카드 행이 늘어나지 않게 

수정: 
.search-page__card + 
align-self: start; /* 추가: 카드가 내용 높이만큼만 차지 

3. 검색 창이 오른쪽에 있어 한눈에 파악 불가. -> 카테고리 선택 밑으로 내려야 할듯. 

3-1 . 검색 창에 margin 필요 너무 딱붙어있음

수정: 

.search-page__search + 
+ margin-bottom: 24px;  



3-2 . 카테고리도 맘에 안듬

4. 카테고리를 바꿀 때마다 푸터가 올라왔다가 내려가면서 깜빡이는 버그 수정 - OK

원인: 카테고리를 바꾸면 새 결과가 오기 전까지 목록을 비우고 "불러오는 중" 박스 하나만 보여줬음. 우측 상세 패널도 같이 사라져서 페이지 높이가 순간적으로 줄어들고, 그만큼 푸터가 올라왔다가 응답이 오면 다시 내려감.

수정: SearchPage.jsx

새 결과가 도착할 때까지 이전 결과를 그대로 보여주도록 변경. products / hasNext / totalElements / errorMessage 를 currentResult 가 아니라 searchResult 에서 읽음.

+ const isRefreshing = searchResult !== null && currentResult === null;

search-page__layout 에 기다리는 동안 is-refreshing 클래스와 aria-busy 부여.

수정:
.search-page__layout +
transition: opacity 0.2s ease;

추가:
.search-page__layout.is-refreshing
  opacity: 0.55;
  pointer-events: none;
  transition-delay: 0.15s;  응답이 빠르면 흐려지지 않게 지연

수정:
.search-page__content +
flex: 1 0 auto;  결과가 적거나 없어도 푸터가 화면 아래에 붙어 있게

참고: 검색어 입력으로 결과가 바뀔 때도 같은 방식으로 동작함. 맨 처음 진입할 때는 이전 결과가 없으므로 기존처럼 "불러오는 중" 박스가 나옴.

미확인: 브라우저에서 직접 눌러서 확인하지는 않음.

5. 목록을 스크롤해도 상세 패널(search-page__detail) 전체가 항상 보이게 수정 - OK

원인: 상세 패널은 position: sticky 라 목록을 스크롤하면 따라오지만, 패널이 화면보다 길면 아래쪽(스펙, 버튼)이 잘려서 목록 끝까지 내려가야 보였음.

수정:
.search-page__detail
- height: fit-content;
+ max-height: calc(100vh - 136px);  헤더 112px + 아래 여백 24px 을 뺀 높이
+ overflow-y: auto;
+ box-sizing: border-box;
+ display: flex;
+ flex-direction: column;

수정:
.search-page__detail-image-wrap
- height: 260px;
+ flex: 0 1 260px;  화면이 낮으면 이미지부터 줄어듦
+ min-height: 120px;

수정: @media (max-width: 980px)
.search-page__detail +
max-height: none;
overflow-y: visible;  패널이 목록 아래로 내려가는 레이아웃이라 높이 제한을 풂

참고: 이미지를 120px 까지 줄여도 안 들어가는 아주 낮은 화면에서만 패널 안쪽에 스크롤이 생김.

참고: 페이지 전체가 스크롤되고 패널만 고정되는 방식이라 제목, 카테고리, 검색창은 스크롤하면 위로 올라감. 이것들도 고정하려면 목록 칸에 자체 스크롤을 넣어야 함.

미확인: 브라우저에서 직접 확인하지는 않음.

6. 검색 페이지 확인용 더미 부품 데이터 추가 - OK

추가: backend/src/main/resources/db/seed/dummy_modules.sql

카테고리별 6개씩 총 48개. modules 에 공통 속성을 넣고 LAST_INSERT_ID() 로 각 상세 테이블(cpus, main_boards, rams, graphic_cards, power, ssds, hdds, monitors)에 스펙을 넣음.

주의: Flyway 는 db/migration 만 읽으므로 자동 적용되지 않음. 직접 실행해야 함.

docker compose exec -T mysql mysql -uapp -papp --default-character-set=utf8mb4 data_base_design < backend/src/main/resources/db/seed/dummy_modules.sql

주의: 다시 실행하면 같은 제품이 중복으로 들어감.

참고: 제품명은 실제 제품이지만 가격과 일부 스펙(그래픽카드 길이, 포트 구성 등)은 대략적인 값. image_url 은 전부 NULL. RAM 의 capacity 는 패키지 전체 용량(16Gx2 제품은 32).

미확인: 실제 DB 에 실행해 보지는 않음.

7. 제품 이미지 자리에 카테고리별 더미 이미지 표시 - OK

배경: 제품 이미지가 없어 목록 카드와 상세 패널의 이미지 자리가 검정 박스였음.

추가: frontend/src/assets/dummy_*.{webp,jpg}  8개 카테고리 전부 (cpu, motherbored, ram, gpu, power, ssd, hdd, monitor)

수정: SearchPage.jsx

카테고리 -> 더미 이미지 매핑(DUMMY_IMAGES) 추가. 제품에 imageUrl 이 있으면 그것을 쓰고, 없으면 카테고리 더미 이미지를 씀.

+ const getProductImage = (product) => product.imageUrl || DUMMY_IMAGES[product.category] || null;

search-page__card-image-wrap, search-page__detail-image-wrap 안에 img 추가.

추가:
.search-page__image
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  object-fit: cover;  박스에 맞춰 늘어나지 않고 잘려서 채워짐

수정:
.search-page__card-image-wrap +
position: relative;

.search-page__detail-image-wrap +
position: relative;

참고: DB 의 image_url 에 넣지 않고 프론트에서 매핑함. src/assets 이미지는 빌드할 때 파일명에 해시가 붙어서 DB 에 고정 경로로 넣을 수 없음.

참고: 같은 카테고리 제품은 전부 같은 이미지가 나옴. 제품 전체가 보이게 하려면 object-fit 을 contain 으로 바꾸면 됨.

미확인: 빌드는 통과했으나 브라우저에서 직접 확인하지는 않음.
