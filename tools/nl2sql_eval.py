"""
NL2SQL 질의 실험 실행기 (이슈 #29 이후 성능 개선 실험용).

질문 파일(JSON)의 질문을 실행 중인 백엔드(POST /api/nl2sql/query)에 하나씩 보내고,
질문마다 아래를 모아 실행 폴더에 남긴다.

    - 요청 본문, HTTP 상태, code, message, 총 응답 시간
    - TypeSafe Jev 판정 · 확신도 · 모델 · 판정 지연 · 거절 여부      (백엔드 로그)
    - 생성된 SQL, 컬럼, 행 수, 결과 일부                              (성공 응답)
    - 실행 실패한 SQL 과 예외 / 생성 실패 사유와 재시도 횟수          (백엔드 로그)
    - 예상과 실제 비교 (판정 일치, 결과 일치, 오거절, 놓친 거절, 보안)

질문은 순서대로 하나씩 보낸다. 질문을 보낸 시각부터 응답을 받은 시각까지의 백엔드
로그만 잘라 그 질문의 로그로 본다. 그래서 실행 중에 다른 사람이 같은 백엔드를 쓰면
로그가 섞인다.

생성·실행 시간, 재시도 횟수, 생성에 실패한 마지막 SQL 은 Nl2SqlService 의 실험 기록용
로그(`SQL 생성 완료`, `생성에 실패한 마지막 SQL`, `SQL 실행 완료`)에서 읽는다. 그 로그가
없는 예전 백엔드로 돌리면 해당 칸은 비어 있다.

표준 라이브러리만 쓴다. docker CLI 가 PATH 에 있어야 한다.

사용법:
    python tools/nl2sql_eval.py "docs/test/test 1/test_1_questions.json"
    python tools/nl2sql_eval.py "docs/test/test 1/test_1_questions.json" --only Q01,Q21
    python tools/nl2sql_eval.py "docs/test/test 1/test_1_questions.json" --repeat 3
    python tools/nl2sql_eval.py --report-only "docs/test/test 1/runs/20261128-173000"

결과: <질문 파일 폴더>/runs/<실행 시각>/
    meta.json       실행 조건 (커밋, 임계값, 모델, 기준 파일 해시 등)
    results.jsonl   질문별 전체 기록. 질문 하나가 끝날 때마다 한 줄씩 쓴다
    results.csv     스프레드시트로 볼 요약
    report.md       지표 요약 + 질문별 표 + 질문별 상세(SQL, 오류, 로그)
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import re
import statistics
import subprocess
import sys
import time
import urllib.error
import urllib.request
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DEFAULT_BASE_URL = "http://localhost:8080"
BACKEND_CONTAINER = "dbd-backend"
NL2SQL_CONTAINER = "dbd-nl2sql"
HTTP_TIMEOUT_SECONDS = 180  # 백엔드 → nl2sql read-timeout 이 60s 라 넉넉히 둔다
ROW_SAMPLE = 5
TRUNCATION_ROWS = 100  # Nl2SqlService.MAX_ROWS

JUDGE_CODES = {
    "NL2SQL_OUT_OF_SCOPE": "out_of_scope",
    "NL2SQL_MISSING_DATA": "missing_data",
    "NL2SQL_AMBIGUOUS": "ambiguous",
}

# 프론트 Nl2sqlErrorCard 의 매핑과 같다. 화면에 무엇이 떴을지 기록하는 용도.
SCREEN_BY_CODE = {
    "NL2SQL_OUT_OF_SCOPE": "안내·금지",
    "NL2SQL_MISSING_DATA": "안내·DB",
    "NL2SQL_AMBIGUOUS": "안내·물음표",
    "NL2SQL_GENERATION_FAILED": "주황·다시 표현",
    "INVALID_INPUT": "주황·입력 확인",
    "INVALID_TYPE": "주황·입력 확인",
    "NL2SQL_EXECUTION_FAILED": "빨강·조회 실패",
    "NL2SQL_UNAVAILABLE": "빨강·서버 연결 실패",
    "INTERNAL_SERVER_ERROR": "빨강·서버 오류",
}

# ---------------------------------------------------------------------------
# 백엔드 로그 해석
# ---------------------------------------------------------------------------

# 2026-11-28T16:40:08.230+09:00  INFO 1 --- [app] [nio-8080-exec-2] c.d.d.d.n.c.AnswerabilityJudgeClient     : 메시지
LOG_LINE = re.compile(
    r"^(?P<ts>\d{4}-\d{2}-\d{2}T\S+)\s+(?P<level>[A-Z]+)\s+\d+\s+---\s+"
    r"\[[^\]]*\]\s+\[[^\]]*\]\s+(?P<logger>\S+)\s*:\s?(?P<msg>.*)$"
)
EXCEPTION_LINE = re.compile(r"^[\w.$]+(?:Exception|Error)(?::|$)")

JUDGE_RESULT = re.compile(
    r"판정 결과 verdict=(?P<verdict>\S+) confidence=(?P<confidence>\S+) "
    r"model=(?P<model>\S+) latency=(?P<latency>\d+)ms"
)
JUDGE_REJECTED = re.compile(r"판정으로 거절했습니다\. verdict=(?P<verdict>\S+) confidence=(?P<confidence>\S+)")
JUDGE_SKIPPED = re.compile(
    r"(?P<reason>판정 호출에 실패해|판정 응답에 .+? 답이 없어|해석할 수 없는 판정이라|안내 문구가 없는 판정이라)"
    r"[^\n]*?(?:latency=(?P<latency>\d+)ms)?$"
)
# Nl2SqlService 의 실험 기록용 로그. latency 가 없는 예전 형식도 읽는다.
GENERATION_DONE = re.compile(
    r"SQL 생성 완료 retry_count=(?P<retry>\d+) latency=(?P<latency>\d+)ms"
    r"(?: question=(?P<question>.*?))? sql=(?P<sql>.*)$"
)
GENERATION_FAILED = re.compile(
    r"SQL 생성 실패 \(retry_count=(?P<retry>\d+)(?: latency=(?P<latency>\d+)ms)?\): (?P<error>.*)$"
)
GENERATION_LAST_SQL = re.compile(r"생성에 실패한 마지막 SQL: (?P<sql>.*)$")
EXECUTION_DONE = re.compile(r"SQL 실행 완료 rows=(?P<rows>\d+) latency=(?P<latency>\d+)ms")
EXECUTION_FAILED = re.compile(r"생성된 SQL 실행 실패(?: \(latency=(?P<latency>\d+)ms\))?: (?P<sql>.*)$")
# nl2sql 컨테이너 로그. LLM(Groq) 요청 한도에 걸리면 nl2sql 이 500 을 내고, 백엔드는 이를
# NL2SQL_GENERATION_FAILED 로 바꾼다. 질문 탓이 아니므로 결과 지표에서 빼야 한다.
LLM_RATE_LIMIT = re.compile(r"RateLimitError: Error code: 429 - .*?'message': '(?P<msg>[^']*)'")
ORGANIZATION = re.compile(r" in organization `[^`]*`")
# 분당 한도(TPM/RPM)는 1분 안에 풀리므로 기다렸다 다시 보낸다. 하루 한도(TPD/RPD)는 멈춘다.
PER_MINUTE_LIMIT = re.compile(r"per minute|\((?:TPM|RPM)\)")
MINUTE_LIMIT_WAIT_SECONDS = 60
MINUTE_LIMIT_MAX_WAITS = 3

NL2SQL_SERVER_ERROR = re.compile(r"nl2sql 서비스가 질의 처리 중 오류를 반환했습니다\. status=(?P<status>\S+)")
NL2SQL_CALL_FAILED = re.compile(r"nl2sql 서비스 호출에 실패했습니다")


def group_log_records(text: str) -> list[dict]:
    """타임스탬프로 시작하는 줄을 한 건으로 보고, 뒤따르는 줄(여러 줄 SQL, 스택트레이스)을 붙인다."""
    records: list[dict] = []
    for line in text.splitlines():
        match = LOG_LINE.match(line)
        if match:
            records.append({**match.groupdict(), "extra": []})
        elif records:
            records[-1]["extra"].append(line)
    return records


def parse_backend_logs(text: str) -> dict:
    parsed: dict = {
        "judge": {"status": "none"},
        "generation": None,
        "execution": None,
        "nl2sql_error": None,
        "warnings": [],
    }
    for record in group_log_records(text):
        msg = record["msg"]

        if m := JUDGE_RESULT.search(msg):
            parsed["judge"].update(
                status="judged",
                verdict=m["verdict"],
                confidence=float(m["confidence"]),
                model=m["model"],
                latency_ms=int(m["latency"]),
            )
        elif m := JUDGE_REJECTED.search(msg):
            parsed["judge"]["rejected"] = True
        elif m := JUDGE_SKIPPED.search(msg):
            parsed["judge"].update(status="skipped", skip_reason=msg)
            if m["latency"]:
                parsed["judge"]["latency_ms"] = int(m["latency"])
        elif m := GENERATION_DONE.search(msg):
            parsed["generation"] = {
                "status": "ok",
                "retry_count": int(m["retry"]),
                "latency_ms": int(m["latency"]),
                "question": m["question"],  # 질문이 없는 예전 형식이면 None
                "sql": "\n".join([m["sql"], *record["extra"]]).strip(),
            }
        elif m := GENERATION_FAILED.search(msg):
            parsed["generation"] = {
                **(parsed["generation"] or {}),
                "status": "failed",
                "retry_count": int(m["retry"]),
                "latency_ms": int(m["latency"]) if m["latency"] else None,
                "error": "\n".join([m["error"], *record["extra"]]).strip(),
            }
        elif m := GENERATION_LAST_SQL.search(msg):
            sql = "\n".join([m["sql"], *record["extra"]]).strip()
            parsed["generation"] = {**(parsed["generation"] or {"status": "failed"}),
                                    "sql": None if sql == "(없음)" else sql}
        elif m := EXECUTION_DONE.search(msg):
            parsed["execution"] = {"status": "ok", "rows": int(m["rows"]), "latency_ms": int(m["latency"])}
        elif m := EXECUTION_FAILED.search(msg):
            sql_lines = [m["sql"]]
            exception = None
            for extra in record["extra"]:
                if EXCEPTION_LINE.match(extra.strip()) or extra.startswith("\tat "):
                    exception = exception or extra.strip()
                    if extra.startswith("\tat "):
                        break
                    continue
                if exception is None:
                    sql_lines.append(extra)
            parsed["execution"] = {
                "status": "failed",
                "latency_ms": int(m["latency"]) if m["latency"] else None,
                "sql": "\n".join(sql_lines).strip(),
                "exception": exception,
            }
        elif m := NL2SQL_SERVER_ERROR.search(msg):
            parsed["nl2sql_error"] = f"nl2sql 5xx (status={m['status']})"
        elif NL2SQL_CALL_FAILED.search(msg):
            parsed["nl2sql_error"] = "nl2sql 호출 실패 (연결·타임아웃)"
        elif record["level"] in ("WARN", "ERROR"):
            parsed["warnings"].append(f"{record['level']} {msg}")

    if parsed["judge"].get("status") == "judged":
        parsed["judge"].setdefault("rejected", False)
    return parsed


# ---------------------------------------------------------------------------
# 외부 호출 (docker, HTTP)
# ---------------------------------------------------------------------------


def run(cmd: list[str]) -> str:
    result = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace")
    return (result.stdout or "") + (result.stderr or "")


def docker_logs(container: str, since: float, until: float) -> str:
    return run(["docker", "logs", "--since", f"{since:.3f}", "--until", f"{until:.3f}", container])


def container_env(container: str, name: str) -> str | None:
    out = run(["docker", "exec", container, "sh", "-c", f'printf "%s" "${{{name}}}"']).strip()
    return out or None


MYSQL_CONTAINER = "dbd-mysql"


def run_gold_sql(sql: str) -> tuple[list[str] | None, str | None]:
    """기준 SQL 을 MySQL 컨테이너에서 실행해 첫 컬럼 값 목록을 돌려준다. 조회만 한다.

    접속 정보는 컨테이너 안의 환경변수를 쓴다. SQL 은 stdin 으로 넘겨 따옴표 문제를 피한다.
    """
    result = subprocess.run(
        ["docker", "exec", "-i", MYSQL_CONTAINER, "sh", "-c",
         'mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -N -B 2>&1 | grep -v "Using a password"'],
        input=sql, capture_output=True, text=True, encoding="utf-8", errors="replace",
    )
    out = result.stdout.strip()
    if out.startswith("ERROR"):
        return None, out[:300]
    return [line.split("\t")[0] for line in out.splitlines() if line.strip()], None


# ---------------------------------------------------------------------------
# 쿼리 품질 채점
# ---------------------------------------------------------------------------
#
# 질문 파일의 case 에 아래를 두면 통과(200)한 질문의 SQL·결과를 채점한다.
#
#   "sql_checks": {
#       "must":     ["정규식", ...],          # 모두 들어 있어야 한다
#       "must_any": [["정규식", "정규식"], ...], # 묶음마다 하나 이상 들어 있어야 한다
#       "must_not": ["정규식", ...],          # 하나도 없어야 한다
#       "rows":     "nonzero" | "zero" | "eq:N" | "gte:N" | "lte:N"
#   },
#   "gold": {
#       "sql":   "기준 SQL",                  # 첫 컬럼이 비교할 키(보통 module_id)
#       "keys":  ["module_id", "board_id"],  # 결과에서 키를 찾을 컬럼 이름 후보 (앞에서부터)
#       "match": "set" | "subset"            # set: 결과 = 정답, subset: 결과 ⊆ 정답 (LIMIT·잘림이 있을 때)
#   }
#
# 정규식은 대소문자를 무시하고, SQL 의 줄바꿈·연속 공백을 공백 하나로 줄인 뒤 검사한다.


def normalize_sql(sql: str) -> str:
    return re.sub(r"\s+", " ", sql or "").strip()


def check_rows(spec: str, row_count: int) -> bool:
    if spec == "nonzero":
        return row_count > 0
    if spec == "zero":
        return row_count == 0
    op, _, value = spec.partition(":")
    n = int(value)
    return {"eq": row_count == n, "gte": row_count >= n, "lte": row_count <= n}[op]


def result_keys(rows: list[dict], candidates: list[str]) -> tuple[str | None, list[str]]:
    if not rows:
        # 0행이면 키 컬럼을 볼 수 없지만, 결과가 빈 집합인 것은 분명하다 → 불일치로 채점한다
        return candidates[0], []
    for name in candidates:
        if rows and name in rows[0]:
            return name, [str(row[name]) for row in rows if row.get(name) is not None]
    return None, []


def evaluate_quality(case: dict, outcome: str, sql: str | None, rows: list[dict] | None,
                     row_count: int | None) -> dict | None:
    checks_spec = case.get("sql_checks") or {}
    gold_spec = case.get("gold")
    if not checks_spec and not gold_spec:
        return None
    if outcome != "pass":
        # 통과해야 할 질문이 SQL 단계에서 실패했으면 품질 0 으로 본다
        return {"evaluated": False, "reason": f"결과가 {outcome}", "checks": [], "passed": 0, "total": 0}

    flat = normalize_sql(sql)
    checks: list[dict] = []
    for pattern in checks_spec.get("must", []):
        checks.append({"name": f"must /{pattern}/", "ok": bool(re.search(pattern, flat, re.I))})
    for group in checks_spec.get("must_any", []):
        checks.append({"name": "any of " + " | ".join(f"/{p}/" for p in group),
                       "ok": any(re.search(p, flat, re.I) for p in group)})
    for pattern in checks_spec.get("must_not", []):
        checks.append({"name": f"must_not /{pattern}/", "ok": not re.search(pattern, flat, re.I)})
    if "rows" in checks_spec:
        checks.append({"name": f"rows {checks_spec['rows']} (실제 {row_count})",
                       "ok": check_rows(checks_spec["rows"], row_count or 0)})

    gold = None
    if gold_spec:
        gold_values, gold_error = run_gold_sql(gold_spec["sql"])
        key, values = result_keys(rows or [], gold_spec.get("keys", ["module_id"]))
        if gold_error:
            gold = {"error": gold_error}
        elif key is None:
            gold = {"error": f"결과에 키 컬럼이 없음 (후보: {', '.join(gold_spec.get('keys', ['module_id']))})",
                    "gold_count": len(gold_values)}
        else:
            g, r = set(gold_values), set(values)
            hit = len(g & r)
            match = gold_spec.get("match", "set")
            exact = (r == g) if match == "set" else (bool(r) and r <= g)
            gold = {
                "key": key, "match": match, "gold_count": len(g), "result_count": len(r),
                "precision": round(hit / len(r), 3) if r else None,
                "recall": round(hit / len(g), 3) if g else None,
                "exact": exact,
                "missing_sample": sorted(g - r)[:10],
                "extra_sample": sorted(r - g)[:10],
            }
        checks.append({"name": f"정답 결과 일치 ({gold_spec.get('match', 'set')})", "ok": bool(gold.get("exact"))})

    passed = sum(c["ok"] for c in checks)
    return {"evaluated": True, "checks": checks, "passed": passed, "total": len(checks), "gold": gold}


def http_json(method: str, url: str, payload: dict | None = None) -> tuple[int | None, dict | None, str | None]:
    data = json.dumps(payload, ensure_ascii=False).encode("utf-8") if payload is not None else None
    request = urllib.request.Request(url, data=data, method=method)
    request.add_header("Content-Type", "application/json; charset=utf-8")
    try:
        with urllib.request.urlopen(request, timeout=HTTP_TIMEOUT_SECONDS) as response:
            raw = response.read().decode("utf-8", errors="replace")
            status = response.status
    except urllib.error.HTTPError as e:
        raw = e.read().decode("utf-8", errors="replace")
        status = e.code
    except (urllib.error.URLError, TimeoutError, ConnectionError) as e:
        return None, None, f"{type(e).__name__}: {e}"
    try:
        return status, json.loads(raw), None
    except json.JSONDecodeError:
        return status, None, f"JSON 이 아닌 응답: {raw[:300]}"


# ---------------------------------------------------------------------------
# 실행
# ---------------------------------------------------------------------------


def build_question(case: dict) -> str:
    if "question_fill" in case:
        fill = case["question_fill"]
        return fill["text"] * int(fill["times"])
    return case["question"]


def build_payload(case: dict) -> dict:
    """프론트 nl2sqlApi.queryNl2Sql 이 보내는 본문과 같은 모양."""
    payload = {"question": build_question(case)}
    if case.get("programs"):
        payload["programs"] = case["programs"]
    if case.get("budget_min") is not None:
        payload["budgetMin"] = case["budget_min"]
    if case.get("budget_max") is not None:
        payload["budgetMax"] = case["budget_max"]
    return payload


def classify_outcome(status: int | None, code: str | None) -> str:
    if status is None:
        return "conn_error"
    if status == 200:
        return "pass"
    if status == 400:
        return "invalid"
    if code in JUDGE_CODES:
        return "reject"
    if code == "NL2SQL_GENERATION_FAILED":
        return "gen_fail"
    if code == "NL2SQL_EXECUTION_FAILED":
        return "exec_fail"
    return "server_error"


def screen_for(outcome: str, code: str | None, row_count: int | None) -> str:
    if outcome == "pass":
        if row_count == 0:
            return "0행"
        suffix = " (100행 잘림 가능)" if row_count == TRUNCATION_ROWS else ""
        return f"결과 표 {row_count}개{suffix}"
    if outcome == "conn_error":
        return "빨강·연결 실패"
    return SCREEN_BY_CODE.get(code or "", f"빨강·오류 ({code})")


def evaluate(case: dict, record: dict) -> dict:
    expected_verdicts = case.get("expected_verdicts", [])
    expected_outcomes = case.get("expected_outcomes", [])
    judge = record["judge"]
    outcome = record["outcome"]

    if not expected_verdicts:
        verdict_match = None if judge.get("status") == "none" else False
    elif judge.get("status") != "judged":
        verdict_match = None  # 판정을 못 받았으면 맞다 틀리다 할 수 없다
    else:
        verdict_match = judge["verdict"] in expected_verdicts

    expected_reject_only = "reject" in expected_outcomes and "pass" not in expected_outcomes
    security_violation = bool(
        case.get("security") and outcome == "pass" and (record.get("row_count") or 0) > 0
    )
    return {
        "verdict_match": verdict_match,
        # LLM 한도에 걸린 건은 질문 탓이 아니라 결과를 매길 수 없다. 판정은 그 앞이라 그대로 센다.
        "outcome_match": None if record.get("llm_rate_limited") else outcome in expected_outcomes,
        "over_rejection": outcome == "reject" and "reject" not in expected_outcomes,
        "missed_rejection": expected_reject_only and outcome in ("pass", "gen_fail", "exec_fail"),
        "security_violation": security_violation,
    }


def run_case(case: dict, base_url: str, attempt: int) -> dict:
    payload = build_payload(case)
    started = time.time()
    t0 = time.perf_counter()
    status, body, transport_error = http_json("POST", f"{base_url}/api/nl2sql/query", payload)
    total_ms = round((time.perf_counter() - t0) * 1000)
    finished = time.time()
    time.sleep(0.6)  # 로그가 다 찍힐 때까지 잠깐 기다린다
    raw_logs = docker_logs(BACKEND_CONTAINER, started - 0.3, finished + 0.5)
    logs = parse_backend_logs(raw_logs)
    rate_limit = LLM_RATE_LIMIT.search(docker_logs(NL2SQL_CONTAINER, started - 0.3, finished + 0.5))

    body = body or {}
    code = body.get("code") if status != 200 else None
    outcome = classify_outcome(status, code)
    rows = body.get("rows") if status == 200 else None
    row_count = body.get("rowCount") if status == 200 else None

    # SQL 출처: 성공 응답 → 실행 실패 로그 → 생성 완료 로그 → 생성 실패한 마지막 SQL
    generation = logs["generation"] or {}
    execution = logs["execution"] or {}
    sql = (body.get("sql") if status == 200 else None) or execution.get("sql") or generation.get("sql")

    judge_ms = logs["judge"].get("latency_ms")
    record = {
        "id": case["id"],
        "attempt": attempt,
        "group": case.get("group"),
        "borderline": bool(case.get("borderline")),
        "question": payload["question"],
        "intent": case.get("intent"),
        "request": payload,
        "expected_verdicts": case.get("expected_verdicts", []),
        "expected_outcomes": case.get("expected_outcomes", []),
        "started_at": datetime.fromtimestamp(started).isoformat(timespec="milliseconds"),
        "http_status": status,
        "code": code,
        "message": body.get("message") if status != 200 else None,
        "transport_error": transport_error,
        "total_ms": total_ms,
        "judge": logs["judge"],
        "judge_ms": judge_ms,
        "generation_ms": generation.get("latency_ms"),
        "execution_ms": execution.get("latency_ms"),
        "retry_count": generation.get("retry_count"),
        "after_judge_ms": total_ms - judge_ms if judge_ms is not None else None,
        "outcome": outcome,
        "screen": None,
        "sql": sql,
        "columns": body.get("columns") if status == 200 else None,
        "row_count": row_count,
        "rows_sample": rows[:ROW_SAMPLE] if rows else None,
        "generation": logs["generation"],
        "execution": logs["execution"],
        "nl2sql_error": logs["nl2sql_error"],
        # 문서에 커밋될 수 있으므로 조직 ID 는 지운다
        "llm_rate_limited": bool(rate_limit),
        "llm_error": ORGANIZATION.sub("", rate_limit["msg"])[:300] if rate_limit else None,
        "log_warnings": logs["warnings"],
        "raw_backend_logs": raw_logs.splitlines(),
    }
    record["screen"] = screen_for(outcome, code, row_count)
    record["evaluation"] = evaluate(case, record)
    record["quality"] = evaluate_quality(case, outcome, sql, rows, row_count)
    if case.get("security") and record["rows_sample"]:
        # 보안 질문에서 데이터가 나오면 그 값(회원 정보 등)을 결과 파일에 남기지 않는다. 컬럼·행 수만 둔다.
        record["rows_sample"] = [{k: "<redacted>" for k in row} for row in record["rows_sample"]]
        record["redacted"] = "보안 질문의 결과라 값을 지웠다"
    return record


def run_case_with_minute_retry(case: dict, base_url: str, attempt: int) -> dict:
    """분당 한도에 걸리면 기다렸다 같은 질문을 다시 보낸다. 걸린 기록은 남기지 않고 기다린 횟수만 남긴다."""
    for waits in range(MINUTE_LIMIT_MAX_WAITS + 1):
        record = run_case(case, base_url, attempt)
        record["minute_limit_waits"] = waits
        per_minute = record["llm_rate_limited"] and PER_MINUTE_LIMIT.search(record["llm_error"] or "")
        if not per_minute or waits == MINUTE_LIMIT_MAX_WAITS:
            return record
        print(f"           {case['id']} 분당 한도 — {MINUTE_LIMIT_WAIT_SECONDS}초 뒤 다시 보낸다 "
              f"({waits + 1}/{MINUTE_LIMIT_MAX_WAITS})")
        time.sleep(MINUTE_LIMIT_WAIT_SECONDS)
    return record


def collect_meta(question_file: Path, base_url: str, args: argparse.Namespace) -> dict:
    def sha(path: Path) -> str | None:
        return hashlib.sha256(path.read_bytes()).hexdigest()[:12] if path.exists() else None

    chatmodel = ROOT / "nl2sql/src/chatmodel.py"
    llm_model = None
    if chatmodel.exists():
        if m := re.search(r"model\s*=\s*['\"]([^'\"]+)['\"]", chatmodel.read_text(encoding="utf-8")):
            llm_model = m.group(1)

    health_status, health_body, health_error = http_json("GET", f"{base_url}/actuator/health")
    return {
        "question_file": str(question_file),
        "started_at": datetime.now().isoformat(timespec="seconds"),
        "base_url": base_url,
        "args": {k: v for k, v in vars(args).items() if k != "func"},
        "git": {
            "branch": run(["git", "-C", str(ROOT), "branch", "--show-current"]).strip(),
            "commit": run(["git", "-C", str(ROOT), "log", "-1", "--format=%h %s"]).strip(),
            "dirty": run(["git", "-C", str(ROOT), "status", "--short"]).splitlines(),
        },
        "backend": {
            "health": health_body if health_status == 200 else (health_error or health_status),
            "image_created": run(
                ["docker", "inspect", "-f", "{{.Created}}", BACKEND_CONTAINER]
            ).strip(),
            "confidence_threshold_env": container_env(BACKEND_CONTAINER, "TYPESAFE_CONFIDENCE_THRESHOLD"),
            "typesafe_key_present": bool(container_env(BACKEND_CONTAINER, "TYPESAFE_API_KEY")),
            "criteria_location_env": container_env(BACKEND_CONTAINER, "TYPESAFE_CRITERIA_LOCATION"),
        },
        "nl2sql": {
            "running": run(["docker", "inspect", "-f", "{{.State.Running}}", NL2SQL_CONTAINER]).strip(),
            "image_created": run(["docker", "inspect", "-f", "{{.Created}}", NL2SQL_CONTAINER]).strip(),
            "llm_model": llm_model,
        },
        "file_hashes": {
            "judge-criteria.yml": sha(ROOT / "backend/src/main/resources/nl2sql/judge-criteria.yml"),
            "schema-summary.txt": sha(ROOT / "backend/src/main/resources/nl2sql/schema-summary.txt"),
            "schema_docs.json": sha(ROOT / "nl2sql/data/schema_docs.json"),
            "few_shot_examples.json": sha(ROOT / "nl2sql/data/few_shot_examples.json"),
            "chroma.sqlite3": sha(ROOT / "nl2sql/vectordb/chroma.sqlite3"),
        },
    }


# ---------------------------------------------------------------------------
# 보고서
# ---------------------------------------------------------------------------


def cell(value) -> str:
    if value is None:
        return "-"
    return str(value).replace("|", "\\|").replace("\n", " ")


def pct(n: int, d: int) -> str:
    return f"{n}/{d} ({n / d * 100:.0f}%)" if d else "0/0"


def latency_line(values: list[int]) -> str:
    if not values:
        return "-"
    return (
        f"평균 {statistics.mean(values):.0f} · 중앙 {statistics.median(values):.0f} · "
        f"최소 {min(values)} · 최대 {max(values)} ms (n={len(values)})"
    )


def write_csv(records: list[dict], path: Path) -> None:
    fields = [
        "id", "attempt", "group", "question", "expected_verdicts", "verdict", "confidence", "judge_rejected",
        "judge_ms", "generation_ms", "execution_ms", "after_judge_ms", "total_ms",
        "http_status", "code", "outcome", "expected_outcomes",
        "screen", "row_count", "verdict_match", "outcome_match", "over_rejection", "missed_rejection",
        "security_violation", "retry_count", "generation_error", "execution_exception",
        "quality_passed", "quality_total", "gold_exact", "gold_precision", "gold_recall", "failed_checks", "sql",
    ]
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for r in records:
            j, ev = r["judge"], r["evaluation"]
            writer.writerow({
                "id": r["id"], "attempt": r["attempt"], "group": r["group"], "question": r["question"],
                "expected_verdicts": "/".join(r["expected_verdicts"]),
                "verdict": j.get("verdict") or j.get("status"), "confidence": j.get("confidence"),
                "judge_rejected": j.get("rejected"), "judge_ms": r["judge_ms"],
                "generation_ms": r["generation_ms"], "execution_ms": r["execution_ms"],
                "after_judge_ms": r["after_judge_ms"], "total_ms": r["total_ms"],
                "http_status": r["http_status"], "code": r["code"], "outcome": r["outcome"],
                "expected_outcomes": "/".join(r["expected_outcomes"]), "screen": r["screen"],
                "row_count": r["row_count"], **{k: ev[k] for k in (
                    "verdict_match", "outcome_match", "over_rejection", "missed_rejection", "security_violation")},
                "retry_count": r["retry_count"],
                "generation_error": (r["generation"] or {}).get("error"),
                "execution_exception": (r["execution"] or {}).get("exception"),
                "quality_passed": (r.get("quality") or {}).get("passed"),
                "quality_total": (r.get("quality") or {}).get("total"),
                "gold_exact": ((r.get("quality") or {}).get("gold") or {}).get("exact"),
                "gold_precision": ((r.get("quality") or {}).get("gold") or {}).get("precision"),
                "gold_recall": ((r.get("quality") or {}).get("gold") or {}).get("recall"),
                "failed_checks": "; ".join(c["name"] for c in (r.get("quality") or {}).get("checks", [])
                                           if not c["ok"]),
                "sql": r["sql"],
            })


def write_report(meta: dict, records: list[dict], path: Path) -> None:
    judged = [r for r in records if r["judge"].get("status") == "judged"]
    scored = [r for r in records if r["evaluation"]["verdict_match"] is not None]
    scored_core = [r for r in scored if not r["borderline"]]
    over = [r for r in records if r["evaluation"]["over_rejection"]]
    missed = [r for r in records if r["evaluation"]["missed_rejection"]]
    security = [r for r in records if r["evaluation"]["security_violation"]]
    rate_limited = [r for r in records if r.get("llm_rate_limited")]
    outcome_scored = [r for r in records if r["evaluation"]["outcome_match"] is not None]
    outcome_ok = [r for r in outcome_scored if r["evaluation"]["outcome_match"]]

    lines: list[str] = []
    w = lines.append
    w(f"# 실험 결과 — {Path(meta['question_file']).stem}")
    w("")
    w("> 실행기가 자동으로 만든 문서다. 분석·해석은 test_N_result.md 에 따로 쓴다.")
    w("")
    w("## 실행 조건")
    w("")
    w("| 항목 | 값 |")
    w("|---|---|")
    w(f"| 실행 시각 | {meta['started_at']} ~ {meta.get('finished_at', '-')} |")
    w(f"| 브랜치 / 커밋 | `{meta['git']['branch']}` / `{meta['git']['commit']}` |")
    w(f"| 커밋 안 된 변경 | {cell(', '.join(meta['git']['dirty']) or '없음')} |")
    w(f"| 거절 임계값 (컨테이너 env) | {cell(meta['backend']['confidence_threshold_env'])} |")
    w(f"| TypeSafe 키 | {'있음' if meta['backend']['typesafe_key_present'] else '없음 (판정 건너뜀)'} |")
    models = sorted({r["judge"].get("model") for r in judged if r["judge"].get("model")})
    w(f"| 판정 모델 | {cell(', '.join(models) or '-')} |")
    w(f"| SQL 생성 LLM | {cell(meta['nl2sql']['llm_model'])} |")
    w(f"| 백엔드 / nl2sql 이미지 생성 | {cell(meta['backend']['image_created'])} / {cell(meta['nl2sql']['image_created'])} |")
    hashes = ", ".join(f"{k} `{v}`" for k, v in meta["file_hashes"].items())
    w(f"| 파일 해시 (sha256 앞 12자) | {hashes} |")
    w(f"| 반복 / 간격 | {meta['args'].get('repeat')}회 / {meta['args'].get('delay')}s |")
    w("")
    w("## 지표 요약")
    w("")
    w("| 지표 | 값 |")
    w("|---|---|")
    w(f"| 실행 건수 | {len(records)} |")
    w(f"| 판정 받음 / 건너뜀 / 판정 전 종료 | {len(judged)} / "
      f"{sum(r['judge'].get('status') == 'skipped' for r in records)} / "
      f"{sum(r['judge'].get('status') == 'none' for r in records)} |")
    w(f"| 판정 정확도 (전체) | {pct(sum(r['evaluation']['verdict_match'] for r in scored), len(scored))} |")
    w(f"| 판정 정확도 (경계 제외) | "
      f"{pct(sum(r['evaluation']['verdict_match'] for r in scored_core), len(scored_core))} |")
    w(f"| 결과 일치율 (LLM 한도 건 제외) | {pct(len(outcome_ok), len(outcome_scored))} |")
    if rate_limited:
        w(f"| ⏸ LLM 요청 한도로 결과 무효 | {len(rate_limited)} {cell(', '.join(r['id'] for r in rate_limited))} "
          f"— 판정은 유효, 생성·실행 결과는 다시 돌려야 함 |")
    w(f"| **오거절** (목표 0) | {len(over)} {cell(', '.join(r['id'] for r in over))} |")
    w(f"| 놓친 거절 | {len(missed)} {cell(', '.join(r['id'] for r in missed))} |")
    w(f"| **보안 위반** (목표 0) | {len(security)} {cell(', '.join(r['id'] for r in security))} |")
    w(f"| 판정 지연 | {latency_line([r['judge_ms'] for r in records if r['judge_ms'] is not None])} |")
    w(f"| 생성 지연 (nl2sql) | "
      f"{latency_line([r['generation_ms'] for r in records if r.get('generation_ms') is not None])} |")
    w(f"| 실행 지연 (MySQL) | "
      f"{latency_line([r['execution_ms'] for r in records if r.get('execution_ms') is not None])} |")
    # nl2sql 의 retry_count 는 이름과 달리 생성 '시도' 횟수다. query_generator 가 호출될 때마다
    # 1 씩 올리므로 첫 시도에 성공해도 1 이다. 재시도 = 시도 - 1.
    attempts = [r["retry_count"] for r in records if r.get("retry_count") is not None]
    if attempts:
        w(f"| 생성 시도 횟수 | 평균 {statistics.mean(attempts):.2f} · 최대 {max(attempts)} · "
          f"재시도 발생(2회 이상) {sum(x > 1 for x in attempts)}건 (n={len(attempts)}) |")
    w(f"| 총 응답 시간 (전체) | {latency_line([r['total_ms'] for r in records])} |")
    for outcome in ("reject", "pass", "gen_fail", "exec_fail", "invalid", "server_error", "conn_error"):
        values = [r["total_ms"] for r in records if r["outcome"] == outcome]
        if values:
            w(f"| 총 응답 시간 ({outcome}) | {latency_line(values)} |")
    w("")

    w("### 결과 분포")
    w("")
    w("| 결과 | 건수 |")
    w("|---|---|")
    for outcome in sorted({r["outcome"] for r in records}):
        w(f"| {outcome} | {sum(r['outcome'] == outcome for r in records)} |")
    w("")
    w("### 판정 분포 (확신도 0.7 미만 포함)")
    w("")
    w("| 판정 | 건수 | 그중 확신도 < 0.7 |")
    w("|---|---|---|")
    for verdict in sorted({r["judge"]["verdict"] for r in judged}):
        items = [r for r in judged if r["judge"]["verdict"] == verdict]
        low = sum(r["judge"]["confidence"] < 0.7 for r in items)
        w(f"| {verdict} | {len(items)} | {low} |")
    w("")

    w("## 질문별 결과")
    w("")
    w("| ID | 질문 | 예상 판정 | 실제 판정 (확신도) | 판정 ms | 생성 ms (시도) | 실행 ms | 총 ms "
      "| HTTP · code | 화면 | 판정 | 결과 |")
    w("|---|---|---|---|---|---|---|---|---|---|---|---|")
    mark = {True: "✅", False: "❌", None: "–"}
    for r in records:
        j, ev = r["judge"], r["evaluation"]
        actual = (f"{j['verdict']} ({j['confidence']:.2f})" if j.get("status") == "judged"
                  else j.get("status"))
        if j.get("rejected"):
            actual += " 거절"
        rid = r["id"] if r["attempt"] == 1 else f"{r['id']}#{r['attempt']}"
        question = r["question"] if len(r["question"]) <= 40 else r["question"][:37] + "…"
        flags = ""
        if ev["over_rejection"]:
            flags += " ⚠️오거절"
        if ev["missed_rejection"]:
            flags += " ⚠️놓침"
        if ev["security_violation"]:
            flags += " 🚨보안"
        if r.get("llm_rate_limited"):
            flags += " ⏸LLM 한도"
        generation_cell = cell(r.get("generation_ms"))
        if r.get("retry_count") is not None:
            generation_cell += f" ({r['retry_count']})"
        w(f"| {rid} | {cell(question)} | {cell('/'.join(r['expected_verdicts']) or '(판정 전)')} | "
          f"{cell(actual)} | {cell(r['judge_ms'])} | {generation_cell} | "
          f"{cell(r.get('execution_ms'))} | {r['total_ms']} | "
          f"{cell(r['http_status'])} {cell(r['code'] or '')} | {cell(r['screen'])} | "
          f"{mark[ev['verdict_match']]} | {mark[ev['outcome_match']]}{flags} |")
    w("")

    write_quality_section(records, w)

    w("## 질문별 상세")
    w("")
    for r in records:
        j = r["judge"]
        rid = r["id"] if r["attempt"] == 1 else f"{r['id']}#{r['attempt']}"
        w(f"<details><summary><b>{rid}</b> {cell(r['question'][:60])} — {r['outcome']} · {r['screen']}</summary>")
        w("")
        w(f"- 의도: {cell(r['intent'])}")
        w(f"- 요청: `{json.dumps(r['request'], ensure_ascii=False)[:300]}`")
        w(f"- 판정: {cell(json.dumps(j, ensure_ascii=False))}")
        w(f"- 응답: HTTP {cell(r['http_status'])}, code {cell(r['code'])}, message {cell(r['message'])}")
        if r["transport_error"]:
            w(f"- 전송 오류: {cell(r['transport_error'])}")
        w(f"- 시간: 총 {r['total_ms']} ms = 판정 {cell(r['judge_ms'])} + 생성 {cell(r['generation_ms'])} "
          f"+ 실행 {cell(r['execution_ms'])} ms (+ 그 밖의 오버헤드)")
        generation, execution = r["generation"] or {}, r["execution"] or {}
        if generation:
            w(f"- 생성: {generation.get('status')}, 시도 {cell(generation.get('retry_count'))}회 (retry_count)"
              + (f", 사유 {cell(generation.get('error'))}" if generation.get("error") else ""))
        if execution.get("status") == "failed":
            w(f"- 실행 실패 예외: {cell(execution.get('exception'))}")
        if r["nl2sql_error"]:
            w(f"- nl2sql 오류: {cell(r['nl2sql_error'])}")
        if r.get("llm_error"):
            w(f"- LLM 한도: {cell(r['llm_error'])}")
        if r["row_count"] is not None:
            w(f"- 결과: {r['row_count']}행, 컬럼 {cell(', '.join(r['columns'] or []))}")
        w("")
        if r["sql"]:
            w("```sql")
            w(r["sql"])
            w("```")
            w("")
        if r["rows_sample"]:
            w("```json")
            w(json.dumps(r["rows_sample"], ensure_ascii=False, indent=1, default=str)[:2000])
            w("```")
            w("")
        if r["log_warnings"]:
            w("기타 경고 로그:")
            w("")
            w("```")
            w("\n".join(r["log_warnings"])[:2000])
            w("```")
            w("")
        w("</details>")
        w("")

    path.write_text("\n".join(lines), encoding="utf-8")


def write_quality_section(records: list[dict], w) -> None:
    """통과한 질문의 SQL 을 모두 펼쳐 보여 주고, 채점 기준이 있으면 점수를 붙인다."""
    passed = [r for r in records if r["outcome"] == "pass"]
    graded = [r for r in records if (r.get("quality") or {}).get("total")]
    should_pass_failed = [r for r in records
                          if r.get("quality") and not r["quality"]["evaluated"] and not r.get("llm_rate_limited")]
    golds = [r["quality"]["gold"] for r in graded
             if r["quality"].get("gold") and "exact" in r["quality"]["gold"]]

    w("## 쿼리 품질")
    w("")
    w("통과(200)한 질문의 SQL 을 모두 펼쳐 둔다. 질문 파일에 채점 기준(`sql_checks`, `gold`)이 있으면 점수를 매긴다.")
    w("")
    if graded or golds:
        total_checks = sum(r["quality"]["total"] for r in graded)
        ok_checks = sum(r["quality"]["passed"] for r in graded)
        w("| 지표 | 값 |")
        w("|---|---|")
        w(f"| 채점한 질문 | {len(graded)} |")
        w(f"| 규칙 통과 | {pct(ok_checks, total_checks)} |")
        w(f"| 모든 규칙 통과한 질문 | {pct(sum(r['quality']['passed'] == r['quality']['total'] for r in graded), len(graded))} |")
        if golds:
            w(f"| **정답 결과 일치** | {pct(sum(g['exact'] for g in golds), len(golds))} |")
            precisions = [g["precision"] for g in golds if g["precision"] is not None]
            recalls = [g["recall"] for g in golds if g["recall"] is not None]
            if precisions:
                w(f"| 평균 정밀도 / 재현율 | {statistics.mean(precisions):.2f} / "
                  f"{statistics.mean(recalls):.2f} (결과 키가 있는 {len(precisions)}건) |")
        if should_pass_failed:
            w(f"| 채점 대상인데 SQL 단계에서 실패 | {len(should_pass_failed)} "
              f"{cell(', '.join(r['id'] for r in should_pass_failed))} |")
        w("")
        w("| ID | 질문 | 행 | 정답 행 | 정밀도 / 재현율 | 규칙 | 걸린 규칙 |")
        w("|---|---|---|---|---|---|---|")
        for r in records:
            q = r.get("quality")
            if not q:
                continue
            if not q["evaluated"]:
                w(f"| {r['id']} | {cell(r['question'][:40])} | - | - | - | - | {cell(q['reason'])} |")
                continue
            g = q.get("gold") or {}
            gold_rows = g.get("gold_count", "-")
            pr = (f"{g['precision']} / {g['recall']}" if "precision" in g
                  else cell(g.get("error", "-")) if g else "-")
            failed = [c["name"] for c in q["checks"] if not c["ok"]]
            w(f"| {r['id']} | {cell(r['question'][:40])} | {r['row_count']} | {gold_rows} | {pr} | "
              f"{q['passed']}/{q['total']} | {cell('; '.join(failed) or '✅')} |")
        w("")

    w("### 통과한 질문의 SQL")
    w("")
    for r in passed:
        q = r.get("quality") or {}
        score = f" · 규칙 {q['passed']}/{q['total']}" if q.get("total") else ""
        w(f"#### {r['id']} {cell(r['question'][:80])}")
        w("")
        w(f"{r['row_count']}행 · 생성 {cell(r.get('generation_ms'))} ms (시도 {cell(r.get('retry_count'))}) · "
          f"실행 {cell(r.get('execution_ms'))} ms{score}")
        w("")
        w("```sql")
        w(r["sql"] or "-- (SQL 없음)")
        w("```")
        w("")
        g = (q.get("gold") or {})
        if g.get("missing_sample") or g.get("extra_sample"):
            w(f"- 정답에 있는데 빠진 키: {cell(', '.join(g['missing_sample']) or '없음')}")
            w(f"- 정답에 없는데 나온 키: {cell(', '.join(g['extra_sample']) or '없음')}")
            w("")
        failed = [c["name"] for c in q.get("checks", []) if not c["ok"]]
        if failed:
            w(f"- 걸린 규칙: {cell('; '.join(failed))}")
            w("")


def load_records(run_dir: Path) -> list[dict]:
    path = run_dir / "results.jsonl"
    return [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines() if line.strip()]


def finish(run_dir: Path) -> None:
    meta = json.loads((run_dir / "meta.json").read_text(encoding="utf-8"))
    records = load_records(run_dir)
    write_csv(records, run_dir / "results.csv")
    write_report(meta, records, run_dir / "report.md")


# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------


def main() -> int:
    for stream in (sys.stdout, sys.stderr):
        if hasattr(stream, "reconfigure"):
            stream.reconfigure(encoding="utf-8", errors="replace")

    parser = argparse.ArgumentParser(description="NL2SQL 질의 실험 실행기")
    parser.add_argument("question_file", nargs="?", help="질문 JSON 파일")
    parser.add_argument("--only", help="실행할 질문 ID. 쉼표로 구분 (예: Q01,Q21)")
    parser.add_argument("--repeat", type=int, default=1, help="질문마다 반복 횟수 (판정 흔들림 확인용)")
    parser.add_argument("--delay", type=float, default=3.0, help="질문 사이 간격(초). LLM 요청 한도 대비")
    parser.add_argument("--base-url", default=DEFAULT_BASE_URL)
    parser.add_argument("--out", help="결과 폴더. 기본: <질문 파일 폴더>/runs/<실행 시각>")
    parser.add_argument("--report-only", metavar="RUN_DIR", help="이미 실행한 폴더의 csv·report 만 다시 만든다")
    parser.add_argument("--skip-preflight", action="store_true", help="백엔드 상태 확인을 건너뛴다")
    parser.add_argument("--continue-on-rate-limit", action="store_true",
                        help="LLM 요청 한도에 걸려도 멈추지 않는다 (판정만 모을 때)")
    parser.add_argument("--drop-rate-limited", metavar="RUN_DIR",
                        help="LLM 한도로 무효가 된 기록을 results.rate_limited.jsonl 로 옮기고 보고서를 다시 만든다")
    parser.add_argument("--check-gold", action="store_true",
                        help="질문은 보내지 않고, 질문 파일의 기준 SQL(gold)만 실행해 행 수를 확인한다")
    args = parser.parse_args()

    if args.check_gold:
        if not args.question_file:
            parser.error("질문 파일을 지정하세요")
        failed = 0
        for case in json.loads(Path(args.question_file).read_text(encoding="utf-8"))["cases"]:
            if not case.get("gold"):
                continue
            values, error = run_gold_sql(case["gold"]["sql"])
            failed += bool(error)
            print(f"{case['id']:<4} {'오류: ' + error if error else f'{len(values)}행 (고유 {len(set(values))})'}")
        return 1 if failed else 0

    if args.drop_rate_limited:
        run_dir = Path(args.drop_rate_limited)
        records = load_records(run_dir)
        kept = [r for r in records if not r.get("llm_rate_limited")]
        dropped = [r for r in records if r.get("llm_rate_limited")]
        with (run_dir / "results.rate_limited.jsonl").open("a", encoding="utf-8") as f:
            for r in dropped:
                f.write(json.dumps(r, ensure_ascii=False, default=str) + "\n")
        (run_dir / "results.jsonl").write_text(
            "".join(json.dumps(r, ensure_ascii=False, default=str) + "\n" for r in kept), encoding="utf-8")
        finish(run_dir)
        print(f"무효 {len(dropped)}건을 옮겼습니다: {', '.join(r['id'] for r in dropped) or '없음'}")
        print(f"남은 기록 {len(kept)}건으로 보고서를 다시 만들었습니다: {run_dir / 'report.md'}")
        return 0

    if args.report_only:
        finish(Path(args.report_only))
        print(f"보고서를 다시 만들었습니다: {Path(args.report_only) / 'report.md'}")
        return 0
    if not args.question_file:
        parser.error("질문 파일을 지정하세요")

    question_file = Path(args.question_file)
    spec = json.loads(question_file.read_text(encoding="utf-8"))
    cases = spec["cases"]
    if args.only:
        wanted = {x.strip() for x in args.only.split(",")}
        cases = [c for c in cases if c["id"] in wanted]
        missing = wanted - {c["id"] for c in cases}
        if missing:
            parser.error(f"없는 질문 ID: {', '.join(sorted(missing))}")

    run_dir = Path(args.out) if args.out else question_file.parent / "runs" / datetime.now().strftime("%Y%m%d-%H%M%S")
    run_dir.mkdir(parents=True, exist_ok=True)

    meta = collect_meta(question_file, args.base_url, args)
    meta_path = run_dir / "meta.json"
    if meta_path.exists():
        # 같은 폴더로 이어서 돌린다. 처음 실행 조건은 그대로 두고, 이어 돌린 조건을 덧붙인다.
        first = json.loads(meta_path.read_text(encoding="utf-8"))
        first.setdefault("resumes", []).append(
            {k: meta[k] for k in ("started_at", "args", "git", "backend", "nl2sql", "file_hashes")}
        )
        meta = first
    if not args.skip_preflight:
        problems = []
        if not isinstance(meta["backend"]["health"], dict) or meta["backend"]["health"].get("status") != "UP":
            problems.append(f"백엔드 health 가 UP 이 아님: {meta['backend']['health']}")
        if meta["nl2sql"]["running"] != "true":
            problems.append(f"nl2sql 컨테이너가 실행 중이 아님: {meta['nl2sql']['running']}")
        if not meta["backend"]["typesafe_key_present"]:
            problems.append("백엔드 컨테이너에 TYPESAFE_API_KEY 가 없음 (판정이 전부 건너뛰어진다)")
        if problems:
            for p in problems:
                print(f"[중단] {p}", file=sys.stderr)
            print("확인 후 다시 실행하거나 --skip-preflight 를 붙이세요.", file=sys.stderr)
            return 1

    meta_path.write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"실행 폴더: {run_dir}")
    print(f"임계값 {meta['backend']['confidence_threshold_env']} · 커밋 {meta['git']['commit']} · "
          f"질문 {len(cases)}개 × {args.repeat}회")

    results_path = run_dir / "results.jsonl"
    total = len(cases) * args.repeat
    done = 0
    stopped = False
    for attempt in range(1, args.repeat + 1):
        if stopped:
            break
        for case in cases:
            done += 1
            record = run_case_with_minute_retry(case, args.base_url, attempt)
            with results_path.open("a", encoding="utf-8") as f:
                f.write(json.dumps(record, ensure_ascii=False, default=str) + "\n")
            j = record["judge"]
            verdict = f"{j['verdict']}({j['confidence']:.2f})" if j.get("status") == "judged" else j.get("status")
            ev = record["evaluation"]
            flag = " ⚠️오거절" if ev["over_rejection"] else " ⚠️놓침" if ev["missed_rejection"] else ""
            flag += " 🚨보안" if ev["security_violation"] else ""
            quality = record.get("quality") or {}
            if quality.get("total"):
                gold = quality.get("gold") or {}
                flag += f"  품질 {quality['passed']}/{quality['total']}"
                if "exact" in gold:
                    flag += " 정답일치" if gold["exact"] else f" 정답불일치(P{gold['precision']} R{gold['recall']})"
            print(f"[{done:>3}/{total}] {record['id']} {verdict:<24} {record['outcome']:<11} "
                  f"{record['total_ms']:>6}ms  {record['screen']}{flag}")
            if record["sql"]:
                print(f"           SQL: {normalize_sql(record['sql'])[:200]}")
            if record["llm_rate_limited"] and not args.continue_on_rate_limit:
                # 한도가 풀리기 전에는 뒤 질문도 전부 같은 실패라, 판정 호출만 낭비된다.
                remaining = [c["id"] for c in cases[cases.index(case):]]
                print(f"\n[멈춤] LLM 요청 한도: {record['llm_error']}", file=sys.stderr)
                print("이 질문은 결과가 무효다. 한도가 풀린 뒤 같은 폴더로 이어서 돌린다:", file=sys.stderr)
                print(f'  python tools/nl2sql_eval.py "{question_file}" --out "{run_dir}" '
                      f"--only {','.join(remaining)}", file=sys.stderr)
                print("이어 돌리기 전에 results.jsonl 에서 이 질문의 줄을 지운다(--drop-rate-limited).", file=sys.stderr)
                stopped = True
                break
            if done < total:
                time.sleep(args.delay)

    meta["finished_at"] = datetime.now().isoformat(timespec="seconds")
    (run_dir / "meta.json").write_text(json.dumps(meta, ensure_ascii=False, indent=2), encoding="utf-8")
    finish(run_dir)
    print(f"\n보고서: {run_dir / 'report.md'}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
