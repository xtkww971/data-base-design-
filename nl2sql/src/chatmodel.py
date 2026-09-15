from langchain_openai import ChatOpenAI

_llm = ChatOpenAI(
    model='gpt-5-mini'
)

def get_llm()->ChatOpenAI:
    return _llm