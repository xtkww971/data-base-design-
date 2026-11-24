import { useSyncExternalStore } from 'react';

// 장바구니를 localStorage 에 보관한다. 장바구니 API 가 생기면 서버 저장으로 바꾼다.
// 항목: { id(module_id), category, name, brand, summary, price, quantity }

const STORAGE_KEY = 'cartItems';
const MAX_QUANTITY = 99;
const listeners = new Set();

function readItems() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    const parsed = raw ? JSON.parse(raw) : [];
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

let cartItems = readItems();

function save(nextItems) {
  cartItems = nextItems;
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(nextItems));
  } catch {
    // 저장소를 못 쓰는 환경이면 새로고침 전까지만 유지한다.
  }
  listeners.forEach((listener) => listener());
}

/** 부품을 담는다. 이미 담긴 부품이면 수량만 늘린다. */
export function addToCart(item, quantity = 1) {
  const existing = cartItems.find((cartItem) => cartItem.id === item.id);
  if (existing) {
    save(
      cartItems.map((cartItem) =>
        cartItem.id === item.id
          ? { ...cartItem, quantity: Math.min(MAX_QUANTITY, cartItem.quantity + quantity) }
          : cartItem,
      ),
    );
    return;
  }
  save([...cartItems, { ...item, quantity: Math.min(MAX_QUANTITY, quantity) }]);
}

export function changeCartQuantity(id, delta) {
  save(
    cartItems.map((item) =>
      item.id === id ? { ...item, quantity: Math.min(MAX_QUANTITY, Math.max(1, item.quantity + delta)) } : item,
    ),
  );
}

export function removeFromCart(id) {
  save(cartItems.filter((item) => item.id !== id));
}

export function clearCart() {
  save([]);
}

function subscribe(listener) {
  listeners.add(listener);
  return () => listeners.delete(listener);
}

/** 장바구니 항목 목록. */
export function useCartItems() {
  return useSyncExternalStore(subscribe, () => cartItems);
}

export { MAX_QUANTITY as CART_MAX_QUANTITY };
