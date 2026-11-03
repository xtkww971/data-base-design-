import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import { addToCart, useCartItems } from '../cart/cartStore.js';
import { DUMMY_IMAGES } from '../assets/dummyImages.js';
import { fetchProductDetail } from '../api/productApi.js';
import { getSpecEntries } from '../utils/productSpecs.js';
import {
  deleteEntry,
  selectEntry,
  submitQuestion,
  useRecommendationHistory,
} from '../recommendation/historyStore.js';
import './RecommendationPage.css';

const SIDEBAR_BREAKPOINT = 900; // 이 폭 이하면 자동으로 닫힘

const defaultPrompt =
  '300만원 안팎의 예산으로 컴퓨터 견적 맞춰줘.';


const MAX_PROGRAMS = 5;
const MAN_WON = 10000;

const programSuggestions = [
  '리그 오브 레전드',
  '배틀그라운드',
  '발로란트',
  '로스트아크',
  '오버워치 2',
  '프리미어 프로',
  '포토샵',
  '블렌더',
  '사무용·웹서핑',
];

// 예산 프리셋 (만원 단위). null 은 그 쪽 경계가 없음
const pricePresets = [
  { label: '~100만원', min: null, max: 100 },
  { label: '100~150만원', min: 100, max: 150 },
  { label: '150~200만원', min: 150, max: 200 },
  { label: '200~300만원', min: 200, max: 300 },
  { label: '300만원 이상', min: 300, max: null },
];

const toManWon = (value) => (value === '' ? null : Number(value));

const CATEGORY_ORDER = ['CPU', 'MAINBOARD', 'RAM', 'GPU', 'POWER', 'SSD', 'HDD', 'MONITOR'];

const CATEGORY_LABELS = {
  CPU: 'CPU',
  MAINBOARD: '메인보드',
  RAM: '램',
  GPU: '그래픽카드',
  POWER: '파워',
  SSD: 'SSD',
  HDD: 'HDD',
  MONITOR: '모니터',
};

// 부품별 핵심 스펙. 결과 표는 부품마다 따로 나오고, 제품명·가격 다음에 이 스펙만 보여준다.
// 각 항목은 같은 스펙을 가리키는 컬럼 이름 후보다. AI 가 여러 테이블을 조인하면 별칭(cpu_socket 등)을 붙인다.
const CATEGORY_SPECS = {
  CPU: [['cores'], ['threads'], ['socket', 'cpu_socket']],
  MAINBOARD: [['socket', 'mb_socket'], ['memory_spec'], ['chipset', 'mb_chipset']],
  RAM: [['memory_spec'], ['capacity'], ['clock']],
  GPU: [['memory_capacity'], ['recommended_power']],
  POWER: [['rated_power'], ['certification']],
  SSD: [['capacity'], ['read_speed']],
  HDD: [['capacity'], ['rpm']],
  MONITOR: [['screen_size'], ['resolution'], ['refresh_rate']],
};

// 결과 표에서 숨기는 내부 컬럼 (부품을 알 수 없는 결과일 때만 쓴다)
const HIDDEN_COLUMNS = new Set(['module_id', 'category_id', 'image_url']);

const COLUMN_LABELS = {
  name: '제품명',
  price: '가격',
  cores: '코어',
  threads: '스레드',
  socket: '소켓',
  cpu_socket: '소켓',
  mb_socket: '소켓',
  chipset: '칩셋',
  mb_chipset: '칩셋',
  memory_spec: '메모리 규격',
  capacity: '용량',
  clock: '클럭',
  memory_capacity: 'VRAM',
  recommended_power: '권장 파워',
  rated_power: '정격 출력',
  certification: '인증',
  read_speed: '읽기 속도',
  rpm: '회전수',
  screen_size: '크기',
  resolution: '해상도',
  refresh_rate: '주사율',
};

// 값에 단위를 붙인다. capacity 는 카테고리마다 단위가 달라 행을 함께 받는다.
const UNIT_FORMATTERS = {
  cores: (v) => `${v}코어`,
  threads: (v) => `${v}스레드`,
  clock: (v) => `${v}MT/s`,
  memory_capacity: (v) => `${v}GB`,
  recommended_power: (v) => `${v}W`,
  rated_power: (v) => `${v}W`,
  read_speed: (v) => `${Number(v).toLocaleString()}MB/s`,
  rpm: (v) => `${Number(v).toLocaleString()}RPM`,
  screen_size: (v) => `${v}인치`,
  refresh_rate: (v) => `${v}Hz`,
};

// categories 테이블의 id (V3 에서 넣은 순서). AI 결과에 category_name 이 없을 때 쓴다.
const CATEGORY_BY_ID = {
  1: 'CPU',
  2: 'MAINBOARD',
  3: 'RAM',
  4: 'GPU',
  5: 'POWER',
  6: 'SSD',
  7: 'HDD',
  8: 'MONITOR',
};

const getCategory = (row) => row.category_name ?? CATEGORY_BY_ID[row.category_id] ?? null;

// 결과에 있는 컬럼 중 이 부품의 핵심 스펙에 해당하는 컬럼 이름
const specColumnsFor = (category, columns) =>
  (CATEGORY_SPECS[category] ?? [])
    .map((candidates) => candidates.find((column) => columns.includes(column)))
    .filter(Boolean);

const canAddToCart = (row) => row.module_id != null && row.name != null && row.price != null;

const toCartItem = (row) => ({
  id: row.module_id,
  category: getCategory(row) ?? '기타',
  name: row.name,
  brand: row.brand ?? '',
  price: Number(row.price),
  imageUrl: row.image_url ?? null,
  // 결과 표와 같은 핵심 스펙. 예: "DDR5 / 32GB / 6000MT/s"
  summary: specColumnsFor(getCategory(row), Object.keys(row))
    .filter((column) => row[column] !== null && row[column] !== undefined)
    .map((column) => formatCell(column, row[column], row))
    .join(' / '),
});

const formatCell = (column, value, row) => {
  if (value === null || value === undefined) {
    return '-';
  }
  if (typeof value === 'boolean') {
    return value ? '예' : '아니오';
  }
  if (column === 'price' || column.endsWith('_price')) {
    return `${Number(value).toLocaleString()}원`;
  }
  if (column === 'capacity') {
    return `${Number(value).toLocaleString()}${getCategory(row) === 'HDD' ? 'TB' : 'GB'}`;
  }
  if (UNIT_FORMATTERS[column]) {
    return UNIT_FORMATTERS[column](value);
  }
  if (typeof value === 'number') {
    return value.toLocaleString();
  }
  return String(value);
};

// 간편 입력 값을 자연어 질의 문장으로 바꾼다. 백엔드가 자연어만 받기 때문이다.
const buildPromptFromForm = (programs, minManWon, maxManWon) => {
  let priceText = '';
  if (minManWon !== null && maxManWon !== null) {
    priceText = `${minManWon}만원~${maxManWon}만원`;
  } else if (maxManWon !== null) {
    priceText = `${maxManWon}만원 이하`;
  } else if (minManWon !== null) {
    priceText = `${minManWon}만원 이상`;
  }

  if (programs.length > 0 && priceText) {
    return `${programs.join(', ')} 용도로 ${priceText} 예산의 컴퓨터 견적 맞춰줘.`;
  }
  if (programs.length > 0) {
    return `${programs.join(', ')} 용도로 컴퓨터 견적 맞춰줘.`;
  }
  return `${priceText} 예산으로 컴퓨터 견적 맞춰줘.`;
};


const CONFIG_LIMITS = {
  ram: 4,
  monitor: 2,
};

const formatConfigurationValue = (key, value) => {
  if (value === undefined || value === null || value === '') {
    return 'Null';
  }

  if (Array.isArray(value)) {
    const limit = CONFIG_LIMITS[key] ?? value.length;
    const limitedItems = value.slice(0, limit);

    if (key === 'ram' || key === 'monitor') {
      return limitedItems.length > 0 ? `x${limitedItems.length}` : '미정';
    }

    return limitedItems.length > 0 ? limitedItems.join(', ') : '미정';
  }

  return value;
};

// 결과 행을 부품별로 나눈다. 부품마다 제품명·가격과 그 부품의 핵심 스펙 컬럼만 둔다.
// 부품을 알 수 없는 행(개수 집계 등)은 마지막 묶음에 내부 컬럼만 빼고 모두 보여준다.
const groupResultByCategory = (result) => {
  const byCategory = new Map();
  const unknown = [];
  result.rows.forEach((row) => {
    const category = getCategory(row);
    if (category && CATEGORY_SPECS[category]) {
      if (!byCategory.has(category)) byCategory.set(category, []);
      byCategory.get(category).push(row);
    } else {
      unknown.push(row);
    }
  });

  const groups = CATEGORY_ORDER.filter((category) => byCategory.has(category)).map((category) => {
    // 조합 결과는 같은 부품이 여러 행에 나오므로 카드는 부품당 한 장만 둔다 (AI 가 정렬한 순서 유지)
    const seen = new Set();
    const rows = byCategory.get(category).filter((row) => {
      if (row.module_id == null) return true;
      if (seen.has(row.module_id)) return false;
      seen.add(row.module_id);
      return true;
    });
    // 조인 결과에서 이 부품 행에는 비어 있는 스펙 컬럼은 뺀다
    const specColumns = specColumnsFor(category, result.columns).filter((column) =>
      rows.some((row) => row[column] !== null && row[column] !== undefined),
    );
    return { key: category, category, title: CATEGORY_LABELS[category], specColumns, rows };
  });

  if (unknown.length > 0) {
    groups.push({
      key: 'unknown',
      category: null,
      title: groups.length > 0 ? '기타' : null,
      columns: result.columns.filter((column) => !HIDDEN_COLUMNS.has(column)),
      rows: unknown,
    });
  }
  return groups;
};

const INITIAL_CARD_COUNT = 6;

function CartButton({ row, cartIds }) {
  if (!canAddToCart(row)) {
    return null;
  }
  if (cartIds.has(row.module_id)) {
    return <span className="recommendation-page__cart-added">담김 ✓</span>;
  }
  return (
    <button
      type="button"
      className="recommendation-page__cart-button"
      onClick={() => addToCart(toCartItem(row))}
      aria-label={`${row.name} 장바구니에 담기`}
    >
      담기
    </button>
  );
}

// 부품 카드. ▶ 상세 스펙을 처음 펼칠 때 상세 API 로 전체 스펙을 받아온다.
// AI 결과에는 스펙이 일부만 있거나 아예 없을 수 있기 때문이다.
function PartCard({ category, row, specColumns, cartIds }) {
  const [isOpen, setIsOpen] = useState(false);
  const [detail, setDetail] = useState(null);
  const [detailError, setDetailError] = useState('');
  const canShowDetail = row.module_id != null;

  const toggleDetail = () => {
    const nextOpen = !isOpen;
    setIsOpen(nextOpen);
    if (nextOpen && !detail) {
      setDetailError('');
      fetchProductDetail(category, row.module_id)
        .then(setDetail)
        .catch((error) => setDetailError(error.message));
    }
  };

  return (
    <article className={`recommendation-page__part-card ${isOpen ? 'is-open' : ''}`}>
      <div className="recommendation-page__part-image-wrap" aria-hidden="true">
        <img
          className="recommendation-page__part-image"
          src={row.image_url || DUMMY_IMAGES[category]}
          alt=""
          loading="lazy"
        />
      </div>
      <div className="recommendation-page__part-body">
        <h4 className="recommendation-page__part-name">{row.name}</h4>
        <strong className="recommendation-page__part-price">{formatCell('price', row.price, row)}</strong>
        {specColumns.length > 0 ? (
          <div className="recommendation-page__part-specs">
            {specColumns
              .filter((column) => row[column] !== null && row[column] !== undefined)
              .map((column) => (
                <span key={column} className="recommendation-page__part-spec">
                  <em>{COLUMN_LABELS[column] ?? column}</em>
                  {formatCell(column, row[column], row)}
                </span>
              ))}
          </div>
        ) : null}
      </div>

      <div className="recommendation-page__part-actions">
        {canShowDetail ? (
          <button
            type="button"
            className="recommendation-page__detail-toggle"
            onClick={toggleDetail}
            aria-expanded={isOpen}
          >
            <span className="recommendation-page__detail-arrow" aria-hidden="true">
              ▶
            </span>
            상세 스펙
          </button>
        ) : (
          <span />
        )}
        <CartButton row={row} cartIds={cartIds} />
      </div>

      {isOpen ? (
        <div className="recommendation-page__part-detail">
          {detailError ? (
            <p className="recommendation-page__part-detail-error">{detailError}</p>
          ) : !detail ? (
            <p className="recommendation-page__part-detail-loading">불러오는 중…</p>
          ) : (
            <dl className="recommendation-page__part-detail-list">
              <div>
                <dt>제조사</dt>
                <dd>{detail.brand}</dd>
              </div>
              {getSpecEntries(detail).map(([label, value]) => (
                <div key={label}>
                  <dt>{label}</dt>
                  <dd>{value}</dd>
                </div>
              ))}
              <div>
                <dt>성능 점수</dt>
                <dd>{detail.performanceScore == null ? '-' : detail.performanceScore.toLocaleString()}</dd>
              </div>
            </dl>
          )}
        </div>
      ) : null}
    </article>
  );
}

// 부품 한 종류의 결과. 처음 6개만 카드로 보여주고 나머지는 "더 보기"로 펼친다.
function CardSection({ category, title, specColumns, rows, cartIds }) {
  const [isExpanded, setIsExpanded] = useState(false);
  const visibleRows = isExpanded ? rows : rows.slice(0, INITIAL_CARD_COUNT);
  const hiddenCount = rows.length - INITIAL_CARD_COUNT;

  return (
    <section className="recommendation-page__result-section">
      <h3 className="recommendation-page__result-section-title">
        {title} <span>{rows.length}개</span>
      </h3>

      <div className="recommendation-page__card-grid">
        {visibleRows.map((row, rowIndex) => (
          <PartCard
            key={row.module_id ?? rowIndex}
            category={category}
            row={row}
            specColumns={specColumns}
            cartIds={cartIds}
          />
        ))}
      </div>

      {hiddenCount > 0 ? (
        <button
          type="button"
          className="recommendation-page__more-button"
          onClick={() => setIsExpanded((prev) => !prev)}
        >
          {isExpanded ? '접기' : `${hiddenCount}개 더 보기`}
        </button>
      ) : null}
    </section>
  );
}

// 부품을 알 수 없는 결과(개수 집계 등)는 표로 보여준다.
function TableSection({ title, columns, rows, cartIds }) {
  const showCartColumn = rows.some(canAddToCart);

  return (
    <section className="recommendation-page__result-section">
      {title ? (
        <h3 className="recommendation-page__result-section-title">
          {title} <span>{rows.length}개</span>
        </h3>
      ) : null}

      <div className="recommendation-page__result-scroll">
        <table className="recommendation-page__result-table">
          <thead>
            <tr>
              {showCartColumn ? <th aria-label="장바구니" /> : null}
              {columns.map((column) => (
                <th key={column}>{COLUMN_LABELS[column] ?? column}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((row, rowIndex) => (
              // 조합 결과는 같은 부품이 여러 행에 나오므로 index 를 키로 쓴다
              <tr key={rowIndex}>
                {showCartColumn ? (
                  <td>
                    <CartButton row={row} cartIds={cartIds} />
                  </td>
                ) : null}
                {columns.map((column) => (
                  <td key={column} className={column === 'name' ? 'is-name' : ''}>
                    {formatCell(column, row[column], row)}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </section>
  );
}

function ResultTable({ result }) {
  const cartItems = useCartItems();
  const cartIds = new Set(cartItems.map((item) => item.id));
  const groups = groupResultByCategory(result);

  return (
    <div className="recommendation-page__result">
      <div className="recommendation-page__result-meta">
        <span>{result.rowCount === 0 ? '조건에 맞는 부품이 없습니다.' : `${result.rowCount}개 결과`}</span>
        {cartItems.length > 0 ? (
          <Link to="/cart" className="recommendation-page__cart-link">
            장바구니 보기 ({cartItems.length}) →
          </Link>
        ) : null}
      </div>

      {groups.map((group) =>
        group.category ? (
          <CardSection
            key={group.key}
            category={group.category}
            title={group.title}
            specColumns={group.specColumns}
            rows={group.rows}
            cartIds={cartIds}
          />
        ) : (
          <TableSection
            key={group.key}
            title={group.title}
            columns={group.columns}
            rows={group.rows}
            cartIds={cartIds}
          />
        ),
      )}

      <details className="recommendation-page__result-sql">
        <summary>AI가 만든 SQL 보기</summary>
        <pre>{result.sql}</pre>
      </details>
    </div>
  );
}

export default function RecommendationPage() {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  // 질문 내역은 페이지를 나갔다 와도 남도록 저장소에 둔다
  const { entries: recentPrompts, selectedId } = useRecommendationHistory();
  const [promptText, setPromptText] = useState(defaultPrompt);
  const isGenerating = recentPrompts.some((entry) => entry.status === 'loading');

  // 'form' 간편 입력 / 'text' 자연어 입력
  const [inputMode, setInputMode] = useState('form');
  const [programs, setPrograms] = useState([]);
  const [programInput, setProgramInput] = useState('');
  const [minPrice, setMinPrice] = useState(''); // 만원 단위 숫자 문자열
  const [maxPrice, setMaxPrice] = useState('');
  const [formError, setFormError] = useState('');

  const selectedPrompt = recentPrompts.find((entry) => entry.id === selectedId) ?? null;

  const addProgram = (rawName) => {
    const name = rawName.trim();
    if (!name) {
      return;
    }
    if (programs.length >= MAX_PROGRAMS) {
      setFormError(`프로그램은 최대 ${MAX_PROGRAMS}개까지 입력할 수 있어요.`);
      return;
    }
    if (!programs.includes(name)) {
      setPrograms((prev) => [...prev, name]);
    }
    setProgramInput('');
    setFormError('');
  };

  const removeProgram = (name) => {
    setPrograms((prev) => prev.filter((program) => program !== name));
  };

  const handleProgramKeyDown = (event) => {
    if (event.nativeEvent.isComposing) {
      return; // 한글 조합 중 Enter 는 무시
    }
    if (event.key === 'Enter' || event.key === ',') {
      event.preventDefault();
      addProgram(programInput);
    } else if (event.key === 'Backspace' && programInput === '' && programs.length > 0) {
      setPrograms((prev) => prev.slice(0, -1));
    }
  };

  const handlePriceChange = (setter) => (event) => {
    setter(event.target.value.replace(/[^0-9]/g, '').slice(0, 5));
    setFormError('');
  };

  const applyPricePreset = (preset) => {
    setMinPrice(preset.min === null ? '' : String(preset.min));
    setMaxPrice(preset.max === null ? '' : String(preset.max));
    setFormError('');
  };

  const isPresetActive = (preset) =>
    toManWon(minPrice) === preset.min && toManWon(maxPrice) === preset.max;

  // conditions: 간편 입력의 원래 값. NL2SQL 키워드 형식과 같다: programs, price { min, max } (원 단위)
  const submitPrompt = (trimmedPrompt, conditions = null) => {
    if (!trimmedPrompt || isGenerating) {
      return;
    }
    submitQuestion(trimmedPrompt, conditions);
  };

  const handleSubmitText = () => {
    const trimmedPrompt = promptText.trim();
    if (!trimmedPrompt || isGenerating) {
      return;
    }
    submitPrompt(trimmedPrompt);
    setPromptText('');
  };

  const handleSubmitForm = () => {
    if (isGenerating) {
      return;
    }

    // 입력칸에 남아 있는 프로그램 이름도 포함한다
    const pending = programInput.trim();
    const allPrograms =
      pending && !programs.includes(pending) && programs.length < MAX_PROGRAMS
        ? [...programs, pending]
        : programs;
    const minManWon = toManWon(minPrice);
    const maxManWon = toManWon(maxPrice);

    if (allPrograms.length === 0 && minManWon === null && maxManWon === null) {
      setFormError('사용할 프로그램이나 예산 중 하나는 입력해 주세요.');
      return;
    }
    if (minManWon !== null && maxManWon !== null && minManWon > maxManWon) {
      setFormError('최소 예산이 최대 예산보다 클 수 없어요.');
      return;
    }

    setPrograms(allPrograms);
    setProgramInput('');
    setFormError('');
    submitPrompt(buildPromptFromForm(allPrograms, minManWon, maxManWon), {
      programs: allPrograms,
      price: {
        min: minManWon === null ? null : minManWon * MAN_WON,
        max: maxManWon === null ? null : maxManWon * MAN_WON,
      },
    });
  };

  useEffect(() => {
    function handleResize() {
      setIsSidebarOpen(window.innerWidth > SIDEBAR_BREAKPOINT);
    }

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return (
    <div className="recommendation-page">
      <Header />

      <button
        type="button"
        className={`recommendation-page__sidebar-toggle ${
          isSidebarOpen ? 'is-open' : 'is-closed'
        }`}
        onClick={() => setIsSidebarOpen((prev) => !prev)}
        aria-label="사이드바 토글"
      >
        ☰
      </button>

      <div className="recommendation-page__stage recommendation-page__header--animated">
        <main className="recommendation-page__content recommendation-page__content--animated">
          <aside
            className={`recommendation-page__sidebar ${
              isSidebarOpen ? 'is-open' : 'is-closed'
            }`}
          >
            <div className="recommendation-page__sidebar-header">
              <span className="recommendation-page__sidebar-icon" aria-hidden="true" />
              질문 내역
            </div>

            <div className="recommendation-page__sidebar-body">
              <ul className="recommendation-page__recent-list">
                {recentPrompts.map((item) => (
                  <li key={item.id}>
                    <div
                      className={`recommendation-page__recent-item-wrapper ${
                        selectedId === item.id ? 'is-selected' : ''
                      }`}
                    >
                      <button
                        type="button"
                        className="recommendation-page__recent-item"
                        onClick={() => selectEntry(item.id)}
                      >
                        <span className="recommendation-page__recent-date">{item.date}</span>
                        <p>{item.prompt}</p>
                      </button>

                      <button
                        type="button"
                        className="recommendation-page__recent-delete"
                        onClick={(event) => {
                          event.stopPropagation();
                          deleteEntry(item.id);
                        }}
                        aria-label={`${item.date} 항목 삭제`}
                      >
                        ×
                      </button>
                    </div>
                  </li>
                ))}
              </ul>
            </div>
          </aside>

          <section
            className={`recommendation-page__main-column ${
              isSidebarOpen ? 'sidebar-open' : 'sidebar-closed'
            }`}
          >
            <div className="recommendation-page__hero">
              <div className="recommendation-page__hero-badge">AI 추천</div>
              {inputMode === 'form' ? (
                <>
                  <h1>사용할 프로그램과 예산을 알려주세요.</h1>
                  <p>프로그램과 예산 중 하나만 입력해도 견적을 맞춰드려요.</p>
                </>
              ) : (
                <>
                  <h1>필요한 조건과 서비스를 자연어로 입력해보세요.</h1>
                  <p>
                   " 예시: 300만원 안팎의 예산으로 컴퓨터 견적 맞춰줘. "
                  </p>
                </>
              )}

              <div className="recommendation-page__mode-tabs" role="tablist" aria-label="입력 방식">
                <button
                  type="button"
                  role="tab"
                  aria-selected={inputMode === 'form'}
                  className={`recommendation-page__mode-tab ${inputMode === 'form' ? 'is-active' : ''}`}
                  onClick={() => setInputMode('form')}
                >
                  간편 입력
                </button>
                <button
                  type="button"
                  role="tab"
                  aria-selected={inputMode === 'text'}
                  className={`recommendation-page__mode-tab ${inputMode === 'text' ? 'is-active' : ''}`}
                  onClick={() => setInputMode('text')}
                >
                  자연어 입력
                </button>
              </div>

              {inputMode === 'form' ? (
                <div className="recommendation-page__prompt-box recommendation-page__form" role="tabpanel">
                  <div className="recommendation-page__field">
                    <label className="recommendation-page__field-label" htmlFor="program-input">
                      사용할 프로그램
                      <span className="recommendation-page__field-hint">
                        Enter로 추가 · 최대 {MAX_PROGRAMS}개
                      </span>
                    </label>

                    <div className="recommendation-page__chip-input">
                      {programs.map((program) => (
                        <span key={program} className="recommendation-page__chip">
                          {program}
                          <button
                            type="button"
                            className="recommendation-page__chip-remove"
                            onClick={() => removeProgram(program)}
                            aria-label={`${program} 삭제`}
                          >
                            ×
                          </button>
                        </span>
                      ))}
                      <input
                        id="program-input"
                        className="recommendation-page__chip-text"
                        value={programInput}
                        onChange={(event) => setProgramInput(event.target.value)}
                        onKeyDown={handleProgramKeyDown}
                        placeholder={programs.length === 0 ? '예: 배틀그라운드, 프리미어 프로' : ''}
                        maxLength={30}
                      />
                    </div>

                    <div className="recommendation-page__suggestions">
                      {programSuggestions
                        .filter((name) => !programs.includes(name))
                        .map((name) => (
                          <button
                            key={name}
                            type="button"
                            className="recommendation-page__suggestion"
                            onClick={() => addProgram(name)}
                          >
                            + {name}
                          </button>
                        ))}
                    </div>
                  </div>

                  <div className="recommendation-page__field">
                    <label className="recommendation-page__field-label" htmlFor="min-price">
                      예산
                      <span className="recommendation-page__field-hint">만원 단위 · 한쪽만 입력해도 돼요</span>
                    </label>

                    <div className="recommendation-page__price-range">
                      <div className="recommendation-page__price-input">
                        <input
                          id="min-price"
                          inputMode="numeric"
                          value={minPrice}
                          onChange={handlePriceChange(setMinPrice)}
                          placeholder="최소"
                          aria-label="최소 예산 (만원)"
                        />
                        <span>만원</span>
                      </div>
                      <span className="recommendation-page__price-separator">~</span>
                      <div className="recommendation-page__price-input">
                        <input
                          inputMode="numeric"
                          value={maxPrice}
                          onChange={handlePriceChange(setMaxPrice)}
                          placeholder="최대"
                          aria-label="최대 예산 (만원)"
                        />
                        <span>만원</span>
                      </div>
                    </div>

                    <div className="recommendation-page__suggestions">
                      {pricePresets.map((preset) => (
                        <button
                          key={preset.label}
                          type="button"
                          className={`recommendation-page__suggestion ${
                            isPresetActive(preset) ? 'is-active' : ''
                          }`}
                          onClick={() => applyPricePreset(preset)}
                        >
                          {preset.label}
                        </button>
                      ))}
                    </div>
                  </div>

                  {formError ? (
                    <div className="recommendation-page__form-error" role="alert">
                      {formError}
                    </div>
                  ) : null}

                  <div className="recommendation-page__prompt-actions">
                    <button
                      type="button"
                      className="recommendation-page__primary-button"
                      onClick={handleSubmitForm}
                      disabled={isGenerating}
                    >
                      AI 추천 분석
                    </button>
                  </div>
                </div>
              ) : (
                <div className="recommendation-page__prompt-box" role="tabpanel">
                  <textarea
                    className="recommendation-page__chat-input"
                    value={promptText}
                    onChange={(event) => setPromptText(event.target.value)}
                    rows={5}
                  />

                  <div className="recommendation-page__prompt-actions">
                    <button
                      type="button"
                      className="recommendation-page__primary-button"
                      onClick={handleSubmitText}
                      disabled={isGenerating}
                    >
                      AI 추천 분석
                    </button>
                  </div>
                </div>
              )}

              {selectedPrompt?.status === 'loading' ? (
                <div className="recommendation-page__loading-card">
                  <div className="recommendation-page__loading-spinner" aria-hidden="true" />
                  <div className="recommendation-page__loading-text">
                    AI가 분석 중입니다. 잠시만 기다려주세요!
                  </div>
                </div>
              ) : selectedPrompt ? (
                <div className="recommendation-page__analysis-card recommendation-page__analysis-card--full recommendation-page__selected-panel">
                  <div className="recommendation-page__analysis-title">AI 분석 결과</div>

                  <div className="recommendation-page__selected-summary">
                    <span className="recommendation-page__selected-date">{selectedPrompt.date}</span>
                    <p>{selectedPrompt.prompt}</p>
                    {selectedPrompt.conditions ? (
                      <div className="recommendation-page__condition-chips">
                        {selectedPrompt.conditions.programs.map((program) => (
                          <span key={program} className="recommendation-page__chip">
                            {program}
                          </span>
                        ))}
                        {selectedPrompt.conditions.price.min !== null ||
                        selectedPrompt.conditions.price.max !== null ? (
                          <span className="recommendation-page__chip is-price">
                            {selectedPrompt.conditions.price.min === null
                              ? ''
                              : `${(selectedPrompt.conditions.price.min / MAN_WON).toLocaleString()}만원`}
                            {' ~ '}
                            {selectedPrompt.conditions.price.max === null
                              ? ''
                              : `${(selectedPrompt.conditions.price.max / MAN_WON).toLocaleString()}만원`}
                          </span>
                        ) : null}
                      </div>
                    ) : null}
                  </div>

                  {/* 견적 조합(부품별 칸) 응답은 아직 없다. 생기면 configuration 으로 받아 보여준다. */}
                  {selectedPrompt.configuration ? (
                    <div className="recommendation-page__config-grid">
                      {Object.entries(selectedPrompt.configuration).map(([key, value]) => (
                        <div key={key} className="recommendation-page__config-item">
                          <span>{key}</span>
                          <strong
                            className={
                              key === 'ram' || key === 'monitor' ? 'is-count-chip' : ''
                            }
                          >
                            {formatConfigurationValue(key, value)}
                          </strong>
                        </div>
                      ))}
                    </div>
                  ) : null}

                  {selectedPrompt.error ? (
                    <div className="recommendation-page__result-error" role="alert">
                      {selectedPrompt.error}
                    </div>
                  ) : null}

                  {selectedPrompt.result ? (
                    // 질문을 바꾸면 "더 보기" 펼침 상태도 처음으로 돌린다
                    <ResultTable key={selectedPrompt.id} result={selectedPrompt.result} />
                  ) : null}
                </div>
              ) : null}
            </div>
          </section>
        </main>
      </div>

      <Footer />
    </div>
  );
}