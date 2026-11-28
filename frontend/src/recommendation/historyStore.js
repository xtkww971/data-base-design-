import { useSyncExternalStore } from 'react';
import { deleteQuery, fetchQueryDetail, fetchQueryHistory, queryNl2Sql } from '../api/nl2sqlApi.js';

// 추천 페이지의 질문 내역. 분석 중에 다른 페이지로 가도 응답이 이 저장소에 들어오도록 컴포넌트 밖에 둔다.
//
// - 로그인: 내역은 서버(nl_queries)에 있다. 목록은 GET /api/nl2sql/queries 로 받고, 결과는 항목을 고를 때 받는다.
// - 비로그인: 서버에도 남지만(user_id NULL) 다시 꺼낼 방법이 없으므로 지금처럼 localStorage 에 둔다.
//
// 항목: {
//   id,            화면용 키. 서버에 있으면 `q-<queryId>`, 아직 없으면 임시 id
//   queryId,       서버 id. 없으면 null
//   date, prompt, conditions,
//   status,        'loading'(분석 중) | 'done' | 'error' | 'stub'(목록만 받고 결과는 아직)
//   outcome,       사이드바 표시용 결과 종류. 'SUCCESS' | 'UNANSWERABLE' | 'GENERATION_FAILED' | 'EXECUTION_FAILED' | null
//   result, error, errorCode,
//   detailStatus,  stub 의 결과를 받는 중인지. 'idle' | 'loading' | 'error'
// }

const STORAGE_KEY = 'recommendationHistory';
const MAX_LOCAL_ENTRIES = 20;
const listeners = new Set();

// 서버가 내역에 남기는 실패 코드와 그 결과 종류. 여기에 없는 실패(서버 연결 실패 등)는 서버에 남지 않는다.
const OUTCOME_BY_CODE = {
  NL2SQL_OUT_OF_SCOPE: 'UNANSWERABLE',
  NL2SQL_MISSING_DATA: 'UNANSWERABLE',
  NL2SQL_AMBIGUOUS: 'UNANSWERABLE',
  NL2SQL_GENERATION_FAILED: 'GENERATION_FAILED',
  NL2SQL_EXECUTION_FAILED: 'EXECUTION_FAILED',
};

let state = {
  userId: undefined, // 아직 setHistoryUser 전
  entries: [],
  selectedId: null,
  listStatus: 'idle', // 'idle' | 'local' | 'loading' | 'ready' | 'error'
  listError: null,
  notice: null,
};

function isLocalMode() {
  return state.userId === null;
}

function readLocalEntries() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    const parsed = raw ? JSON.parse(raw) : [];
    if (!Array.isArray(parsed)) return [];
    return parsed.map((entry) => {
      // 새로고침 전에 끝나지 않은 요청은 응답을 받을 수 없다.
      const restored =
        entry.status === 'loading'
          ? { ...entry, status: 'error', error: '페이지를 새로고침해 결과를 받지 못했습니다. 다시 시도해 주세요.' }
          : entry;
      return { queryId: null, detailStatus: 'idle', ...restored, outcome: outcomeOf(restored) };
    });
  } catch {
    return [];
  }
}

function setState(patch) {
  state = { ...state, ...patch };
  if (isLocalMode()) {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(state.entries.slice(0, MAX_LOCAL_ENTRIES)));
    } catch {
      // 저장소를 못 쓰는 환경이면 새로고침 전까지만 유지한다.
    }
  }
  listeners.forEach((listener) => listener());
}

function updateEntry(id, patch) {
  setState({ entries: state.entries.map((entry) => (entry.id === id ? { ...entry, ...patch } : entry)) });
}

// 백엔드 ErrorCode 와 HTTP 상태를 "NL2SQL_EXECUTION_FAILED · 422" 처럼 붙인다. 서버에 닿지 못했으면 null.
function formatErrorCode(error) {
  const parts = [error?.code, error?.status].filter(Boolean);
  return parts.length > 0 ? parts.join(' · ') : null;
}

function codeOf(errorCode) {
  return errorCode ? errorCode.split(' · ')[0] : null;
}

function outcomeOf(entry) {
  if (entry.status === 'done') return 'SUCCESS';
  if (entry.status === 'error') return OUTCOME_BY_CODE[codeOf(entry.errorCode)] ?? null;
  return entry.outcome ?? null;
}

const pad = (value) => String(value).padStart(2, '0');

function formatDate(date) {
  return `${date.getFullYear()}.${pad(date.getMonth() + 1)}.${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

function fromSummary(summary) {
  return {
    id: `q-${summary.queryId}`,
    queryId: summary.queryId,
    date: formatDate(new Date(summary.createdAt)),
    prompt: summary.question,
    conditions: null,
    status: 'stub',
    outcome: summary.status,
    result: null,
    error: null,
    errorCode: null,
    detailStatus: 'idle',
  };
}

/**
 * 로그인한 유저가 바뀔 때마다 부른다(비로그인이면 null). 같은 유저면 아무것도 하지 않아 분석 중인 요청이 유지된다.
 */
export function setHistoryUser(userId) {
  if (state.userId === userId) {
    return;
  }
  if (userId === null) {
    state = { ...state, userId: null };
    setState({ entries: readLocalEntries(), selectedId: null, listStatus: 'local', listError: null, notice: null });
    return;
  }
  state = { ...state, userId };
  setState({ entries: [], selectedId: null, listStatus: 'loading', listError: null, notice: null });
  refreshHistory();
}

/**
 * 서버 목록을 다시 받는다. 이미 결과를 받아 둔 항목은 다시 받지 않도록 그대로 둔다.
 * 서버에 없는 항목(분석 중, 서버에 남지 않는 실패)은 맨 위에 남긴다.
 *
 * adopt: 방금 실패한 임시 항목을 서버에 새로 생긴 같은 질문으로 바꾼다. 실패 응답에는 queryId 가 없기 때문이다.
 */
export async function refreshHistory({ adopt = null } = {}) {
  const userId = state.userId;
  if (userId == null) {
    return;
  }
  if (state.entries.length === 0) {
    setState({ listStatus: 'loading', listError: null });
  }

  let summaries;
  try {
    summaries = await fetchQueryHistory(userId);
  } catch (error) {
    if (state.userId === userId) {
      setState({ listStatus: 'error', listError: error.message });
    }
    return;
  }
  if (state.userId !== userId) {
    return; // 기다리는 사이 로그아웃했거나 다른 유저로 바뀌었다
  }

  const loaded = new Map(state.entries.filter((entry) => entry.queryId != null).map((entry) => [entry.queryId, entry]));
  let selectedId = state.selectedId;
  let localEntries = state.entries.filter((entry) => entry.queryId == null);

  if (adopt) {
    const adopted = summaries.find(
      (summary) => !adopt.knownQueryIds.has(summary.queryId) && summary.question === adopt.prompt,
    );
    const local = localEntries.find((entry) => entry.id === adopt.localId);
    if (adopted && local) {
      // 받은 에러를 그대로 들고 가서 상세를 다시 받지 않는다.
      loaded.set(adopted.queryId, { ...local, id: `q-${adopted.queryId}`, queryId: adopted.queryId });
      localEntries = localEntries.filter((entry) => entry.id !== adopt.localId);
      if (selectedId === adopt.localId) selectedId = `q-${adopted.queryId}`;
    }
  }

  const serverEntries = summaries.map((summary) => {
    const existing = loaded.get(summary.queryId);
    return existing && existing.status !== 'stub' ? existing : fromSummary(summary);
  });
  const entries = [...localEntries, ...serverEntries];
  if (!entries.some((entry) => entry.id === selectedId)) {
    selectedId = null;
  }
  setState({ entries, selectedId, listStatus: 'ready', listError: null });
}

/** 질문을 보내고 내역 맨 위에 추가한다. conditions 는 간편 입력의 원래 값(없으면 null). */
export function submitQuestion(prompt, conditions = null) {
  const userId = state.userId ?? null;
  const now = new Date();
  const localId = `${now.getTime()}-${Math.random().toString(36).slice(2, 8)}`;
  const knownQueryIds = new Set(state.entries.map((entry) => entry.queryId).filter((id) => id != null));
  const entry = {
    id: localId,
    queryId: null,
    date: formatDate(now),
    prompt,
    conditions,
    status: 'loading',
    outcome: null,
    result: null,
    error: null,
    errorCode: null,
    detailStatus: 'idle',
  };

  const entries = [entry, ...state.entries];
  setState({ entries: isLocalMode() ? entries.slice(0, MAX_LOCAL_ENTRIES) : entries, selectedId: localId, notice: null });

  queryNl2Sql(prompt, conditions, userId)
    .then((result) => {
      if (state.userId !== userId || !state.entries.some((item) => item.id === localId)) {
        return; // 유저가 바뀌었거나 분석 중에 지웠다
      }
      // 로그인 상태에서 서버에 저장됐으면 서버 id 로 바꿔 목록과 같은 항목이 되게 한다.
      const id = userId != null && result.queryId != null ? `q-${result.queryId}` : localId;
      updateEntry(localId, {
        id,
        queryId: userId != null ? (result.queryId ?? null) : null,
        status: 'done',
        outcome: 'SUCCESS',
        result,
      });
      if (state.selectedId === localId) {
        setState({ selectedId: id });
      }
    })
    .catch((error) => {
      if (state.userId !== userId || !state.entries.some((item) => item.id === localId)) {
        return;
      }
      const errorCode = formatErrorCode(error);
      const outcome = OUTCOME_BY_CODE[codeOf(errorCode)] ?? null;
      updateEntry(localId, { status: 'error', outcome, error: error.message, errorCode });
      // 서버에 남는 실패면 목록을 다시 받아 그 항목으로 바꾼다.
      if (userId != null && outcome) {
        refreshHistory({ adopt: { localId, prompt, knownQueryIds } });
      }
    });
}

/** 항목을 고른다. 목록만 받아 둔 서버 항목이면 그때 결과를 받는다. */
export function selectEntry(id) {
  setState({ selectedId: id });
  const entry = state.entries.find((item) => item.id === id);
  if (entry && entry.status === 'stub' && entry.detailStatus !== 'loading') {
    loadDetail(entry);
  }
}

async function loadDetail(entry) {
  const userId = state.userId;
  updateEntry(entry.id, { detailStatus: 'loading', error: null });
  try {
    const detail = await fetchQueryDetail(userId, entry.queryId);
    if (state.userId !== userId) return;
    updateEntry(
      entry.id,
      detail.result
        ? { status: 'done', outcome: detail.status, result: detail.result, detailStatus: 'idle' }
        : {
            status: 'error',
            outcome: detail.status,
            error: detail.error?.message ?? '질문을 처리하지 못했습니다.',
            errorCode: detail.error ? `${detail.error.code} · ${detail.error.status}` : null,
            detailStatus: 'idle',
          },
    );
  } catch (error) {
    if (state.userId !== userId) return;
    updateEntry(entry.id, { detailStatus: 'error', error: error.message, errorCode: formatErrorCode(error) });
  }
}

/** 결과를 받지 못한 항목을 다시 받는다. */
export function retryDetail(id) {
  const entry = state.entries.find((item) => item.id === id);
  if (entry && entry.status === 'stub') {
    loadDetail(entry);
  }
}

export function deleteEntry(id) {
  const target = state.entries.find((entry) => entry.id === id);
  if (!target) return;

  const entries = state.entries.filter((entry) => entry.id !== id);
  const selectedId = state.selectedId === id ? null : state.selectedId;
  setState({ entries, selectedId, notice: null });

  // 서버 항목은 서버에서도 지운다. 실패하면 목록을 다시 받아 되살린다. 이미 지워졌으면(404) 그대로 둔다.
  const userId = state.userId;
  if (userId != null && target.queryId != null) {
    deleteQuery(userId, target.queryId).catch((error) => {
      if (state.userId !== userId || error.status === 404) return;
      setState({ notice: '질문 내역을 삭제하지 못했습니다. 잠시 후 다시 시도해 주세요.' });
      refreshHistory();
    });
  }
}

function subscribe(listener) {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

/** { userId, entries, selectedId, listStatus, listError, notice } */
export function useRecommendationHistory() {
  return useSyncExternalStore(subscribe, () => state);
}
