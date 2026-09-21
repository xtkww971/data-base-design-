from src.state import GraphState
from langchain_core.prompts import ChatPromptTemplate
from src.chatmodel import get_llm
from pydantic import Field, BaseModel

class SQLGenerationResult(BaseModel):
    sql: str = Field(description="생성된 SQL 쿼리. 마크다운 코드블록 없이 순수 SQL 텍스트만")


SYSTEM_PROMPT = """당신은 숙력된 SQL 엔지니어 입니다. 주어진 스키마 정보와 예시 쿼리문을 
참고하여 사용자 질문에 답하는 SQL 쿼리문을 작성하세요

다음과 규칙을 따라 작성하세요.
1. INSERT/UPDATE/DELETE/DROP 등은 절대 사용하지 마세요.
2. 스키마에 없는 테이블/컬럼명을 지어내지 마세요.
3. 결과행이 많더라도 LIMIT은 사용하지 마세요.
4. 출력은 반드시 json 형태로 출력하세요
5. 만약 테이블 이름이나 컬럼명(스키마) 정보가 부족하여 SQL을 생성할 수 없다면 'sql' 필드에 "스키마 정보 부족"문자열을 담으세요"
"""

RETRY_PROMPT = """이전에 생성한 쿼리에 문제가 발생하였습니다. 오류를 참고해서 수정하세요

이전쿼리:{previous_query}

오류내용:{error_msg}
"""

def query_generator(state: GraphState):
    """
    사용자의 자연어 질의를 쿼리문으로 바꿔 생성해주는 노드

    Args:
        state: GraphState
    Return
        query: 생성된 SQL 쿼리
        retry_count: 재시도 횟수
    """
    question = state["question"]
    schema = state.get("schema_info", "")
    example = state.get("query_example", "")
    query = state.get("query", "")
    error= state.get("error", "")


    message = [
        ("system", SYSTEM_PROMPT),
        ("human", f"DB스키마 정보:\n{schema}\n\n예시 쿼리문:\n{example}\n\n질문:\n{question}")
    ]
    if state["retry_count"] > 0:
        message.append(("human", RETRY_PROMPT.format(
            previous_query = query,
            error_msg = error
        )))

    chain = ChatPromptTemplate.from_messages(message) | get_llm().with_structured_output(SQLGenerationResult, method="json_mode")

    result : SQLGenerationResult = chain.invoke({
        "schema_info": schema,
        "few_shot_examples": example,
        "question": question
    })

    return {
        "query" : result.sql,
        "retry_count" : state["retry_count"] + 1,
        "error": ""
    }

