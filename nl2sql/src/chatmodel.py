from langchain_groq import ChatGroq
from dotenv import load_dotenv

load_dotenv()

_llm = ChatGroq(
    model='openai/gpt-oss-120b',
    temperature=0
)

def get_llm():
    return _llm