from src.state import GraphState
from langchain_core.prompts import ChatPromptTemplate
from src.chatmodel import get_llm
from pydantic import Field, BaseModel
from tools.budget import BUDGET_RATIOS

class UsageResult(BaseModel):
    usage: str = Field(default="", description="프로그램으로 판단한 PC 용도")


USAGE_PROMPT = """사용자가 PC로 사용할 프로그램을 보고 용도를 하나만 고르세요.

용도 후보: {usages}
프로그램: {programs}
권장 사양:
{program_specs}

다음 규칙을 따르세요.
1. 용도는 후보에 있는 값을 그대로 출력하세요.
2. 프로그램이 여러 개면 가장 높은 사양이 필요한 프로그램을 기준으로 고르세요.
3. 로컬 AI 모델을 실행하는 프로그램은 3D·CAD로 고르세요.
4. 출력은 반드시 json 형태로 {{"usage": "용도"}}처럼 작성하세요.
"""

def usage_classifier(state: GraphState):
    """
    사용자가 입력한 프로그램으로 PC 용도를 판단하는 노드

    Args:
        state: GraphState

    Returns:
        usage: 판단한 용도. 최대 예산이 없거나 후보에 없는 값이면 빈 문자열
    """
    # 최대 예산이 없으면 부품별 상한을 계산할 수 없으므로 LLM을 호출하지 않음
    if state.get("budget_max") is None:
        return {"usage": ""}

    chain = ChatPromptTemplate.from_messages([("human", USAGE_PROMPT)]) | get_llm().with_structured_output(UsageResult, method="json_mode")

    result : UsageResult = chain.invoke({
        "usages": ", ".join(BUDGET_RATIOS),
        "programs": ", ".join(state["programs"]),
        "program_specs": state.get("program_specs") or "없음"
    })

    return {"usage": result.usage if result.usage in BUDGET_RATIOS else ""}
