import { useEffect, useRef, useState } from 'react';
import { Link } from 'react-router-dom';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import './SearchPage.css';
import { PRODUCT_CATEGORIES } from '../types/productDetail.ts';
import { searchProducts } from '../api/productApi.js';
import { getSpecEntries } from '../utils/productSpecs.js';
import { CART_MAX_QUANTITY, addToCart, useCartItems } from '../cart/cartStore.js';
import dummyCpuImage from '../assets/dummy_cpu.webp';
import dummyMainboardImage from '../assets/dummy_motherbored.webp';
import dummyRamImage from '../assets/dummy_ram.jpg';
import dummyGpuImage from '../assets/dummy_gpu.jpg';
import dummyPowerImage from '../assets/dummy_power.webp';
import dummySsdImage from '../assets/dummy_ssd.jpg';
import dummyHddImage from '../assets/dummy_hdd.webp';
import dummyMonitorImage from '../assets/dummy_monitor.jpg';

// 제품 이미지가 없을 때 카테고리별로 대신 보여주는 더미 이미지.
const DUMMY_IMAGES = {
  CPU: dummyCpuImage,
  MAINBOARD: dummyMainboardImage,
  RAM: dummyRamImage,
  GPU: dummyGpuImage,
  POWER: dummyPowerImage,
  SSD: dummySsdImage,
  HDD: dummyHddImage,
  MONITOR: dummyMonitorImage,
};

const getProductImage = (product) => product.imageUrl || DUMMY_IMAGES[product.category] || null;

const PAGE_SIZE = 20;
const SEARCH_DEBOUNCE_MS = 300;
// 목록 칸이 멈춰 서는 화면 위치(헤더 100px + 12px). SearchPage.css 의 calc(100vh - 136px) 와 맞춘다.
const LIST_PIN_TOP = 112;

const formatPrice = (price) => `₩ ${new Intl.NumberFormat('ko-KR').format(price)}`;

const formatSpecValue = (key, value) => {
  if (typeof value === 'boolean') {
    return value ? '지원' : '미지원';
  }

  if (typeof value === 'number') {
    if (key === 'capacity' && value >= 1000) {
      return `${value / 1000}TB`;
    }

    if (key === 'memoryCapacity') {
      return `${value}GB`;
    }

    if (key === 'screenSize') {
      return `${value}인치`;
    }

    if (key === 'length') {
      return `${value}mm`;
    }

    if (key === 'recommendedPower') {
      return `${value}W`;
    }

    if (key === 'ratedPower') {
      return `${value}W`;
    }

    if (key === 'clock' || key === 'readSpeed' || key === 'writeSpeed' || key === 'rpm' || key === 'refreshRate') {
      return `${value}${key === 'clock' ? 'MHz' : key === 'rpm' ? 'RPM' : key === 'refreshRate' ? 'Hz' : 'MB/s'}`;
    }

    return `${value}`;
  }

  return String(value);
};

const getProductSummary = (product) => {
  const { specs } = product;

  if (product.category === 'CPU') {
    return `${specs.cores}코어 / ${specs.threads}스레드 / ${specs.clockSpeed}`;
  }

  if (product.category === 'MAINBOARD') {
    return `${specs.socket} / ${specs.formFactor} / ${specs.memorySpec}`;
  }

  if (product.category === 'RAM') {
    return `${specs.memorySpec} / ${specs.capacity}GB / ${specs.clock}MHz`;
  }

  if (product.category === 'GPU') {
    return `${specs.chipset} / ${specs.memoryCapacity}GB / ${specs.ports}`;
  }

  if (product.category === 'POWER') {
    return `${specs.ratedPower}W / ${specs.certification} / ${specs.formFactor}`;
  }

  if (product.category === 'SSD') {
    return `${specs.formFactor} / ${specs.capacity}GB / ${specs.readSpeed}MB/s`;
  }

  if (product.category === 'HDD') {
    return `${specs.capacity}TB / ${specs.rpm}RPM / ${specs.interface}`;
  }

  if (product.category === 'MONITOR') {
    return `${specs.screenSize}인치 / ${specs.resolution} / ${specs.refreshRate}Hz`;
  }

  return '';
};

// cartStore 항목 형식: { id(module_id), category, name, brand, summary, price, imageUrl }
const toCartItem = (product) => ({
  id: product.id,
  category: product.category,
  name: product.name,
  brand: product.brand ?? '',
  summary: getProductSummary(product),
  price: product.price,
  imageUrl: product.imageUrl ?? null,
});

function QuantityStepper({ quantity, onChange, name }) {
  return (
    <div className="search-page__stepper">
      <button
        type="button"
        onClick={() => onChange(-1)}
        aria-label={quantity <= 1 ? `${name} 선택 목록에서 빼기` : `${name} 수량 줄이기`}
      >
        −
      </button>
      <span aria-label="수량">{quantity}</span>
      <button
        type="button"
        onClick={() => onChange(1)}
        disabled={quantity >= CART_MAX_QUANTITY}
        aria-label={`${name} 수량 늘리기`}
      >
        +
      </button>
    </div>
  );
}

export default function SearchPage() {
  const cartQuantities = new Map(useCartItems().map((item) => [item.id, item.quantity]));

  // 장바구니에 보내기 전에 모아 두는 선택 목록. 항목: { item(cartStore 형식), quantity }
  // 카테고리나 검색어를 바꿔도 유지되어 여러 부품을 모은 뒤 한 번에 담을 수 있다.
  // 선택 목록은 왼쪽 서랍에 두고, 열면 본문을 오른쪽으로 민다(넓은 화면). 추가해도 자동으로 열지 않는다.
  const [selection, setSelection] = useState([]);
  const [isSelectionOpen, setIsSelectionOpen] = useState(false);
  // 마지막으로 장바구니에 보낸 부품 종류 수. 서랍이 비었을 때 안내 문구에 쓴다.
  const [sentCount, setSentCount] = useState(0);

  const [selectedCategory, setSelectedCategory] = useState('ALL');
  const [searchTerm, setSearchTerm] = useState('');
  const [debouncedSearchTerm, setDebouncedSearchTerm] = useState('');
  const [selectedProductId, setSelectedProductId] = useState(null);

  // 마지막으로 받은 검색 결과. queryKey 가 현재 검색 조건과 다르면 새 결과를 기다리는 중이다.
  const [searchResult, setSearchResult] = useState(null);
  const [isLoadingMore, setIsLoadingMore] = useState(false);

  const queryKey = `${selectedCategory}|${debouncedSearchTerm}`;
  const currentResult = searchResult?.queryKey === queryKey ? searchResult : null;
  // 새 결과가 올 때까지 이전 결과를 그대로 보여준다. 목록을 비우면 페이지 높이가 줄어 푸터가 튀어 오른다.
  const isRefreshing = searchResult !== null && currentResult === null;
  const products = searchResult?.products ?? [];
  const hasNext = searchResult?.hasNext ?? false;
  const totalElements = searchResult?.totalElements ?? 0;
  const errorMessage = searchResult?.errorMessage ?? null;
  const isLoading = currentResult === null || isLoadingMore;

  const layoutRef = useRef(null);
  const resultsRef = useRef(null);

  // 목록 위에서 휠을 내리면, 목록 칸이 헤더 아래(LIST_PIN_TOP)에 닿을 때까지는 페이지를 먼저 내리고
  // 그다음부터 목록 안을 스크롤한다. 그냥 두면 페이지 맨 위에서 목록 안만 움직여 칸 아래쪽이 화면 밖에 남는다.
  // 위로 올릴 때와 목록 끝에서 더 내릴 때는 브라우저 기본 동작(페이지로 이어서 스크롤)을 그대로 쓴다.
  useEffect(() => {
    const results = resultsRef.current;
    const layout = layoutRef.current;
    if (!results || !layout) return undefined;

    const handleWheel = (event) => {
      // 목록이 칸 안에서 스크롤되지 않는 화면(좁은 화면)이면 손대지 않는다.
      if (event.deltaY <= 0 || results.scrollHeight <= results.clientHeight) return;
      // 소수점 위치 오차는 무시하고, 페이지가 더 내려갈 수 없으면(페이지가 짧은 경우) 바로 목록을 스크롤한다.
      const distance = layout.getBoundingClientRect().top - LIST_PIN_TOP;
      const pageRemaining = document.documentElement.scrollHeight - window.innerHeight - window.scrollY;
      if (distance <= 1 || pageRemaining <= 1) return;
      event.preventDefault();
      const delta = event.deltaMode === 1 ? event.deltaY * 16 : event.deltaY; // 줄 단위(Firefox)면 px 로
      window.scrollBy(0, Math.min(delta, distance));
    };

    results.addEventListener('wheel', handleWheel, { passive: false });
    return () => results.removeEventListener('wheel', handleWheel);
  }, []);

  // 카테고리·검색어가 바뀌면 목록 칸을 맨 위로 돌린다.
  useEffect(() => {
    resultsRef.current?.scrollTo({ top: 0 });
  }, [queryKey]);

  // 타이핑할 때마다 요청하지 않도록 입력이 멈춘 뒤에 검색어를 반영한다.
  useEffect(() => {
    const timer = setTimeout(() => setDebouncedSearchTerm(searchTerm), SEARCH_DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [searchTerm]);

  // 카테고리나 검색어가 바뀌면 첫 페이지부터 다시 읽어온다.
  useEffect(() => {
    const controller = new AbortController();

    searchProducts(
      { category: selectedCategory, searchTerm: debouncedSearchTerm, page: 0, size: PAGE_SIZE },
      controller.signal,
    )
      .then((result) => {
        setSearchResult({
          queryKey,
          products: result.content,
          page: result.page,
          hasNext: result.hasNext,
          totalElements: result.totalElements,
          errorMessage: null,
        });
      })
      .catch((error) => {
        if (error.name === 'AbortError') return;
        setSearchResult({ queryKey, products: [], page: 0, hasNext: false, totalElements: 0, errorMessage: error.message });
      });

    return () => controller.abort();
  }, [queryKey, selectedCategory, debouncedSearchTerm]);

  const handleLoadMore = () => {
    if (!currentResult) return;
    const nextPage = currentResult.page + 1;
    setIsLoadingMore(true);

    searchProducts({ category: selectedCategory, searchTerm: debouncedSearchTerm, page: nextPage, size: PAGE_SIZE })
      .then((result) => {
        // 그사이 검색 조건이 바뀌었다면 이전 조건의 결과는 버린다.
        setSearchResult((prev) =>
          prev?.queryKey !== queryKey
            ? prev
            : {
                ...prev,
                products: [...prev.products, ...result.content],
                page: result.page,
                hasNext: result.hasNext,
                totalElements: result.totalElements,
              },
        );
      })
      .catch((error) => {
        setSearchResult((prev) => (prev?.queryKey !== queryKey ? prev : { ...prev, errorMessage: error.message }));
      })
      .finally(() => setIsLoadingMore(false));
  };

  const selectedProduct =
    products.find((product) => product.id === selectedProductId) || products[0] || null;
  // 선택 목록·장바구니에 담긴 수량. 없으면 undefined
  const selectedQuantity = selection.find((entry) => entry.item.id === selectedProduct?.id)?.quantity;
  const inCartQuantity = selectedProduct ? cartQuantities.get(selectedProduct.id) : undefined;

  const selectionCount = selection.reduce((sum, entry) => sum + entry.quantity, 0);
  const selectionPrice = selection.reduce((sum, entry) => sum + entry.item.price * entry.quantity, 0);

  const addToSelection = (product) => {
    setSelection((prev) => [...prev, { item: toCartItem(product), quantity: 1 }]);
    setSentCount(0);
  };

  // 1개에서 줄이면 선택 목록에서 뺀다.
  const changeSelectionQuantity = (id, delta) => {
    setSelection((prev) =>
      prev.flatMap((entry) => {
        if (entry.item.id !== id) return [entry];
        const quantity = Math.min(CART_MAX_QUANTITY, entry.quantity + delta);
        return quantity < 1 ? [] : [{ ...entry, quantity }];
      }),
    );
  };

  const removeFromSelection = (id) => {
    setSelection((prev) => prev.filter((entry) => entry.item.id !== id));
  };

  // 이미 장바구니에 있는 부품은 addToCart 가 수량을 더한다.
  const sendSelectionToCart = () => {
    selection.forEach(({ item, quantity }) => addToCart(item, quantity));
    setSentCount(selection.length);
    setSelection([]);
  };

  // 서랍이 열려 있는 동안 Esc 로 접을 수 있게 한다.
  useEffect(() => {
    if (!isSelectionOpen) return undefined;
    const handleKeyDown = (event) => {
      if (event.key === 'Escape') setIsSelectionOpen(false);
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [isSelectionOpen]);

  return (
    <div className={`search-page ${isSelectionOpen ? 'is-selection-open' : ''}`}>
      <Header />

      <main className="search-page__content">
        <section className="search-page__panel">
          <div className="search-page__header">
            <div>
              <span className="search-page__eyebrow">견적 검색</span>
              <h1>부품별 최저가와 상세 스펙을 한눈에 확인하세요.</h1>
            </div>

            {/* 같은 버튼으로 서랍을 열고 닫는다. 화면에 떠 있지 않아 목록을 가리지 않는다. */}
            <button
              type="button"
              className={`search-page__selection-toggle ${isSelectionOpen ? 'is-active' : ''}`}
              onClick={() => setIsSelectionOpen((open) => !open)}
              aria-expanded={isSelectionOpen}
              aria-controls="selection-drawer"
            >
              <svg viewBox="0 0 24 24" width="18" height="18" aria-hidden="true">
                <path
                  d="M9 6h11M9 12h11M9 18h11M4 6l.01 0M4 12l.01 0M4 18l.01 0"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                />
              </svg>
              선택 목록
              {selectionCount > 0 && (
                // 개수가 바뀔 때마다 다시 그려 배지가 살짝 튀도록 한다 (추가 피드백)
                <span key={selectionCount} className="search-page__selection-badge">
                  {selectionCount}
                </span>
              )}
            </button>
          </div>

          <div className="search-page__filters" aria-label="카테고리 필터">
            {PRODUCT_CATEGORIES.map((category) => (
              <button
                key={category}
                type="button"
                className={`search-page__filter ${selectedCategory === category ? 'is-active' : ''}`}
                onClick={() => setSelectedCategory(category)}
              >
                {category === 'ALL' ? '전체' : category}
              </button>
            ))}
          </div>

          <label className="search-page__search" htmlFor="product-search">
            <span className="search-page__search-icon" aria-hidden="true">⌕</span>
            <input
              id="product-search"
              type="text"
              value={searchTerm}
              onChange={(event) => setSearchTerm(event.target.value)}
              placeholder="제품명, 브랜드를 검색하세요"
            />
          </label>

          <div
            ref={layoutRef}
            className={`search-page__layout ${isRefreshing ? 'is-refreshing' : ''}`}
            aria-busy={isRefreshing}
          >
            <div className="search-page__results" ref={resultsRef}>
              {errorMessage ? (
                <div className="search-page__empty-state">
                  제품 정보를 불러오지 못했습니다.
                  <br />
                  {errorMessage}
                </div>
              ) : isLoading && products.length === 0 ? (
                <div className="search-page__empty-state">제품 정보를 불러오는 중입니다...</div>
              ) : products.length > 0 ? (
                products.map((product) => (
                  <button
                    key={product.id}
                    type="button"
                    className={`search-page__card ${selectedProduct?.id === product.id ? 'is-selected' : ''}`}
                    onClick={() => setSelectedProductId(product.id)}
                  >
                    {/* 이미지를 못 찾은 제품은 검정 박스로 남는다. */}
                    <div className="search-page__card-image-wrap" aria-hidden="true">
                      {getProductImage(product) && (
                        <img className="search-page__image" src={getProductImage(product)} alt="" loading="lazy" />
                      )}
                    </div>

                    <div className="search-page__card-body">
                      <div className="search-page__card-meta">
                        <span className="search-page__category-tag">{product.category}</span>
                        <span className="search-page__brand">{product.brand}</span>
                      </div>

                      <h2>{product.name}</h2>
                      <p className="search-page__summary">{getProductSummary(product)}</p>

                      <div className="search-page__price-row">
                        <span className="search-page__price">{formatPrice(product.price)}</span>
                        <span className="search-page__compare">최저가 기준</span>
                      </div>
                    </div>
                  </button>
                ))
              ) : (
                <div className="search-page__empty-state">
                  검색 조건에 맞는 제품이 없습니다.
                  <br />
                  다른 카테고리 또는 키워드를 입력해 보세요.
                </div>
              )}

              {!errorMessage && hasNext && (
                <button
                  type="button"
                  className="search-page__load-more"
                  onClick={handleLoadMore}
                  disabled={isLoading}
                >
                  {isLoading ? '불러오는 중...' : `더 보기 (${products.length} / ${totalElements})`}
                </button>
              )}
            </div>

            {selectedProduct && (
              <aside className="search-page__detail">
                <div className="search-page__detail-image-wrap" aria-hidden="true">
                  {getProductImage(selectedProduct) && (
                    <img className="search-page__image" src={getProductImage(selectedProduct)} alt="" />
                  )}
                </div>

                <div className="search-page__detail-header">
                  <span className="search-page__category-tag">{selectedProduct.category}</span>
                  <span className="search-page__detail-brand">{selectedProduct.brand}</span>
                </div>

                <h2>{selectedProduct.name}</h2>
                <div className="search-page__detail-price">{formatPrice(selectedProduct.price)}</div>

                <div className="search-page__spec-list">
                  {getSpecEntries(selectedProduct).map(([label, value]) => (
                    <div key={label} className="search-page__spec-item">
                      <span>{label}</span>
                      <strong>{value}</strong>
                    </div>
                  ))}
                </div>

                <div className="search-page__detail-actions">
                  {selectedQuantity === undefined ? (
                    <button
                      type="button"
                      className="search-page__primary-button"
                      onClick={() => addToSelection(selectedProduct)}
                    >
                      선택 목록에 추가
                    </button>
                  ) : (
                    <div className="search-page__selected-quantity">
                      {/* 상세 패널은 화면에 붙어 따라오므로, 스크롤한 뒤에도 여기서 서랍을 열 수 있다. */}
                      <button
                        type="button"
                        className="search-page__selected-link"
                        onClick={() => setIsSelectionOpen(true)}
                        aria-controls="selection-drawer"
                      >
                        ✓ 선택 목록 보기
                      </button>
                      <QuantityStepper
                        quantity={selectedQuantity}
                        onChange={(delta) => changeSelectionQuantity(selectedProduct.id, delta)}
                        name={selectedProduct.name}
                      />
                    </div>
                  )}
                  <button type="button" className="search-page__secondary-button">
                    비교하기
                  </button>
                </div>

                {inCartQuantity ? (
                  <p className="search-page__in-cart-note">장바구니에 이미 {inCartQuantity}개 있어요.</p>
                ) : null}
              </aside>
            )}
          </div>
        </section>
      </main>

      <Footer />

      <aside
        id="selection-drawer"
        className={`search-page__selection-drawer ${isSelectionOpen ? 'is-open' : ''}`}
        aria-label="선택 목록"
      >
        <div className="search-page__selection-header">
          <h2>
            선택 목록
            {selection.length > 0 && (
              <span>
                {selection.length}종 · {selectionCount}개
              </span>
            )}
          </h2>
          <button
            type="button"
            className="search-page__selection-close"
            onClick={() => setIsSelectionOpen(false)}
            aria-label="선택 목록 접기"
          >
            ✕
          </button>
        </div>

        {selection.length > 0 ? (
          <>
            <ul className="search-page__selection-list">
              {selection.map(({ item, quantity }) => (
                <li key={item.id} className="search-page__selection-item">
                  <div className="search-page__selection-item-top">
                    <span className="search-page__category-tag">{item.category}</span>
                    <button
                      type="button"
                      className="search-page__selection-remove"
                      onClick={() => removeFromSelection(item.id)}
                      aria-label={`${item.name} 선택 목록에서 빼기`}
                    >
                      ✕
                    </button>
                  </div>
                  <span className="search-page__selection-name">{item.name}</span>
                  <div className="search-page__selection-item-bottom">
                    <span className="search-page__selection-price">{formatPrice(item.price * quantity)}</span>
                    <QuantityStepper
                      quantity={quantity}
                      onChange={(delta) => changeSelectionQuantity(item.id, delta)}
                      name={item.name}
                    />
                  </div>
                </li>
              ))}
            </ul>

            <div className="search-page__selection-footer">
              <div className="search-page__selection-total">
                <span>합계</span>
                <strong>{formatPrice(selectionPrice)}</strong>
              </div>
              <div className="search-page__selection-actions">
                <button type="button" className="search-page__secondary-button" onClick={() => setSelection([])}>
                  비우기
                </button>
                <button type="button" className="search-page__primary-button" onClick={sendSelectionToCart}>
                  장바구니에 모두 담기
                </button>
              </div>
            </div>
          </>
        ) : (
          <div className="search-page__selection-empty" aria-live="polite">
            {sentCount > 0 ? (
              <>
                <p className="search-page__selection-sent">부품 {sentCount}종을 장바구니에 담았어요.</p>
                <Link to="/cart" className="search-page__selection-link">
                  장바구니 보기 →
                </Link>
              </>
            ) : (
              <p>
                아직 고른 부품이 없어요.
                <br />
                부품 상세에서 "선택 목록에 추가"를 눌러 모아 보세요.
              </p>
            )}
          </div>
        )}
      </aside>
    </div>
  );
}
