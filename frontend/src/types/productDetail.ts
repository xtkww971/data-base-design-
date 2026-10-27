export type ProductCategory =
  | 'CPU'
  | 'MAINBOARD'
  | 'RAM'
  | 'GPU'
  | 'POWER'
  | 'SSD'
  | 'HDD'
  | 'MONITOR';

export interface BaseProductDetail {
  id: number;
  category: ProductCategory;
  name: string;
  brand: string;
  price: number;
  imageUrl: string;
  /** 성능 점수. 카테고리마다 지표가 달라 같은 카테고리 안에서만 비교. 지표가 없으면 null */
  performanceScore: number | null;
}

export interface CpuDetailResponse extends BaseProductDetail {
  specs: {
    socket: string;
    cores: number;
    threads: number;
    hasGraphics: boolean;
    clockSpeed: string;
  };
}

export interface MainboardDetailResponse extends BaseProductDetail {
  specs: {
    socket: string;
    formFactor: string;
    memorySpec: string;
    memorySlots: number;
    chipset: string;
  };
}

export interface RamDetailResponse extends BaseProductDetail {
  specs: {
    memorySpec: string;
    capacity: number;
    clock: number;
    packageCount: number;
  };
}

export interface PowerDetailResponse extends BaseProductDetail {
  specs: {
    ratedPower: number;
    certification: string;
    formFactor: string;
  };
}

export interface GpuDetailResponse extends BaseProductDetail {
  specs: {
    chipset: string;
    memoryType: string;
    memoryCapacity: number;
    length: number;
    recommendedPower: number;
    ports: string;
  };
}

export interface SsdDetailResponse extends BaseProductDetail {
  specs: {
    formFactor: string;
    capacity: number;
    readSpeed: number;
    writeSpeed: number;
  };
}

export interface HddDetailResponse extends BaseProductDetail {
  specs: {
    interface: string;
    capacity: number;
    rpm: number;
    bufferMemory: number;
  };
}

export interface MonitorDetailResponse extends BaseProductDetail {
  specs: {
    screenSize: number;
    resolution: string;
    panelType: string;
    refreshRate: number;
    aspectRatio: string;
  };
}

export const PRODUCT_CATEGORIES: Array<'ALL' | ProductCategory> = [
  'ALL',
  'CPU',
  'MAINBOARD',
  'RAM',
  'GPU',
  'POWER',
  'SSD',
  'HDD',
  'MONITOR',
];

export type ProductDetail =
  | CpuDetailResponse
  | MainboardDetailResponse
  | RamDetailResponse
  | PowerDetailResponse
  | GpuDetailResponse
  | SsdDetailResponse
  | HddDetailResponse
  | MonitorDetailResponse;

// GET /api/modules/search 응답 (백엔드 PageResponse)
export interface PageResponse<T> {
  content: T[];
  page: number;
  size: number;
  totalElements: number;
  totalPages: number;
  hasNext: boolean;
}
