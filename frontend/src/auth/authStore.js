import { useSyncExternalStore } from 'react';

// 로그인한 유저 정보(UserResponse)를 localStorage 에 보관한다.
// 백엔드에 토큰·세션이 없으므로 "누가 로그인했는지" 화면 표시용일 뿐, 인증 수단이 아니다.

const STORAGE_KEY = 'currentUser';
const listeners = new Set();

function readUser() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

let currentUser = readUser();

function emit() {
  listeners.forEach((listener) => listener());
}

export function setCurrentUser(user) {
  currentUser = user;
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(user));
  } catch {
    // 저장소를 못 쓰는 환경이면 새로고침 전까지만 유지한다.
  }
  emit();
}

export function clearCurrentUser() {
  currentUser = null;
  try {
    localStorage.removeItem(STORAGE_KEY);
  } catch {
    // 무시
  }
  emit();
}

function subscribe(listener) {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

/** 현재 로그인한 유저. 로그인 전이면 null. */
export function useCurrentUser() {
  return useSyncExternalStore(subscribe, () => currentUser);
}
