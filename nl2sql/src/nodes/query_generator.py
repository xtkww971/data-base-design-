from src.state import GraphState
from langchain_core.prompts import ChatPromptTemplate
from src.chatmodel import get_llm
from pydantic import Field, BaseModel
from tools.budget import format_part_budgets
from src.prompts.query_generator_prompt import (
    SYSTEM_PROMPT, HUMAN_PROMPT, PROGRAM_SPEC_PROMPT,
    BUDGET_PROMPT, PART_BUDGET_PROMPT, RETRY_PROMPT,
)

class SQLGenerationResult(BaseModel):
    sql: str = Field(default="", description="생성된 SQL 쿼리. 마크다운 코드블록 없이 순수 SQL 텍스트만")
    error: str = Field(default="", description="LLM이 판단하기에 정보가 부족하거나 생성 불가할 때 에러 사유 기록")


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
    program_specs = state.get("program_specs", "")
    budget_min = state.get("budget_min")
    budget_max = state.get("budget_max")
    usage = state.get("usage", "")


    message = [
        ("system", SYSTEM_PROMPT),
        ("human", HUMAN_PROMPT)
    ]

    input_variables = {
        "schema_info": schema,
        "few_shot_examples": example,
        "question": question
    }

    if program_specs:
        message.append(("human", PROGRAM_SPEC_PROMPT))
        input_variables["program_specs"] = program_specs

    if budget_min is not None or budget_max is not None:
        # 용도를 판단했으면 부품별 상한을, 아니면 전체 예산을 상한으로 사용
        if usage and budget_max is not None:
            message.append(("human", PART_BUDGET_PROMPT))
            input_variables.update({
                "usage": usage,
                "part_budgets": format_part_budgets(usage, budget_max)
            })
        else:
            message.append(("human", BUDGET_PROMPT))

        input_variables.update({
            "budget_min": f"{budget_min}원" if budget_min is not None else "제한 없음",
            "budget_max": f"{budget_max}원" if budget_max is not None else "제한 없음"
        })

    if state["retry_count"] > 0:
        message.append(("human", RETRY_PROMPT))
        input_variables.update({
            "previous_query": query,
            "error_msg": error
        })

    chain = ChatPromptTemplate.from_messages(message) | get_llm().with_structured_output(SQLGenerationResult, method="json_mode")

    result : SQLGenerationResult = chain.invoke(input_variables)
    
    return {
        "query" : result.sql,
        "retry_count" : state["retry_count"] + 1,
        "error": ""
    }

