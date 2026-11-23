// 장바구니에 담긴 부품 조합의 호환성을 판별한다.
// 규칙 ID 는 docs/스키마 설계/04-부품별-제약조건.md 와 같고, 상세 API 응답의 스펙만으로 판별할 수 있는 규칙만 다룬다.
// B7·B8·B9, W1·W2·W4·W5 는 필요한 컬럼(V7)이 상세 API 응답에 아직 없어 제외했다.

// 판별에 스펙이 필요한 카테고리. 이 카테고리 부품만 상세 API 로 스펙을 받아온다.
export const SPEC_CATEGORIES = ['CPU', 'MAINBOARD', 'RAM', 'GPU', 'POWER'];

// B6: 완성 견적에 반드시 있어야 하는 부품
const REQUIRED_CATEGORIES = { CPU: 'CPU', MAINBOARD: '메인보드', RAM: '램', POWER: '파워' };

// 견적에 하나만 들어가는 부품
const SINGLE_CATEGORIES = { CPU: 'CPU', MAINBOARD: '메인보드', POWER: '파워' };

/**
 * @param {Array<{ id: number, category: string, quantity: number }>} items 장바구니 항목
 * @param {Record<number, { specs?: object } | null>} details 부품 id 별 상세 응답. 없거나 실패(null)한 부품은 스펙 규칙에서 빠진다.
 * @returns {Array<{ rule: string, level: 'error' | 'warning', message: string }>} 조립 불가(error)가 앞에 온다.
 */
export function checkCompatibility(items, details) {
  const issues = [];
  const messages = new Set();
  const add = (rule, level, message) => {
    // CPU 를 두 개 담은 경우처럼 같은 위반이 여러 쌍에서 나오면 한 번만 보여준다.
    if (messages.has(message)) return;
    messages.add(message);
    issues.push({ rule, level, message });
  };

  const byCategory = (category) => items.filter((item) => item.category === category);
  const withSpecs = (category) =>
    byCategory(category)
      .map((item) => ({ item, specs: details[item.id]?.specs }))
      .filter(({ specs }) => specs);

  const cpus = withSpecs('CPU');
  const boards = withSpecs('MAINBOARD');
  const rams = withSpecs('RAM');
  const gpus = withSpecs('GPU');
  const powers = withSpecs('POWER');

  for (const [category, label] of Object.entries(SINGLE_CATEGORIES)) {
    const count = byCategory(category).reduce((sum, item) => sum + item.quantity, 0);
    if (count > 1) {
      add('수량', 'warning', `${label}를 ${count}개 담았어요. 견적에는 하나만 들어가요.`);
    }
  }

  for (const cpu of cpus) {
    for (const board of boards) {
      if (cpu.specs.socket !== board.specs.socket) {
        add('B1', 'error', `CPU 소켓(${cpu.specs.socket})과 메인보드 소켓(${board.specs.socket})이 달라요.`);
      }
    }
  }

  for (const ram of rams) {
    for (const board of boards) {
      if (ram.specs.memorySpec !== board.specs.memorySpec) {
        add('B2', 'error', `램 규격(${ram.specs.memorySpec})과 메인보드 메모리 규격(${board.specs.memorySpec})이 달라요.`);
      }
    }
  }

  // 램 총 모듈 수 = 키트 안 모듈 수 × 담은 수량
  const moduleCount = rams.reduce((sum, { item, specs }) => sum + specs.packageCount * item.quantity, 0);
  for (const board of boards) {
    if (moduleCount > board.specs.memorySlots) {
      add('B3', 'error', `램 모듈 ${moduleCount}개가 메인보드 메모리 슬롯 ${board.specs.memorySlots}개보다 많아요.`);
    }
  }

  if (byCategory('GPU').length === 0 && cpus.some(({ specs }) => specs.hasGraphics === false)) {
    add('B4', 'error', '내장 그래픽이 없는 CPU라 그래픽카드가 필요해요.');
  }

  for (const power of powers) {
    for (const gpu of gpus) {
      if (power.specs.ratedPower < gpu.specs.recommendedPower) {
        add(
          'B5',
          'error',
          `파워 정격 출력(${power.specs.ratedPower}W)이 그래픽카드 권장 파워(${gpu.specs.recommendedPower}W)보다 낮아요.`,
        );
      }
    }
  }

  const missing = Object.entries(REQUIRED_CATEGORIES)
    .filter(([category]) => byCategory(category).length === 0)
    .map(([, label]) => label);
  if (missing.length > 0) {
    add('B6', 'warning', `견적을 완성하려면 다음 부품이 더 필요해요: ${missing.join(', ')}`);
  }

  // 스펙을 못 받은 램이 있으면 모듈 수를 확정할 수 없으므로 판단하지 않는다.
  if (moduleCount === 1 && rams.length === byCategory('RAM').length) {
    add('W3', 'warning', '램 모듈이 1개라 싱글 채널로 동작해요. 2개 이상이면 듀얼 채널로 더 빨라져요.');
  }

  return issues.sort((a, b) => (a.level === 'error' ? 0 : 1) - (b.level === 'error' ? 0 : 1));
}
