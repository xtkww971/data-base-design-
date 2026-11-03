from typing import TypedDict
from typing_extensions import Annotated 
from pydantic import Field

class GraphState(TypedDict):
    question: Annotated[str, Field(default='', description="사용자의 자연어 질문")]
    programs: Annotated[list[str], Field(default=[], description="사용자가 입력한 주요 프로그램 이름. 입력하지 않으면 빈 값")]
    budget_min: Annotated[int | None, Field(default=None, description="사용자가 입력한 예산 최솟값. 원 단위 정수")]
    budget_max: Annotated[int | None, Field(default=None, description="사용자가 입력한 예산 최댓값. 원 단위 정수")]
    program_specs: Annotated[str, Field(default='', description="vector db에서 검색해 온 프로그램 권장 사양")]
    usage: Annotated[str, Field(default='', description="프로그램으로 판단한 PC 용도. 판단하지 못하면 빈 값")]
    schema_info: Annotated[str, Field(default='', description="vector db에서 검색해 온 관련 테이블 스키마 정보")]
    query_example: Annotated[str, Field(default='', description="few shot을 위한 쿼리 예시문")]
    query: Annotated[str, Field(default='', description="생성된 SQL 쿼리. 순수 SQL 텍스트만 저장")]
    error: Annotated[str, Field(default='', description="쿼리 검증 단계에서 발생한 에러 메시지")]
    retry_count: Annotated[int, Field(default=0, description="llm이 검증을 통과하지 못하고 재시도한 횟수")]
