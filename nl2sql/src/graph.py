from langgraph.graph import StateGraph, START, END

from src.state import GraphState
from src.nodes.example_retriever import example_retriever
from src.nodes.query_generator import query_generator
from src.nodes.schema_retriever import schema_retriever
from src.nodes.validator import validator

MAX_RETRY = 3

def route_after_validation(state: GraphState)-> str:
    """쿼리 검증 후 재생성할지 종료할지 판단"""
    if state.get("error") == "":
        return "end"
    if state.get("retry_count") >= MAX_RETRY:
        return "end"
    return "retry"

def build_graph():
    builder = StateGraph(GraphState)

    builder.add_node("schema_retriever", schema_retriever)
    builder.add_node("example_retriever", example_retriever)
    builder.add_node("query_generator", query_generator)
    builder.add_node("validator", validator)

    builder.add_edge(START, "schema_retriever")
    builder.add_edge("schema_retriever", "example_retriever")
    builder.add_edge("example_retriever", "query_generator")
    builder.add_edge("query_generator", "validator" )

    builder.add_conditional_edges(
        "validator",
        route_after_validation,
        {"retry": "query_generator", "end": END}
    )

    return builder.compile()

