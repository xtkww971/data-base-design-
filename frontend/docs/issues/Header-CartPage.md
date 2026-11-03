배경:
헤더가 본문 패널 디자인과 톤이 달랐고(회색 실선, 치우친 메뉴), 헤더의 장바구니 아이콘은 눌러도 갈 페이지가 없었음. 헤더를 다듬고 장바구니 페이지를 프로토타입으로 추가함.

장바구니는 화면 디자인만 만든 상태. 백엔드 API 는 아직 없고 연결하지 않음.

todo :

1. 헤더 디자인 수정 - OK

수정: components/Header.css

1-1. 배치

.header__inner
display: flex -> grid
+ grid-template-columns: 1fr auto 1fr;  로고 | 메뉴 | 버튼 3칸. 양쪽 칸 폭이 같아서 메뉴가 화면 정가운데에 옴
width: 100% -> min(1280px, 100%)  본문과 같은 최대 폭
height: 80px -> 100px
padding: 0 26px -> 0 24px

이전에는 로고와 오른쪽 버튼 폭이 달라서 메뉴가 한쪽으로 치우쳐 있었음.

주의: 헤더 높이를 100px 로 올렸는데 각 페이지의 padding-top 은 80px 기준으로 잡혀 있음.
- MainPage: 80px 이라 본문 위쪽 20px 이 헤더에 가려짐. 확인 필요.
- SearchPage, CartPage: 96px 이라 4px 가려지지만, 본문 자체의 위쪽 여백(36px)이 있어서 내용은 안 가려짐.
- LoginPage, SignUpPage: 128px 이라 문제 없음.

1-2. 테두리, 배경

.header
border-bottom: 1px solid #484848 -> 1px solid rgba(148, 163, 184, 0.16)  본문 패널과 같은 선
+ box-shadow: 0 10px 30px rgba(2, 6, 23, 0.35);

1-3. 로고

.header__logo-image
80px -> 60px
+ hover 시 살짝 커짐

1-4. 메뉴

.header__nav-list
gap: 100px -> 90px

.header__nav-link
font-size: 20px (유지), font-weight: 500 -> 600
밑줄이 왼쪽이 아니라 가운데에서 펼쳐짐. hover 는 40% 길이, 현재 페이지는 전체 길이.

1-5. 오른쪽 버튼

.header__right
gap: 20px -> 32px

.header__icon-btn  장바구니 아이콘
20px -> 40px 둥근 버튼, hover 시 배경 표시
- transform: translateX(-10px);  위치를 억지로 밀던 값 제거

.header__login  로그인 버튼
어두운 회색 -> 파란 그라데이션 (로그인 페이지 버튼과 같은 색)
font-size: 13px -> 16px

추가: .header__login--ghost  로그아웃 버튼용. 덜 눈에 띄는 반투명 스타일
Header.jsx 의 로그아웃 버튼에 클래스 추가.

.header__user  닉네임
font-size: 14px -> 16px

삭제: 쓰이지 않던 .header__icon-group 규칙

2. 장바구니 페이지 프로토타입 추가 - OK

추가: pages/CartPage.jsx, pages/CartPage.css (클래스 접두사 cart-page__)

수정: App.jsx
+ /cart 경로 등록

수정: Header.jsx
장바구니 아이콘을 누르면 /cart 로 이동.

화면 구성 (SearchPage 와 같은 패널 디자인):

- 왼쪽 목록: 부품 카드마다 이미지, 카테고리 태그, 브랜드, 이름, 요약 스펙, 개당 가격. 오른쪽에 삭제(✕), 수량 조절(− / +), 수량을 곱한 금액.
- 오른쪽 견적 요약: 상품 종류, 총 수량, 합계, "견적 저장하기", "부품 더 담기". position: sticky 로 스크롤을 따라옴.
- 빈 상태: "장바구니가 비어 있습니다" + "부품 보러 가기".
- 980px 이하에서는 요약이 목록 아래로 내려감.

프로토타입 범위:

- 데이터는 CartPage.jsx 안의 더미 부품 4개(DUMMY_CART_ITEMS). 새로고침하면 처음 상태로 돌아감.
- 수량 조절, 삭제, 전체 비우기는 화면 안에서만 동작.
- SearchPage 의 "견적에 추가" 버튼과는 아직 연결하지 않음.

3. 견적 저장 시 로그인 안내 팝업 - OK

"견적 저장하기" 를 눌렀을 때 로그인이 안 되어 있으면 팝업으로 안내.

- 문구: "로그인이 필요합니다 / 견적을 저장하려면 로그인해야 합니다."
- "로그인하러 가기": /login 으로 이동. state 에 from: '/cart' 를 넘겨서 로그인 후 장바구니로 돌아옴.
- 닫기: "닫기" 버튼, 팝업 바깥 클릭, Esc 키.
- 로그인 여부는 헤더와 같은 useCurrentUser (auth/authStore.js) 로 판단.

추가:
.cart-page__modal-backdrop  z-index: 200 (헤더 100 보다 위)
.cart-page__modal
.cart-page__modal-actions

미해결:
- 로그인된 상태에서 "견적 저장하기" 를 눌렀을 때의 실제 저장 동작 없음.
- 장바구니가 더미 데이터라 로그인하고 돌아오면 수량 변경, 삭제 내용이 초기화됨.
- 장바구니 API 연결, SearchPage "견적에 추가" 연결.
- Header.jsx 의 setIsSearchOpen 미사용 린트 오류는 이번 수정 이전부터 있던 것.

미확인: 린트(위 기존 오류 제외)와 빌드는 통과했으나, 수정한 쪽에서 브라우저로 직접 확인하지는 않음.
