from langchain_groq import ChatGroq
from dotenv import load_dotenv

load_dotenv()

_llm = ChatGroq(
    model='openai/gpt-oss-120b',
    temperature=0,
    # 이 모델은 추론 토큰도 완성 토큰에 포함된다. 기본값으로는 프로그램 권장 사양과
    # 부품별 예산 상한까지 붙은 프롬프트에서 JSON 을 끝내기 전에 한도에 걸려
    # groq 가 json_validate_failed(400) 를 돌려준다.
    max_tokens=8192
)

def get_llm():
    return _llm