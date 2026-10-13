import { useEffect, useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import './CartPage.css';
import { useCurrentUser } from '../auth/authStore.js';
import dummyCpuImage from '../assets/dummy_cpu.webp';
import dummyMainboardImage from '../assets/dummy_motherbored.webp';
import dummyRamImage from '../assets/dummy_ram.jpg';
import dummyGpuImage from '../assets/dummy_gpu.jpg';

// 프로토타입용 더미 데이터. 장바구니 API 가 생기면 서버에서 받아온 값으로 바꾼다.
const DUMMY_CART_ITEMS = [
  {
    id: 1,
    category: 'CPU',
    name: 'AMD 라이젠7 7800X3D',
    brand: 'AMD',
    summary: '8코어 / 16스레드 / 4.2GHz',
    price: 479000,
    quantity: 1,
    image: dummyCpuImage,
  },
  {
    id: 2,
    category: 'MAINBOARD',
    name: 'MSI MAG B650 토마호크 WIFI',
    brand: 'MSI',
    summary: 'AM5 / ATX / DDR5',
    price: 289000,
    quantity: 1,
    image: dummyMainboardImage,
  },
  {
    id: 3,
    category: 'RAM',
    name: 'TeamGroup T-Force Delta RGB DDR5-6000 CL30 32GB(16Gx2)',
    brand: 'TeamGroup',
    summary: 'DDR5 / 32GB / 6000MHz',
    price: 159000,
    quantity: 2,
    image: dummyRamImage,
  },
  {
    id: 4,
    category: 'GPU',
    name: 'ASUS TUF Gaming 지포스 RTX 4070 SUPER OC 12GB',
    brand: 'ASUS',
    summary: 'GeForce RTX 4070 SUPER / 12GB',
    price: 949000,
    quantity: 1,
    image: dummyGpuImage,
  },
];

const MAX_QUANTITY = 99;

const formatPrice = (price) => `₩ ${new Intl.NumberFormat('ko-KR').format(price)}`;

export default function CartPage() {
  const navigate = useNavigate();
  const currentUser = useCurrentUser();
  const [items, setItems] = useState(DUMMY_CART_ITEMS);
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

  const changeQuantity = (id, delta) => {
    setItems((prev) =>
      prev.map((item) =>
        item.id === id
          ? { ...item, quantity: Math.min(MAX_QUANTITY, Math.max(1, item.quantity + delta)) }
          : item,
      ),
    );
  };

  const removeItem = (id) => {
    setItems((prev) => prev.filter((item) => item.id !== id));
  };

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
              <button type="button" className="cart-page__clear" onClick={() => setItems([])}>
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
            <div className="cart-page__layout">
              <ul className="cart-page__list">
                {items.map((item) => (
                  <li key={item.id} className="cart-page__item">
                    <div className="cart-page__item-image-wrap" aria-hidden="true">
                      <img className="cart-page__item-image" src={item.image} alt="" loading="lazy" />
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
