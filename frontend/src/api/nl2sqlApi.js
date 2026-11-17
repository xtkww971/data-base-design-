// 백엔드 자연어 질의 API (/api/nl2sql). 개발 중에는 vite.config.js 의 프록시가 /api 를 백엔드(8080)로 넘겨준다.
import { ApiError } from './authApi.js';

// 백엔드 ErrorCode 별로 화면에 보여줄 문구
const ERROR_MESSAGES = {
  NL2SQL_GENERATION_FAILED: '질문을 이해하지 못했어요. 예산이나 용도를 조금 더 구체적으로 적어 주세요.',
  NL2SQL_EXECUTION_FAILED: '견적을 조회하는 중 문제가 생겼어요. 잠시 후 다시 시도해 주세요.',
};

/**
 * 자연어 질문을 SQL 로 바꿔 실행한 결과를 받는다.
 * 응답: NlQueryResponse { question, sql, columns, rows, rowCount }
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
    if (error?.name === 'AbortError') {
      throw error;
    }
    throw new ApiError(0, { message: '서버에 연결할 수 없습니다. 잠시 후 다시 시도해 주세요.' });
  }

  const body = await response.json().catch(() => null);
  if (!response.ok) {
    const message = ERROR_MESSAGES[body?.code] ?? body?.message;
    throw new ApiError(response.status, { ...body, message });
  }
  return body;
}
