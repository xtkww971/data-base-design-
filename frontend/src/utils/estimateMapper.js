// NL2SQL 응답(rows)을 추천 페이지의 부품 구성(configuration)으로 바꾼다.
// LLM 이 SQL 을 만들기 때문에 응답 형태가 매번 같지 않아 두 가지 형태를 모두 처리한다.
//  1) 부품 한 개당 한 행: { category_id 또는 category_name, name, price, ... }
//  2) 견적 한 개당 한 행: { cpu_name, cpu_price, mb_name, gpu_name, ..., total_price }

export const CONFIG_KEYS = ['cpu', 'motherboard', 'ram', 'gpu', 'power', 'ssd', 'hdd', 'monitor'];

// categories 테이블 기준 (category_id -> 화면 키)
const CATEGORY_ID_TO_KEY = {
  1: 'cpu',
  2: 'motherboard',
  3: 'ram',
  4: 'gpu',
  5: 'power',
  6: 'ssd',
  7: 'hdd',
  8: 'monitor',
};

// category_name 이나 컬럼 접두어로 올 수 있는 이름들 (소문자로 비교)
const ALIAS_TO_KEY = {
  cpu: 'cpu',
  mainboard: 'motherboard',
  main_board: 'motherboard',
  motherboard: 'motherboard',
  mb: 'motherboard',
  ram: 'ram',
  memory: 'ram',
  gpu: 'gpu',
  vga: 'gpu',
  power: 'power',
  psu: 'power',
  ssd: 'ssd',
  hdd: 'hdd',
  monitor: 'monitor',
};

const createEmptyConfiguration = () =>
  Object.fromEntries(CONFIG_KEYS.map((key) => [key, undefined]));

const toNumber = (value) => {
  if (value === null || value === undefined || value === '') {
    return null;
  }
  const number = Number(value);
  return Number.isFinite(number) ? number : null;
};

const formatPrice = (price) => `${price.toLocaleString('ko-KR')}원`;

const describePart = (name, price) => {
  if (!name) {
    return undefined;
  }
  return price === null ? String(name) : `${name} · ${formatPrice(price)}`;
};

const resolveCategoryKey = (row) => {
  const byId = CATEGORY_ID_TO_KEY[toNumber(row.category_id)];
  if (byId) {
    return byId;
  }
  const name = typeof row.category_name === 'string' ? row.category_name.trim().toLowerCase() : '';
  return ALIAS_TO_KEY[name];
};

// 1) 부품 한 개당 한 행. 같은 부품이 여러 개면 SQL 정렬 순서상 첫 번째를 쓴다.
function mapLongRows(rows) {
  const configuration = createEmptyConfiguration();
  let totalPrice = 0;

  for (const row of rows) {
    const key = resolveCategoryKey(row);
    if (!key || configuration[key] !== undefined) {
      continue;
    }
    const price = toNumber(row.price);
    configuration[key] = describePart(row.name, price);
    totalPrice += price ?? 0;
  }

  return { configuration, totalPrice: totalPrice || null };
}

// 2) 견적 한 개당 한 행. "<접두어>_name" 컬럼을 찾아 부품으로 묶는다. 첫 번째 견적을 쓴다.
function mapWideRow(row) {
  const configuration = createEmptyConfiguration();
  let summedPrice = 0;

  for (const column of Object.keys(row)) {
    const match = /^(.+)_name$/i.exec(column);
    if (!match || match[1].toLowerCase() === 'category') {
      continue;
    }
    const prefix = match[1];
    const key = ALIAS_TO_KEY[prefix.toLowerCase()];
    if (!key || configuration[key] !== undefined) {
      continue;
    }
    const price = toNumber(row[`${prefix}_price`]);
    configuration[key] = describePart(row[column], price);
    summedPrice += price ?? 0;
  }

  const totalPrice = toNumber(row.total_price) ?? (summedPrice || null);
  return { configuration, totalPrice };
}

const isWideRow = (row) =>
  Object.keys(row).some((column) => {
    const match = /^(.+)_name$/i.exec(column);
    return match && ALIAS_TO_KEY[match[1].toLowerCase()];
  });

/**
 * @param {{ rows?: Array<Record<string, unknown>> }} response NlQueryResponse
 * @returns {{ configuration: Record<string, string | undefined>, totalPrice: number | null, isEmpty: boolean }}
 */
export function mapEstimate(response) {
  const rows = Array.isArray(response?.rows) ? response.rows : [];
  if (rows.length === 0) {
    return { configuration: createEmptyConfiguration(), totalPrice: null, isEmpty: true };
  }

  const { configuration, totalPrice } = isWideRow(rows[0]) ? mapWideRow(rows[0]) : mapLongRows(rows);
  const isEmpty = Object.values(configuration).every((value) => value === undefined);
  return { configuration, totalPrice, isEmpty };
}

export { formatPrice };
