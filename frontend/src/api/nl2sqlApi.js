// 백엔드 자연어 질의 API (/api/nl2sql). 질문을 SQL 로 바꿔 실행한 결과 표를 받는다.

/**
 * 응답: { question, sql, columns: string[], rows: object[], rowCount }
 * LLM 이 SQL 을 만들고 실행하므로 수십 초 걸릴 수 있다.
 * @param {string} question
 */
export async function queryNl2Sql(question) {
  let response;
  try {
    response = await fetch('/api/nl2sql/query', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ question }),
    });
  } catch {
    throw new Error('서버에 연결할 수 없습니다.');
  }

  if (!response.ok) {
    const error = await response.json().catch(() => null);
    throw new Error(error?.message ?? `견적 생성에 실패했습니다. (${response.status})`);
  }
  return response.json();
}
