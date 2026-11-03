-- 개발용 더미 부품 데이터. 카테고리별 150개씩 총 1200개. V7 스키마 기준.
-- Flyway 는 db/migration 만 읽으므로 이 파일은 자동 적용되지 않는다. 필요할 때 직접 실행한다.
-- 다시 실행하면 같은 제품이 중복으로 들어간다. 빈 DB(V1~V7 적용 직후)에 한 번만 넣는다.
--
-- 데이터 출처
-- - 카테고리별 첫 6개는 기존 시드 그대로다. performance_score 는 2026-10-27 PassMark 에서 확인한 값이다.
--   지표와 출처: docs/스키마 설계/03-부품-성능-점수.md
-- - 나머지는 실제 제품 계열(모델명, 시리즈, 용량 구성)을 바탕으로 스펙 규칙에 따라 만든 값이다.
--   제품명은 실제 계열을 따르지만 모든 조합이 실제로 판매되는 제품은 아니다.
--   가격, 길이, CPU·GPU·저장장치 PassMark 점수는 대략적인 값이다.
--   RAM·파워·모니터 점수는 03 문서의 공식(대역폭, 80PLUS 효율, Mpx/s)으로 계산했다.
-- - V7 에서 추가한 컬럼(cpus.tdp_watt·overclockable, main_boards.max_memory_gb·has_video_output,
--   graphic_cards·power 의 커넥터 컬럼)과 cpu_memory_clocks 도 대략적인 사양 값이다.
--   제약 설계와 근거: docs/스키마 설계/04-부품별-제약조건.md

SET @cpu = (SELECT category_id FROM categories WHERE category_name = 'CPU');
SET @mainboard = (SELECT category_id FROM categories WHERE category_name = 'MAINBOARD');
SET @ram = (SELECT category_id FROM categories WHERE category_name = 'RAM');
SET @gpu = (SELECT category_id FROM categories WHERE category_name = 'GPU');
SET @power = (SELECT category_id FROM categories WHERE category_name = 'POWER');
SET @ssd = (SELECT category_id FROM categories WHERE category_name = 'SSD');
SET @hdd = (SELECT category_id FROM categories WHERE category_name = 'HDD');
SET @monitor = (SELECT category_id FROM categories WHERE category_name = 'MONITOR');

-- CPU (tdp_watt 단위: W, cpu_memory_clocks 단위: MT/s)
INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-12100', '인텔', 159000, 14000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 1, '3.3GHz', 60, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-12100F', '인텔', 119000, 14000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 0, '3.3GHz', 58, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-12300', '인텔', 169000, 14800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 1, '3.5GHz', 60, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12400', '인텔', 199000, 19400, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 6, 12, 1, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12400F', '인텔', 149000, 19400, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 6, 12, 0, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12490F', '인텔', 169000, 20400, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 6, 12, 0, '3.0GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12500', '인텔', 239000, 20500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 6, 12, 1, '3.0GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12600', '인텔', 259000, 21500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 6, 12, 1, '3.3GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12600K', '인텔', 269000, 27600, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 1, '3.7GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12600KF', '인텔', 239000, 27600, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 0, '3.7GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-12700', '인텔', 389000, 30500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 12, 20, 1, '2.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-12700F', '인텔', 349000, 30500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 12, 20, 0, '2.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-12700K', '인텔', 409000, 34500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 12, 20, 1, '3.6GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-12700KF', '인텔', 379000, 34500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 12, 20, 0, '3.6GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-12900', '인텔', 559000, 36000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 1, '2.4GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-12900F', '인텔', 519000, 36000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 0, '2.4GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-12900K', '인텔', 589000, 41000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 1, '3.2GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-12900KF', '인텔', 549000, 41000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 0, '3.2GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-12900KS', '인텔', 699000, 43000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 1, '3.4GHz', 150, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-12100T', '인텔', 159000, 12500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 1, '2.2GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12500T', '인텔', 229000, 17500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 6, 12, 1, '2.0GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12600T', '인텔', 249000, 18500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 6, 12, 1, '2.1GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-12700T', '인텔', 379000, 25000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 12, 20, 1, '1.4GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-12900T', '인텔', 539000, 29000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 1, '1.4GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-13100', '인텔', 169000, 14800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 1, '3.4GHz', 60, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-13100F', '인텔', 129000, 14800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 0, '3.4GHz', 58, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13400', '인텔', 249000, 25000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 1, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13400F', '인텔', 209000, 25000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 0, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13490F', '인텔', 229000, 25500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 0, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13500', '인텔', 309000, 32500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13600', '인텔', 329000, 34500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '2.7GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13600K', '인텔', 349000, 38000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '3.5GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13600KF', '인텔', 319000, 38000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 0, '3.5GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-13700', '인텔', 459000, 41000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 1, '2.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-13700F', '인텔', 429000, 41000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 0, '2.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-13700K', '인텔', 499000, 46500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 1, '3.4GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-13700KF', '인텔', 469000, 46500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 0, '3.4GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-13790F', '인텔', 449000, 42000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 0, '2.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-13900', '인텔', 639000, 49000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 1, '2.0GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-13900F', '인텔', 609000, 49000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 0, '2.0GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-13900K', '인텔', 689000, 59500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 1, '3.0GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-13900KF', '인텔', 659000, 59500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 0, '3.0GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-13900KS', '인텔', 799000, 62000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 1, '3.2GHz', 150, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-13100T', '인텔', 169000, 12800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 1, '2.5GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13400T', '인텔', 239000, 20000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 1, '1.3GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13500T', '인텔', 299000, 26000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '1.6GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13600T', '인텔', 319000, 27500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '1.8GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-13700T', '인텔', 449000, 31000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 1, '1.4GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-13900T', '인텔', 619000, 36000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 1, '1.1GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-14100', '인텔', 179000, 15300, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 1, '3.5GHz', 60, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-14100F', '인텔', 139000, 15300, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 0, '3.5GHz', 58, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14400', '인텔', 229000, 25400, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 1, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14400F', '인텔', 189000, 25393, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 0, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14490F', '인텔', 219000, 26500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 0, '2.8GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14500', '인텔', 299000, 33500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '2.6GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14600', '인텔', 319000, 35000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '2.7GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14600K', '인텔', 329000, 38349, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '3.5GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14600KF', '인텔', 299000, 38300, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 0, '3.5GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-14700', '인텔', 469000, 46000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 20, 28, 1, '2.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-14700F', '인텔', 439000, 46000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 20, 28, 0, '2.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-14700K', '인텔', 539000, 51906, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 20, 28, 1, '3.4GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-14700KF', '인텔', 499000, 51800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 20, 28, 0, '3.4GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-14790F', '인텔', 449000, 42500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 16, 24, 0, '2.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-14900', '인텔', 659000, 50000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 1, '2.0GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-14900F', '인텔', 629000, 50000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 0, '2.0GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-14900K', '인텔', 729000, 60500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 1, '3.2GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-14900KF', '인텔', 699000, 60500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 0, '3.2GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-14900KS', '인텔', 849000, 63000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 1, '3.2GHz', 150, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-14100T', '인텔', 179000, 13000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 1, '2.7GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14400T', '인텔', 229000, 20500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 1, '1.5GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14500T', '인텔', 289000, 26500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '1.7GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14600T', '인텔', 309000, 28000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '1.8GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-14700T', '인텔', 459000, 34000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 20, 28, 1, '1.3GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-14900T', '인텔', 639000, 37000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 1, '1.1GHz', 35, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 펜티엄 골드 G7400', '인텔', 89000, 6500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 2, 4, 1, '3.7GHz', 46, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 셀러론 G6900', '인텔', 69000, 3800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 2, 2, 1, '3.4GHz', 46, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠3 3100', 'AMD', 79000, 11800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 4, 8, 0, '3.6GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠3 3300X', 'AMD', 99000, 12800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 4, 8, 0, '3.8GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠3 3200G', 'AMD', 79000, 7200, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 4, 4, 1, '3.6GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 3400G', 'AMD', 109000, 9300, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 4, 8, 1, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠3 4100', 'AMD', 69000, 11200, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 4, 8, 0, '3.8GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 3600', 'AMD', 109000, 17800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.6GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 3600X', 'AMD', 129000, 18300, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.8GHz', 95, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 3600XT', 'AMD', 139000, 18800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.8GHz', 95, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 4500', 'AMD', 89000, 16300, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.6GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 4600G', 'AMD', 109000, 16400, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 1, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5500', 'AMD', 99000, 19500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.6GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5500GT', 'AMD', 119000, 19800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 1, '3.6GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5600', 'AMD', 135000, 21517, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.5GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5600X', 'AMD', 159000, 22000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5600G', 'AMD', 139000, 19900, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 1, '3.9GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5600GT', 'AMD', 129000, 20100, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 1, '3.6GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5600T', 'AMD', 125000, 21300, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.5GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5600XT', 'AMD', 149000, 22300, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5600X3D', 'AMD', 259000, 22000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.3GHz', 105, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 3700X', 'AMD', 189000, 22700, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.6GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 3800X', 'AMD', 219000, 23500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.9GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 3800XT', 'AMD', 229000, 24000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.9GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 5700', 'AMD', 179000, 24000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 5700X', 'AMD', 199000, 26700, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.4GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 5700G', 'AMD', 219000, 24500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 1, '3.8GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 5700X3D', 'AMD', 289000, 26500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.0GHz', 105, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 5800X', 'AMD', 239000, 28000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.8GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 5800X3D', 'AMD', 399000, 28000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.4GHz', 105, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 5800XT', 'AMD', 259000, 28500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.8GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 3900X', 'AMD', 349000, 32800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 12, 24, 0, '3.8GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 3950X', 'AMD', 499000, 39000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 16, 32, 0, '3.5GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 5900X', 'AMD', 379000, 39200, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 12, 24, 0, '3.7GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 5900XT', 'AMD', 429000, 45000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 16, 32, 0, '3.3GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 5950X', 'AMD', 549000, 45900, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 16, 32, 0, '3.4GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 7400F', 'AMD', 189000, 26000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 0, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 7500F', 'AMD', 215000, 26544, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 0, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 7600', 'AMD', 249000, 27000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 1, '3.8GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 7600X', 'AMD', 279000, 28800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 1, '4.7GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 7600X3D', 'AMD', 399000, 27500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 1, '4.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 7700', 'AMD', 389000, 34400, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 8, 16, 1, '3.8GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 7700X', 'AMD', 399000, 36000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 8, 16, 1, '4.5GHz', 105, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 7800X3D', 'AMD', 479000, 34278, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 8, 16, 1, '4.2GHz', 120, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 7900', 'AMD', 559000, 48500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 12, 24, 1, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 7900X', 'AMD', 589000, 51500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 12, 24, 1, '4.7GHz', 170, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 7900X3D', 'AMD', 669000, 50500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 12, 24, 1, '4.4GHz', 120, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 7950X', 'AMD', 789000, 62500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 16, 32, 1, '4.5GHz', 170, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 7950X3D', 'AMD', 899000, 62500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 16, 32, 1, '4.2GHz', 120, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 8400F', 'AMD', 179000, 21500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 0, '4.2GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 8500G', 'AMD', 229000, 20500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 1, '3.5GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 8600G', 'AMD', 289000, 23800, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 1, '4.3GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 8700F', 'AMD', 289000, 28500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 8, 16, 0, '4.1GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 8700G', 'AMD', 409000, 30500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 8, 16, 1, '4.2GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 9600', 'AMD', 319000, 29300, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 1, '3.8GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 9600X', 'AMD', 349000, 30200, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 1, '3.9GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 9700X', 'AMD', 479000, 37000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 8, 16, 1, '3.8GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 9800X3D', 'AMD', 699000, 40200, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 8, 16, 1, '4.7GHz', 120, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 9900X', 'AMD', 619000, 54500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 12, 24, 1, '4.4GHz', 120, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 9900X3D', 'AMD', 799000, 54000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 12, 24, 1, '4.4GHz', 120, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 9950X', 'AMD', 899000, 66500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 16, 32, 1, '4.3GHz', 170, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠9 9950X3D', 'AMD', 1049000, 69500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 16, 32, 1, '4.3GHz', 170, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14400F (벌크)', '인텔', 174000, 25393, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 0, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-14600K (벌크)', '인텔', 303000, 38349, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '3.5GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-14700K (벌크)', '인텔', 496000, 51906, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 20, 28, 1, '3.4GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-13400F (벌크)', '인텔', 192000, 25000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 0, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i5-12400F (벌크)', '인텔', 137000, 19400, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 6, 12, 0, '2.5GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i3-12100F (벌크)', '인텔', 109000, 14000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 4, 8, 0, '3.3GHz', 58, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 4800, 4000), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i7-14700F (벌크)', '인텔', 404000, 46000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 20, 28, 0, '2.1GHz', 65, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, '인텔 코어 i9-14900K (벌크)', '인텔', 671000, 60500, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'LGA1700', 24, 32, 1, '3.2GHz', 125, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5600, 4400), (LAST_INSERT_ID(), 'DDR4', 3200, 2933);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5600 (멀티팩)', 'AMD', 127000, 21517, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.5GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 7500F (멀티팩)', 'AMD', 202000, 26544, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 0, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 7800X3D (멀티팩)', 'AMD', 450000, 34278, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 8, 16, 1, '4.2GHz', 120, 0);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 7600 (멀티팩)', 'AMD', 234000, 27000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 1, '3.8GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR5', 5200, 3600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠7 5700X (멀티팩)', 'AMD', 187000, 26700, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 8, 16, 0, '3.4GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@cpu, 'AMD 라이젠5 5600X (멀티팩)', 'AMD', 149000, 22000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed, tdp_watt, overclockable) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.7GHz', 65, 1);
INSERT INTO cpu_memory_clocks (cpu_id, memory_spec, max_clock_2dimm, max_clock_4dimm) VALUES (LAST_INSERT_ID(), 'DDR4', 3200, 2667);

-- MAINBOARD (max_memory_gb 단위: GB)
INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG B760M 박격포 II', 'MSI', 219000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE Z790 AORUS ELITE AX', 'GIGABYTE', 389000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B650M Pro RS', 'ASRock', 179000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG B650 토마호크 WIFI', 'MSI', 289000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE A620I AX', 'GIGABYTE', 195000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'Mini-ITX', 'DDR5', 2, 96, 1, 'A620');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF Gaming B550M-PLUS', 'ASUS', 139000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'M-ATX', 'DDR4', 4, 128, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG MAXIMUS Z790 HERO', 'ASUS', 899000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX Z790-E GAMING WIFI II', 'ASUS', 659000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX Z790-F GAMING WIFI II', 'ASUS', 559000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX Z790-A GAMING WIFI II', 'ASUS', 519000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX Z790-I GAMING WIFI', 'ASUS', 589000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'Mini-ITX', 'DDR5', 2, 96, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING Z790-PLUS WIFI', 'ASUS', 389000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME Z790-P WIFI', 'ASUS', 329000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME Z790-P WIFI D4', 'ASUS', 299000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR4', 4, 128, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MEG Z790 ACE MAX', 'MSI', 899000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'E-ATX', 'DDR5', 4, 192, 0, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MPG Z790 CARBON WIFI II', 'MSI', 589000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG Z790 토마호크 MAX WIFI', 'MSI', 399000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO Z790-A MAX WIFI', 'MSI', 339000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO Z790-P WIFI DDR4', 'MSI', 279000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR4', 4, 128, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE Z790 AORUS MASTER X', 'GIGABYTE', 799000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'E-ATX', 'DDR5', 4, 192, 0, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE Z790 AORUS ELITE X AX', 'GIGABYTE', 419000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE Z790 UD AX', 'GIGABYTE', 299000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock Z790 Taichi Lite', 'ASRock', 569000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'E-ATX', 'DDR5', 4, 192, 0, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock Z790 Steel Legend WiFi', 'ASRock', 359000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock Z790 Pro RS', 'ASRock', 289000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock Z790M PG Lightning/D4', 'ASRock', 229000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'Z790');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME Z690-P D4', 'ASUS', 239000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR4', 4, 128, 1, 'Z690');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING Z690-PLUS WIFI', 'ASUS', 299000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 128, 1, 'Z690');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO Z690-A DDR4', 'MSI', 249000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR4', 4, 128, 1, 'Z690');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG Z690 토마호크 WIFI', 'MSI', 329000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 128, 1, 'Z690');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE Z690 UD DDR4', 'GIGABYTE', 219000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR4', 4, 128, 1, 'Z690');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock Z690 Steel Legend WiFi 6E', 'ASRock', 289000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 128, 1, 'Z690');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME H770-PLUS D4', 'ASUS', 219000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR4', 4, 128, 1, 'H770');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO H770-P WIFI', 'MSI', 229000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'H770');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE H770 GAMING X AX', 'GIGABYTE', 239000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'H770');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME H670-PLUS D4', 'ASUS', 209000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR4', 4, 128, 1, 'H670');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO H670-P DDR4', 'MSI', 199000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR4', 4, 128, 1, 'H670');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME B760M-A', 'ASUS', 179000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME B760M-A D4', 'ASUS', 159000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME B760M-K D4', 'ASUS', 129000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING B760M-PLUS WIFI', 'ASUS', 229000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING B760M-PLUS WIFI D4', 'ASUS', 209000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING B760-PLUS WIFI', 'ASUS', 249000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX B760-G GAMING WIFI', 'ASUS', 289000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX B760-F GAMING WIFI', 'ASUS', 319000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX B760-I GAMING WIFI', 'ASUS', 309000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'Mini-ITX', 'DDR5', 2, 96, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG B760M 박격포 WIFI II', 'MSI', 239000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG B760 토마호크 WIFI', 'MSI', 269000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO B760M-A WIFI', 'MSI', 189000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO B760M-A DDR4 II', 'MSI', 159000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO B760M-E DDR4', 'MSI', 119000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO B760-P WIFI DDR4', 'MSI', 189000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR4', 4, 128, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B760M DS3H', 'GIGABYTE', 149000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B760M DS3H DDR4', 'GIGABYTE', 139000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B760M GAMING X AX', 'GIGABYTE', 189000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B760M AORUS ELITE AX', 'GIGABYTE', 229000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B760 AORUS ELITE AX', 'GIGABYTE', 259000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B760I AORUS PRO DDR4', 'GIGABYTE', 249000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'Mini-ITX', 'DDR4', 2, 64, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B760M Pro RS', 'ASRock', 159000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B760M Pro RS/D4', 'ASRock', 149000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B760M-HDV/M.2 D4', 'ASRock', 119000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B760M Steel Legend WiFi', 'ASRock', 219000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 192, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B760M-ITX/D4 WiFi', 'ASRock', 189000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'Mini-ITX', 'DDR4', 2, 64, 1, 'B760');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME B660M-A D4', 'ASUS', 149000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'B660');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO B660M-A DDR4', 'MSI', 149000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'B660');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B660M DS3H DDR4', 'GIGABYTE', 129000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'B660');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B660M Pro RS', 'ASRock', 139000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 4, 128, 1, 'B660');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG B660M 박격포 WIFI', 'MSI', 219000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 128, 1, 'B660');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B660M AORUS PRO AX', 'GIGABYTE', 229000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 128, 1, 'B660');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME H610M-E D4', 'ASUS', 99000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'H610');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME H610M-A D4', 'ASUS', 109000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'H610');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME H610M-E', 'ASUS', 119000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 2, 64, 1, 'H610');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO H610M-E DDR4', 'MSI', 95000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'H610');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO H610M-G DDR4', 'MSI', 99000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'H610');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE H610M S2H DDR4', 'GIGABYTE', 99000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'H610');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE H610M H DDR4', 'GIGABYTE', 95000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'H610');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock H610M-HDV/M.2 R2.0', 'ASRock', 99000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'H610');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock H610M-HVS', 'ASRock', 89000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR4', 2, 64, 1, 'H610');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG CROSSHAIR X870E HERO', 'ASUS', 999000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'X870E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX X870E-E GAMING WIFI', 'ASUS', 699000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'X870E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MPG X870E CARBON WIFI', 'MSI', 629000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'X870E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE X870E AORUS MASTER', 'GIGABYTE', 749000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'E-ATX', 'DDR5', 4, 256, 1, 'X870E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING X870-PLUS WIFI', 'ASUS', 379000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'X870');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG X870 토마호크 WIFI', 'MSI', 399000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'X870');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE X870 AORUS ELITE WIFI7', 'GIGABYTE', 379000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'X870');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock X870 Steel Legend WiFi', 'ASRock', 349000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'X870');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING B850-PLUS WIFI', 'ASUS', 299000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'B850');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME B850M-A WIFI', 'ASUS', 229000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 256, 1, 'B850');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG B850 토마호크 MAX WIFI', 'MSI', 309000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'B850');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO B850M-A WIFI', 'MSI', 219000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 256, 1, 'B850');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B850 AORUS ELITE WIFI7', 'GIGABYTE', 309000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 256, 1, 'B850');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B850M Pro RS WiFi', 'ASRock', 199000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 256, 1, 'B850');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME B840M-A WIFI', 'ASUS', 169000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 256, 1, 'B840');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B840M DS3H', 'GIGABYTE', 149000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 256, 1, 'B840');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B840M-HDV/M.2', 'ASRock', 129000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 2, 128, 1, 'B840');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX X670E-E GAMING WIFI', 'ASUS', 649000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'X670E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG CROSSHAIR X670E HERO', 'ASUS', 899000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'X670E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING X670E-PLUS WIFI', 'ASUS', 389000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'X670E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MPG X670E CARBON WIFI', 'MSI', 559000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'X670E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE X670E AORUS MASTER', 'GIGABYTE', 699000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'E-ATX', 'DDR5', 4, 192, 1, 'X670E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock X670E Taichi', 'ASRock', 699000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'E-ATX', 'DDR5', 4, 192, 0, 'X670E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE X670 AORUS ELITE AX', 'GIGABYTE', 389000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'X670');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO X670-P WIFI', 'MSI', 349000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'X670');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE X670 GAMING X AX V2', 'GIGABYTE', 329000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'X670');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX B650E-F GAMING WIFI', 'ASUS', 389000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'B650E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX B650E-I GAMING WIFI', 'ASUS', 429000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'Mini-ITX', 'DDR5', 2, 96, 1, 'B650E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B650E AORUS MASTER', 'GIGABYTE', 549000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'B650E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B650E PG Riptide WiFi', 'ASRock', 299000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'B650E');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME B650M-A II', 'ASUS', 199000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME B650M-A WIFI II', 'ASUS', 219000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING B650M-PLUS WIFI', 'ASUS', 249000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING B650-PLUS WIFI', 'ASUS', 279000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX B650-A GAMING WIFI', 'ASUS', 339000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO B650M-A WIFI', 'MSI', 199000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO B650M-P', 'MSI', 159000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG B650M 박격포 WIFI', 'MSI', 259000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MPG B650I EDGE WIFI', 'MSI', 349000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'Mini-ITX', 'DDR5', 2, 96, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B650M DS3H', 'GIGABYTE', 169000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B650M GAMING X AX', 'GIGABYTE', 199000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B650M AORUS ELITE AX', 'GIGABYTE', 239000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B650 AORUS ELITE AX V2', 'GIGABYTE', 259000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B650 EAGLE AX', 'GIGABYTE', 229000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B650M PG Lightning WiFi', 'ASRock', 179000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B650M-HDV/M.2', 'ASRock', 149000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 2, 96, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B650I Lightning WiFi', 'ASRock', 269000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'Mini-ITX', 'DDR5', 2, 96, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B650 Steel Legend WiFi', 'ASRock', 249000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 192, 1, 'B650');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE A620M S2H', 'GIGABYTE', 109000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 2, 96, 1, 'A620');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE A620M GAMING X AX', 'GIGABYTE', 139000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'A620');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME A620M-A', 'ASUS', 129000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'A620');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME A620M-E', 'ASUS', 119000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 2, 96, 1, 'A620');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI PRO A620M-E', 'MSI', 109000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 2, 96, 1, 'A620');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock A620M-HDV/M.2+', 'ASRock', 109000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 2, 96, 1, 'A620');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock A620M Pro RS WiFi', 'ASRock', 139000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 192, 1, 'A620');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock A620I Lightning WiFi', 'ASRock', 179000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'Mini-ITX', 'DDR5', 2, 96, 1, 'A620');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX X570-E GAMING WIFI II', 'ASUS', 399000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'ATX', 'DDR4', 4, 128, 1, 'X570');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING X570-PLUS WIFI', 'ASUS', 249000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'ATX', 'DDR4', 4, 128, 1, 'X570');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MPG X570 GAMING PLUS', 'MSI', 199000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'ATX', 'DDR4', 4, 128, 0, 'X570');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE X570 AORUS ELITE', 'GIGABYTE', 239000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'ATX', 'DDR4', 4, 128, 1, 'X570');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS TUF GAMING B550-PLUS WIFI II', 'ASUS', 199000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'ATX', 'DDR4', 4, 128, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS ROG STRIX B550-F GAMING WIFI II', 'ASUS', 269000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'ATX', 'DDR4', 4, 128, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME B550M-A WIFI II', 'ASUS', 149000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'M-ATX', 'DDR4', 4, 128, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG B550M 박격포 WIFI', 'MSI', 179000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'M-ATX', 'DDR4', 4, 128, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI MAG B550 토마호크', 'MSI', 199000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'ATX', 'DDR4', 4, 128, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B550M DS3H', 'GIGABYTE', 119000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'M-ATX', 'DDR4', 4, 128, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B550 AORUS ELITE V2', 'GIGABYTE', 169000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'ATX', 'DDR4', 4, 128, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B550M Pro4', 'ASRock', 129000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'M-ATX', 'DDR4', 4, 128, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASRock B550 Phantom Gaming-ITX/ax', 'ASRock', 239000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'Mini-ITX', 'DDR4', 2, 64, 1, 'B550');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'MSI B450M 박격포 MAX', 'MSI', 99000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'M-ATX', 'DDR4', 4, 128, 1, 'B450');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'GIGABYTE B450M DS3H V2', 'GIGABYTE', 89000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'M-ATX', 'DDR4', 2, 64, 1, 'B450');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@mainboard, 'ASUS PRIME A520M-E', 'ASUS', 79000, NULL, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, max_memory_gb, has_video_output, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'M-ATX', 'DDR4', 2, 64, 1, 'A520');

-- RAM (capacity 는 패키지 전체 용량 GB, clock 단위: MT/s)
INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR4-3200 16GB', '삼성전자', 45000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR5-5600 16GB', '삼성전자', 62000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 16, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'SK하이닉스 DDR5-5600 32GB', 'SK하이닉스', 125000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3200 CL16 32GB(16Gx2)', 'Corsair', 95000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR5-6000 CL30 32GB(16Gx2)', 'TeamGroup', 159000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 Neo DDR5-6000 CL30 64GB(32Gx2)', 'G.SKILL', 319000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR4-3200 8GB', '삼성전자', 29000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 8, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR4-3200 32GB', '삼성전자', 91000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR5-5600 8GB', '삼성전자', 40000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 8, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR5-5600 32GB', '삼성전자', 135000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'SK하이닉스 DDR5-5600 16GB', 'SK하이닉스', 71000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 16, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'SK하이닉스 DDR5-5600 8GB', 'SK하이닉스', 40000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 8, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3200 CL16 16GB(8Gx2)', 'Corsair', 56000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3200 CL16 64GB(32Gx2)', 'Corsair', 199000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3200 CL16 64GB(16Gx4)', 'Corsair', 199000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3200, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3200 CL16 128GB(32Gx4)', 'Corsair', 391000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 128, 3200, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3600 CL18 32GB(16Gx2)', 'Corsair', 113000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3600 CL18 16GB(8Gx2)', 'Corsair', 61000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3600 CL18 64GB(32Gx2)', 'Corsair', 218000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3600 CL18 64GB(16Gx4)', 'Corsair', 218000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3600, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3600 CL18 128GB(32Gx4)', 'Corsair', 429000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 128, 3600, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR5-6000 CL30 64GB(32Gx2)', 'TeamGroup', 317000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR5-6000 CL30 48GB(24Gx2)', 'TeamGroup', 240000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 48, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR5-6400 CL32 32GB(16Gx2)', 'TeamGroup', 171000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR5-6400 CL32 64GB(32Gx2)', 'TeamGroup', 334000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR5-6400 CL32 48GB(24Gx2)', 'TeamGroup', 253000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 48, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 Neo DDR5-6000 CL30 32GB(16Gx2)', 'G.SKILL', 176000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 Neo DDR5-6000 CL30 96GB(48Gx2)', 'G.SKILL', 512000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 96, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 Neo DDR5-6400 CL32 64GB(32Gx2)', 'G.SKILL', 363000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 Neo DDR5-6400 CL32 32GB(16Gx2)', 'G.SKILL', 185000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 Neo DDR5-6400 CL32 96GB(48Gx2)', 'G.SKILL', 540000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 96, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR5-4800 16GB', '삼성전자', 61000, 38400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 16, 4800, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR5-4800 32GB', '삼성전자', 114000, 38400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 4800, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR4-2666 8GB', '삼성전자', 28000, 21328, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 8, 2666, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '삼성전자 DDR4-2666 16GB', '삼성전자', 48000, 21328, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 2666, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'SK하이닉스 DDR4-3200 8GB', 'SK하이닉스', 29000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 8, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'SK하이닉스 DDR4-3200 16GB', 'SK하이닉스', 50000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'SK하이닉스 DDR4-3200 32GB', 'SK하이닉스', 91000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial DDR5-5600 16GB', '마이크론', 71000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 16, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial DDR5-5600 32GB', '마이크론', 135000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial DDR5-5600 48GB', '마이크론', 198000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 48, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial DDR5-4800 16GB', '마이크론', 64000, 38400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 16, 4800, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial DDR5-4800 32GB', '마이크론', 120000, 38400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 4800, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial DDR5-4800 48GB', '마이크론', 176000, 38400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 48, 4800, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial DDR4-3200 8GB', '마이크론', 29000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 8, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial DDR4-3200 16GB', '마이크론', 50000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial DDR4-3200 32GB', '마이크론', 91000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 RGB DDR5-6000 CL30 32GB(16Gx2)', 'G.SKILL', 183000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 RGB DDR5-6000 CL30 48GB(24Gx2)', 'G.SKILL', 270000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 48, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 RGB DDR5-6000 CL30 64GB(32Gx2)', 'G.SKILL', 357000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 RGB DDR5-6400 CL32 32GB(16Gx2)', 'G.SKILL', 192000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 RGB DDR5-6400 CL32 48GB(24Gx2)', 'G.SKILL', 285000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 48, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 RGB DDR5-6400 CL32 64GB(32Gx2)', 'G.SKILL', 377000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 RGB DDR5-7200 CL34 32GB(16Gx2)', 'G.SKILL', 212000, 115200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 7200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 RGB DDR5-7200 CL34 48GB(24Gx2)', 'G.SKILL', 314000, 115200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 48, 7200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z5 RGB DDR5-7200 CL34 64GB(32Gx2)', 'G.SKILL', 416000, 115200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 7200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Flare X5 DDR5-6000 CL30 32GB(16Gx2)', 'G.SKILL', 169000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Flare X5 DDR5-6000 CL30 64GB(32Gx2)', 'G.SKILL', 331000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-5600 CL28 32GB(16Gx2)', 'G.SKILL', 154000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-5600 CL28 64GB(32Gx2)', 'G.SKILL', 300000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-5600 CL28 96GB(48Gx2)', 'G.SKILL', 446000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 96, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-5600 CL28 64GB(16Gx4)', 'G.SKILL', 300000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 5600, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-5600 CL28 128GB(32Gx4)', 'G.SKILL', 592000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 128, 5600, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-6000 CL30 32GB(16Gx2)', 'G.SKILL', 163000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-6000 CL30 64GB(32Gx2)', 'G.SKILL', 317000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-6000 CL30 96GB(48Gx2)', 'G.SKILL', 472000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 96, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-6000 CL30 64GB(16Gx4)', 'G.SKILL', 317000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws S5 DDR5-6000 CL30 128GB(32Gx4)', 'G.SKILL', 626000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 128, 6000, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-5600 CL36 32GB(16Gx2)', 'Corsair', 160000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-5600 CL36 64GB(32Gx2)', 'Corsair', 313000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-5600 CL36 96GB(48Gx2)', 'Corsair', 465000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 96, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-5600 CL36 64GB(16Gx4)', 'Corsair', 313000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 5600, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-5600 CL36 128GB(32Gx4)', 'Corsair', 617000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 128, 5600, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6000 CL30 32GB(16Gx2)', 'Corsair', 169000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6000 CL30 64GB(32Gx2)', 'Corsair', 331000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6000 CL30 96GB(48Gx2)', 'Corsair', 492000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 96, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6000 CL30 64GB(16Gx4)', 'Corsair', 331000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6000 CL30 128GB(32Gx4)', 'Corsair', 653000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 128, 6000, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6400 CL32 32GB(16Gx2)', 'Corsair', 178000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6400 CL32 64GB(32Gx2)', 'Corsair', 348000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6400 CL32 96GB(48Gx2)', 'Corsair', 519000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 96, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6400 CL32 64GB(16Gx4)', 'Corsair', 348000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6400, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance DDR5-6400 CL32 128GB(32Gx4)', 'Corsair', 689000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 128, 6400, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance RGB DDR5-6000 CL30 32GB(16Gx2)', 'Corsair', 183000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance RGB DDR5-6000 CL30 64GB(32Gx2)', 'Corsair', 357000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Vulcan DDR5-5600 CL40 32GB(16Gx2)', 'TeamGroup', 141000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Vulcan DDR5-5600 CL40 64GB(32Gx2)', 'TeamGroup', 275000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Vulcan DDR5-6000 CL30 32GB(16Gx2)', 'TeamGroup', 149000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Vulcan DDR5-6000 CL30 64GB(32Gx2)', 'TeamGroup', 290000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR5-5600 CL36 32GB(16Gx2)', 'Kingston', 148000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR5-5600 CL36 64GB(32Gx2)', 'Kingston', 287000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 5600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR5-5600 CL36 16GB', 'Kingston', 78000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 16, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR5-5600 CL36 32GB', 'Kingston', 148000, 44800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR5-6000 CL36 32GB(16Gx2)', 'Kingston', 156000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR5-6000 CL36 64GB(32Gx2)', 'Kingston', 304000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR5-6000 CL36 16GB', 'Kingston', 82000, 48000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 16, 6000, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR5-6000 CL36 32GB', 'Kingston', 156000, 48000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Renegade DDR5-6400 CL32 32GB(16Gx2)', 'Kingston', 192000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Renegade DDR5-6400 CL32 48GB(24Gx2)', 'Kingston', 285000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 48, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'ESSENCORE KLEVV CRAS V RGB DDR5-6000 CL30 32GB(16Gx2)', 'ESSENCORE', 156000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'ESSENCORE KLEVV CRAS V RGB DDR5-6000 CL30 64GB(32Gx2)', 'ESSENCORE', 304000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'ADATA XPG Lancer RGB DDR5-6000 CL30 32GB(16Gx2)', 'ADATA', 163000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'ADATA XPG Lancer RGB DDR5-6000 CL30 64GB(32Gx2)', 'ADATA', 317000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3200 CL16 16GB(8Gx2)', 'G.SKILL', 54000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3200 CL16 32GB(16Gx2)', 'G.SKILL', 100000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3200 CL16 64GB(32Gx2)', 'G.SKILL', 191000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3200 CL16 64GB(16Gx4)', 'G.SKILL', 191000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3200, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3200 CL16 128GB(32Gx4)', 'G.SKILL', 374000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 128, 3200, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3600 CL18 16GB(8Gx2)', 'G.SKILL', 58000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3600 CL18 32GB(16Gx2)', 'G.SKILL', 109000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3600 CL18 64GB(32Gx2)', 'G.SKILL', 209000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3600 CL18 64GB(16Gx4)', 'G.SKILL', 209000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3600, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Ripjaws V DDR4-3600 CL18 128GB(32Gx4)', 'G.SKILL', 411000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 128, 3600, 4);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z RGB DDR4-3600 CL16 32GB(16Gx2)', 'G.SKILL', 127000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z RGB DDR4-3600 CL16 64GB(32Gx2)', 'G.SKILL', 246000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z RGB DDR4-3200 CL16 32GB(16Gx2)', 'G.SKILL', 116000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z RGB DDR4-3200 CL16 64GB(32Gx2)', 'G.SKILL', 224000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z Neo DDR4-3600 CL16 32GB(16Gx2)', 'G.SKILL', 127000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'G.SKILL Trident Z Neo DDR4-3600 CL16 64GB(32Gx2)', 'G.SKILL', 246000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 64, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance RGB Pro DDR4-3600 CL18 32GB(16Gx2)', 'Corsair', 122000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance RGB Pro DDR4-3600 CL18 16GB(8Gx2)', 'Corsair', 65000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance RGB Pro DDR4-3200 CL16 32GB(16Gx2)', 'Corsair', 112000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Vengeance RGB Pro DDR4-3200 CL16 16GB(8Gx2)', 'Corsair', 60000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Vulcan Z DDR4-3200 CL16 16GB(8Gx2)', 'TeamGroup', 50000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Vulcan Z DDR4-3200 CL16 32GB(16Gx2)', 'TeamGroup', 91000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Vulcan Z DDR4-3600 CL18 16GB(8Gx2)', 'TeamGroup', 54000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Vulcan Z DDR4-3600 CL18 32GB(16Gx2)', 'TeamGroup', 100000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR4-3200 CL16 16GB(8Gx2)', 'Kingston', 52000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR4-3200 CL16 32GB(16Gx2)', 'Kingston', 95000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR4-3200 CL16 8GB', 'Kingston', 30000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 8, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR4-3200 CL16 16GB', 'Kingston', 52000, 25600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR4-3600 CL18 16GB(8Gx2)', 'Kingston', 56000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR4-3600 CL18 32GB(16Gx2)', 'Kingston', 104000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR4-3600 CL18 8GB', 'Kingston', 32000, 28800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 8, 3600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast DDR4-3600 CL18 16GB', 'Kingston', 56000, 28800, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3600, 1);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'ESSENCORE KLEVV BOLT X DDR4-3200 CL16 32GB(16Gx2)', 'ESSENCORE', 91000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'ESSENCORE KLEVV BOLT X DDR4-3200 CL16 16GB(8Gx2)', 'ESSENCORE', 50000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Dominator Platinum RGB DDR5-6000 CL30 32GB(16Gx2)', 'Corsair', 223000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Dominator Platinum RGB DDR5-6000 CL30 64GB(32Gx2)', 'Corsair', 438000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Dominator Platinum RGB DDR5-6400 CL32 32GB(16Gx2)', 'Corsair', 235000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Corsair Dominator Platinum RGB DDR5-6400 CL32 64GB(32Gx2)', 'Corsair', 462000, 102400, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6400, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR4-3200 CL16 16GB(8Gx2)', 'TeamGroup', 52000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR4-3200 CL16 32GB(16Gx2)', 'TeamGroup', 95000, 51200, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR4-3600 CL18 16GB(8Gx2)', 'TeamGroup', 56000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR4-3600 CL18 32GB(16Gx2)', 'TeamGroup', 104000, 57600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3600, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast RGB DDR5-6000 CL30 32GB(16Gx2)', 'Kingston', 169000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'Kingston FURY Beast RGB DDR5-6000 CL30 64GB(32Gx2)', 'Kingston', 331000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'ADATA XPG Lancer Blade DDR5-6000 CL30 32GB(16Gx2)', 'ADATA', 156000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, 'ADATA XPG Lancer Blade DDR5-6000 CL30 48GB(24Gx2)', 'ADATA', 230000, 96000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 48, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ram, '마이크론 Crucial Pro DDR5-5600 CL46 32GB(16Gx2)', '마이크론', 141000, 89600, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 2);

-- GPU (pcie_8pin_count: 카드가 요구하는 8핀 개수. 16핀 카드는 동봉 어댑터 기준)
INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4060 벤투스 2X 블랙 OC 8GB', 'MSI', 419000, 19478, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060', 'GDDR6', 8, 199, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4060 Ti EAGLE OC 8GB', 'GIGABYTE', 569000, 22594, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 8, 272, 550, 0, 1, 'HDMI 2.1 x2, DP 1.4a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS TUF Gaming 지포스 RTX 4070 SUPER OC 12GB', 'ASUS', 949000, 29934, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 SUPER', 'GDDR6X', 12, 301, 650, 1, 2, 'HDMI 2.1 x2, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ZOTAC GAMING 지포스 RTX 4080 SUPER Trinity 16GB', 'ZOTAC', 1590000, 34212, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4080 SUPER', 'GDDR6X', 16, 307, 750, 1, 3, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'XFX 라데온 RX 7600 SPEEDSTER SWFT 210 8GB', 'XFX', 369000, 16430, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600', 'GDDR6', 8, 241, 550, 0, 1, 'HDMI 2.1 x1, DP 2.1 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7800 XT PULSE 16GB', 'SAPPHIRE', 729000, 24482, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7800 XT', 'GDDR6', 16, 280, 700, 0, 2, 'HDMI 2.1 x2, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 3050 벤투스 2X OC 8GB', 'MSI', 306000, 12847, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3050', 'GDDR6', 8, 204, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 3060 EAGLE OC 12GB', 'GIGABYTE', 421000, 17183, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3060', 'GDDR6', 12, 244, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4060 AORUS MASTER 8GB', 'GIGABYTE', 494000, 20007, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060', 'GDDR6', 8, 247, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ZOTAC GAMING 지포스 RTX 4060 Ti Twin Edge OC 8GB', 'ZOTAC', 585000, 22672, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 8, 248, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS TUF Gaming 지포스 RTX 4060 Ti OC 16GB', 'ASUS', 801000, 23274, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 16, 295, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4070 WINDFORCE OC 12GB', 'GIGABYTE', 810000, 26903, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070', 'GDDR6X', 12, 269, 650, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4070 SUPER 벤투스 3X OC 12GB', 'MSI', 1018000, 30409, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 SUPER', 'GDDR6X', 12, 287, 650, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS ROG STRIX 지포스 RTX 4070 Ti SUPER OC 16GB', 'ASUS', 1398000, 32657, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 Ti SUPER', 'GDDR6X', 16, 338, 700, 1, 2, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4080 SUPER EAGLE OC 16GB', 'GIGABYTE', 1723000, 34816, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4080 SUPER', 'GDDR6X', 16, 329, 750, 1, 3, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4090 게이밍 X 트리오 24GB', 'MSI', 3603000, 39438, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4090', 'GDDR6X', 24, 379, 850, 1, 4, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS DUAL 지포스 RTX 5060 OC 8GB', 'ASUS', 466000, 21558, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060', 'GDDR7', 8, 213, 550, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '갤럭시 GALAX 지포스 RTX 5060 Ti EX 게이머 OC 8GB', '갤럭시', 617000, 24734, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 8, 249, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 5060 Ti 벤투스 2X OC 16GB', 'MSI', 650000, 24473, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 16, 231, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5070 EAGLE OC 12GB', 'GIGABYTE', 988000, 29574, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070', 'GDDR7', 12, 289, 650, 1, 2, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5070 Ti AORUS MASTER 16GB', 'GIGABYTE', 1551000, 33706, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070 Ti', 'GDDR7', 16, 360, 750, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5080 EAGLE OC 16GB', 'GIGABYTE', 1847000, 36482, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5080', 'GDDR7', 16, 350, 850, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS TUF Gaming 지포스 RTX 5090 OC 32GB', 'ASUS', 4759000, 39932, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5090', 'GDDR7', 32, 378, 1000, 1, 4, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 라데온 RX 6600 GAMING OC 8GB', 'GIGABYTE', 324000, 15261, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 6600', 'GDDR6', 8, 224, 500, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7600 Fighter 8GB', 'PowerColor', 360000, 16462, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600', 'GDDR6', 8, 241, 550, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7600 XT Red Devil 16GB', 'PowerColor', 549000, 17783, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600 XT', 'GDDR6', 16, 302, 600, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7700 XT Hellhound 12GB', 'PowerColor', 643000, 21857, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7700 XT', 'GDDR6', 12, 291, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7800 XT Fighter 16GB', 'PowerColor', 717000, 24427, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7800 XT', 'GDDR6', 16, 283, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7900 GRE NITRO+ 16GB', 'SAPPHIRE', 925000, 26580, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 GRE', 'GDDR6', 16, 333, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 라데온 RX 7900 XT Challenger OC 20GB', 'ASRock', 1006000, 29019, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 XT', 'GDDR6', 20, 308, 750, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7900 XTX PULSE 24GB', 'SAPPHIRE', 1327000, 31059, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 XTX', 'GDDR6', 24, 299, 800, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 라데온 RX 9060 XT GAMING OC 16GB', 'GIGABYTE', 561000, 20768, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9060 XT', 'GDDR6', 16, 264, 500, 0, 1, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 9070 Fighter 16GB', 'PowerColor', 827000, 26380, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9070', 'GDDR6', 16, 280, 650, 0, 2, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 9070 XT Red Devil 16GB', 'PowerColor', 1202000, 30042, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9070 XT', 'GDDR6', 16, 336, 750, 0, 3, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 인텔 Arc A750 Steel Legend 8GB', 'ASRock', 307000, 12687, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc A750', 'GDDR6', 8, 282, 600, 0, 2, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'Sparkle 인텔 Arc A770 TITAN OC 16GB', 'Sparkle', 434000, 13816, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc A770', 'GDDR6', 16, 303, 650, 0, 2, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 인텔 Arc B570 Challenger OC 10GB', 'ASRock', 314000, 13540, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc B570', 'GDDR6', 10, 274, 550, 0, 1, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 인텔 Arc B580 Steel Legend 12GB', 'ASRock', 424000, 15435, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc B580', 'GDDR6', 12, 294, 600, 0, 1, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 3050 WINDFORCE OC 8GB', 'GIGABYTE', 303000, 12735, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3050', 'GDDR6', 8, 202, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 3060 벤투스 3X OC 12GB', 'MSI', 419000, 17255, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3060', 'GDDR6', 12, 246, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS ROG STRIX 지포스 RTX 4060 OC 8GB', 'ASUS', 487000, 20059, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060', 'GDDR6', 8, 251, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '이엠텍 지포스 RTX 4060 Ti STORM X Dual OC 8GB', '이엠텍', 581000, 22535, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 8, 257, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4060 Ti 게이밍 X 트리오 16GB', 'MSI', 841000, 23217, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 16, 292, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS DUAL 지포스 RTX 4070 OC 12GB', 'ASUS', 815000, 27053, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070', 'GDDR6X', 12, 250, 650, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '갤럭시 GALAX 지포스 RTX 4070 SUPER EX 게이머 OC 12GB', '갤럭시', 1038000, 30410, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 SUPER', 'GDDR6X', 12, 301, 650, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4070 Ti SUPER WINDFORCE OC 16GB', 'GIGABYTE', 1211000, 32067, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 Ti SUPER', 'GDDR6X', 16, 292, 700, 1, 2, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4080 SUPER 벤투스 3X OC 16GB', 'MSI', 1757000, 34681, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4080 SUPER', 'GDDR6X', 16, 330, 750, 1, 3, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4090 AORUS MASTER 24GB', 'GIGABYTE', 3585000, 39412, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4090', 'GDDR6X', 24, 367, 850, 1, 4, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ZOTAC GAMING 지포스 RTX 5060 Twin Edge OC 8GB', 'ZOTAC', 466000, 21543, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060', 'GDDR7', 8, 205, 550, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS TUF Gaming 지포스 RTX 5060 Ti OC 8GB', 'ASUS', 674000, 24820, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 8, 266, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5060 Ti WINDFORCE OC 16GB', 'GIGABYTE', 688000, 24674, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 16, 232, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 5070 벤투스 3X OC 12GB', 'MSI', 952000, 29590, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070', 'GDDR7', 12, 282, 650, 1, 2, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS ROG STRIX 지포스 RTX 5070 Ti OC 16GB', 'ASUS', 1506000, 33744, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070 Ti', 'GDDR7', 16, 336, 750, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 5080 벤투스 3X OC 16GB', 'MSI', 1802000, 36576, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5080', 'GDDR7', 16, 354, 850, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 5090 게이밍 X 트리오 32GB', 'MSI', 4614000, 40334, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5090', 'GDDR7', 32, 392, 1000, 1, 4, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 6600 NITRO+ 8GB', 'SAPPHIRE', 333000, 15426, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 6600', 'GDDR6', 8, 239, 500, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 라데온 RX 7600 Challenger OC 8GB', 'ASRock', 365000, 16500, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600', 'GDDR6', 8, 231, 550, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7600 XT PULSE 16GB', 'SAPPHIRE', 461000, 17303, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600 XT', 'GDDR6', 16, 251, 600, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 라데온 RX 7700 XT GAMING OC 12GB', 'GIGABYTE', 639000, 21960, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7700 XT', 'GDDR6', 12, 289, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 라데온 RX 7800 XT Challenger OC 16GB', 'ASRock', 736000, 24496, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7800 XT', 'GDDR6', 16, 271, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7900 GRE Red Devil 16GB', 'PowerColor', 925000, 26402, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 GRE', 'GDDR6', 16, 334, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7900 XT Hellhound 20GB', 'PowerColor', 1079000, 29100, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 XT', 'GDDR6', 20, 331, 750, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7900 XTX Fighter 24GB', 'PowerColor', 1254000, 31012, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 XTX', 'GDDR6', 24, 314, 800, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 9060 XT NITRO+ 16GB', 'SAPPHIRE', 631000, 21009, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9060 XT', 'GDDR6', 16, 277, 500, 0, 1, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 라데온 RX 9070 Challenger OC 16GB', 'ASRock', 872000, 26249, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9070', 'GDDR6', 16, 286, 650, 0, 2, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 9070 XT PULSE 16GB', 'SAPPHIRE', 1006000, 29229, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9070 XT', 'GDDR6', 16, 308, 750, 0, 2, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 인텔 Arc A750 Challenger OC 8GB', 'ASRock', 277000, 12515, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc A750', 'GDDR6', 8, 274, 600, 0, 2, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 인텔 Arc A770 Steel Legend 16GB', 'ASRock', 434000, 13909, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc A770', 'GDDR6', 16, 304, 650, 0, 2, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'Sparkle 인텔 Arc B570 TITAN OC 10GB', 'Sparkle', 330000, 13679, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc B570', 'GDDR6', 10, 302, 550, 0, 1, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 인텔 Arc B580 Challenger OC 12GB', 'ASRock', 380000, 15170, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc B580', 'GDDR6', 12, 270, 600, 0, 1, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS DUAL 지포스 RTX 3050 OC 8GB', 'ASUS', 304000, 12841, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3050', 'GDDR6', 8, 200, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '갤럭시 GALAX 지포스 RTX 3060 EX 게이머 OC 12GB', '갤럭시', 422000, 17252, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3060', 'GDDR6', 12, 243, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4060 벤투스 2X OC 8GB', 'MSI', 413000, 19572, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060', 'GDDR6', 8, 204, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4060 Ti AORUS MASTER 16GB', 'GIGABYTE', 808000, 23366, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 16, 287, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ZOTAC GAMING 지포스 RTX 4070 Twin Edge OC 12GB', 'ZOTAC', 812000, 27024, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070', 'GDDR6X', 12, 268, 650, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4070 Ti SUPER EAGLE OC 16GB', 'GIGABYTE', 1288000, 32236, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 Ti SUPER', 'GDDR6X', 16, 321, 700, 1, 2, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '갤럭시 GALAX 지포스 RTX 4080 SUPER EX 게이머 OC 16GB', '갤럭시', 1692000, 34692, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4080 SUPER', 'GDDR6X', 16, 329, 750, 1, 3, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS ROG STRIX 지포스 RTX 4090 OC 24GB', 'ASUS', 3446000, 39379, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4090', 'GDDR6X', 24, 367, 850, 1, 4, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '이엠텍 지포스 RTX 5060 STORM X Dual OC 8GB', '이엠텍', 448000, 21532, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060', 'GDDR7', 8, 209, 550, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 5060 Ti 게이밍 X 트리오 8GB', 'MSI', 669000, 24787, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 8, 278, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS DUAL 지포스 RTX 5060 Ti OC 16GB', 'ASUS', 680000, 24565, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 16, 223, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '갤럭시 GALAX 지포스 RTX 5070 EX 게이머 OC 12GB', '갤럭시', 1003000, 29584, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070', 'GDDR7', 12, 298, 650, 1, 2, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5070 Ti WINDFORCE OC 16GB', 'GIGABYTE', 1291000, 33030, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070 Ti', 'GDDR7', 16, 308, 750, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '갤럭시 GALAX 지포스 RTX 5080 EX 게이머 OC 16GB', '갤럭시', 1849000, 36707, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5080', 'GDDR7', 16, 349, 850, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5090 AORUS MASTER 32GB', 'GIGABYTE', 4788000, 40228, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5090', 'GDDR7', 32, 383, 1000, 1, 4, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 6600 Red Devil 8GB', 'PowerColor', 345000, 15450, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 6600', 'GDDR6', 8, 240, 500, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7600 Hellhound 8GB', 'PowerColor', 402000, 16555, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600', 'GDDR6', 8, 253, 550, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'XFX 라데온 RX 7600 XT SPEEDSTER SWFT 210 16GB', 'XFX', 475000, 17202, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600 XT', 'GDDR6', 16, 242, 600, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7700 XT NITRO+ 12GB', 'SAPPHIRE', 704000, 22150, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7700 XT', 'GDDR6', 12, 304, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7800 XT Hellhound 16GB', 'PowerColor', 772000, 24735, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7800 XT', 'GDDR6', 16, 290, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7900 GRE PULSE 16GB', 'SAPPHIRE', 806000, 25793, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 GRE', 'GDDR6', 16, 276, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 라데온 RX 7900 XT GAMING OC 20GB', 'GIGABYTE', 1104000, 29265, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 XT', 'GDDR6', 20, 324, 750, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 라데온 RX 7900 XTX Challenger OC 24GB', 'ASRock', 1310000, 30936, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 XTX', 'GDDR6', 24, 319, 800, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 9060 XT Red Devil 16GB', 'PowerColor', 621000, 21074, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9060 XT', 'GDDR6', 16, 288, 500, 0, 1, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 9070 Hellhound 16GB', 'PowerColor', 931000, 26763, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9070', 'GDDR6', 16, 314, 650, 0, 2, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 9070 XT Fighter 16GB', 'PowerColor', 972000, 29570, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9070 XT', 'GDDR6', 16, 300, 750, 0, 2, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'Sparkle 인텔 Arc A750 TITAN OC 8GB', 'Sparkle', 300000, 12666, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc A750', 'GDDR6', 8, 294, 600, 0, 2, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 인텔 Arc A770 Challenger OC 16GB', 'ASRock', 387000, 13687, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc A770', 'GDDR6', 16, 280, 650, 0, 2, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 인텔 Arc B570 Steel Legend 10GB', 'ASRock', 338000, 13665, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc B570', 'GDDR6', 10, 288, 550, 0, 1, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'Sparkle 인텔 Arc B580 TITAN OC 12GB', 'Sparkle', 407000, 15301, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Intel Arc B580', 'GDDR6', 12, 294, 600, 0, 1, 'HDMI 2.1 x1, DP 2.0 x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ZOTAC GAMING 지포스 RTX 3050 Twin Edge OC 8GB', 'ZOTAC', 291000, 12819, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3050', 'GDDR6', 8, 204, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS TUF Gaming 지포스 RTX 3060 OC 12GB', 'ASUS', 466000, 17458, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3060', 'GDDR6', 12, 269, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4060 WINDFORCE OC 8GB', 'GIGABYTE', 419000, 19447, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060', 'GDDR6', 8, 194, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4060 Ti 벤투스 3X OC 8GB', 'MSI', 610000, 22732, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 8, 274, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS ROG STRIX 지포스 RTX 4060 Ti OC 16GB', 'ASUS', 809000, 23275, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 16, 285, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '이엠텍 지포스 RTX 4070 STORM X Dual OC 12GB', '이엠텍', 830000, 27019, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070', 'GDDR6X', 12, 257, 650, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4070 SUPER 게이밍 X 트리오 12GB', 'MSI', 1098000, 30751, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 SUPER', 'GDDR6X', 12, 320, 650, 1, 2, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4070 Ti SUPER 벤투스 3X OC 16GB', 'MSI', 1299000, 32272, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 Ti SUPER', 'GDDR6X', 16, 313, 700, 1, 2, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS TUF Gaming 지포스 RTX 4080 SUPER OC 16GB', 'ASUS', 1915000, 35160, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4080 SUPER', 'GDDR6X', 16, 352, 750, 1, 3, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4090 WINDFORCE OC 24GB', 'GIGABYTE', 2937000, 38287, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4090', 'GDDR6X', 24, 317, 850, 1, 4, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5060 EAGLE OC 8GB', 'GIGABYTE', 508000, 21796, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060', 'GDDR7', 8, 237, 550, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5060 Ti AORUS MASTER 8GB', 'GIGABYTE', 667000, 24890, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 8, 273, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ZOTAC GAMING 지포스 RTX 5060 Ti Twin Edge OC 16GB', 'ZOTAC', 682000, 24716, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 16, 227, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS TUF Gaming 지포스 RTX 5070 OC 12GB', 'ASUS', 1034000, 29757, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070', 'GDDR7', 12, 324, 650, 1, 2, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5070 Ti EAGLE OC 16GB', 'GIGABYTE', 1425000, 33627, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070 Ti', 'GDDR7', 16, 317, 750, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS TUF Gaming 지포스 RTX 5080 OC 16GB', 'ASUS', 2044000, 36984, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5080', 'GDDR7', 16, 375, 850, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS ROG STRIX 지포스 RTX 5090 OC 32GB', 'ASUS', 4696000, 40243, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5090', 'GDDR7', 32, 380, 1000, 1, 4, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 6600 PULSE 8GB', 'SAPPHIRE', 282000, 15146, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 6600', 'GDDR6', 8, 201, 500, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 라데온 RX 7600 GAMING OC 8GB', 'GIGABYTE', 396000, 16545, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600', 'GDDR6', 8, 255, 550, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7600 XT Fighter 16GB', 'PowerColor', 478000, 17359, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600 XT', 'GDDR6', 16, 240, 600, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7700 XT Red Devil 12GB', 'PowerColor', 714000, 22131, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7700 XT', 'GDDR6', 12, 309, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 라데온 RX 7800 XT GAMING OC 16GB', 'GIGABYTE', 801000, 24706, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7800 XT', 'GDDR6', 16, 303, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7900 GRE Fighter 16GB', 'PowerColor', 801000, 25930, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 GRE', 'GDDR6', 16, 288, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7900 XT NITRO+ 20GB', 'SAPPHIRE', 1155000, 29730, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 XT', 'GDDR6', 20, 338, 750, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'PowerColor 라데온 RX 7900 XTX Hellhound 24GB', 'PowerColor', 1389000, 31344, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7900 XTX', 'GDDR6', 24, 341, 800, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 9060 XT PULSE 16GB', 'SAPPHIRE', 526000, 20557, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9060 XT', 'GDDR6', 16, 248, 500, 0, 1, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 라데온 RX 9070 GAMING OC 16GB', 'GIGABYTE', 939000, 26808, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9070', 'GDDR6', 16, 319, 650, 0, 2, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 라데온 RX 9070 XT Challenger OC 16GB', 'ASRock', 1002000, 29527, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 9070 XT', 'GDDR6', 16, 297, 750, 0, 2, 'HDMI 2.1b x1, DP 2.1a x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '이엠텍 지포스 RTX 3050 STORM X Dual OC 8GB', '이엠텍', 305000, 12809, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3050', 'GDDR6', 8, 202, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 3060 게이밍 X 트리오 12GB', 'MSI', 467000, 17337, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 3060', 'GDDR6', 12, 268, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS DUAL 지포스 RTX 4060 OC 8GB', 'ASUS', 418000, 19541, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060', 'GDDR6', 8, 199, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '갤럭시 GALAX 지포스 RTX 4060 Ti EX 게이머 OC 8GB', '갤럭시', 615000, 22779, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 8, 277, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4060 Ti 벤투스 2X OC 16GB', 'MSI', 704000, 22822, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 16, 258, 550, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4070 EAGLE OC 12GB', 'GIGABYTE', 909000, 27188, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070', 'GDDR6X', 12, 283, 650, 0, 1, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4070 SUPER AORUS MASTER 12GB', 'GIGABYTE', 1092000, 30576, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 SUPER', 'GDDR6X', 12, 308, 650, 1, 2, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '갤럭시 GALAX 지포스 RTX 4070 Ti SUPER EX 게이머 OC 16GB', '갤럭시', 1266000, 32111, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 Ti SUPER', 'GDDR6X', 16, 326, 700, 1, 2, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4080 SUPER 게이밍 X 트리오 16GB', 'MSI', 1903000, 34984, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4080 SUPER', 'GDDR6X', 16, 356, 750, 1, 3, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4090 EAGLE OC 24GB', 'GIGABYTE', 3334000, 38722, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4090', 'GDDR6X', 24, 349, 850, 1, 4, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 5060 벤투스 3X OC 8GB', 'MSI', 501000, 21717, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060', 'GDDR7', 8, 235, 550, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASUS ROG STRIX 지포스 RTX 5060 Ti OC 8GB', 'ASUS', 672000, 24904, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 8, 275, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, '이엠텍 지포스 RTX 5060 Ti STORM X Dual OC 16GB', '이엠텍', 684000, 24457, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5060 Ti', 'GDDR7', 16, 222, 600, 0, 1, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 5070 게이밍 X 트리오 12GB', 'MSI', 1042000, 29814, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070', 'GDDR7', 12, 307, 650, 1, 2, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 5070 Ti 벤투스 3X OC 16GB', 'MSI', 1390000, 33560, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5070 Ti', 'GDDR7', 16, 326, 750, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'MSI 지포스 RTX 5080 게이밍 X 트리오 16GB', 'MSI', 2002000, 37067, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5080', 'GDDR7', 16, 356, 850, 1, 3, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 5090 WINDFORCE OC 32GB', 'GIGABYTE', 3922000, 39084, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 5090', 'GDDR7', 32, 334, 1000, 1, 4, 'HDMI 2.1b x1, DP 2.1b x3');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'XFX 라데온 RX 6600 SPEEDSTER SWFT 210 8GB', 'XFX', 287000, 15065, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 6600', 'GDDR6', 8, 198, 500, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7600 NITRO+ 8GB', 'SAPPHIRE', 442000, 16858, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600', 'GDDR6', 8, 292, 550, 0, 1, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'ASRock 라데온 RX 7600 XT Challenger OC 16GB', 'ASRock', 468000, 17355, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600 XT', 'GDDR6', 16, 250, 600, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7700 XT PULSE 12GB', 'SAPPHIRE', 586000, 21723, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7700 XT', 'GDDR6', 12, 268, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7800 XT NITRO+ 16GB', 'SAPPHIRE', 862000, 24979, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, uses_16pin, pcie_8pin_count, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7800 XT', 'GDDR6', 16, 327, 700, 0, 2, 'HDMI 2.1 x1, DP 2.1 x2');

-- POWER (pcie_8pin_count: 파워가 제공하는 PCIe 8핀 개수)
INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 Classic II 풀체인지 600W 80PLUS BRONZE', '마이크로닉스', 65000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 600, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'FSP HYPER K PRO 700W 80PLUS STANDARD', 'FSP', 62000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 700, 0, 2, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 FOCUS GX-750 GOLD', '시소닉', 159000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '슈퍼플라워 SF-850F14XG LEADEX VII GOLD', '슈퍼플라워', 185000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM1000x', 'Corsair', 259000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 0, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair SF750', 'Corsair', 229000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS PLATINUM', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 Classic II 풀체인지 500W 80PLUS BRONZE', '마이크로닉스', 92000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 500, 0, 1, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 Classic II 풀체인지 700W 80PLUS BRONZE', '마이크로닉스', 109000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 700, 0, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 Classic II 풀체인지 800W 80PLUS BRONZE', '마이크로닉스', 127000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 800, 0, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 Classic II 풀체인지 700W 80PLUS BRONZE ATX3.1', '마이크로닉스', 126000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 700, 1, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 Classic II 풀체인지 800W 80PLUS BRONZE ATX3.1', '마이크로닉스', 138000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 800, 1, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 Classic II 풀체인지 850W 80PLUS BRONZE ATX3.1', '마이크로닉스', 139000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 WIZMAX 750W 80PLUS GOLD 풀모듈러 ATX3.1', '마이크로닉스', 144000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 WIZMAX 850W 80PLUS GOLD 풀모듈러 ATX3.1', '마이크로닉스', 157000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 WIZMAX 1000W 80PLUS GOLD 풀모듈러 ATX3.1', '마이크로닉스', 191000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 WIZMAX 1200W 80PLUS GOLD 풀모듈러 ATX3.1', '마이크로닉스', 208000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 COOLMAX 500W 80PLUS STANDARD', '마이크로닉스', 78000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 500, 0, 1, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 COOLMAX 600W 80PLUS STANDARD', '마이크로닉스', 83000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 600, 0, 2, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '마이크로닉스 COOLMAX 700W 80PLUS STANDARD', '마이크로닉스', 96000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 700, 0, 2, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 FOCUS GX-650 GOLD', '시소닉', 155000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 FOCUS GX-850 GOLD', '시소닉', 187000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 FOCUS GX-1000 GOLD', '시소닉', 207000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 0, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 FOCUS GX-750 ATX3.0 GOLD', '시소닉', 181000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 FOCUS GX-850 ATX3.0 GOLD', '시소닉', 191000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 FOCUS GX-1000 ATX3.0 GOLD', '시소닉', 210000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 VERTEX GX-850 GOLD', '시소닉', 214000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 VERTEX GX-1000 GOLD', '시소닉', 240000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 VERTEX GX-1200 GOLD', '시소닉', 273000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 VERTEX PX-850 PLATINUM', '시소닉', 227000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 VERTEX PX-1000 PLATINUM', '시소닉', 252000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 PRIME TX-1000 TITANIUM', '시소닉', 317000, 94, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS TITANIUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 PRIME TX-1300 TITANIUM', '시소닉', 382000, 94, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1300, 1, 8, '80PLUS TITANIUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 PRIME TX-1600 TITANIUM', '시소닉', 447000, 94, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1600, 1, 8, '80PLUS TITANIUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 G12 GC-650 GOLD', '시소닉', 126000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 G12 GC-750 GOLD', '시소닉', 144000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 G12 GC-850 GOLD', '시소닉', 162000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM750x', 'Corsair', 176000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM850x', 'Corsair', 191000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM1200x', 'Corsair', 250000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 0, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM750x SHIFT', 'Corsair', 189000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM850x SHIFT', 'Corsair', 212000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM1000x SHIFT', 'Corsair', 240000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM1200x SHIFT', 'Corsair', 257000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM650e ATX3.1', 'Corsair', 149000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 1, 2, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM750e ATX3.1', 'Corsair', 163000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM850e ATX3.1', 'Corsair', 175000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair RM1000e ATX3.1', 'Corsair', 197000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair CX550', 'Corsair', 104000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 550, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair CX650', 'Corsair', 117000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair CX750', 'Corsair', 134000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair SF600', 'Corsair', 203000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 600, 0, 2, '80PLUS PLATINUM', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair SF1000', 'Corsair', 292000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 0, 3, '80PLUS PLATINUM', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair HX1000i', 'Corsair', 285000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair HX1200i', 'Corsair', 330000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair HX1500i', 'Corsair', 409000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1500, 1, 8, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Corsair AX1600i', 'Corsair', 517000, 94, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1600, 1, 8, '80PLUS TITANIUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '슈퍼플라워 SF-750F14XG LEADEX VII GOLD', '슈퍼플라워', 176000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '슈퍼플라워 SF-1000F14XG LEADEX VII GOLD', '슈퍼플라워', 211000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '슈퍼플라워 SF-1300F14XG LEADEX VII GOLD', '슈퍼플라워', 263000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1300, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '슈퍼플라워 LEADEX III GOLD 650W', '슈퍼플라워', 135000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '슈퍼플라워 LEADEX III GOLD 750W', '슈퍼플라워', 145000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '슈퍼플라워 LEADEX III GOLD 850W', '슈퍼플라워', 159000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '슈퍼플라워 LEADEX PLATINUM SE 1000W', '슈퍼플라워', 232000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 0, 6, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '슈퍼플라워 LEADEX PLATINUM SE 1200W', '슈퍼플라워', 269000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 0, 8, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'FSP HYPER K PRO 500W 80PLUS STANDARD', 'FSP', 82000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 500, 0, 1, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'FSP HYPER K PRO 600W 80PLUS STANDARD', 'FSP', 88000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 600, 0, 2, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'FSP HYDRO G PRO 850W 80PLUS GOLD ATX3.0', 'FSP', 185000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'FSP HYDRO G PRO 1000W 80PLUS GOLD ATX3.0', 'FSP', 204000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'FSP DAGGER PRO 650W SFX 80PLUS GOLD ATX3.0', 'FSP', 186000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 1, 2, '80PLUS GOLD', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'FSP DAGGER PRO 750W SFX 80PLUS GOLD ATX3.0', 'FSP', 210000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 3, '80PLUS GOLD', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'FSP DAGGER PRO 850W SFX 80PLUS GOLD ATX3.0', 'FSP', 235000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 3, '80PLUS GOLD', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 MegaMax 500W 80PLUS STANDARD', '잘만', 74000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 500, 0, 1, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 MegaMax 600W 80PLUS STANDARD', '잘만', 84000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 600, 0, 2, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 MegaMax 700W 80PLUS STANDARD', '잘만', 91000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 700, 0, 2, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 TeraMax II 750W 80PLUS GOLD', '잘만', 162000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 TeraMax II 850W 80PLUS GOLD', '잘만', 177000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 TeraMax II 1000W 80PLUS GOLD', '잘만', 189000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 TeraMax II 1200W 80PLUS GOLD', '잘만', 229000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 GigaMax III 650W 80PLUS BRONZE', '잘만', 109000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 GigaMax III 750W 80PLUS BRONZE', '잘만', 123000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '잘만 GigaMax III 850W 80PLUS BRONZE', '잘만', 132000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 0, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '쿨러마스터 MWE BRONZE V2 550W', '쿨러마스터', 102000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 550, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '쿨러마스터 MWE BRONZE V2 650W', '쿨러마스터', 114000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '쿨러마스터 MWE BRONZE V2 750W', '쿨러마스터', 124000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '쿨러마스터 MWE GOLD V2 750W ATX3.0', '쿨러마스터', 160000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '쿨러마스터 MWE GOLD V2 850W ATX3.0', '쿨러마스터', 168000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '쿨러마스터 MWE GOLD V2 1050W ATX3.0', '쿨러마스터', 193000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1050, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '쿨러마스터 V SFX GOLD 750W ATX3.0', '쿨러마스터', 207000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 3, '80PLUS GOLD', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '쿨러마스터 V SFX GOLD 850W ATX3.0', '쿨러마스터', 236000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 3, '80PLUS GOLD', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! PURE POWER 12 M 550W GOLD', 'be quiet!', 135000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 550, 1, 2, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! PURE POWER 12 M 650W GOLD', 'be quiet!', 143000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 1, 2, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! PURE POWER 12 M 750W GOLD', 'be quiet!', 160000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! PURE POWER 12 M 850W GOLD', 'be quiet!', 184000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! PURE POWER 12 M 1000W GOLD', 'be quiet!', 195000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! STRAIGHT POWER 12 750W PLATINUM', 'be quiet!', 204000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! STRAIGHT POWER 12 850W PLATINUM', 'be quiet!', 235000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! STRAIGHT POWER 12 1000W PLATINUM', 'be quiet!', 262000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! STRAIGHT POWER 12 1200W PLATINUM', 'be quiet!', 300000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! DARK POWER 13 850W TITANIUM', 'be quiet!', 286000, 94, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS TITANIUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! DARK POWER 13 1000W TITANIUM', 'be quiet!', 308000, 94, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS TITANIUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! SYSTEM POWER 10 450W BRONZE', 'be quiet!', 87000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 450, 0, 1, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! SYSTEM POWER 10 550W BRONZE', 'be quiet!', 104000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 550, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! SYSTEM POWER 10 650W BRONZE', 'be quiet!', 116000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'be quiet! SYSTEM POWER 10 750W BRONZE', 'be quiet!', 121000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '맥스엘리트 MAXWELL BANGBANG 500W 80PLUS STANDARD', '맥스엘리트', 71000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 500, 0, 1, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '맥스엘리트 MAXWELL BANGBANG 600W 80PLUS STANDARD', '맥스엘리트', 75000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 600, 0, 2, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '맥스엘리트 MAXWELL BANGBANG 700W 80PLUS STANDARD', '맥스엘리트', 86000, 80, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 700, 0, 2, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Thermaltake Toughpower GF3 750W GOLD', 'Thermaltake', 174000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Thermaltake Toughpower GF3 850W GOLD', 'Thermaltake', 185000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Thermaltake Toughpower GF3 1000W GOLD', 'Thermaltake', 201000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Thermaltake Toughpower GF3 1200W GOLD', 'Thermaltake', 242000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Thermaltake Toughpower GF3 1350W GOLD', 'Thermaltake', 259000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1350, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Thermaltake Smart BX1 550W BRONZE', 'Thermaltake', 103000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 550, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Thermaltake Smart BX1 650W BRONZE', 'Thermaltake', 108000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Thermaltake Smart BX1 750W BRONZE', 'Thermaltake', 119000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS ROG STRIX 750W GOLD Aura Edition', 'ASUS', 205000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS ROG STRIX 850W GOLD Aura Edition', 'ASUS', 220000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS ROG STRIX 1000W GOLD Aura Edition', 'ASUS', 259000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS ROG STRIX 1200W GOLD Aura Edition', 'ASUS', 306000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS TUF GAMING 750W GOLD', 'ASUS', 173000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS TUF GAMING 850W GOLD', 'ASUS', 186000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS TUF GAMING 1000W GOLD', 'ASUS', 200000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS TUF GAMING 1200W GOLD', 'ASUS', 235000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS ROG LOKI SFX-L 850W PLATINUM', 'ASUS', 275000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 3, '80PLUS PLATINUM', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS ROG LOKI SFX-L 1000W PLATINUM', 'ASUS', 312000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 4, '80PLUS PLATINUM', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS ROG LOKI SFX-L 1200W PLATINUM', 'ASUS', 359000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 6, '80PLUS PLATINUM', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS ROG THOR 1000P2 PLATINUM', 'ASUS', 307000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'ASUS ROG THOR 1200P2 PLATINUM', 'ASUS', 370000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS PLATINUM', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'MSI MAG A650GL PCIE5 GOLD', 'MSI', 134000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 1, 2, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'MSI MAG A750GL PCIE5 GOLD', 'MSI', 148000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'MSI MAG A850GL PCIE5 GOLD', 'MSI', 158000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'MSI MAG A1000GL PCIE5 GOLD', 'MSI', 190000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'MSI MPG A850G PCIE5 GOLD', 'MSI', 193000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'MSI MPG A1000G PCIE5 GOLD', 'MSI', 208000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'MSI MAG A550BN BRONZE', 'MSI', 94000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 550, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'MSI MAG A650BN BRONZE', 'MSI', 105000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'MSI MAG A750BN BRONZE', 'MSI', 117000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'GIGABYTE UD750GM PG5 GOLD', 'GIGABYTE', 162000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'GIGABYTE UD850GM PG5 GOLD', 'GIGABYTE', 167000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'GIGABYTE UD1000GM PG5 GOLD', 'GIGABYTE', 187000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'NZXT C850 GOLD ATX3.1', 'NZXT', 192000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 1, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'NZXT C1000 GOLD ATX3.1', 'NZXT', 221000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 1, 6, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'NZXT C1200 GOLD ATX3.1', 'NZXT', 248000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1200, 1, 8, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'SilverStone SX750-PT SFX PLATINUM', 'SilverStone', 247000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 3, '80PLUS PLATINUM', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'SilverStone SX1000-PT SFX PLATINUM', 'SilverStone', 302000, 92, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, 0, 3, '80PLUS PLATINUM', 'SFX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Antec NeoECO 650 GOLD', 'Antec', 131000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Antec NeoECO 750 GOLD', 'Antec', 144000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, 'Antec NeoECO 850 GOLD', 'Antec', 154000, 90, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, 0, 4, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 S12III-550 BRONZE', '시소닉', 93000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 550, 0, 2, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@power, '시소닉 S12III-650 BRONZE', '시소닉', 110000, 85, NULL);
INSERT INTO power (module_id, rated_power, has_16pin, pcie_8pin_count, certification, form_factor) VALUES (LAST_INSERT_ID(), 650, 0, 2, '80PLUS BRONZE', 'ATX');

-- SSD (capacity 단위: GB)
INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 870 EVO 500GB', '삼성전자', 79000, 4177, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 500, 560, 530);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial P3 Plus M.2 NVMe 500GB', '마이크론', 59000, 23933, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 4700, 1900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Platinum P41 M.2 NVMe 1TB', 'SK하이닉스', 135000, 42076, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7000, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 PRO M.2 NVMe 1TB', '삼성전자', 165000, 47782, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7450, 6900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 PRO M.2 NVMe 2TB', '삼성전자', 289000, 48968, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7450, 6900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Black SN850X M.2 NVMe 2TB', 'Western Digital', 239000, 51176, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7300, 6600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 PRO M.2 NVMe 4TB', '삼성전자', 575000, 50634, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 7450, 6900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 EVO Plus M.2 NVMe 1TB', '삼성전자', 130000, 42764, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7250, 6300);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 EVO Plus M.2 NVMe 2TB', '삼성전자', 245000, 45241, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7250, 6300);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 EVO Plus M.2 NVMe 4TB', '삼성전자', 475000, 46265, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 7250, 6300);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 EVO M.2 NVMe 1TB', '삼성전자', 120000, 29414, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 5000, 4200);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 EVO M.2 NVMe 2TB', '삼성전자', 225000, 31451, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 5000, 4200);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 980 PRO M.2 NVMe 1TB', '삼성전자', 135000, 38295, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7000, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 980 PRO M.2 NVMe 2TB', '삼성전자', 255000, 41176, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7000, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 980 M.2 NVMe 500GB', '삼성전자', 72000, 15213, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 2945, 1819);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 980 M.2 NVMe 1TB', '삼성전자', 110000, 18828, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 3100, 2600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 870 EVO 250GB', '삼성전자', 48000, 3506, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 250, 560, 371);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 870 EVO 1TB', '삼성전자', 125000, 4227, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 1000, 560, 530);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 870 EVO 2TB', '삼성전자', 235000, 4566, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 2000, 560, 530);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 870 EVO 4TB', '삼성전자', 455000, 4587, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 4000, 560, 530);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 870 QVO 1TB', '삼성전자', 100000, 4376, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 1000, 560, 530);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 870 QVO 2TB', '삼성전자', 185000, 4455, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 2000, 560, 530);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 870 QVO 4TB', '삼성전자', 355000, 4789, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 4000, 560, 530);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Platinum P41 M.2 NVMe 500GB', 'SK하이닉스', 87000, 35469, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 6650, 4550);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Platinum P41 M.2 NVMe 2TB', 'SK하이닉스', 255000, 44424, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7000, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Platinum P51 M.2 NVMe 1TB', 'SK하이닉스', 205000, 90997, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 14700, 13400);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Platinum P51 M.2 NVMe 2TB', 'SK하이닉스', 395000, 94087, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 14700, 13400);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Gold P31 M.2 NVMe 500GB', 'SK하이닉스', 72000, 17833, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 3325, 2240);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Gold P31 M.2 NVMe 1TB', 'SK하이닉스', 110000, 20782, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 3500, 3200);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Gold P31 M.2 NVMe 2TB', 'SK하이닉스', 205000, 22153, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 3500, 3200);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Gold S31 500GB', 'SK하이닉스', 72000, 3588, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 500, 560, 367);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SK하이닉스 Gold S31 1TB', 'SK하이닉스', 110000, 4294, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 1000, 560, 525);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Black SN850X M.2 NVMe 1TB', 'Western Digital', 130000, 45503, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7300, 6600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Black SN850X M.2 NVMe 4TB', 'Western Digital', 475000, 48643, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 7300, 6600);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Black SN770 M.2 NVMe 500GB', 'Western Digital', 69000, 25649, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 4892, 3430);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Black SN770 M.2 NVMe 1TB', 'Western Digital', 105000, 31339, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 5150, 4900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Black SN770 M.2 NVMe 2TB', 'Western Digital', 195000, 32971, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 5150, 4900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SN580 M.2 NVMe 500GB', 'Western Digital', 63000, 21047, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 3942, 2905);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SN580 M.2 NVMe 1TB', 'Western Digital', 95000, 26647, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 4150, 4150);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SN580 M.2 NVMe 2TB', 'Western Digital', 175000, 26956, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 4150, 4150);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SA510 500GB', 'Western Digital', 66000, 3702, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 500, 560, 357);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SA510 1TB', 'Western Digital', 100000, 4203, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 1000, 560, 510);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SA510 2TB', 'Western Digital', 185000, 4569, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 2000, 560, 510);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial P3 Plus M.2 NVMe 1TB', '마이크론', 95000, 28840, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 5000, 4200);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial P3 Plus M.2 NVMe 2TB', '마이크론', 175000, 29870, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 5000, 4200);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial P3 Plus M.2 NVMe 4TB', '마이크론', 335000, 31015, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 5000, 4200);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial P3 M.2 NVMe 500GB', '마이크론', 60000, 17335, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 3325, 2100);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial P3 M.2 NVMe 1TB', '마이크론', 90000, 20669, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 3500, 3000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial P3 M.2 NVMe 2TB', '마이크론', 165000, 21822, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 3500, 3000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial T500 M.2 NVMe 500GB', '마이크론', 78000, 37019, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 7030, 4900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial T500 M.2 NVMe 1TB', '마이크론', 120000, 46270, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7400, 7000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial T500 M.2 NVMe 2TB', '마이크론', 225000, 46487, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7400, 7000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial T700 M.2 NVMe 1TB', '마이크론', 195000, 76148, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 12400, 11800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial T700 M.2 NVMe 2TB', '마이크론', 375000, 80910, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 12400, 11800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial T700 M.2 NVMe 4TB', '마이크론', 735000, 83177, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 12400, 11800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial MX500 250GB', '마이크론', 42000, 3543, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 250, 560, 357);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial MX500 500GB', '마이크론', 69000, 3614, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 500, 560, 357);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial MX500 1TB', '마이크론', 105000, 4204, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 1000, 560, 510);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial MX500 2TB', '마이크론', 195000, 4400, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 2000, 560, 510);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial MX500 4TB', '마이크론', 375000, 4729, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 4000, 560, 510);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial BX500 240GB', '마이크론', 37000, 3436, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 240, 540, 350);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial BX500 480GB', '마이크론', 58000, 3590, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 480, 540, 350);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial BX500 1TB', '마이크론', 90000, 4243, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 1000, 540, 500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial BX500 2TB', '마이크론', 165000, 4339, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 2000, 540, 500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston NV2 M.2 NVMe 500GB', 'Kingston', 57000, 16908, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 3325, 1959);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston NV2 M.2 NVMe 1TB', 'Kingston', 85000, 19815, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 3500, 2800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston NV2 M.2 NVMe 2TB', 'Kingston', 155000, 21075, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 3500, 2800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston NV3 M.2 NVMe 500GB', 'Kingston', 63000, 28289, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 5700, 3500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston NV3 M.2 NVMe 1TB', 'Kingston', 95000, 34322, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 6000, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston NV3 M.2 NVMe 2TB', 'Kingston', 175000, 37769, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 6000, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston NV3 M.2 NVMe 4TB', 'Kingston', 335000, 38162, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 6000, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston KC3000 M.2 NVMe 512GB', 'Kingston', 80000, 33865, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 512, 6650, 4200);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston KC3000 M.2 NVMe 1TB', 'Kingston', 123000, 41639, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1024, 7000, 6000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston KC3000 M.2 NVMe 2TB', 'Kingston', 230000, 42635, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2048, 7000, 6000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston FURY Renegade M.2 NVMe 1TB', 'Kingston', 135000, 44394, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7300, 7000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston FURY Renegade M.2 NVMe 2TB', 'Kingston', 255000, 46859, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7300, 7000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston FURY Renegade M.2 NVMe 4TB', 'Kingston', 495000, 48530, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 7300, 7000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston A400 240GB', 'Kingston', 35000, 2987, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 240, 500, 315);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston A400 480GB', 'Kingston', 55000, 3271, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 480, 500, 315);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston A400 1TB', 'Kingston', 82000, 3776, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 960, 500, 450);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SOLIDIGM P44 Pro M.2 NVMe 512GB', 'SOLIDIGM', 80000, 34679, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 512, 6650, 4550);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SOLIDIGM P44 Pro M.2 NVMe 1TB', 'SOLIDIGM', 123000, 42667, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1024, 7000, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SOLIDIGM P44 Pro M.2 NVMe 2TB', 'SOLIDIGM', 230000, 45509, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2048, 7000, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SOLIDIGM P41 Plus M.2 NVMe 512GB', 'SOLIDIGM', 61000, 19830, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 512, 3918, 2327);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SOLIDIGM P41 Plus M.2 NVMe 1TB', 'SOLIDIGM', 92000, 24722, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1024, 4125, 3325);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'SOLIDIGM P41 Plus M.2 NVMe 2TB', 'SOLIDIGM', 169000, 25029, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2048, 4125, 3325);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 960 MAX M.2 NVMe 1TB', 'ADATA', 120000, 45457, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7400, 6800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 960 MAX M.2 NVMe 2TB', 'ADATA', 225000, 47665, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7400, 6800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 960 MAX M.2 NVMe 4TB', 'ADATA', 435000, 49199, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 7400, 6800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 710 M.2 NVMe 512GB', 'ADATA', 55000, 11044, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 512, 2280, 1260);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 710 M.2 NVMe 1TB', 'ADATA', 80000, 13703, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 2400, 1800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 710 M.2 NVMe 2TB', 'ADATA', 145000, 14187, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 2400, 1800);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA SU650 256GB', 'ADATA', 35000, 3090, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 256, 520, 315);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA SU650 512GB', 'ADATA', 55000, 3238, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 512, 520, 315);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA SU650 1TB', 'ADATA', 80000, 3918, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 1000, 520, 450);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup MP44 M.2 NVMe 1TB', 'TeamGroup', 110000, 44460, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7400, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup MP44 M.2 NVMe 2TB', 'TeamGroup', 205000, 46005, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7400, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup MP44 M.2 NVMe 4TB', 'TeamGroup', 395000, 47524, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 7400, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup MP33 M.2 NVMe 512GB', 'TeamGroup', 55000, 8944, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 512, 1710, 1050);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup MP33 M.2 NVMe 1TB', 'TeamGroup', 80000, 10685, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 1800, 1500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup MP33 M.2 NVMe 2TB', 'TeamGroup', 145000, 10697, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 1800, 1500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup CX2 512GB', 'TeamGroup', 55000, 3422, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 512, 540, 343);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup CX2 1TB', 'TeamGroup', 80000, 4062, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 1000, 540, 490);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NM790 M.2 NVMe 1TB', 'Lexar', 110000, 43288, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7400, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NM790 M.2 NVMe 2TB', 'Lexar', 205000, 47535, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7400, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NM790 M.2 NVMe 4TB', 'Lexar', 395000, 48900, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 7400, 6500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NM620 M.2 NVMe 512GB', 'Lexar', 58000, 16410, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 512, 3135, 2100);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NM620 M.2 NVMe 1TB', 'Lexar', 85000, 20173, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 3300, 3000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NM620 M.2 NVMe 2TB', 'Lexar', 155000, 21116, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 3300, 3000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NS100 512GB', 'Lexar', 55000, 3508, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 512, 550, 315);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NS100 1TB', 'Lexar', 80000, 3904, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 1000, 550, 450);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 PRO 히트싱크 M.2 NVMe 1TB', '삼성전자', 165000, 45406, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7450, 6900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 PRO 히트싱크 M.2 NVMe 2TB', '삼성전자', 315000, 47787, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7450, 6900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 990 PRO 히트싱크 M.2 NVMe 4TB', '삼성전자', 615000, 49912, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 7450, 6900);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 9100 PRO M.2 NVMe 1TB', '삼성전자', 215000, 87095, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 14700, 13300);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 9100 PRO M.2 NVMe 2TB', '삼성전자', 415000, 95424, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 14700, 13300);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 9100 PRO M.2 NVMe 4TB', '삼성전자', 815000, 95780, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 14700, 13300);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 PM9A1 M.2 NVMe 512GB', '삼성전자', 73000, 33030, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 512, 6650, 3570);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 PM9A1 M.2 NVMe 1TB', '삼성전자', 112000, 39379, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1024, 7000, 5100);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, '삼성전자 PM9A1 M.2 NVMe 2TB', '삼성전자', 210000, 41747, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2048, 7000, 5100);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Black SN8100 M.2 NVMe 1TB', 'Western Digital', 205000, 93691, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 14900, 14000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Black SN8100 M.2 NVMe 2TB', 'Western Digital', 395000, 98002, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 14900, 14000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Black SN8100 M.2 NVMe 4TB', 'Western Digital', 775000, 97608, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 14900, 14000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SN5000 M.2 NVMe 500GB', 'Western Digital', 66000, 27704, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 5225, 3500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SN5000 M.2 NVMe 1TB', 'Western Digital', 100000, 34074, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 5500, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SN5000 M.2 NVMe 2TB', 'Western Digital', 185000, 34728, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 5500, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Blue SN5000 M.2 NVMe 4TB', 'Western Digital', 355000, 37030, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 5500, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Green SN350 M.2 NVMe 500GB', 'Western Digital', 54000, 15536, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 3040, 1750);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Green SN350 M.2 NVMe 1TB', 'Western Digital', 80000, 18910, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 3200, 2500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'WD Green SN350 M.2 NVMe 2TB', 'Western Digital', 145000, 18956, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 3200, 2500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial P310 M.2 NVMe 1TB', '마이크론', 100000, 41638, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7100, 6000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial P310 M.2 NVMe 2TB', '마이크론', 185000, 44525, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7100, 6000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial T705 M.2 NVMe 1TB', '마이크론', 225000, 86651, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 14500, 12700);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial T705 M.2 NVMe 2TB', '마이크론', 435000, 89655, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 14500, 12700);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Crucial T705 M.2 NVMe 4TB', '마이크론', 855000, 94430, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 14500, 12700);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston KC3000 M.2 NVMe 4TB', 'Kingston', 445000, 47642, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4096, 7000, 7000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston FURY Renegade G5 M.2 NVMe 1TB', 'Kingston', 210000, 93966, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1024, 14700, 14000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston FURY Renegade G5 M.2 NVMe 2TB', 'Kingston', 404000, 95562, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2048, 14700, 14000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Kingston FURY Renegade G5 M.2 NVMe 4TB', 'Kingston', 793000, 98762, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4096, 14700, 14000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 970 M.2 NVMe 1TB', 'ADATA', 175000, 62638, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 10000, 10000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 970 M.2 NVMe 2TB', 'ADATA', 335000, 67759, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 10000, 10000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 860 M.2 NVMe 500GB', 'ADATA', 63000, 29661, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 5700, 3500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 860 M.2 NVMe 1TB', 'ADATA', 95000, 36284, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 6000, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'ADATA LEGEND 860 M.2 NVMe 2TB', 'ADATA', 175000, 36427, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 6000, 5000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup MP44L M.2 NVMe 500GB', 'TeamGroup', 60000, 24246, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 4750, 3150);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup MP44L M.2 NVMe 1TB', 'TeamGroup', 90000, 30270, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 5000, 4500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'TeamGroup MP44L M.2 NVMe 2TB', 'TeamGroup', 165000, 31652, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 5000, 4500);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NM990 M.2 NVMe 1TB', 'Lexar', 195000, 81363, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 14000, 11000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NM990 M.2 NVMe 2TB', 'Lexar', 375000, 84682, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 14000, 11000);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@ssd, 'Lexar NM990 M.2 NVMe 4TB', 'Lexar', 735000, 84997, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 4000, 14000, 11000);

-- HDD (capacity 단위: TB)
INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Blue 7200/64M 1TB', 'Western Digital', 69000, 1223, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 1, 7200, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate BarraCuda 7200/256M 2TB', 'Seagate', 85000, 2375, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba P300 7200/256M 2TB', 'Toshiba', 82000, 1399, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate BarraCuda 5400/256M 4TB', 'Seagate', 119000, 3014, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Plus 5640/256M 8TB', 'Western Digital', 279000, 1389, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 5640, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf 7200/256M 12TB', 'Seagate', 389000, 1549, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Blue 7200/256M 2TB', 'Western Digital', 136000, 1128, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Blue 5400/256M 4TB', 'Western Digital', 160000, 1249, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Blue 5400/256M 6TB', 'Western Digital', 220000, 1358, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Blue 5640/256M 8TB', 'Western Digital', 280000, 1583, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 5640, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate BarraCuda 7200/64M 1TB', 'Seagate', 85000, 1059, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 1, 7200, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate BarraCuda 5400/256M 3TB', 'Seagate', 124000, 1174, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 3, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate BarraCuda 5400/256M 6TB', 'Seagate', 208000, 1483, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate BarraCuda 5400/256M 8TB', 'Seagate', 264000, 1436, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba P300 7200/64M 1TB', 'Toshiba', 85000, 1138, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 1, 7200, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba P300 7200/64M 3TB', 'Toshiba', 124000, 1264, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 3, 7200, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba P300 5400/128M 4TB', 'Toshiba', 152000, 1148, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 5400, 128);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba P300 5400/128M 6TB', 'Toshiba', 208000, 1307, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 5400, 128);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Plus 5400/128M 2TB', 'Western Digital', 149000, 1060, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 5400, 128);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Plus 5400/256M 3TB', 'Western Digital', 142000, 1047, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 3, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Plus 5400/256M 4TB', 'Western Digital', 176000, 1174, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Plus 5400/256M 6TB', 'Western Digital', 244000, 1306, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Plus 7200/256M 10TB', 'Western Digital', 380000, 2024, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Plus 7200/256M 12TB', 'Western Digital', 448000, 2019, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Plus 5400/512M 14TB', 'Western Digital', 516000, 1758, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 5400, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/256M 4TB', 'Western Digital', 192000, 1261, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/256M 6TB', 'Western Digital', 268000, 1432, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/256M 8TB', 'Western Digital', 344000, 1549, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/256M 10TB', 'Western Digital', 420000, 1898, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/256M 12TB', 'Western Digital', 496000, 2026, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/512M 14TB', 'Western Digital', 572000, 2364, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/512M 16TB', 'Western Digital', 648000, 2272, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/512M 18TB', 'Western Digital', 724000, 2559, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/512M 20TB', 'Western Digital', 800000, 2508, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 20, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Red Pro 7200/512M 22TB', 'Western Digital', 876000, 2879, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 22, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple 5400/64M 1TB', 'Western Digital', 90000, 889, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 1, 5400, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple 5400/64M 2TB', 'Western Digital', 139000, 1143, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 5400, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple 5400/64M 3TB', 'Western Digital', 133000, 1188, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 3, 5400, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple 5400/256M 4TB', 'Western Digital', 164000, 1273, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple 5400/256M 6TB', 'Western Digital', 226000, 1469, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple 5640/256M 8TB', 'Western Digital', 288000, 1567, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 5640, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple 7200/256M 10TB', 'Western Digital', 350000, 2027, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple 7200/256M 12TB', 'Western Digital', 412000, 1930, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple Pro 7200/256M 8TB', 'Western Digital', 336000, 1534, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple Pro 7200/256M 10TB', 'Western Digital', 410000, 1790, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple Pro 7200/256M 12TB', 'Western Digital', 484000, 1957, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple Pro 7200/512M 14TB', 'Western Digital', 558000, 2252, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple Pro 7200/512M 18TB', 'Western Digital', 706000, 2524, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Purple Pro 7200/512M 22TB', 'Western Digital', 854000, 2995, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 22, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/128M 1TB', 'Western Digital', 104000, 1110, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 1, 7200, 128);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/128M 2TB', 'Western Digital', 168000, 1212, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 7200, 128);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/256M 4TB', 'Western Digital', 200000, 1491, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/256M 6TB', 'Western Digital', 280000, 1435, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/256M 8TB', 'Western Digital', 360000, 1582, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/256M 10TB', 'Western Digital', 440000, 1872, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/256M 12TB', 'Western Digital', 520000, 2031, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/512M 14TB', 'Western Digital', 600000, 2017, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/512M 16TB', 'Western Digital', 680000, 2438, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/512M 18TB', 'Western Digital', 760000, 2580, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/512M 20TB', 'Western Digital', 840000, 2763, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 20, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Gold 7200/512M 22TB', 'Western Digital', 920000, 2645, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 22, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Black 7200/64M 2TB', 'Western Digital', 174000, 1151, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 7200, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Black 7200/256M 4TB', 'Western Digital', 208000, 1494, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Black 7200/256M 6TB', 'Western Digital', 292000, 1510, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Black 7200/256M 8TB', 'Western Digital', 376000, 1697, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf 5900/64M 1TB', 'Seagate', 91000, 1066, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 1, 5900, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf 5900/64M 2TB', 'Seagate', 142000, 1066, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 5900, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf 5400/256M 3TB', 'Seagate', 136000, 1216, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 3, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf 5400/256M 4TB', 'Seagate', 168000, 1115, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf 5400/256M 6TB', 'Seagate', 232000, 1417, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf 7200/256M 8TB', 'Seagate', 296000, 1736, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf 7200/256M 10TB', 'Seagate', 360000, 2031, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/256M 4TB', 'Seagate', 184000, 1508, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/256M 6TB', 'Seagate', 256000, 1412, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/256M 8TB', 'Seagate', 328000, 1676, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/256M 10TB', 'Seagate', 400000, 1880, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/256M 12TB', 'Seagate', 472000, 2132, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/256M 14TB', 'Seagate', 544000, 2122, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/256M 16TB', 'Seagate', 616000, 2448, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/256M 18TB', 'Seagate', 688000, 2568, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/256M 20TB', 'Seagate', 760000, 2488, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 20, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/512M 22TB', 'Seagate', 832000, 2985, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 22, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate IronWolf Pro 7200/512M 24TB', 'Seagate', 904000, 2997, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 24, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk 5400/64M 1TB', 'Seagate', 86000, 933, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 1, 5400, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk 5400/256M 2TB', 'Seagate', 133000, 1056, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk 5400/256M 3TB', 'Seagate', 127000, 1162, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 3, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk 5400/256M 4TB', 'Seagate', 156000, 1132, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk 5400/256M 6TB', 'Seagate', 214000, 1234, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk 5400/256M 8TB', 'Seagate', 272000, 1361, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk AI 7200/256M 8TB', 'Seagate', 320000, 1747, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk AI 7200/256M 10TB', 'Seagate', 390000, 1792, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk AI 7200/256M 12TB', 'Seagate', 460000, 2056, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk AI 7200/256M 16TB', 'Seagate', 600000, 2452, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk AI 7200/256M 20TB', 'Seagate', 740000, 2384, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 20, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate SkyHawk AI 7200/512M 24TB', 'Seagate', 880000, 2927, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 24, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X16 7200/256M 14TB', 'Seagate', 460000, 2035, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X16 7200/256M 16TB', 'Seagate', 520000, 2411, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X18 7200/256M 16TB', 'Seagate', 520000, 2376, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X18 7200/256M 18TB', 'Seagate', 580000, 2294, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X20 7200/256M 18TB', 'Seagate', 580000, 2599, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X20 7200/256M 20TB', 'Seagate', 640000, 2348, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 20, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X24 7200/512M 20TB', 'Seagate', 660000, 2363, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 20, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X24 7200/512M 24TB', 'Seagate', 784000, 2716, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 24, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 7200/256M 4TB', 'Toshiba', 164000, 1307, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 7200/256M 6TB', 'Toshiba', 226000, 1503, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 7200/256M 8TB', 'Toshiba', 288000, 1560, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 7200/256M 10TB', 'Toshiba', 350000, 1990, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 7200/256M 12TB', 'Toshiba', 412000, 2163, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 7200/256M 14TB', 'Toshiba', 474000, 2286, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 7200/512M 16TB', 'Toshiba', 536000, 2339, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 7200/512M 18TB', 'Toshiba', 598000, 2675, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba X300 7200/256M 4TB', 'Toshiba', 164000, 1357, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba X300 7200/256M 6TB', 'Toshiba', 226000, 1605, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba X300 7200/256M 8TB', 'Toshiba', 288000, 1536, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba X300 7200/256M 10TB', 'Toshiba', 350000, 1712, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba X300 7200/256M 12TB', 'Toshiba', 412000, 2030, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba X300 7200/256M 14TB', 'Toshiba', 474000, 2017, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba X300 7200/512M 16TB', 'Toshiba', 536000, 2504, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba X300 7200/512M 18TB', 'Toshiba', 598000, 2269, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba MG10 7200/512M 20TB', 'Toshiba', 640000, 2486, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 20, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba MG09 7200/512M 18TB', 'Toshiba', 580000, 2639, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba MG08 7200/512M 14TB', 'Toshiba', 460000, 2329, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba MG08 7200/512M 16TB', 'Toshiba', 520000, 2451, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 Pro 7200/256M 4TB', 'Toshiba', 176000, 1268, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 Pro 7200/256M 6TB', 'Toshiba', 244000, 1479, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 Pro 7200/256M 8TB', 'Toshiba', 312000, 1840, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 Pro 7200/256M 10TB', 'Toshiba', 380000, 1948, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba N300 Pro 7200/256M 12TB', 'Toshiba', 448000, 2015, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Ultrastar DC HC550 7200/512M 16TB', 'Western Digital', 520000, 2264, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 16, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Ultrastar DC HC550 7200/512M 18TB', 'Western Digital', 580000, 2398, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 18, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Ultrastar DC HC560 7200/512M 20TB', 'Western Digital', 640000, 2785, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 20, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Ultrastar DC HC570 7200/512M 22TB', 'Western Digital', 700000, 2873, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 22, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'WD Ultrastar DC HC580 7200/512M 24TB', 'Western Digital', 784000, 2669, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 24, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos 7E10 7200/256M 2TB', 'Seagate', 136000, 1207, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos 7E10 7200/256M 4TB', 'Seagate', 160000, 1409, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos 7E10 7200/256M 6TB', 'Seagate', 220000, 1490, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos 7E10 7200/256M 8TB', 'Seagate', 280000, 1826, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos 7E10 7200/256M 10TB', 'Seagate', 340000, 1824, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X18 7200/256M 10TB', 'Seagate', 340000, 1754, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 10, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X18 7200/256M 12TB', 'Seagate', 400000, 2145, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Seagate Exos X18 7200/256M 14TB', 'Seagate', 460000, 2337, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba MG07 7200/256M 12TB', 'Toshiba', 388000, 1842, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba MG07 7200/256M 14TB', 'Toshiba', 446000, 2329, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 14, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba MG11 7200/512M 22TB', 'Toshiba', 722000, 2719, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 22, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba MG11 7200/512M 24TB', 'Toshiba', 784000, 3018, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 24, 7200, 512);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba S300 5400/64M 1TB', 'Toshiba', 86000, 914, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 1, 5400, 64);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba S300 5400/128M 2TB', 'Toshiba', 133000, 1112, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 5400, 128);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba S300 5400/128M 4TB', 'Toshiba', 156000, 1163, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 5400, 128);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba S300 5400/256M 6TB', 'Toshiba', 214000, 1439, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 6, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@hdd, 'Toshiba S300 7200/256M 8TB', 'Toshiba', 272000, 1797, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 7200, 256);

-- MONITOR
INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI G2412F', 'MSI', 139000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 23.8, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 27GR75Q', 'LG전자', 369000, 608, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL S2722QC', 'DELL', 459000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G5 S32CG510', '삼성전자', 349000, 608, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, 'QHD (2560x1440)', 'VA', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 OLED G8 G80SD', '삼성전자', 1390000, 1991, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라와이드 34WQ75C', 'LG전자', 549000, 297, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'IPS', 60, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G3 24인치 FHD VA 180Hz', '삼성전자', 368000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'VA', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G3 27인치 FHD VA 180Hz', '삼성전자', 354000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'VA', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G5 27인치 QHD VA 165Hz', '삼성전자', 435000, 608, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'VA', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G5 27인치 QHD IPS 180Hz', '삼성전자', 486000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G5 32인치 QHD VA 180Hz', '삼성전자', 464000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, 'QHD (2560x1440)', 'VA', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G5 34인치 WQHD VA 165Hz', '삼성전자', 512000, 817, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'VA', 165, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G6 27인치 QHD IPS 240Hz', '삼성전자', 559000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G6 32인치 QHD VA 240Hz', '삼성전자', 561000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, 'QHD (2560x1440)', 'VA', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G7 28인치 4K IPS 144Hz', '삼성전자', 689000, 1194, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 28.0, '4K UHD (3840x2160)', 'IPS', 144, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G7 32인치 4K IPS 144Hz', '삼성전자', 769000, 1194, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 144, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 OLED G6 27인치 QHD OLED 360Hz', '삼성전자', 1602000, 1327, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 360, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 OLED G6 27인치 QHD OLED 500Hz', '삼성전자', 1943000, 1843, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 500, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 OLED G8 27인치 4K OLED 240Hz', '삼성전자', 1857000, 1991, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 OLED G8 34인치 WQHD OLED 175Hz', '삼성전자', 1472000, 867, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'OLED', 175, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 OLED G9 49인치 DQHD OLED 240Hz', '삼성전자', 2140000, 1769, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 49.0, 'DQHD (5120x1440)', 'OLED', 240, '32:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 뷰피니티 S6 27인치 QHD IPS 100Hz', '삼성전자', 366000, 369, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 뷰피니티 S6 32인치 4K VA 60Hz', '삼성전자', 571000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'VA', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 스마트모니터 M7 32인치 4K VA 60Hz', '삼성전자', 622000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'VA', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 스마트모니터 M7 43인치 4K VA 60Hz', '삼성전자', 636000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 43.0, '4K UHD (3840x2160)', 'VA', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 에센셜 S3 24인치 FHD IPS 100Hz', '삼성전자', 264000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 에센셜 S3 27인치 FHD IPS 100Hz', '삼성전자', 259000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 24인치 FHD IPS 180Hz', 'LG전자', 385000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 27인치 FHD IPS 180Hz', 'LG전자', 391000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 27인치 QHD IPS 180Hz', 'LG전자', 482000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 27인치 QHD IPS 240Hz', 'LG전자', 525000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 32인치 QHD IPS 165Hz', 'LG전자', 455000, 608, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, 'QHD (2560x1440)', 'IPS', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 32인치 4K IPS 144Hz', 'LG전자', 660000, 1194, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 144, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 OLED 27인치 QHD OLED 240Hz', 'LG전자', 1383000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 OLED 27인치 QHD OLED 480Hz', 'LG전자', 1896000, 1769, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 480, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 OLED 32인치 4K OLED 240Hz', 'LG전자', 2004000, 1991, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 OLED 45인치 WQHD OLED 240Hz', 'LG전자', 1752000, 1189, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 45.0, 'WQHD (3440x1440)', 'OLED', 240, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라파인 27인치 4K IPS 60Hz', 'LG전자', 610000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라파인 32인치 4K IPS 60Hz', 'LG전자', 592000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라와이드 29인치 WFHD IPS 100Hz', 'LG전자', 350000, 276, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 29.0, 'WFHD (2560x1080)', 'IPS', 100, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라와이드 34인치 WFHD IPS 100Hz', 'LG전자', 381000, 276, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WFHD (2560x1080)', 'IPS', 100, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라와이드 34인치 WQHD IPS 160Hz', 'LG전자', 524000, 793, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'IPS', 160, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라와이드 38인치 WQHD IPS 144Hz', 'LG전자', 511000, 713, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 38.0, 'WQHD (3440x1440)', 'IPS', 144, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 모니터 24인치 FHD IPS 100Hz', 'LG전자', 244000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 모니터 27인치 FHD IPS 100Hz', 'LG전자', 264000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 모니터 27인치 QHD IPS 100Hz', 'LG전자', 317000, 369, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MAG 24.5인치 FHD IPS 180Hz', 'MSI', 358000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.5, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MAG 27인치 QHD IPS 180Hz', 'MSI', 461000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MAG 27인치 QHD IPS 240Hz', 'MSI', 511000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MAG 32인치 4K IPS 160Hz', 'MSI', 661000, 1327, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 160, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MAG 34인치 WQHD VA 180Hz', 'MSI', 519000, 892, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'VA', 180, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MPG OLED 27인치 QHD OLED 360Hz', 'MSI', 1666000, 1327, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 360, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MPG OLED 32인치 4K OLED 240Hz', 'MSI', 1935000, 1991, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MPG OLED 49인치 DQHD OLED 240Hz', 'MSI', 1928000, 1769, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 49.0, 'DQHD (5120x1440)', 'OLED', 240, '32:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI PRO 24인치 FHD IPS 100Hz', 'MSI', 253000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI PRO 27인치 FHD IPS 100Hz', 'MSI', 253000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI PRO 27인치 QHD IPS 100Hz', 'MSI', 324000, 369, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL S 24인치 FHD IPS 100Hz', 'DELL', 275000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL S 27인치 FHD IPS 100Hz', 'DELL', 308000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL S 27인치 QHD IPS 165Hz', 'DELL', 416000, 608, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL S 32인치 4K VA 60Hz', 'DELL', 587000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'VA', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL 울트라샤프 24인치 FHD IPS 120Hz', 'DELL', 386000, 249, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 120, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL 울트라샤프 27인치 QHD IPS 120Hz', 'DELL', 527000, 442, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 120, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL 울트라샤프 27인치 4K IPS 60Hz', 'DELL', 678000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL 울트라샤프 32인치 4K IPS 60Hz', 'DELL', 703000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL 울트라샤프 34인치 WQHD IPS 120Hz', 'DELL', 612000, 594, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'IPS', 120, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL 에일리언웨어 25인치 FHD IPS 360Hz', 'DELL', 709000, 746, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 25.0, 'FHD (1920x1080)', 'IPS', 360, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL 에일리언웨어 27인치 QHD OLED 360Hz', 'DELL', 1735000, 1327, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 360, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL 에일리언웨어 32인치 4K OLED 240Hz', 'DELL', 2093000, 1991, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL 에일리언웨어 34인치 WQHD OLED 165Hz', 'DELL', 1589000, 817, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'OLED', 165, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS TUF Gaming 24인치 FHD IPS 180Hz', 'ASUS', 374000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS TUF Gaming 27인치 QHD IPS 180Hz', 'ASUS', 452000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS TUF Gaming 27인치 QHD IPS 260Hz', 'ASUS', 501000, 958, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 260, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS ROG Strix 27인치 QHD IPS 280Hz', 'ASUS', 638000, 1032, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 280, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS ROG Strix 27인치 QHD OLED 240Hz', 'ASUS', 1397000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS ROG Strix 32인치 4K OLED 240Hz', 'ASUS', 1976000, 1991, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS ProArt 27인치 QHD IPS 75Hz', 'ASUS', 436000, 276, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 75, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS ProArt 27인치 4K IPS 60Hz', 'ASUS', 733000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS ProArt 32인치 4K IPS 60Hz', 'ASUS', 748000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ MOBIUZ 27인치 QHD IPS 165Hz', 'BenQ', 471000, 608, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ MOBIUZ 32인치 4K IPS 144Hz', 'BenQ', 746000, 1194, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 144, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ ZOWIE 24.5인치 FHD TN 240Hz', 'BenQ', 835000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.5, 'FHD (1920x1080)', 'TN', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ ZOWIE 24.5인치 FHD TN 360Hz', 'BenQ', 1057000, 746, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.5, 'FHD (1920x1080)', 'TN', 360, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ GW 24인치 FHD IPS 100Hz', 'BenQ', 247000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ GW 27인치 FHD IPS 100Hz', 'BenQ', 261000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'GIGABYTE AORUS 27인치 QHD OLED 360Hz', 'GIGABYTE', 1603000, 1327, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 360, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'GIGABYTE AORUS 32인치 4K OLED 240Hz', 'GIGABYTE', 1943000, 1991, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'GIGABYTE 27인치 QHD IPS 180Hz', 'GIGABYTE', 429000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'GIGABYTE 34인치 WQHD VA 180Hz', 'GIGABYTE', 497000, 892, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'VA', 180, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '주연테크 게이밍 24인치 FHD IPS 180Hz', '주연테크', 296000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '주연테크 게이밍 27인치 FHD IPS 180Hz', '주연테크', 299000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '주연테크 게이밍 27인치 QHD IPS 180Hz', '주연테크', 347000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '주연테크 게이밍 32인치 QHD VA 165Hz', '주연테크', 346000, 608, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, 'QHD (2560x1440)', 'VA', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '주연테크 사무용 24인치 FHD IPS 100Hz', '주연테크', 205000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '주연테크 사무용 27인치 FHD IPS 100Hz', '주연테크', 217000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '한성컴퓨터 TFG 24인치 FHD IPS 180Hz', '한성컴퓨터', 280000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '한성컴퓨터 TFG 27인치 QHD IPS 180Hz', '한성컴퓨터', 364000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '한성컴퓨터 TFG 27인치 QHD IPS 240Hz', '한성컴퓨터', 408000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '한성컴퓨터 TFG 32인치 4K IPS 160Hz', '한성컴퓨터', 503000, 1327, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 160, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '한성컴퓨터 ULTRON 27인치 FHD IPS 100Hz', '한성컴퓨터', 205000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '한성컴퓨터 ULTRON 27인치 QHD IPS 100Hz', '한성컴퓨터', 257000, 369, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '한성컴퓨터 ULTRON 32인치 QHD VA 100Hz', '한성컴퓨터', 273000, 369, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, 'QHD (2560x1440)', 'VA', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '크로스오버 게이밍 24.5인치 FHD IPS 180Hz', '크로스오버', 275000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.5, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '크로스오버 게이밍 27인치 QHD IPS 180Hz', '크로스오버', 324000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '크로스오버 게이밍 32인치 4K IPS 144Hz', '크로스오버', 498000, 1194, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 144, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '알파스캔 AOC 게이밍 24인치 FHD IPS 180Hz', '알파스캔', 292000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '알파스캔 AOC 게이밍 27인치 FHD VA 240Hz', '알파스캔', 345000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'VA', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '알파스캔 AOC 게이밍 27인치 QHD IPS 180Hz', '알파스캔', 352000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '알파스캔 AOC 게이밍 34인치 WQHD VA 180Hz', '알파스캔', 433000, 892, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'VA', 180, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '알파스캔 AOC 사무용 24인치 FHD IPS 100Hz', '알파스캔', 196000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '알파스캔 AOC 사무용 27인치 QHD IPS 75Hz', '알파스캔', 248000, 276, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 75, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '비트엠 Newsync 24인치 FHD IPS 180Hz', '비트엠', 260000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '비트엠 Newsync 27인치 QHD IPS 180Hz', '비트엠', 307000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '비트엠 Newsync 32인치 QHD VA 165Hz', '비트엠', 312000, 608, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, 'QHD (2560x1440)', 'VA', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G4 25인치 FHD IPS 240Hz', '삼성전자', 425000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 25.0, 'FHD (1920x1080)', 'IPS', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 G4 27인치 FHD IPS 240Hz', '삼성전자', 437000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 오디세이 아크 55인치 4K VA 165Hz', '삼성전자', 986000, 1369, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 55.0, '4K UHD (3840x2160)', 'VA', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 뷰피니티 S8 27인치 4K IPS 60Hz', '삼성전자', 590000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '삼성전자 뷰피니티 S8 32인치 4K IPS 60Hz', '삼성전자', 600000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 24.5인치 FHD IPS 240Hz', 'LG전자', 422000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.5, 'FHD (1920x1080)', 'IPS', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 울트라기어 27인치 4K IPS 160Hz', 'LG전자', 660000, 1327, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 160, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 스마트모니터 27인치 4K IPS 60Hz', 'LG전자', 536000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'LG전자 스마트모니터 32인치 4K IPS 60Hz', 'LG전자', 548000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI G 24인치 FHD IPS 180Hz', 'MSI', 310000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI G 27인치 FHD IPS 180Hz', 'MSI', 323000, 373, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI G 27인치 QHD IPS 180Hz', 'MSI', 417000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI G 32인치 QHD VA 170Hz', 'MSI', 396000, 627, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, 'QHD (2560x1440)', 'VA', 170, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MAG OLED 27인치 QHD OLED 240Hz', 'MSI', 1232000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'MSI MAG OLED 34인치 WQHD OLED 175Hz', 'MSI', 1260000, 867, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'OLED', 175, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL P 24인치 FHD IPS 100Hz', 'DELL', 307000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL P 27인치 FHD IPS 100Hz', 'DELL', 309000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL P 27인치 QHD IPS 100Hz', 'DELL', 380000, 369, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL G 27인치 QHD IPS 180Hz', 'DELL', 456000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'DELL G 25인치 FHD IPS 280Hz', 'DELL', 446000, 581, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 25.0, 'FHD (1920x1080)', 'IPS', 280, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS VA 24인치 FHD IPS 100Hz', 'ASUS', 254000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS VA 27인치 FHD IPS 100Hz', 'ASUS', 241000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS VA 27인치 QHD IPS 100Hz', 'ASUS', 319000, 369, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS ROG Swift OLED 27인치 QHD OLED 480Hz', 'ASUS', 2204000, 1769, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 480, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS ROG Swift OLED 32인치 4K OLED 240Hz', 'ASUS', 2157000, 1991, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'ASUS ROG Swift OLED 34인치 WQHD OLED 240Hz', 'ASUS', 1819000, 1189, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'OLED', 240, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ PD 27인치 QHD IPS 60Hz', 'BenQ', 455000, 221, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ PD 27인치 4K IPS 60Hz', 'BenQ', 714000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ PD 32인치 4K IPS 60Hz', 'BenQ', 724000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, 'BenQ MOBIUZ 27인치 QHD OLED 240Hz', 'BenQ', 1337000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '필립스 Evnia 27인치 QHD IPS 180Hz', '필립스', 452000, 664, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '필립스 Evnia 27인치 QHD OLED 240Hz', '필립스', 1126000, 885, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '필립스 Evnia 34인치 WQHD OLED 175Hz', '필립스', 1244000, 867, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'OLED', 175, '21:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '필립스 사무용 24인치 FHD IPS 100Hz', '필립스', 213000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 24.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '필립스 사무용 27인치 FHD IPS 100Hz', '필립스', 212000, 207, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'FHD (1920x1080)', 'IPS', 100, '16:9');

INSERT INTO modules (category_id, name, brand, price, performance_score, image_url) VALUES (@monitor, '주연테크 사무용 27인치 4K IPS 60Hz', '주연테크', 371000, 498, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

