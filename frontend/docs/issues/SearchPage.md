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
