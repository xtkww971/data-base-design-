BUDGET_RATIOS = {
    "게임": {"GPU": 40, "CPU": 20, "MAINBOARD": 10, "RAM": 10, "SSD": 10, "POWER": 10},
    "영상 편집": {"GPU": 30, "CPU": 25, "MAINBOARD": 10, "RAM": 15, "SSD": 10, "POWER": 10},
    "3D·CAD": {"GPU": 35, "CPU": 25, "MAINBOARD": 10, "RAM": 15, "SSD": 5, "POWER": 10},
    "개발": {"GPU": 10, "CPU": 30, "MAINBOARD": 10, "RAM": 25, "SSD": 15, "POWER": 10},
    "사무": {"CPU": 35, "MAINBOARD": 20, "RAM": 20, "SSD": 15, "POWER": 10},
}

# DB modules 테이블의 카테고리별 최저가
CATEGORY_MIN_PRICES = {
    "CPU": 69000,
    "GPU": 277000,
    "MAINBOARD": 79000,
    "RAM": 28000,
    "SSD": 35000,
    "POWER": 62000
}

def format_part_budgets(usage: str, budget_max: int) -> str:
    """용도별 비율로 부품별 가격 상한 프롬프트용 문자열로 반환"""
    return "\n".join(
        f"- {part}: {max(budget_max * ratio // 100, CATEGORY_MIN_PRICES.get(part, 0))}원"
        for part, ratio in BUDGET_RATIOS[usage].items()
    )
