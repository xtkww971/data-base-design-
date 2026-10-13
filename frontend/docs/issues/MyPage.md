배경:
로그인하면 헤더에 "닉네임님" 만 표시되고, 내 정보를 볼 수 있는 페이지가 없었음. 헤더의 닉네임에서 마이페이지로 갈 수 있게 하고, 마이페이지를 프로토타입으로 추가함.

마이페이지는 화면 디자인만 만든 상태. 백엔드 호출은 없고 로그인할 때 받아 둔 유저 정보만 보여줌.

todo :

1. 헤더 닉네임에 화살표를 붙이고 마이페이지로 이동 - OK

수정: components/Header.jsx

닉네임 span 을 /mypage 로 가는 Link 로 바꾸고 오른쪽 화살표(›) 아이콘을 붙임. 닉네임과 화살표 전체가 눌리는 영역.

- <span className="header__user">{currentUser.nickname}님</span>
+ <Link to="/mypage" className="header__user">
+   <span className="header__user-name">{currentUser.nickname}님</span>
+   <svg className="header__user-arrow" ... />
+ </Link>

수정: components/Header.css

.header__user
+ display: inline-flex;
+ align-items: center;
+ gap: 4px;
+ padding: 8px 10px 8px 12px;
+ border-radius: 10px;
+ text-decoration: none;
hover 시 옅은 배경 표시

추가:
.header__user-name  긴 닉네임 말줄임 (max-width: 160px, 720px 이하에서는 80px)
.header__user-arrow  16px. hover 시 오른쪽으로 3px 이동

말줄임(max-width, overflow, text-overflow)은 .header__user 에서 .header__user-name 으로 옮김. 링크 전체에 걸면 화살표까지 잘리기 때문.

2. 마이페이지 프로토타입 추가 - OK

추가: pages/MyPage.jsx, pages/MyPage.css (클래스 접두사 my-page__)

수정: App.jsx
+ /mypage 경로 등록

화면 구성 (SearchPage 와 같은 패널 디자인):

- 상단: "마이페이지" 제목, "닉네임님, 반가워요." 문구, 로그아웃 버튼.
- 내 정보 카드: 닉네임, 아이디, 가입일. authStore 의 useCurrentUser 값(UserResponse 의 nickname, loginId, createdAt)을 그대로 표시.
- 저장한 견적 카드: 아직 기능이 없어 "아직 저장한 견적이 없습니다" 안내와 "장바구니 보러 가기" 버튼만 있음.
- 860px 이하에서는 두 카드가 세로로 쌓임.

동작:

- 로그인하지 않고 /mypage 로 들어오면 /login 으로 보냄. state 에 from: '/mypage' 를 넘겨서 로그인 후 마이페이지로 돌아옴.
- 마이페이지의 로그아웃 버튼: 로그아웃 후 메인(/)으로 이동.
- 마이페이지에서 헤더의 로그아웃 버튼을 누르면 위 규칙에 따라 /login 으로 이동함.

.my-page 의 padding-top 은 헤더 높이에 맞춰 100px.

미해결:
- 저장한 견적 목록 (장바구니 "견적 저장하기" 동작과 같이 필요).
- 닉네임, 비밀번호 변경 등 내 정보 수정 기능.
- 가입일 등은 로그인 시점에 localStorage 에 저장된 값이라, 서버에서 정보가 바뀌어도 다시 로그인하기 전까지 반영되지 않음.

미확인: 빌드는 통과했으나, 수정한 쪽에서 브라우저로 직접 확인하지는 않음. 린트의 Header.jsx setIsSearchOpen 미사용 오류는 이번 수정 이전부터 있던 것.
