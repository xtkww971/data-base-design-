# figma + React + Vite 


이 프로젝트는 [`data_base_design`](https://github.com/xtkww971/data-base-design-) 백엔드 및 LLM/Langchain API와 연동되는 프론트 엔드 애플리케이션 이다.

---


## 🛠 준비 및 환경변수 설정

백엔드 서버(`http://localhost:8080`)와의 통신을 위해 환경변수 설정이 필요하다.

접속 정보는 `src/main/resources/application-local.yml**`. 이 파일은 `.gitignore`에 등록되어 커밋되지 않으므로**, 클론 후 템플릿을 복사하여 작성해야 한다.

빌드는 frontend/ 경로 이동 후 `npm run dev`

---

## 규칙

type: Subject 형태로 작성.

feat: 새로운 기능 구현 (로그인, 회원가입 폼 등)

fix: 버그 수정

design: CSS, 레이아웃 등 UI 디자인 변경

refactor: 코드 구조 개선 (기능 동작은 동일)

docs: README 및 주석 문서 수정

chore: 빌드 설정, 패키지 설치 등 보조 작업

---

## 개발 시 생각할 것
[`스키마 설계`](https://github.com/xtkww971/data-base-design-/blob/main/docs/%EC%8A%A4%ED%82%A4%EB%A7%88%20%EC%84%A4%EA%B3%84/01-%EC%9C%A0%EC%A0%80-%EC%8A%A4%ED%82%A4%EB%A7%88-%EC%84%A4%EA%B3%84.md) 

문서에 따라, 실제 구매로 이어지는 로직은 구현하지 않기 때문에 자연어 견적 질의에 대한 결과를 깔끔하게 보여주는 과정 및 결과 화면 구현에만 집중하여 개발한다.

## 패키지 구조
```
frontend/
├── public/ # 정적 리소스 (favicon, index.html 등)
├── src/
│ ├── assets/ # 이미지, 폰트 등 정적 파일
│ ├── components/ # 재사용 가능한 UI 컴포넌트
│ ├── pages/ # 라우트 단위 페이지 컴포넌트
│ ├── hooks/ # 커스텀 훅
│ ├── api/ # Spring 백엔드 및 LLM/Langchain API 요청 모듈 (axios)
│ ├── styles/ # 전역 스타일, 테마, CSS 변수
│ ├── utils/ # 공통 유틸 함수
│ ├── App.jsx
│ └── main.jsx
├── .env.local # 로컬 환경변수 (gitignore 처리)
├── vite.config.js
└── package.json
```
업데이트 예정


## 설계 순서

1. Figma를 통한 페이지 레이아웃 구성
2. main 페이지 구현
3. 로그인, 회원가입 페이지 구현
4. 자연어 견적 질의 입력 페이지 구현 (질의 입력 폼, 로딩 상태 UI)
5. 백엔드/LLM API 연동 (질의 요청 → 응답 데이터 처리)
6. 견적 결과 화면 구현 (응답 결과를 리스트/카드 형태로 시각화)
7. 예외 처리 및 에러 화면 (질의 실패, 응답 없음 등)
8. 반응형 대응 및 UI 디테일 다듬기
9. 통합 테스트





