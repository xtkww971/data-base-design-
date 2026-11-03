# 개발 환경 세팅 가이드

Docker를 처음 쓰는 사람 기준으로 적었습니다. 위에서부터 순서대로 따라 하면 됩니다.

## 0. Docker가 뭘 해주나요?

Docker를 쓰면 **MySQL을 내 PC에 직접 설치하지 않아도** 팀원 모두가 같은 버전·같은 설정의 DB를 명령어 한 줄로 띄울 수 있습니다.

- **이미지(image)**: 프로그램 설치본이라고 생각하면 됩니다. 예: `mysql:8.4`
- **컨테이너(container)**: 이미지를 실행한 것입니다. 우리 프로젝트에서는 `dbd-mysql`이 MySQL이 돌아가는 컨테이너입니다.
- **볼륨(volume)**: 컨테이너를 꺼도 DB 데이터가 사라지지 않게 보관하는 저장소입니다.
- **docker-compose.yml**: "어떤 컨테이너를 어떤 설정으로 띄울지" 적어 둔 파일입니다. 루트에 있는 파일이 이것입니다.

---

## 1. Docker Desktop 설치

1. https://www.docker.com/products/docker-desktop/ 에서 본인 OS에 맞는 버전을 받아 설치합니다.
   - Windows는 설치 중에 **WSL 2** 사용 여부를 물으면 체크된 그대로 진행합니다. 설치 후 재부팅을 요구할 수 있습니다.
2. **Docker Desktop을 실행합니다.** 앱을 켜 두어야 `docker` 명령어가 동작합니다. (작업 표시줄에 고래 아이콘이 보이면 켜진 상태입니다.)
3. 터미널(PowerShell, Git Bash, macOS 터미널 등)에서 확인합니다.

   ```bash
   docker --version
   docker compose version
   ```

   두 줄 모두 버전이 나오면 설치된 것입니다.

---

## 2. 환경 변수 설정

비밀번호나 API 키는 git에 올리면 안 되므로 **각자 PC에만 있는 파일**에 적습니다. 적는 곳은 아래 세 군데입니다.

| 파일 | 누가 읽나요 | git에 올라가나요 |
|---|---|---|
| `.env` (프로젝트 루트) | Docker(MySQL 컨테이너), nl2sql | ❌ `.gitignore`에 등록됨 |
| `backend/src/main/resources/application-local.yml` | 백엔드(Spring) | ❌ `backend/.gitignore`에 등록됨 |
| `frontend` | 따로 설정할 것 없음 | — |

> ⚠️ 위 파일들은 절대 커밋하지 마세요. `git status`에 `.env`나 `application-local.yml`이 보이면 뭔가 잘못된 것입니다.

### 2-1. 루트 `.env`

프로젝트 루트(`docker-compose.yml`이 있는 폴더)에 `.env` 파일을 새로 만들고 아래 내용을 붙여 넣은 뒤 값을 채웁니다.

```dotenv
# ---------- MySQL (Docker) ----------
# root 계정 비밀번호. 아무 값이나 정해도 됩니다.
MYSQL_ROOT_PASSWORD=원하는_root_비밀번호

# 자동으로 만들어질 데이터베이스 이름. 바꾸지 마세요.
MYSQL_DATABASE=data_base_design

# 백엔드/nl2sql이 접속할 계정. root는 쓸 수 없습니다.
MYSQL_USER=app
MYSQL_PASSWORD=원하는_app_비밀번호

# 내 PC에서 MySQL에 접속할 포트. 로컬 MySQL(3306)과 겹치지 않도록 기본 3307을 씁니다.
MYSQL_PORT=3307

# ---------- nl2sql (Python) ----------
# https://console.groq.com/keys 에서 발급
GROQ_API_KEY=gsk_로_시작하는_키
```

| 변수 | 들어갈 값 | 필수 | 비워 두면 |
|---|---|---|---|
| `MYSQL_ROOT_PASSWORD` | MySQL root 비밀번호(아무 값) | 권장 | `root` |
| `MYSQL_DATABASE` | `data_base_design` 고정 | 선택 | `data_base_design` |
| `MYSQL_USER` | 앱이 쓸 계정 이름. **`root` 금지** | 선택 | `app` |
| `MYSQL_PASSWORD` | 위 계정의 비밀번호 | 권장 | `app` |
| `MYSQL_PORT` | 내 PC 쪽 포트. 3307도 사용 중이면 다른 번호로 | 선택 | `3307` |
| `GROQ_API_KEY` | Groq API 키 | nl2sql 실행 시 필수 | LLM 호출 실패 |

비밀번호 값은 팀원끼리 맞출 필요가 없습니다. **내 `.env`와 내 `application-local.yml`만 서로 일치**하면 됩니다.

> 💡 `nl2sql/src/chatmodel.py`의 `load_dotenv()`는 상위 폴더까지 `.env`를 찾아 올라가므로, 루트 `.env` 하나에 적으면 nl2sql도 읽습니다.

### 2-2. 백엔드 `application-local.yml`

`backend/src/main/resources/application-local.yml` 파일을 만들고 아래처럼 적습니다.
`username`, `password`, 포트는 **위 `.env`에 적은 값과 똑같이** 맞춥니다.

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3307/data_base_design?serverTimezone=Asia/Seoul&characterEncoding=UTF-8
    driver-class-name: com.mysql.cj.jdbc.Driver
    username: app                  # .env 의 MYSQL_USER
    password: 원하는_app_비밀번호    # .env 의 MYSQL_PASSWORD
  jpa:
    show-sql: true
```

- `.env`에서 `MYSQL_PORT`를 다른 값으로 바꿨다면 url의 `localhost:3307`도 같은 포트로 바꿉니다.
- 테이블은 직접 만들 필요 없습니다. 백엔드를 실행하면 Flyway가 `db/migration`의 SQL을 자동으로 적용합니다.

---

## 3. MySQL 띄우기

프로젝트 루트에서 실행합니다.

```bash
docker compose up -d
```

- 처음 실행할 때는 MySQL 이미지를 내려받느라 1~2분 걸립니다.
- `-d`는 백그라운드 실행입니다. 터미널을 닫아도 계속 돌아갑니다.

잘 떴는지 확인합니다.

```bash
docker compose ps
```

`STATUS`에 **`(healthy)`**가 보이면 준비된 것입니다. `(health: starting)`이면 30초쯤 기다렸다가 다시 확인하세요.

이제 백엔드를 IntelliJ에서 평소처럼 실행하면 됩니다.

---

## 4. 자주 쓰는 명령어

모두 프로젝트 루트에서 실행합니다.

| 하고 싶은 것 | 명령어 |
|---|---|
| MySQL 켜기 | `docker compose up -d` |
| 상태 보기 | `docker compose ps` |
| MySQL 로그 보기 (`Ctrl+C`로 빠져나옴) | `docker compose logs -f mysql` |
| MySQL 끄기 (데이터 유지) | `docker compose down` |
| MySQL 콘솔 접속 | `docker compose exec mysql mysql -u app -p data_base_design` |
| ⚠️ DB 완전 초기화 (데이터 삭제) | `docker compose down -v` |

PC를 재부팅해도 Docker Desktop만 켜져 있으면 MySQL이 자동으로 다시 올라옵니다.

### DB 툴(DataGrip, IntelliJ Database, Workbench 등)로 접속할 때

| 항목 | 값 |
|---|---|
| Host | `localhost` |
| Port | `.env`의 `MYSQL_PORT` (기본 `3307`) |
| User / Password | `.env`의 `MYSQL_USER` / `MYSQL_PASSWORD` |
| Database | `data_base_design` |

---

## 5. 문제 해결

**`error during connect` / `Cannot connect to the Docker daemon`**
→ Docker Desktop이 꺼져 있습니다. 앱을 켜고 고래 아이콘이 멈출 때까지 기다린 뒤 다시 실행하세요.

**`port is already allocated` / `Bind for 0.0.0.0:3307 failed`**
→ 내 PC에서 다른 프로그램이 3307을 쓰고 있습니다.
- `.env`에서 `MYSQL_PORT`를 비어 있는 포트(예: `3308`)로 바꾸고 `application-local.yml`의 url 포트도 똑같이 바꾸기

**`.env`에서 비밀번호를 바꿨는데 `Access denied`가 뜬다**
→ MySQL 컨테이너는 **처음 만들어질 때만** `.env`의 계정/비밀번호를 적용합니다. 나중에 바꾸면 반영되지 않습니다.
아래 명령으로 DB를 초기화한 뒤 다시 띄우세요. (DB 데이터가 전부 지워집니다.)

```bash
docker compose down -v
docker compose up -d
```

**백엔드 실행 시 `Access denied for user`**
→ `application-local.yml`의 `username`/`password`가 `.env`의 `MYSQL_USER`/`MYSQL_PASSWORD`와 같은지 확인하세요.

**백엔드 실행 시 `Communications link failure`**
→ MySQL이 아직 안 떴거나 포트가 다릅니다. `docker compose ps`에서 `(healthy)`인지, url의 포트가 `MYSQL_PORT`와 같은지 확인하세요.

---

## 참고: 백엔드·nl2sql도 Docker로 띄우기 (준비 중)

`docker-compose.yml`에는 `backend`, `nl2sql` 서비스가 `app` 프로필로 미리 정의돼 있습니다. 각 폴더에 `Dockerfile`이 추가되면 아래 명령 하나로 전부 띄울 수 있습니다. **지금은 아직 실행하지 마세요.**

```bash
docker compose --profile app up -d --build
```

이때 nl2sql은 `.env`의 값을 아래 이름으로 넘겨받습니다. nl2sql의 DB 접속 코드(`tools/db_executor.py`)는 이 이름으로 읽도록 작성해 주세요.

| 컨테이너 안 변수 | 값 출처 |
|---|---|
| `DB_HOST` | `mysql` (고정) |
| `DB_PORT` | `3306` (고정) |
| `DB_NAME` | `MYSQL_DATABASE` |
| `DB_USER` | `MYSQL_USER` |
| `DB_PASSWORD` | `MYSQL_PASSWORD` |
| `GROQ_API_KEY` | `GROQ_API_KEY` |
