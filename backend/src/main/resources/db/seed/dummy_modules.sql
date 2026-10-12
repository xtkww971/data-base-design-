-- 개발용 더미 부품 데이터. 카테고리별 6개씩 총 48개.
-- Flyway 는 db/migration 만 읽으므로 이 파일은 자동 적용되지 않는다. 필요할 때 직접 실행한다.
-- 제품명은 실제 제품이지만 가격과 일부 스펙은 대략적인 값이다.
-- 다시 실행하면 같은 제품이 중복으로 들어간다.

SET @cpu = (SELECT category_id FROM categories WHERE category_name = 'CPU');
SET @mainboard = (SELECT category_id FROM categories WHERE category_name = 'MAINBOARD');
SET @ram = (SELECT category_id FROM categories WHERE category_name = 'RAM');
SET @gpu = (SELECT category_id FROM categories WHERE category_name = 'GPU');
SET @power = (SELECT category_id FROM categories WHERE category_name = 'POWER');
SET @ssd = (SELECT category_id FROM categories WHERE category_name = 'SSD');
SET @hdd = (SELECT category_id FROM categories WHERE category_name = 'HDD');
SET @monitor = (SELECT category_id FROM categories WHERE category_name = 'MONITOR');

-- CPU
INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@cpu, '인텔 코어 i5-14400F', '인텔', 189000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed) VALUES (LAST_INSERT_ID(), 'LGA1700', 10, 16, 0, '2.5GHz');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@cpu, '인텔 코어 i5-14600K', '인텔', 329000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed) VALUES (LAST_INSERT_ID(), 'LGA1700', 14, 20, 1, '3.5GHz');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@cpu, '인텔 코어 i7-14700K', '인텔', 539000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed) VALUES (LAST_INSERT_ID(), 'LGA1700', 20, 28, 1, '3.4GHz');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@cpu, 'AMD 라이젠5 5600', 'AMD', 135000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed) VALUES (LAST_INSERT_ID(), 'AM4', 6, 12, 0, '3.5GHz');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@cpu, 'AMD 라이젠5 7500F', 'AMD', 215000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed) VALUES (LAST_INSERT_ID(), 'AM5', 6, 12, 0, '3.7GHz');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@cpu, 'AMD 라이젠7 7800X3D', 'AMD', 479000, NULL);
INSERT INTO cpus (module_id, socket, cores, threads, has_graphics, clock_speed) VALUES (LAST_INSERT_ID(), 'AM5', 8, 16, 1, '4.2GHz');

-- MAINBOARD
INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@mainboard, 'MSI MAG B760M 박격포 II', 'MSI', 219000, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'M-ATX', 'DDR5', 4, 'B760');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@mainboard, 'GIGABYTE Z790 AORUS ELITE AX', 'GIGABYTE', 389000, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, chipset) VALUES (LAST_INSERT_ID(), 'LGA1700', 'ATX', 'DDR5', 4, 'Z790');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@mainboard, 'ASRock B650M Pro RS', 'ASRock', 179000, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'M-ATX', 'DDR5', 4, 'B650');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@mainboard, 'MSI MAG B650 토마호크 WIFI', 'MSI', 289000, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'ATX', 'DDR5', 4, 'B650');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@mainboard, 'GIGABYTE A620I AX', 'GIGABYTE', 195000, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, chipset) VALUES (LAST_INSERT_ID(), 'AM5', 'Mini-ITX', 'DDR5', 2, 'A620');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@mainboard, 'ASUS TUF Gaming B550M-PLUS', 'ASUS', 139000, NULL);
INSERT INTO main_boards (module_id, socket, form_factor, memory_spec, memory_slots, chipset) VALUES (LAST_INSERT_ID(), 'AM4', 'M-ATX', 'DDR4', 4, 'B550');

-- RAM (capacity 는 패키지 전체 용량)
INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ram, '삼성전자 DDR4-3200 16GB', '삼성전자', 45000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 16, 3200, 1);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ram, '삼성전자 DDR5-5600 16GB', '삼성전자', 62000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 16, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ram, 'SK하이닉스 DDR5-5600 32GB', 'SK하이닉스', 125000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 5600, 1);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ram, 'Corsair Vengeance LPX DDR4-3200 CL16 32GB(16Gx2)', 'Corsair', 95000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR4', 32, 3200, 2);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ram, 'TeamGroup T-Force Delta RGB DDR5-6000 CL30 32GB(16Gx2)', 'TeamGroup', 159000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 32, 6000, 2);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ram, 'G.SKILL Trident Z5 Neo DDR5-6000 CL30 64GB(32Gx2)', 'G.SKILL', 319000, NULL);
INSERT INTO rams (module_id, memory_spec, capacity, clock, package_count) VALUES (LAST_INSERT_ID(), 'DDR5', 64, 6000, 2);

-- GPU
INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@gpu, 'MSI 지포스 RTX 4060 벤투스 2X 블랙 OC 8GB', 'MSI', 419000, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060', 'GDDR6', 8, 199, 550, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@gpu, 'GIGABYTE 지포스 RTX 4060 Ti EAGLE OC 8GB', 'GIGABYTE', 569000, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4060 Ti', 'GDDR6', 8, 272, 550, 'HDMI 2.1 x2, DP 1.4a x2');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@gpu, 'ASUS TUF Gaming 지포스 RTX 4070 SUPER OC 12GB', 'ASUS', 949000, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4070 SUPER', 'GDDR6X', 12, 301, 650, 'HDMI 2.1 x2, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@gpu, 'ZOTAC GAMING 지포스 RTX 4080 SUPER Trinity 16GB', 'ZOTAC', 1590000, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, ports) VALUES (LAST_INSERT_ID(), 'GeForce RTX 4080 SUPER', 'GDDR6X', 16, 307, 750, 'HDMI 2.1 x1, DP 1.4a x3');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@gpu, 'XFX 라데온 RX 7600 SPEEDSTER SWFT 210 8GB', 'XFX', 369000, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7600', 'GDDR6', 8, 241, 550, 'HDMI 2.1 x1, DP 2.1 x3');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@gpu, 'SAPPHIRE 라데온 RX 7800 XT PULSE 16GB', 'SAPPHIRE', 729000, NULL);
INSERT INTO graphic_cards (module_id, chipset, memory_type, memory_capacity, length_mm, recommended_power, ports) VALUES (LAST_INSERT_ID(), 'Radeon RX 7800 XT', 'GDDR6', 16, 280, 700, 'HDMI 2.1 x2, DP 2.1 x2');

-- POWER
INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@power, '마이크로닉스 Classic II 풀체인지 600W 80PLUS BRONZE', '마이크로닉스', 65000, NULL);
INSERT INTO power (module_id, rated_power, certification, form_factor) VALUES (LAST_INSERT_ID(), 600, '80PLUS BRONZE', 'ATX');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@power, 'FSP HYPER K PRO 700W 80PLUS STANDARD', 'FSP', 62000, NULL);
INSERT INTO power (module_id, rated_power, certification, form_factor) VALUES (LAST_INSERT_ID(), 700, '80PLUS STANDARD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@power, '시소닉 FOCUS GX-750 GOLD', '시소닉', 159000, NULL);
INSERT INTO power (module_id, rated_power, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@power, '슈퍼플라워 SF-850F14XG LEADEX VII GOLD', '슈퍼플라워', 185000, NULL);
INSERT INTO power (module_id, rated_power, certification, form_factor) VALUES (LAST_INSERT_ID(), 850, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@power, 'Corsair RM1000x', 'Corsair', 259000, NULL);
INSERT INTO power (module_id, rated_power, certification, form_factor) VALUES (LAST_INSERT_ID(), 1000, '80PLUS GOLD', 'ATX');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@power, 'Corsair SF750', 'Corsair', 229000, NULL);
INSERT INTO power (module_id, rated_power, certification, form_factor) VALUES (LAST_INSERT_ID(), 750, '80PLUS PLATINUM', 'SFX');

-- SSD (capacity 단위: GB)
INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ssd, '삼성전자 870 EVO 500GB', '삼성전자', 79000, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), '2.5인치', 500, 560, 530);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ssd, 'Crucial P3 Plus M.2 NVMe 500GB', '마이크론', 59000, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 500, 4700, 1900);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ssd, 'SK하이닉스 Platinum P41 M.2 NVMe 1TB', 'SK하이닉스', 135000, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7000, 6500);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ssd, '삼성전자 990 PRO M.2 NVMe 1TB', '삼성전자', 165000, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 1000, 7450, 6900);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ssd, '삼성전자 990 PRO M.2 NVMe 2TB', '삼성전자', 289000, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7450, 6900);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@ssd, 'WD Black SN850X M.2 NVMe 2TB', 'Western Digital', 239000, NULL);
INSERT INTO ssds (module_id, form_factor, capacity, read_speed, write_speed) VALUES (LAST_INSERT_ID(), 'M.2 2280', 2000, 7300, 6600);

-- HDD (capacity 단위: TB)
INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@hdd, 'WD Blue 7200/64M 1TB', 'Western Digital', 69000, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 1, 7200, 64);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@hdd, 'Seagate BarraCuda 7200/256M 2TB', 'Seagate', 85000, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@hdd, 'Toshiba P300 7200/256M 2TB', 'Toshiba', 82000, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 2, 7200, 256);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@hdd, 'Seagate BarraCuda 5400/256M 4TB', 'Seagate', 119000, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 4, 5400, 256);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@hdd, 'WD Red Plus 5640/256M 8TB', 'Western Digital', 279000, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 8, 5640, 256);

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@hdd, 'Seagate IronWolf 7200/256M 12TB', 'Seagate', 389000, NULL);
INSERT INTO hdds (module_id, interface_type, capacity, rpm, buffer_memory) VALUES (LAST_INSERT_ID(), 'SATA3', 12, 7200, 256);

-- MONITOR
INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@monitor, 'MSI G2412F', 'MSI', 139000, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 23.8, 'FHD (1920x1080)', 'IPS', 180, '16:9');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@monitor, 'LG전자 울트라기어 27GR75Q', 'LG전자', 369000, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, 'QHD (2560x1440)', 'IPS', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@monitor, 'DELL S2722QC', 'DELL', 459000, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 27.0, '4K UHD (3840x2160)', 'IPS', 60, '16:9');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@monitor, '삼성전자 오디세이 G5 S32CG510', '삼성전자', 349000, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, 'QHD (2560x1440)', 'VA', 165, '16:9');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@monitor, '삼성전자 오디세이 OLED G8 G80SD', '삼성전자', 1390000, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 32.0, '4K UHD (3840x2160)', 'OLED', 240, '16:9');

INSERT INTO modules (category_id, name, brand, price, image_url) VALUES (@monitor, 'LG전자 울트라와이드 34WQ75C', 'LG전자', 549000, NULL);
INSERT INTO monitors (module_id, screen_size, resolution, panel_type, refresh_rate, aspect_ratio) VALUES (LAST_INSERT_ID(), 34.0, 'WQHD (3440x1440)', 'IPS', 60, '21:9');
