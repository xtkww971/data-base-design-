-- 부품 성능 점수. 카테고리마다 지표가 달라서 같은 카테고리 안에서만 비교할 수 있다.
-- 지표와 출처: docs/스키마 설계/03-부품-성능-점수.md
--   CPU     : PassMark CPU Mark
--   GPU     : PassMark G3D Mark
--   SSD/HDD : PassMark Disk Rating (SSD 와 HDD 는 같은 척도)
--   RAM     : 이론 대역폭 MB/s = 클럭(MT/s) x 8B x 채널 수(모듈 수, 최대 2)
--   POWER   : 80 PLUS 인증 등급의 50% 부하 효율(%)
--   MONITOR : 초당 픽셀 처리량 Mpx/s = 가로 x 세로 x 주사율 / 1,000,000
--   MAINBOARD: 성능 벤치마크가 없어 NULL
ALTER TABLE modules
    ADD COLUMN performance_score INT NULL AFTER price,
    -- 카테고리별 성능순 정렬: WHERE category_id = ? ORDER BY performance_score DESC
    ADD KEY idx_modules_category_score (category_id, performance_score);
