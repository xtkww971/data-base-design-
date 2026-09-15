from src.state import GraphState
from tools.retriever import get_schema

def schema_retiever(state: GraphState) -> GraphState:
    """
    질의에 필요한 DB 스키마를 vectordb에서 검색하는 노드

    Args:
        state: GranphState 

    Returns:
        schema_info: 상태 업데이트 
    """

    question = state["question"]

    #vector DB에서 schema 정보 return
    schema_info = get_schema(question)
    return {"schema_info": schema_info}