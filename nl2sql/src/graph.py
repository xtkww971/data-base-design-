from langgraph.graph import StateGraph, START, END

from src.state import GraphState
from src.nodes.example_retriever import example_retriever
from src.nodes.program_spec_retriever import program_spec_retriever
from src.nodes.query_generator import query_generator
from src.nodes.schema_retriever import schema_retriever
from src.nodes.usage_classifier import usage_classifier
from src.nodes.validator import validator

MAX_RETRY = 3

def route_by_programs(state: GraphState)-> str:
    """사용자가 프로그램을 입력했으면 권장 사양을 검색하고, 아니면 건너뜀"""
    if state.get("programs"):
        return "program"
    return "schema"

def route_after_validation(state: GraphState)-> str:
    """쿼리 검증 후 재생성할지 종료할지 판단"""
    if state.get("error") == "":
        return "end"
    if state.get("retry_count") >= MAX_RETRY:
        return "end"
    return "retry"

def build_graph():
    builder = StateGraph(GraphState)

    builder.add_node("program_spec_retriever", program_spec_retriever)
    builder.add_node("usage_classifier", usage_classifier)
    builder.add_node("schema_retriever", schema_retriever)
    builder.add_node("example_retriever", example_retriever)
    builder.add_node("query_generator", query_generator)
    builder.add_node("validator", validator)

    builder.add_conditional_edges(
        START,
        route_by_programs,
        {"program": "program_spec_retriever", "schema": "schema_retriever"}
    )
    builder.add_edge("program_spec_retriever", "usage_classifier")
    builder.add_edge("usage_classifier", "schema_retriever")
    builder.add_edge("schema_retriever", "example_retriever")
    builder.add_edge("example_retriever", "query_generator")
    builder.add_edge("query_generator", "validator" )

    builder.add_conditional_edges(
        "validator",
        route_after_validation,
        {"retry": "query_generator", "end": END}
    )

    return builder.compile()

