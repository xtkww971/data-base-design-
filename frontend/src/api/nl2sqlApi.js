// 백엔드 자연어 질의 API (/api/nl2sql). 백엔드가 nl2sql 서비스로 SQL 을 만들고 DB 에서 실행한 결과를 돌려준다.

/**
 * 자연어 질의. 응답: NlQueryResponse { question, sql, columns, rows, rowCount }
 * rows 의 각 항목은 { 컬럼명: 값 } 형태다.
 * 실패하면 백엔드 ErrorResponse 의 message 를 담은 Error 를 던진다.
 * @param {string} question
 * @param {AbortSignal} [signal]
 */
export async function queryNl2Sql(question, signal) {
  let response;
  try {
    response = await fetch('/api/nl2sql/query', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ question }),
      signal,
    });
  } catch (error) {
    if (error.name === 'AbortError') {
      throw error;
    }
    throw new Error('서버에 연결할 수 없습니다. 잠시 후 다시 시도해 주세요.', { cause: error });
  }

  const body = await response.json().catch(() => null);
  if (!response.ok) {
    throw new Error(body?.message ?? `질의에 실패했습니다. (${response.status})`);
  }
  return body;
}
