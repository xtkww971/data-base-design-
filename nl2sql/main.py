from contextlib import asynccontextmanager

from fastapi import FastAPI
from pydantic import BaseModel, Field

from tools.retriever import init_vector_db_if_need
from src.graph import build_graph


class QueryRequest(BaseModel):
    question: str = Field(min_length=1, description="사용자의 자연어 질문")


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
    result = app.state.graph.invoke({"question": request.question, "retry_count": 0})

    return QueryResponse(
        query=result.get("query", ""),
        error=result.get("error", ""),
        retry_count=result.get("retry_count", 0),
    )


if __name__ == "__main__":
    init_vector_db_if_need()
    graph = build_graph()

    question = "가장 많이 팔린 상품 5개는?"
    result = graph.invoke({"question": question, "retry_count" : 0})

    print("최종 sql:\n" + result["query"])
