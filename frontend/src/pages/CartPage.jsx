import { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import './CartPage.css';
import { useCurrentUser } from '../auth/authStore.js';
import {
  CART_MAX_QUANTITY as MAX_QUANTITY,
  changeCartQuantity,
  clearCart,
  removeFromCart,
  useCartItems,
} from '../cart/cartStore.js';
import { DUMMY_IMAGES } from '../assets/dummyImages.js';
import { fetchProductDetail } from '../api/productApi.js';
import { SPEC_CATEGORIES, checkCompatibility } from '../utils/compatibility.js';

const formatPrice = (price) => `₩ ${new Intl.NumberFormat('ko-KR').format(price)}`;

// 장바구니 항목에는 스펙이 없어서 호환성 판별에 필요한 부품만 상세 API 로 받아온다.
// 반환값은 부품 id 별 상세 응답이며, 불러오지 못한 부품은 null 이다.
function useSpecDetails(items) {
  const [details, setDetails] = useState({});

  const missingKey = items
    .filter((item) => SPEC_CATEGORIES.includes(item.category) && !(item.id in details))
    .map((item) => `${item.category}:${item.id}`)
    .join(',');

  useEffect(() => {
    if (!missingKey) return undefined;
    const controller = new AbortController();
    const targets = missingKey.split(',').map((key) => {
      const [category, id] = key.split(':');
      return { category, id: Number(id) };
    });

    Promise.all(
      targets.map(({ category, id }) =>
        fetchProductDetail(category, id, controller.signal)
          .then((detail) => [id, detail])
          .catch(() => [id, null]),
      ),
    ).then((entries) => {
      // 장바구니가 바뀌어 취소된 요청이면 다음 effect 가 다시 받아온다.
      if (controller.signal.aborted) return;
      setDetails((prev) => ({ ...prev, ...Object.fromEntries(entries) }));
    });

    return () => controller.abort();
  }, [missingKey]);

  return details;
}

function CompatibilityPanel({ items }) {
  const details = useSpecDetails(items);
  const specItems = items.filter((item) => SPEC_CATEGORIES.includes(item.category));
  const isLoading = specItems.some((item) => !(item.id in details));
  const hasFailed = specItems.some((item) => details[item.id] === null);

  if (isLoading) {
    return (
      <section className="cart-page__compat" aria-live="polite">
        <h2>호환성 검사</h2>
        <p className="cart-page__compat-note">부품 스펙을 불러와 호환성을 확인하는 중이에요…</p>
      </section>
    );
  }

  const issues = checkCompatibility(items, details);
  const hasError = issues.some((issue) => issue.level === 'error');

  return (
    <section className="cart-page__compat" aria-live="polite">
      <h2>
        호환성 검사
        <span className={`cart-page__compat-status ${hasError ? 'is-error' : issues.length > 0 ? 'is-warning' : 'is-ok'}`}>
          {hasError ? '조립 불가' : issues.length > 0 ? '확인 필요' : '문제 없음'}
        </span>
      </h2>

      {issues.length > 0 ? (
        <ul className="cart-page__compat-list">
          {issues.map((issue) => (
            <li key={issue.message} className={`cart-page__compat-issue is-${issue.level}`}>
              <span className="cart-page__compat-rule">{issue.rule}</span>
              <span>{issue.message}</span>
            </li>
          ))}
        </ul>
      ) : (
        <p className="cart-page__compat-note">담은 부품끼리 호환돼요.</p>
      )}

      {hasFailed ? (
        <p className="cart-page__compat-note">일부 부품의 스펙을 불러오지 못해 그 부품은 검사하지 못했어요.</p>
      ) : null}
    </section>
  );
}

export default function CartPage() {
  const navigate = useNavigate();
  const currentUser = useCurrentUser();
  const items = useCartItems();
  const [isLoginPromptOpen, setIsLoginPromptOpen] = useState(false);

  // 팝업이 떠 있는 동안 Esc 로 닫을 수 있게 한다.
  useEffect(() => {
    if (!isLoginPromptOpen) return undefined;
    const handleKeyDown = (event) => {
      if (event.key === 'Escape') setIsLoginPromptOpen(false);
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isLoginPromptOpen]);

  const handleSaveEstimate = () => {
    if (!currentUser) {
      setIsLoginPromptOpen(true);
      return;
    }
    // 프로토타입이라 로그인한 경우의 저장 동작은 아직 연결하지 않았다.
  };

  const handleGoToLogin = () => {
    // 로그인 후 장바구니로 돌아오도록 현재 경로를 넘긴다.
    navigate('/login', { state: { from: '/cart' } });
  };

  const totalQuantity = items.reduce((sum, item) => sum + item.quantity, 0);
  const totalPrice = items.reduce((sum, item) => sum + item.price * item.quantity, 0);

  const changeQuantity = changeCartQuantity;
  const removeItem = removeFromCart;

  return (
    <div className="cart-page">
      <Header />

      <main className="cart-page__content">
        <section className="cart-page__panel">
          <div className="cart-page__header">
            <div>
              <h1>장바구니</h1>
              <p className="cart-page__subtitle">담아 둔 부품을 확인하고 견적을 완성해 보세요.</p>
            </div>

            {items.length > 0 && (
              <button type="button" className="cart-page__clear" onClick={clearCart}>
                전체 비우기
              </button>
            )}
          </div>

          {items.length === 0 ? (
            <div className="cart-page__empty-state">
              <p>장바구니가 비어 있습니다.</p>
              <Link to="/search" className="cart-page__primary-button">
                부품 보러 가기
              </Link>
            </div>
          ) : (
            <>
              <CompatibilityPanel items={items} />
              <div className="cart-page__layout">
                <ul className="cart-page__list">
                  {items.map((item) => (
                    <li key={item.id} className="cart-page__item">
                      <div className="cart-page__item-image-wrap" aria-hidden="true">
                        <img
                          className="cart-page__item-image"
                          src={item.imageUrl || DUMMY_IMAGES[item.category]}
                          alt=""
                          loading="lazy"
                        />
                      </div>

                      <div className="cart-page__item-body">
                        <div className="cart-page__item-meta">
                          <span className="cart-page__category-tag">{item.category}</span>
                          <span className="cart-page__brand">{item.brand}</span>
                        </div>
                        <h2>{item.name}</h2>
                        <p className="cart-page__item-summary">{item.summary}</p>
                        <span className="cart-page__unit-price">개당 {formatPrice(item.price)}</span>
                      </div>

                      <div className="cart-page__item-side">
                        <button
                          type="button"
                          className="cart-page__remove"
                          onClick={() => removeItem(item.id)}
                          aria-label={`${item.name} 삭제`}
                        >
                          ✕
                        </button>

                        <div className="cart-page__quantity">
                          <button
                            type="button"
                            onClick={() => changeQuantity(item.id, -1)}
                            disabled={item.quantity <= 1}
                            aria-label="수량 줄이기"
                          >
                            −
                          </button>
                          <span aria-label="수량">{item.quantity}</span>
                          <button
                            type="button"
                            onClick={() => changeQuantity(item.id, 1)}
                            disabled={item.quantity >= MAX_QUANTITY}
                            aria-label="수량 늘리기"
                          >
                            +
                          </button>
                        </div>

                        <strong className="cart-page__item-price">{formatPrice(item.price * item.quantity)}</strong>
                      </div>
                    </li>
                  ))}
                </ul>

                <aside className="cart-page__summary">
                  <h2>견적 요약</h2>

                  <dl className="cart-page__summary-list">
                    <div>
                      <dt>상품 종류</dt>
                      <dd>{items.length}개</dd>
                    </div>
                    <div>
                      <dt>총 수량</dt>
                      <dd>{totalQuantity}개</dd>
                    </div>
                    <div>
                      <dt>상품 금액</dt>
                      <dd>{formatPrice(totalPrice)}</dd>
                    </div>
                  </dl>

                  <div className="cart-page__total">
                    <span>합계</span>
                    <strong>{formatPrice(totalPrice)}</strong>
                  </div>

                  <button type="button" className="cart-page__primary-button" onClick={handleSaveEstimate}>
                    견적 저장하기
                  </button>
                  <Link to="/search" className="cart-page__secondary-button">
                    부품 더 담기
                  </Link>
                </aside>
              </div>
            </>
          )}
        </section>
      </main>

      <Footer />

      {isLoginPromptOpen && (
        <div className="cart-page__modal-backdrop" onClick={() => setIsLoginPromptOpen(false)}>
          <div
            className="cart-page__modal"
            role="dialog"
            aria-modal="true"
            aria-labelledby="cart-login-prompt-title"
            onClick={(event) => event.stopPropagation()}
          >
            <h2 id="cart-login-prompt-title">로그인이 필요합니다</h2>
            <p>견적을 저장하려면 로그인해야 합니다.</p>

            <div className="cart-page__modal-actions">
              <button type="button" className="cart-page__secondary-button" onClick={() => setIsLoginPromptOpen(false)}>
                닫기
              </button>
              <button type="button" className="cart-page__primary-button" onClick={handleGoToLogin} autoFocus>
                로그인하러 가기
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
