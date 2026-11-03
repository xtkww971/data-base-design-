import { useSyncExternalStore } from 'react';
import { queryNl2Sql } from '../api/nl2sqlApi.js';

// 추천 페이지의 질문 내역. 페이지를 나갔다 와도 남도록 컴포넌트 밖(localStorage)에 둔다.
// 분석 중에 다른 페이지로 가도 응답은 이 저장소에 들어온다.
// 항목: { id, date, prompt, conditions, status: 'loading' | 'done' | 'error', result, error }

const STORAGE_KEY = 'recommendationHistory';
const MAX_ENTRIES = 20;
const listeners = new Set();

function readEntries() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    const parsed = raw ? JSON.parse(raw) : [];
    if (!Array.isArray(parsed)) return [];
    // 새로고침 전에 끝나지 않은 요청은 응답을 받을 수 없다.
    return parsed.map((entry) =>
      entry.status === 'loading'
        ? { ...entry, status: 'error', error: '페이지를 새로고침해 결과를 받지 못했습니다. 다시 시도해 주세요.' }
        : entry,
    );
  } catch {
    return [];
  }
}

let state = { entries: readEntries(), selectedId: null };

function setState(next) {
  state = next;
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(next.entries));
  } catch {
    // 저장소를 못 쓰는 환경이면 새로고침 전까지만 유지한다.
  }
  listeners.forEach((listener) => listener());
}

function updateEntry(id, patch) {
  setState({
    ...state,
    entries: state.entries.map((entry) => (entry.id === id ? { ...entry, ...patch } : entry)),
  });
}

function formatDate(date) {
  return `${date.getFullYear()}.${String(date.getMonth() + 1).padStart(2, '0')}.${String(date.getDate()).padStart(2, '0')}`;
}

/** 질문을 보내고 내역 맨 위에 추가한다. conditions 는 간편 입력의 원래 값(없으면 null). */
export function submitQuestion(prompt, conditions = null) {
  const now = new Date();
  const id = `${now.getTime()}-${Math.random().toString(36).slice(2, 8)}`;
  const entry = { id, date: formatDate(now), prompt, conditions, status: 'loading', result: null, error: null };

  setState({ entries: [entry, ...state.entries].slice(0, MAX_ENTRIES), selectedId: id });

  queryNl2Sql(prompt)
    .then((result) => updateEntry(id, { status: 'done', result }))
    .catch((error) => updateEntry(id, { status: 'error', error: error.message }));
}

export function selectEntry(id) {
  setState({ ...state, selectedId: id });
}

export function deleteEntry(id) {
  const entries = state.entries.filter((entry) => entry.id !== id);
  const selectedId = state.selectedId === id ? (entries[0]?.id ?? null) : state.selectedId;
  setState({ entries, selectedId });
}

function subscribe(listener) {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

/** { entries, selectedId } */
export function useRecommendationHistory() {
  return useSyncExternalStore(subscribe, () => state);
}
