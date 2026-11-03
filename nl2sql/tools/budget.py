BUDGET_RATIOS = {
    "게임": {"GPU": 40, "CPU": 20, "MAINBOARD": 10, "RAM": 10, "SSD": 10, "POWER": 10},
    "영상 편집": {"GPU": 30, "CPU": 25, "MAINBOARD": 10, "RAM": 15, "SSD": 10, "POWER": 10},
    "3D·CAD": {"GPU": 35, "CPU": 25, "MAINBOARD": 10, "RAM": 15, "SSD": 5, "POWER": 10},
    "개발": {"GPU": 10, "CPU": 30, "MAINBOARD": 10, "RAM": 25, "SSD": 15, "POWER": 10},
    "사무": {"CPU": 35, "MAINBOARD": 20, "RAM": 20, "SSD": 15, "POWER": 10},
}

def format_part_budgets(usage: str, budget_max: int) -> str:
    """용도별 비율로 부품별 가격 상한을 계산해 프롬프트용 문자열로 반환"""
    return "\n".join(
        f"- {part}: {budget_max * ratio // 100}원"
        for part, ratio in BUDGET_RATIOS[usage].items()
    )
