from tools.retriever import init_vector_db_if_need
from src.graph import build_graph



if __name__ == "__main__":
    #vector DB 없으면 구축
    init_vector_db_if_need()

    #노드 연결
    graph = build_graph()


    question = "가장 많이 팔린 상품 5개는?"
    result = graph.invoke({"question": question, "retry_count" : 0})

    print("최종 sql:\n" + result["query"])


   


