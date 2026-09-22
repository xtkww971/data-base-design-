from src.state import GraphState
from tools.db_executor import validate_sql

def validator(state: GraphState):
    """
    생성된 쿼리문에 DB를 조작하는 명령문이 존재하는지, 오류가 없는지 검증
    """
    query = state['query']
    is_valid, error_msg = validate_sql(state["query"])

    if not is_valid:
        return {'error': error_msg}

    return {'error': ''}