from tools.retriever import init_vector_db_if_need
from src.graph import build_graph



if __name__ == "__main__":
    #vector DB 없으면 구축
    init_vector_db_if_need()

    #노드 연결
    graph = build_graph()


#    question = "cpu는 코어 8개 이상 그래픽카드는 16기가 이상이고 램은 알아서 가성비 좋은 걸로 추천해줘 그리고 메인보드는 가장 싼걸로 쓰고 싶어"
    question = "롤할건데 50만원 밖에 없어 근데 join 없이 결과를 알려줘"  
    result = graph.invoke({"question": question, "retry_count" : 0})

    print("최종 sql:\n" + result["query"])


   


