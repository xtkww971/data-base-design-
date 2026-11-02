from contextlib import asynccontextmanager

from fastapi import FastAPI
from pydantic import BaseModel, Field, model_validator

from tools.retriever import init_vector_db_if_need
from src.graph import build_graph


class QueryRequest(BaseModel):
    question: str = Field(min_length=1, description="사용자의 자연어 질문")
    programs: list[str] | None = Field(default=None, description="컴퓨터로 사용할 주요 프로그램 이름")
    budget_min: int | None = Field(default=None, ge=0, description="예산 최솟값. 원 단위 정수")
    budget_max: int | None = Field(default=None, ge=0, description="예산 최댓값. 원 단위 정수")


class QueryResponse(BaseModel):
    query: str = Field(default="", description="생성된 SQL 쿼리")
    error: str = Field(default="", description="검증 실패 시 에러 메시지")
    retry_count: int = Field(default=0, description="쿼리 생성 시도 횟수")


@asynccontextmanager
async def lifespan(app: FastAPI):
    #vector DB 없으면 구축
    init_vector_db_if_need()

    #노드 연결, 서버 기동 시 한 번만 빌드해서 재사용
    app.state.graph = build_graph()
    yield


app = FastAPI(title="nl2sql", lifespan=lifespan)


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/query", response_model=QueryResponse)
def query(request: QueryRequest):
    # graph.invoke가 동기 함수이므로 def로 선언해 스레드풀에서 실행
    programs = [program.strip() for program in request.programs or [] if program.strip()]

    result = app.state.graph.invoke({
        "question": request.question,
        "programs": programs,
        "budget_min": request.budget_min,
        "budget_max": request.budget_max,
        "retry_count": 0
    })

    return QueryResponse(
        query=result.get("query", ""),
        error=result.get("error", ""),
        retry_count=result.get("retry_count", 0),
    )


if __name__ == "__main__":
    init_vector_db_if_need()
    graph = build_graph()

    test_inputs = [
        # 질문만 입력
        {"question": "가장 많이 팔린 상품 5개는?"},
        # 프로그램만 입력
        {"question": "그래픽카드 추천해줘", "programs": ["배그", "포토샵"]},
        # 예산만 입력
        {"question": "그래픽카드 추천해줘", "budget_min": 1000000, "budget_max": 2000000},
        # 프로그램, 예산 모두 입력
        {"question": "그래픽카드 추천해줘", "programs": ["배그"], "budget_max": 2000000},
    ]

    for test_input in test_inputs:
        result = graph.invoke({**test_input, "retry_count": 0})
        print(f"입력: {test_input}")
        print("최종 sql:\n" + result["query"])
