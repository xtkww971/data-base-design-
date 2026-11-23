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
// 목록 휠 스크롤의 감속 시간 상수(ms). 클수록 더 미끄러지듯 느리게 멈춘다. 약 3배 시간이면 거의 도착한다.
const SMOOTH_SCROLL_MS = 60;

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
  // 진행 중인 부드러운 스크롤을 멈추는 함수. 카테고리를 바꿔 목록을 맨 위로 돌릴 때 쓴다.
  const stopListScrollRef = useRef(() => {});

  // 목록 위에서 굴린 휠은 직접 나눠서 처리한다.
  // 내릴 때: 목록 칸이 헤더 아래(LIST_PIN_TOP)에 닿을 때까지 페이지 -> 목록 안 -> 목록 끝이면 다시 페이지(푸터 쪽)
  // 올릴 때: 같은 순서를 거꾸로.
  // 일부만 브라우저에 맡기면 안 된다. Chrome 은 이어지는 휠 입력을 한 묶음으로 처리하는데, 묶음의 첫 입력을
  // 막으면 그 묶음 동안은 직접 스크롤하지 않아서, 칸이 멈춘 뒤 목록이 안 내려가는 문제가 생긴다.
  // 직접 처리하는 대신 브라우저처럼 부드럽게 움직이도록, 휠마다 목표 위치를 쌓고 매 프레임 목표로 감속하며 다가간다.
  useEffect(() => {
    const results = resultsRef.current;
    const layout = layoutRef.current;
    if (!results || !layout) return undefined;

    const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
    // pos: 지금 그린 위치, target: 가야 할 위치. 소수점까지 따로 들고 있어야 느린 구간에서 멈추지 않는다.
    const anim = { frame: 0, lastTime: 0, pagePos: 0, listPos: 0, pageTarget: 0, listTarget: 0 };

    const apply = () => {
      window.scrollTo({ top: anim.pagePos, behavior: 'instant' });
      results.scrollTop = anim.listPos;
    };

    const step = (time) => {
      // 그사이 사용자가 다른 방법(목록 밖 휠, 스크롤바, 키보드)으로 움직였으면 그쪽을 따르고 멈춘다.
      if (anim.lastTime && (Math.abs(window.scrollY - anim.pagePos) > 2 || Math.abs(results.scrollTop - anim.listPos) > 2)) {
        anim.frame = 0;
        return;
      }
      const elapsed = anim.lastTime ? time - anim.lastTime : 16;
      anim.lastTime = time;
      const ratio = 1 - Math.exp(-elapsed / SMOOTH_SCROLL_MS);
      anim.pagePos += (anim.pageTarget - anim.pagePos) * ratio;
      anim.listPos += (anim.listTarget - anim.listPos) * ratio;

      const done =
        Math.abs(anim.pageTarget - anim.pagePos) < 0.5 && Math.abs(anim.listTarget - anim.listPos) < 0.5;
      if (done) {
        anim.pagePos = anim.pageTarget;
        anim.listPos = anim.listTarget;
      }
      apply();
      anim.frame = done ? 0 : requestAnimationFrame(step);
    };

    const stop = () => {
      cancelAnimationFrame(anim.frame);
      anim.frame = 0;
    };
    stopListScrollRef.current = stop;

    const handleWheel = (event) => {
      // 목록이 칸 안에서 스크롤되지 않는 화면(좁은 화면, 결과가 적을 때)과 확대·축소(ctrl+휠)는 브라우저에 맡긴다.
      if (event.ctrlKey || event.deltaY === 0 || results.scrollHeight <= results.clientHeight) return;
      event.preventDefault();

      // 움직이는 중이 아니면 지금 위치에서 시작한다. 스크롤바·키보드로 옮겼을 수 있다.
      if (!anim.frame) {
        anim.pagePos = anim.pageTarget = window.scrollY;
        anim.listPos = anim.listTarget = results.scrollTop;
        anim.lastTime = 0;
      }

      // 줄·페이지 단위(Firefox 등)면 px 로 바꾼다.
      let remaining =
        event.deltaMode === 1 ? event.deltaY * 16 : event.deltaMode === 2 ? event.deltaY * results.clientHeight : event.deltaY;
      // 목록 칸이 헤더 아래에 멈추는 페이지 스크롤 위치와 각 스크롤의 끝
      const pinY = window.scrollY + layout.getBoundingClientRect().top - LIST_PIN_TOP;
      const pageMax = document.documentElement.scrollHeight - window.innerHeight;
      const listMax = results.scrollHeight - results.clientHeight;

      // remaining 을 from 에서 limit 까지만 쓰고, 쓴 만큼을 돌려준다.
      const take = (from, limit) => {
        const room = limit - from;
        const amount = remaining > 0 ? Math.min(remaining, Math.max(room, 0)) : Math.max(remaining, Math.min(room, 0));
        remaining -= amount;
        return amount;
      };

      // 목표 위치 기준으로 나눠야 애니메이션 도중에 휠을 더 굴려도 단계가 맞다. 1px 이하 차이는 칸이 멈춘 것으로 본다.
      if (remaining > 0) {
        if (pinY - anim.pageTarget > 1) anim.pageTarget += take(anim.pageTarget, Math.min(pinY, pageMax));
        anim.listTarget += take(anim.listTarget, listMax);
        anim.pageTarget += take(anim.pageTarget, pageMax);
      } else {
        if (anim.pageTarget - pinY > 1) anim.pageTarget += take(anim.pageTarget, Math.max(pinY, 0));
        anim.listTarget += take(anim.listTarget, 0);
        anim.pageTarget += take(anim.pageTarget, 0);
      }

      if (reduceMotion.matches) {
        anim.pagePos = anim.pageTarget;
        anim.listPos = anim.listTarget;
        apply();
        return;
      }
      if (!anim.frame) anim.frame = requestAnimationFrame(step);
    };

    results.addEventListener('wheel', handleWheel, { passive: false });
    return () => {
      stop();
      results.removeEventListener('wheel', handleWheel);
    };
  }, []);

  // 카테고리·검색어가 바뀌면 목록 칸을 맨 위로 돌린다.
  useEffect(() => {
    stopListScrollRef.current();
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
