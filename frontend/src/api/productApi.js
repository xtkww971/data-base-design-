// 백엔드 부품 API. 개발 중에는 vite.config.js 의 프록시가 /api 를 백엔드(8080)로 넘겨준다.

/**
 * 부품 통합 검색. 응답은 PageResponse<ProductDetail> (types/productDetail.ts).
 * @param {{ category?: string, searchTerm?: string, page?: number, size?: number }} query
 * @param {AbortSignal} [signal]
 */
export async function searchProducts({ category = 'ALL', searchTerm = '', page = 0, size = 20 } = {}, signal) {
  const params = new URLSearchParams({ category, page: String(page), size: String(size) });
  if (searchTerm.trim()) {
    params.set('searchTerm', searchTerm.trim());
  }

  const response = await fetch(`/api/modules/search?${params}`, { signal });
  if (!response.ok) {
    const error = await response.json().catch(() => null);
    throw new Error(error?.message ?? `검색 요청에 실패했습니다. (${response.status})`);
  }
  return response.json();
}
