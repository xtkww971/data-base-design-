배경:
로그인과 회원가입 페이지가 AuthPage.css 하나를 같이 쓰고 있어서, 로그인 페이지 디자인만 따로 손보기 어려웠음. 다른 페이지들처럼 페이지.jsx + 페이지.css 한 쌍으로 맞추고, 로그인 페이지 입력 폼을 다듬음.

백엔드와 API 호출(authApi.js, authStore.js), 페이지 로직은 건드리지 않음.

todo :

1. 로그인 / 회원가입 CSS 분리 - OK

삭제: AuthPage.css

추가: LoginPage.css (클래스 접두사 login-page__)

추가: SignUpPage.css (클래스 접두사 signup-page__)

수정: LoginPage.jsx, SignUpPage.jsx
클래스 이름(auth-page -> login-page / signup-page)과 CSS import 만 변경.

각 CSS 에는 그 페이지가 실제로 쓰는 규칙만 남김. 중복 확인 버튼(check-button), input-row 는 회원가입에만 있고, 가입 완료 안내(alert.is-success)는 로그인에만 있음.

주의: 두 CSS 가 대부분 같은 내용이라 공통 디자인을 바꿀 때는 양쪽을 같이 고쳐야 함.

2. 입력 박스 높이가 적용되지 않는 버그 수정 - OK

원인: 입력 박스에 flex: 1 이 걸려 있었음. 라벨과 입력 박스를 세로로 쌓는 구조(flex-direction: column)에서는 flex: 1 때문에 height 가 무시되어 박스가 글자 높이만큼만 나옴.

수정:
.login-page__input
- flex: 1;
- min-width: 0;
+ flex: none;

SignUpPage.css 의 비밀번호, 비밀번호 확인, 닉네임 입력 박스에도 같은 문제가 있었고 4번에서 같이 수정함.

3. 로그인 페이지 디자인 수정 - OK

3-1. "로그인" 파란 배지 삭제

삭제: LoginPage.jsx 의 login-page__eyebrow 요소, LoginPage.css 의 .login-page__eyebrow 규칙

수정:
.login-page__panel h1
margin: 14px 0 0 -> 0  배지 아래 간격용이던 여백 제거

3-2. 패널, 입력 박스 크기

수정:
.login-page
padding-top: 96px -> 128px

.login-page__content
padding: 56px 16px 96px -> 55px 0 96px

.login-page__panel
width: min(100%, 460px) -> min(100%, 520px)
padding: 36px 32px 32px -> 36px 32px 24px

.login-page__form
gap: 18px -> 17px

.login-page__input
height: 52px -> 50px
font-size: 0.96rem -> 1.05rem
+ margin: 5px (위아래)

.login-page__submit
height: 52px -> 55px
margin-top: 6px -> 13px  비밀번호 박스와 간격을 벌림

3-3. 입력 박스와 로그인 버튼의 좌우 끝 맞춤

제목, 안내 문구, 라벨은 같은 왼쪽 선에서 시작함. 입력 박스와 로그인 버튼은 그 선보다 좌우로 --input-inset 만큼 바깥으로 내밀어 둠.

추가:
.login-page__form
--input-inset: 4px;

수정:
.login-page__input
width: calc(100% + var(--input-inset) * 2);
margin: 5px calc(var(--input-inset) * -1);

.login-page__submit
margin: 13px calc(var(--input-inset) * -1) 0;

주의: --input-inset 은 입력 박스와 버튼의 공통 부모인 .login-page__form 에 정의해야 함. 입력 박스 규칙 안에 두면 버튼에서는 값이 없어서 margin 줄 전체가 무시됨. 폭을 바꿀 때는 이 값 한 곳만 고치면 됨.

4. 회원가입 페이지를 로그인 페이지와 같은 디자인으로 수정 - OK

SignUpPage.css 를 LoginPage.css 와 같은 값으로 맞춤 (3번의 패널 / 입력 박스 / 버튼 수치, --input-inset, 입력 박스 높이 버그 수정 포함).

삭제: SignUpPage.jsx 의 "회원가입" 파란 배지(signup-page__eyebrow)와 해당 CSS 규칙

회원가입에만 있는 부분:

.signup-page__input-row  아이디 입력 박스 + 중복 확인 버튼 줄
+ margin: 5px calc(var(--input-inset) * -1);  줄 전체를 다른 입력 박스와 같은 폭으로 내밂

.signup-page__input-row .signup-page__input
  flex: 1;
  min-width: 0;
  width: auto;
  margin: 0;  가로 배치 안에서는 flex: 1 로 남는 폭을 채워야 함

.signup-page__check-button
height: 52px -> 50px  입력 박스 높이와 맞춤

미확인: 린트와 빌드는 통과했으나, 수정한 쪽에서 브라우저로 직접 확인하지는 않음.
