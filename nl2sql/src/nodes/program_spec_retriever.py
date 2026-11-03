from src.state import GraphState
from tools.retriever import get_program_requirements

def program_spec_retriever(state: GraphState):
    """
    사용자가 입력한 프로그램의 권장 사양을 vectordb에서 검색하는 노드

    Args:
        state: GraphState

    Returns:
        program_specs: 프로그램 권장 사양 상태 업데이트. 찾지 못한 프로그램은 제외
    """

    specs = []
    for program in state["programs"]:
        requirements = get_program_requirements(program)
        if requirements:
            specs.append(f"{program}: {requirements}")

    return {"program_specs": "\n".join(specs)}
