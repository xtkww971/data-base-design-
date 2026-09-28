// 백엔드 인증 API (/api/auth). 토큰·세션은 없고 아이디/비밀번호 확인 결과로 유저 정보만 받는다.

/**
 * 백엔드 ErrorResponse({ code, message, fieldErrors }) 를 담는 에러.
 * 화면에서 fieldErrors 로 입력칸별 메시지를 보여준다.
 */
export class ApiError extends Error {
  constructor(status, body) {
    super(body?.message ?? `요청에 실패했습니다. (${status})`);
    this.status = status;
    this.code = body?.code ?? null;
    this.fieldErrors = body?.fieldErrors ?? {};
  }
}

async function request(path, options) {
  let response;
  try {
    response = await fetch(path, options);
  } catch {
    throw new ApiError(0, { message: '서버에 연결할 수 없습니다. 잠시 후 다시 시도해 주세요.' });
  }

  const body = await response.json().catch(() => null);
  if (!response.ok) {
    throw new ApiError(response.status, body);
  }
  return body;
}

function postJson(path, data) {
  return request(path, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data),
  });
}

/** 회원가입. 응답: UserResponse { userId, loginId, nickname, createdAt } */
export function signUp({ loginId, password, nickname }) {
  return postJson('/api/auth/signup', { loginId, password, nickname });
}

/** 로그인. 응답: UserResponse */
export function login({ loginId, password }) {
  return postJson('/api/auth/login', { loginId, password });
}

/** 아이디 사용 가능 여부. 응답: { available: boolean } */
export function checkLoginId(loginId) {
  return request(`/api/auth/check-login-id?${new URLSearchParams({ loginId })}`);
}
