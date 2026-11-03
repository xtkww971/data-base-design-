// 부품 상세 응답(types/productDetail.ts)의 specs 를 화면에 보여줄 [라벨, 값] 목록으로 바꾼다.
// 검색 페이지 상세 패널과 추천 페이지 카드가 같이 쓴다.
export const getSpecEntries = (product) => {
  const { specs } = product;

  switch (product.category) {
    case 'CPU':
      return [
        ['소켓', specs.socket],
        ['코어', `${specs.cores}개`],
        ['스레드', `${specs.threads}개`],
        ['내장 그래픽', specs.hasGraphics ? '지원' : '미지원'],
        ['클럭', specs.clockSpeed],
      ];
    case 'MAINBOARD':
      return [
        ['소켓', specs.socket],
        ['폼팩터', specs.formFactor],
        ['메모리 규격', specs.memorySpec],
        ['메모리 슬롯', `${specs.memorySlots}개`],
        ['칩셋', specs.chipset],
      ];
    case 'RAM':
      return [
        ['메모리 규격', specs.memorySpec],
        ['용량', `${specs.capacity}GB`],
        // 값은 전송 속도(MT/s)다. V4 주석의 MHz 는 잘못된 표기 (docs/스키마 설계/04-부품별-제약조건.md 1장)
        ['클럭', `${specs.clock}MT/s`],
        ['패키지 수', `${specs.packageCount}개`],
      ];
    case 'GPU':
      return [
        ['칩셋', specs.chipset],
        ['메모리', `${specs.memoryType} ${specs.memoryCapacity}GB`],
        ['길이', `${specs.length}mm`],
        ['권장 파워', `${specs.recommendedPower}W`],
        ['포트', specs.ports],
      ];
    case 'POWER':
      return [
        ['정격 출력', `${specs.ratedPower}W`],
        ['80PLUS', specs.certification],
        ['폼팩터', specs.formFactor],
      ];
    case 'SSD':
      return [
        ['규격', specs.formFactor],
        ['용량', `${specs.capacity}GB`],
        ['읽기 속도', `${specs.readSpeed}MB/s`],
        ['쓰기 속도', `${specs.writeSpeed}MB/s`],
      ];
    case 'HDD':
      return [
        ['인터페이스', specs.interface],
        ['용량', `${specs.capacity}TB`],
        ['RPM', `${specs.rpm}RPM`],
        ['버퍼', `${specs.bufferMemory}MB`],
      ];
    case 'MONITOR':
      return [
        ['화면 크기', `${specs.screenSize}인치`],
        ['해상도', specs.resolution],
        ['패널', specs.panelType],
        ['주사율', `${specs.refreshRate}Hz`],
        ['비율', specs.aspectRatio],
      ];
    default:
      return [];
  }
};
