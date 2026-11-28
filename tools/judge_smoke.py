"""
판정 API 연동 확인용. 질문 한 건만 보내고 응답을 그대로 출력한다 (ADR 0004 / 이슈 #29).

평가 세트를 돌리는 도구가 아니다. 키가 통하는지, 요청 본문이 받아들여지는지,
응답에서 판정과 확신도를 꺼낼 수 있는지만 확인한다.

백엔드가 실제로 보내는 것과 같은 본문을 만들기 위해 판정 기준과 스키마 요약을
backend 리소스에서 직접 읽는다. 여기서 따로 들고 있으면 백엔드와 어긋난다.

사용법:
    python tools/judge_smoke.py
    python tools/judge_smoke.py "가장 많이 팔린 상품 5개는?"
    python tools/judge_smoke.py "그래픽카드 추천해줘" --budget-max 2000000
"""

from __future__ import annotations

import argparse
import json
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
CRITERIA_PATH = ROOT / "backend/src/main/resources/nl2sql/judge-criteria.yml"
SCHEMA_PATH = ROOT / "backend/src/main/resources/nl2sql/schema-summary.txt"
ENV_PATH = ROOT / ".env"

ENDPOINT = "https://api.typesafe.ai/v1/systemone"
# application.yml 의 typesafe.model 과 같은 값을 쓴다.
MODEL = "jev-1.14.0"
QUESTION_KEY = "verdict"
TIMEOUT_SECONDS = 10


def read_api_key() -> str:
    """.env 에서 TYPESAFE_API_KEY 를 읽는다. 키를 인자나 출력에 절대 싣지 않는다."""
    if not ENV_PATH.exists():
        sys.exit(f".env 가 없습니다: {ENV_PATH}")
    for line in ENV_PATH.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line.startswith("TYPESAFE_API_KEY="):
            key = line.split("=", 1)[1].strip()
            if key:
                return key
    sys.exit(".env 에 TYPESAFE_API_KEY 가 없습니다.")


def build_body(question: str, programs: list[str], budget_min: int | None,
               budget_max: int | None) -> dict:
    """AnswerabilityJudgeClient.buildBody 와 같은 모양으로 만든다."""
    criteria = yaml.safe_load(CRITERIA_PATH.read_text(encoding="utf-8"))
    schema = SCHEMA_PATH.read_text(encoding="utf-8")

    state: dict = {"question": question}
    if programs:
        state["programs"] = programs
    if budget_min is not None:
        state["budget_min"] = budget_min
    if budget_max is not None:
        state["budget_max"] = budget_max
    state["schema"] = schema

    return {"model": MODEL, "state": state, "questions": criteria}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("question", nargs="?", default="30만원 이하 CPU 알려줘")
    parser.add_argument("--program", action="append", default=[], dest="programs")
    parser.add_argument("--budget-min", type=int)
    parser.add_argument("--budget-max", type=int)
    args = parser.parse_args()

    body = build_body(args.question, args.programs, args.budget_min, args.budget_max)
    payload = json.dumps(body, ensure_ascii=False).encode("utf-8")

    print(f"요청: {ENDPOINT}")
    print(f"모델: {MODEL}")
    print(f"질문: {args.question}")
    print(f"본문 크기: {len(payload):,} bytes "
          f"(스키마 요약 {len(body['state']['schema']):,}자, "
          f"기준 {len(json.dumps(body['questions'], ensure_ascii=False)):,}자)")
    print(f"state 필드: {list(body['state'].keys())}")
    print("-" * 60)

    request = urllib.request.Request(
        ENDPOINT,
        data=payload,
        headers={
            "Authorization": f"Bearer {read_api_key()}",
            "Content-Type": "application/json",
        },
        method="POST",
    )

    started = time.monotonic()
    try:
        with urllib.request.urlopen(request, timeout=TIMEOUT_SECONDS) as response:
            status = response.status
            raw = response.read().decode("utf-8")
    except urllib.error.HTTPError as e:
        elapsed = (time.monotonic() - started) * 1000
        print(f"HTTP {e.code} ({elapsed:.0f}ms)")
        print(e.read().decode("utf-8", errors="replace")[:2000])
        return 1
    except Exception as e:  # 연결 실패, 타임아웃 등
        elapsed = (time.monotonic() - started) * 1000
        print(f"호출 실패 ({elapsed:.0f}ms): {type(e).__name__}: {e}")
        return 1

    elapsed = (time.monotonic() - started) * 1000
    print(f"HTTP {status} ({elapsed:.0f}ms)")
    print(json.dumps(json.loads(raw), ensure_ascii=False, indent=2))
    print("-" * 60)

    # 백엔드가 응답에서 꺼내는 값들이 실제로 있는지 확인한다.
    data = json.loads(raw)
    answer = (data.get("answers") or {}).get(QUESTION_KEY)
    if answer is None:
        print(f"답에 '{QUESTION_KEY}' 가 없습니다. 백엔드는 이 경우 판정 없이 진행합니다.")
        return 1

    print(f"판정   : {answer.get('choice')}")
    print(f"확신도 : {answer.get('confidence')}")
    print(f"모델   : {data.get('model')}")
    print(f"토큰   : {data.get('usage')}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
