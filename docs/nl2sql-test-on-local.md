# NL2SQL 로컬 테스트 (26.09.29)

## 개요

26.09.29에 진행한 1차 테스트이다. 질의는 단순조회, 스펙기반 질문, 모호성 질문, 복잡성 질문의 유형으로 나누어 10개의 자연어 질의에 대해 테스트를 진행하였다.


## 1. 테스트 요약

| # | 유형 | 자연어 질의 | 결과 |
| :-: | --- | --- | :-: |
| 1 | 단순 조회 | 삼성전자 SSD 목록 보여줘 | ✅ |
| 2 | 단순 조회 | 가장 비싼 CPU 5개 알려줘 | ⚠️ |
| 3 | 스펙 기반 | 16GB 이상 그래픽카드 중 40만 원대 제품 보여줘 | ✅ |
| 4 | 스펙 기반 | SSD 중 읽기 속도 7000MB/s 이상 제품 보여줘 | ✅ |
| 5 | 모호성 | 배틀그라운드 할건데 게임 잘 돌아가는 견적 추천해줘 | ⚠️ |
| 6 | 모호성 | 가성비 좋은 메모리 뭐 있어? | ⚠️ |
| 7 | 모호성 | 나 200만원 있는데 새롭게 컴퓨터 맞추고 싶어, 바로 살 수 있게 견적 하나 짜줘 | ⚠️ |
| 8 | 모호성 | 비트코인 채굴 할건데 그래픽 카드 추천해줘 최대한 가성비 좋은 걸로 | ⚠️ |
| 9 | 복잡성 | cpu는 코어 8개 이상 그래픽카드는 16기가 이상이고 램은 알아서 가성비 좋은 걸로 추천해줘 그리고 메인보드는 가장 싼걸로 쓰고 싶어 | ⚠️ |
| 10 | 복잡성 | 코어 8개 이상인 cpu랑 그에 호환되는 메인보드 보여줘 | ⚠️ |

> ✅ 의도대로 동작 · ⚠️ 동작은 하나 개선 필요

---

## 2. 유형별 테스트 결과

### 2.1 단순 조회

#### ① "삼성전자 SSD 목록 보여줘"

```sql
SELECT m.name, s.capacity, s.read_speed, s.write_speed, m.price
FROM modules m
JOIN ssds s ON s.module_id = m.module_id
WHERE m.brand = '삼성전자';
```

#### ② "가장 비싼 CPU 5개 알려줘"

```sql
SELECT m.name, m.brand, m.price
FROM modules m
JOIN cpus c ON c.module_id = m.module_id
ORDER BY m.price DESC;
```

- 5개를 요청했지만 `LIMIT`을 걸지 않음

---

### 2.2 스펙 기반 조회

#### ③ "16GB 이상 그래픽카드 중 40만 원대 제품 보여줘"

```sql
SELECT m.name, g.chipset, g.memory_type, g.memory_capacity, m.price
FROM modules m
JOIN graphic_cards g ON g.module_id = m.module_id
WHERE g.memory_capacity >= 16
  AND m.price >= 400000
  AND m.price < 500000
ORDER BY m.price ASC;
```

#### ④ "SSD 중 읽기 속도 7000MB/s 이상 제품 보여줘"

```sql
SELECT m.name, s.capacity, s.read_speed, m.price
FROM modules m
JOIN ssds s ON s.module_id = m.module_id
WHERE s.read_speed >= 7000;
```

---

### 2.3 모호성 질문

> 의미 해석이 필요한 질문 (형용사, 주관적 판단이 필요한 단어 사용)

#### ⑤ "배틀그라운드 할건데 게임 잘 돌아가는 견적 추천해줘"

```sql
SELECT 'CPU' AS component_type, m.module_id, m.name, m.brand, m.price,
       c.cores, c.threads, c.clock_speed
FROM modules m
JOIN cpus c ON m.module_id = c.module_id
WHERE c.cores >= 6 AND c.clock_speed >= '3.0GHz'

UNION ALL

SELECT 'GPU' AS component_type, m.module_id, m.name, m.brand, m.price,
       g.memory_capacity, g.recommended_power, g.chipset
FROM modules m
JOIN graphic_cards g ON m.module_id = g.module_id
WHERE g.memory_capacity >= 8

ORDER BY component_type, price ASC;
```

- CPU와 GPU만 추천함
- 추천 부품을 한 테이블에 섞어서 출력함

#### ⑥ "가성비 좋은 메모리 뭐 있어?"

```sql
SELECT m.name, m.price, r.capacity, r.clock,
       (m.price * 1.0 / r.capacity) AS price_per_gb
FROM modules m
JOIN rams r ON r.module_id = m.module_id
ORDER BY price_per_gb ASC;
```

- 용량당 가격(`price_per_gb`) 컬럼을 만들어 가성비를 판단
- 전체 데이터를 가격이 낮은 순으로 모두 출력
- 모든 데이터를 보여주면 사용자 질문의 의미가 없어질 수 있음

#### ⑦ "나 200만원 있는데 새롭게 컴퓨터 맞추고 싶어, 바로 살 수 있게 견적 하나 짜줘"

```sql
SELECT c.category_name, m.name, m.brand, m.price
FROM modules m
JOIN categories c ON m.category_id = c.category_id
WHERE m.price = (
    SELECT MIN(m2.price)
    FROM modules m2
    WHERE m2.category_id = m.category_id
)
ORDER BY c.category_id;
```

- 카테고리별 최저가 부품을 모아서 출력

#### ⑧ "비트코인 채굴 할건데 그래픽 카드 추천해줘 최대한 가성비 좋은 걸로"

```sql
SELECT m.name, g.chipset, g.memory_type, g.memory_capacity, m.price,
       (m.price * 1.0 / g.memory_capacity) AS price_per_gb
FROM modules m
JOIN graphic_cards g ON g.module_id = m.module_id
WHERE g.memory_capacity >= 8
ORDER BY price_per_gb ASC, m.price ASC;
```

- 용량당 가격으로 가성비 판단
- 실제로 그래픽카드로는 비트코인 채굴을 못하지만, 메모리 8GB 이상 조건으로 답변함

---

### 2.4 복잡성 질문

#### ⑨ "cpu는 코어 8개 이상 그래픽카드는 16기가 이상이고 램은 알아서 가성비 좋은 걸로 추천해줘 그리고 메인보드는 가장 싼걸로 쓰고 싶어"

```sql
SELECT 'CPU' AS component_type, m.name, m.price,
       c.cores AS spec1, c.threads AS spec2, NULL AS spec3
FROM modules m
JOIN cpus c ON c.module_id = m.module_id
WHERE c.cores >= 8
ORDER BY m.price ASC LIMIT 1

UNION ALL

SELECT 'GPU' AS component_type, m.name, m.price,
       NULL, NULL, g.memory_capacity AS spec3
FROM modules m
JOIN graphic_cards g ON g.module_id = m.module_id
WHERE g.memory_capacity >= 16
ORDER BY m.price ASC LIMIT 1

UNION ALL

SELECT 'RAM' AS component_type, m.name, m.price,
       NULL, NULL, r.memory_capacity AS spec3
FROM modules m
JOIN rams r ON r.module_id = m.module_id
ORDER BY (m.price / r.memory_capacity) ASC LIMIT 1

UNION ALL

SELECT 'Mainboard' AS component_type, m.name, m.price,
       NULL, NULL, NULL
FROM modules m
JOIN main_boards mb ON mb.module_id = m.module_id
ORDER BY m.price ASC LIMIT 1;
```

- 여러 요청을 한 번에 질의하면 각각 처리한 뒤 `UNION ALL`로 묶어서 출력함

#### ⑩ "코어 8개 이상인 cpu랑 그에 호환되는 메인보드 보여줘"

```sql
SELECT c.module_id, c.cores,
       mb.module_id AS mainboard_module_id, mb.socket
FROM cpus c
JOIN main_boards mb ON c.socket = mb.socket
WHERE c.cores >= 8;
```

- `modules` 테이블을 조인하지 않음
- 두 카테고리 부품이 한 테이블에 섞여 나옴

---

## 3. 인사이트 및 개선 필요 사항

| 관찰 | 개선 방향 |
| --- | --- |
| 일부 컬럼만 출력함 | 사용자에게는 전체 스펙이 보여야 함 |
| 개수를 지정해도 `LIMIT`이 누락됨 | 필요한 경우 `LIMIT`을 쓰도록 프롬프트에 추가 |
| `modules` 테이블을 조인하지 않는 경우가 있음 | `modules` 조인을 강제하도록 프롬프트에 추가 |
| 두 개 이상 카테고리 부품이 한 테이블에 섞여 출력됨 | 처리 방법 검토 필요 |
| '가성비' 같은 표현을 '용량당 가격'으로 해석함 | 해석 기준이 적절한지 검토 필요 |


