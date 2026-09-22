from src.state import GraphState
from tools.retriever import get_examples

def example_retriever(state: GraphState):
    """
    few shot을 위해 질문-답변 예시 데이터를 가져옴

    Args:
        state: GranphState 

    Returns:
        query_example: 예시 데이터 상태 업데이트 
    """

    question = state["question"]

    #vector DB에서 질의-답변 예시 데이터 return
    examples = get_examples(question)
    return {"query_example":examples}