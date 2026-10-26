from langchain_core.prompts import ChatPromptTemplate
from pydantic import BaseModel, Field

from src.chatmodel import get_llm
from src.state import GraphState


class PriceRange(BaseModel):
    min: int | None = Field(default=None, description="최소 가격. 원 단위 정수")
    max: int | None = Field(default=None, description="최대 가격. 원 단위 정수")


class SpecCondition(BaseModel):
    name: str = Field(description="스펙 이름. 예: VRAM, 코어 수, 주사율")
    operator: str = Field(default="=", description="비교 연산자 (=, >, >=, <, <=)")
    value: str = Field(description="비교 값. 단위 포함. 예: 16GB, 144Hz")


class QuestionKeywords(BaseModel):
    categories: list[str] = Field(default=[], description="부품 카테고리 코드")
    brands: list[str] = Field(default=[], description="제조사")
    price: PriceRange = Field(default_factory=PriceRange, description="가격 조건")
    specs: list[SpecCondition] = Field(default=[], description="스펙 조건")
    program: list[str] = Field(default=[], description="PC로 사용하려는 프로그램. 예: 롤, 배그, 포토샵")


SYSTEM_PROMPT = """당신은 PC 부품 쇼핑몰의 검색 질의 분석기입니다.
사용자 질문을 읽고 키워드를 분류해 json으로만 출력하세요.

다음 규칙을 따르세요.
1. 질문에 없는 내용은 지어내지 말고 빈 값(null, [])으로 두세요.
2. categories는 CPU, MAINBOARD, RAM, GPU, POWER, SSD, HDD, MONITOR 중에서만 고르세요. (그래픽카드 → GPU, 파워 → POWER)
3. brands는 질문에 나온 제조사를 넣으세요.
4. price는 원 단위 정수로 변환하세요. (150만원 이하 → max 1500000, 50만원대 → min 500000 / max 599999, 300만원 안팎 → min 2700000 / max 3300000)
5. specs에는 가격 외의 성능·규격 조건을 넣으세요. (VRAM 16GB 이상 → name: VRAM, operator: >=, value: 16GB)
6. program에는 PC를 사용하려는 게임·프로그램 이름을 질문에 나온 그대로 넣으세요. (롤을 할 때 필요한 컴퓨터 스펙 → 롤)

출력 형식:
{output_format}
"""

HUMAN_PROMPT = """질문:
{question}
"""

OUTPUT_FORMAT = """{
  "categories": ["GPU"],
  "brands": ["MSI"],
  "price": {"min": null, "max": 1000000},
  "specs": [{"name": "VRAM", "operator": ">=", "value": "16GB"}],
  "program": ["배그"]
}"""


def keyword_extractor(state: GraphState):
    """
    자연어 질의에서 카테고리, 제조사, 가격, 스펙, 사용 프로그램 키워드를 분류하는 노드

    Args:
        state: GraphState

    Returns:
        keywords: 키워드별로 분류한 dict
    """
    question = state["question"]

    chain = ChatPromptTemplate.from_messages([
        ("system", SYSTEM_PROMPT),
        ("human", HUMAN_PROMPT)
    ]) | get_llm().with_structured_output(QuestionKeywords, method="json_mode")

    result: QuestionKeywords = chain.invoke({
        "output_format": OUTPUT_FORMAT,
        "question": question
    })

    return {"keywords": result.model_dump()}
