import json 
import chromadb
from chromadb.utils import embedding_functions

chroma_client = chromadb.PersistentClient(path="./vectordb")

bge_m3_ef = embedding_functions.SentenceTransformerEmbeddingFunction(
    model_name="BAAI/bge-m3"
)

#collection 생셩(DB의 테이블 같은 개념)
schema_collection = chroma_client.get_or_create_collection(
    name="schema_collection",
    embedding_function=bge_m3_ef
)
fewshot_collection = chroma_client.get_or_create_collection(
    name="fewshot_collection",
    embedding_function=bge_m3_ef
)




def init_vector_db_if_need():
    """vectordata 생성 함수, 프로그램 실행 처음에만 실행한다."""

    schema_count = schema_collection.count()
    fewshot_count = fewshot_collection.count()

    if schema_count == 0 or fewshot_count == 0:
        print("vector db 생성")

        #스키마 데이터 임베딩
        with open("data/schema_docs.json", "r", encoding="utf-8") as f:
            schemas = json.load(f)
            for i , schema in enumerate(schemas):
                schema_collection.upsert(
                    documents=[json.dumps(schema, ensure_ascii=False)],
                    ids=[f"schema_{i}"]
                )

        with open("data/few_shot_examples.json", "r", encoding="utf-8") as f:
            few_shots = json.load(f)
            for i , fs in enumerate(few_shots):
                fewshot_collection.upsert(
                    documents=[fs["question"]],
                    metadatas=[{"query": fs["sql"]}],
                    ids=[f"fewshot_{i}"]
                )


def get_schema(question: str) -> str:
    """질문과 연관된 스키마 정보를 반환"""
    results = schema_collection.query(
        query_texts=[question],
        n_results= 3
    )

    docs = results.get("documents", [[]])[0]
    return "\n".join(docs) if docs else "관련 스키마 없음"

def get_examples(question: str) -> str:
    """few shot을 위한 질문-쿼리 예시문을 반환"""
    results = fewshot_collection.query(
        query_texts=[question],
        n_results=3
    )

    docs = results.get("documents", [[]])[0]
    metas = results.get("metadatas", [[]])[0]

    few_shot_str = ""
    for doc, meta in zip(docs, metas):
        few_shot_str += f"Question: {doc}\nSQL: {meta['query']}\n\n"

    return few_shot_str if few_shot_str else "참고할 예시 없음"    