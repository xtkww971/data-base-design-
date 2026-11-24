// 백엔드 자연어 질의 API (/api/nl2sql). 백엔드가 nl2sql 서비스로 SQL 을 만들고 DB 에서 실행한 결과를 돌려준다.

/**
 * 자연어 질의. 응답: NlQueryResponse { question, sql, columns, rows, rowCount }
 * rows 의 각 항목은 { 컬럼명: 값 } 형태다.
 * 실패하면 백엔드 ErrorResponse 의 message 를 담은 Error 를 던진다. code(ErrorCode 이름)와 status(HTTP 상태)도 함께 담는다.
 *
 * conditions 를 주면 프로그램·예산을 함께 보내 nl2sql 이 권장 사양과 부품별 예산 상한을 쓰게 한다.
 * 없으면 질문만 보내고, nl2sql 이 문장에서 직접 추측한다.
 * @param {string} question
 * @param {{ programs?: string[], price?: { min: number|null, max: number|null } }|null} [conditions] 간편 입력 값 (원 단위)
 * @param {AbortSignal} [signal]
 */
export async function queryNl2Sql(question, conditions = null, signal) {
  const programs = conditions?.programs?.filter((program) => program?.trim()) ?? [];
  const payload = {
    question,
    ...(programs.length > 0 && { programs }),
    ...(conditions?.price?.min != null && { budgetMin: conditions.price.min }),
    ...(conditions?.price?.max != null && { budgetMax: conditions.price.max }),
  };

  let response;
  try {
    response = await fetch('/api/nl2sql/query', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
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
    throw Object.assign(new Error(body?.message ?? `질의에 실패했습니다. (${response.status})`), {
      code: body?.code ?? null,
      status: response.status,
    });
  }
  return body;
}
