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

export const mockProductDetails: Array<
  | CpuDetailResponse
  | MainboardDetailResponse
  | RamDetailResponse
  | PowerDetailResponse
  | GpuDetailResponse
  | SsdDetailResponse
  | HddDetailResponse
  | MonitorDetailResponse
> = [
  {
    id: 1,
    category: 'CPU',
    name: 'AMD 라이젠 5 7500F',
    brand: 'AMD',
    price: 189000,
    imageUrl:
      'https://images.unsplash.com/photo-1591799264318-7e6ef8ddb7ea?auto=format&fit=crop&w=900&q=80',
    specs: {
      socket: 'AM5',
      cores: 6,
      threads: 12,
      hasGraphics: false,
      clockSpeed: '3.7GHz',
    },
  },
  {
    id: 2,
    category: 'CPU',
    name: 'Intel Core i5-13400F',
    brand: 'Intel',
    price: 214000,
    imageUrl:
      'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=900&q=80',
    specs: {
      socket: 'LGA1700',
      cores: 6,
      threads: 12,
      hasGraphics: false,
      clockSpeed: '2.5GHz',
    },
  },
  {
    id: 3,
    category: 'MAINBOARD',
    name: 'MSI B650M GAMING PLUS',
    brand: 'MSI',
    price: 169000,
    imageUrl:
      'https://images.unsplash.com/photo-1555618565-3a0d0a1d1f1c?auto=format&fit=crop&w=900&q=80',
    specs: {
      socket: 'AM5',
      formFactor: 'M-ATX',
      memorySpec: 'DDR5',
      memorySlots: 4,
      chipset: 'B650',
    },
  },
  {
    id: 4,
    category: 'RAM',
    name: 'Corsair Vengeance DDR5-6000 32GB',
    brand: 'Corsair',
    price: 149000,
    imageUrl:
      'https://images.unsplash.com/photo-1587202372775-98927b4c6c7d?auto=format&fit=crop&w=900&q=80',
    specs: {
      memorySpec: 'DDR5',
      capacity: 32,
      clock: 6000,
      packageCount: 2,
    },
  },
  {
    id: 5,
    category: 'GPU',
    name: 'NVIDIA GeForce RTX 4060 Ti',
    brand: 'NVIDIA',
    price: 539000,
    imageUrl:
      'https://images.unsplash.com/photo-1625790061158-65b1f5ef8e9b?auto=format&fit=crop&w=900&q=80',
    specs: {
      chipset: 'RTX 4060 Ti',
      memoryType: 'GDDR6',
      memoryCapacity: 8,
      length: 228,
      recommendedPower: 600,
      ports: 'HDMI x1, DP x3',
    },
  },
  {
    id: 6,
    category: 'POWER',
    name: 'Seasonic FOCUS GX-750',
    brand: 'Seasonic',
    price: 179000,
    imageUrl:
      'https://images.unsplash.com/photo-1518773553398-650c184e0bb3?auto=format&fit=crop&w=900&q=80',
    specs: {
      ratedPower: 750,
      certification: 'Gold',
      formFactor: 'ATX',
    },
  },
  {
    id: 7,
    category: 'SSD',
    name: 'Samsung 990 PRO 1TB',
    brand: 'Samsung',
    price: 149000,
    imageUrl:
      'https://images.unsplash.com/photo-1563206767-5b18f218e8de?auto=format&fit=crop&w=900&q=80',
    specs: {
      formFactor: 'M.2',
      capacity: 1024,
      readSpeed: 7450,
      writeSpeed: 6900,
    },
  },
  {
    id: 8,
    category: 'HDD',
    name: 'WD Blue 2TB SATA3',
    brand: 'Western Digital',
    price: 54000,
    imageUrl:
      'https://images.unsplash.com/photo-1542744094-24638eff58bb?auto=format&fit=crop&w=900&q=80',
    specs: {
      interface: 'SATA3',
      capacity: 2,
      rpm: 5400,
      bufferMemory: 256,
    },
  },
  {
    id: 9,
    category: 'MONITOR',
    name: 'LG UltraGear 27GN850',
    brand: 'LG',
    price: 429000,
    imageUrl:
      'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?auto=format&fit=crop&w=900&q=80',
    specs: {
      screenSize: 27,
      resolution: '2560 x 1440 (QHD)',
      panelType: 'IPS',
      refreshRate: 144,
      aspectRatio: '16:9',
    },
  },
];
