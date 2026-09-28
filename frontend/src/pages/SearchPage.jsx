import { useEffect, useState } from 'react';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import './SearchPage.css';
import { PRODUCT_CATEGORIES } from '../types/productDetail.ts';
import { searchProducts } from '../api/productApi.js';

const PAGE_SIZE = 20;
const SEARCH_DEBOUNCE_MS = 300;

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

const getSpecEntries = (product) => {
  const { specs } = product;

  switch (product.category) {
    case 'CPU':
      return [
        ['소켓', specs.socket],
        ['코어', `${specs.cores}개`],
        ['스레드', `${specs.threads}개`],
        ['내장 그래픽', specs.hasGraphics ? '지원' : '미지원'],
        ['클럭', specs.clockSpeed],
      ];
    case 'MAINBOARD':
      return [
        ['소켓', specs.socket],
        ['폼팩터', specs.formFactor],
        ['메모리 규격', specs.memorySpec],
        ['메모리 슬롯', `${specs.memorySlots}개`],
        ['칩셋', specs.chipset],
      ];
    case 'RAM':
      return [
        ['메모리 규격', specs.memorySpec],
        ['용량', `${specs.capacity}GB`],
        ['클럭', `${specs.clock}MHz`],
        ['패키지 수', `${specs.packageCount}개`],
      ];
    case 'GPU':
      return [
        ['칩셋', specs.chipset],
        ['메모리', `${specs.memoryType} ${specs.memoryCapacity}GB`],
        ['길이', `${specs.length}mm`],
        ['권장 파워', `${specs.recommendedPower}W`],
        ['포트', specs.ports],
      ];
    case 'POWER':
      return [
        ['정격 출력', `${specs.ratedPower}W`],
        ['80PLUS', specs.certification],
        ['폼팩터', specs.formFactor],
      ];
    case 'SSD':
      return [
        ['규격', specs.formFactor],
        ['용량', `${specs.capacity}GB`],
        ['읽기 속도', `${specs.readSpeed}MB/s`],
        ['쓰기 속도', `${specs.writeSpeed}MB/s`],
      ];
    case 'HDD':
      return [
        ['인터페이스', specs.interface],
        ['용량', `${specs.capacity}TB`],
        ['RPM', `${specs.rpm}RPM`],
        ['버퍼', `${specs.bufferMemory}MB`],
      ];
    case 'MONITOR':
      return [
        ['화면 크기', `${specs.screenSize}인치`],
        ['해상도', specs.resolution],
        ['패널', specs.panelType],
        ['주사율', `${specs.refreshRate}Hz`],
        ['비율', specs.aspectRatio],
      ];
    default:
      return [];
  }
};

export default function SearchPage() {
  const [selectedCategory, setSelectedCategory] = useState('ALL');
  const [searchTerm, setSearchTerm] = useState('');
  const [debouncedSearchTerm, setDebouncedSearchTerm] = useState('');
  const [selectedProductId, setSelectedProductId] = useState(null);

  // 마지막으로 받은 검색 결과. queryKey 가 현재 검색 조건과 다르면 새 결과를 기다리는 중이다.
  const [searchResult, setSearchResult] = useState(null);
  const [isLoadingMore, setIsLoadingMore] = useState(false);

  const queryKey = `${selectedCategory}|${debouncedSearchTerm}`;
  const currentResult = searchResult?.queryKey === queryKey ? searchResult : null;
  const products = currentResult?.products ?? [];
  const hasNext = currentResult?.hasNext ?? false;
  const totalElements = currentResult?.totalElements ?? 0;
  const errorMessage = currentResult?.errorMessage ?? null;
  const isLoading = currentResult === null || isLoadingMore;

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

  return (
    <div className="search-page">
      <Header />

      <main className="search-page__content">
        <section className="search-page__panel">
          <div className="search-page__header">
            <div>
              <span className="search-page__eyebrow">견적 검색</span>
              <h1>부품별 최저가와 상세 스펙을 한눈에 확인하세요.</h1>
            </div>
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

          <div className="search-page__layout">
            <div className="search-page__results">
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
                    {/* 제품 이미지는 아직 없어서 검정 박스로 대신한다. */}
                    <div className="search-page__card-image-wrap" aria-hidden="true" />

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
                <div className="search-page__detail-image-wrap" aria-hidden="true" />

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
                  <button type="button" className="search-page__primary-button">
                    견적에 추가
                  </button>
                  <button type="button" className="search-page__secondary-button">
                    비교하기
                  </button>
                </div>
              </aside>
            )}
          </div>
        </section>
      </main>

      <Footer />
    </div>
  );
}
