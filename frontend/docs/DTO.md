부품 보기 DTO
```
공통

export interface BaseProductDetail {
id: number;
category: "CPU" | "MAINBOARD" | "RAM" | "GPU" | "POWER" | "SSD" | "HDD" | "MONITOR";
name: string;         // 제품명 (예: AMD 라이젠5 5세대 7500F)
brand: string;        // 제조사 (예: AMD)
price: number;        // 현재 기준 최저가 가격
imageUrl: string;     // 제품 큰 이미지 URL
}

CPU

export interface CpuDetailResponse extends BaseProductDetail {
specs: {
socket: string;       // 소켓 규격
cores: number;        // 코어 수 (예: 6)
threads: number;      // 스레드 수 (예: 12)
hasGraphics: boolean; // 내장 그래픽 유무 (true/false)
clockSpeed: string;   // 동작 클럭 (예: "3.7GHz")
};
}

메인보드

export interface MainboardDetailResponse extends BaseProductDetail {
specs: {
socket: string;       // 지원 소켓 (예: "AM5")
formFactor: string;   // 보드 크기 (예: "M-ATX") 
memorySpec: string;   // 메모리 규격 (예: "DDR5") 
memorySlots: number;  // 메모리 슬롯 개수 (예: 4)
chipset: string;      // 칩셋명 (예: "B650")
};
}

RAM

export interface RamDetailResponse extends BaseProductDetail {
specs: {
memorySpec: string;   // 메모리 규격 (예: "DDR5")
capacity: number;     // 용량 (예: 16)
clock: number;        // 동작 클럭 (예: 5600) 
packageCount: number; // 패키지 개수 (예: 1) 
};
}

POWER

export interface PowerDetailResponse extends BaseProductDetail {
specs: {
ratedPower: number;   // 정격 출력 (예: 700W)
certification: string;// 80PLUS 인증 등급 (예: "Gold")
formFactor: string;   // 파워 규격 (예: "ATX")
};
}

글카

export interface GpuDetailResponse extends BaseProductDetail {
specs: {
chipset: string;          // 칩셋 그룹 (예: "RTX 4060 Ti", "RX 7600")
memoryType: string;       // 메모리 종류 (예: "GDDR6")
memoryCapacity: number;   // 메모리 용량 (예: 8)
length: number;           // 가로 길이 (예: 250) -> 단위: mm (케이스 장착 공간 체크용)
recommendedPower: number; // 권장 파워 용량 (예: 600) -> 단위: W
ports: string;            // 출력 단자 (예: "HDMI x1, DP x3")
};
}

SSD

export interface SsdDetailResponse extends BaseProductDetail {
specs: {
formFactor: string;       // 규격 (예: "M.2 혹은 “SATA”)
capacity: number;         // 용량 (예: 1024 또는 1000) -> 단위: GB
readSpeed: number;        // 순차 읽기 속도 (예: 7000) -> 단위: MB/s
writeSpeed: number;       // 순차 쓰기 속도 (예: 6000) -> 단위: MB/s
};
}

HDD

export interface HddDetailResponse extends BaseProductDetail {
specs: {
interface: string;        // 인터페이스 (예: "SATA3")
capacity: number;         // 용량 (예: 2 또는 4) -> 단위: TB
rpm: number;              // 회전수 (예: 5400, 7200) -> 단위: RPM
bufferMemory: number;     // 버퍼 용량 (예: 256) -> 단위: MB
};
}

모니터

export interface MonitorDetailResponse extends BaseProductDetail {
specs: {
screenSize: number;       // 화면 크기 (예: 27, 32) -> 단위: 인치
resolution: string;       // 해상도 (예: "2560 x 1440 (QHD)", "1920 x 1080 (FHD)")
panelType: string;        // 패널 종류 (예: "IPS", "VA", "OLED")
refreshRate: number;      // 주사율 (예: 144, 240) -> 단위: Hz
aspectRatio: string;      // 화면 비율 (예: "16:9", "21:9")
};
}
```

로그인 DTO
```
public class LoginRequestDto {

    @NotBlank(message = "아이디(또는 이메일)는 필수 입력 항목입니다.")
    private String username; // 또는 email

    @NotBlank(message = "비밀번호는 필수 입력 항목입니다.")
    private String password;
}
```

쿼리 DTO
```
public class ProductSearchQueryDto {

    // 카테고리 필터 (예: "ALL", "CPU", "RAM", "GPU" 등)
    private String category;

    // 검색어 키워드 (제품명, 브랜드 등 통합 검색용)
    private String searchTerm;
    
    // 대량 데이터 조회를 위한 페이징 정보 
    private Integer page = 0; //현재 페이지 수
    private Integer size = 20; // 한 페이지 안의 카드 개수
}
```
AI 프롬프트 이용시 Request DTO
```
public class AiRecommendationRequest {

@NotBlank(message = "견적 요청 내용을 입력해주세요.")  // 견적을 입력하지 않고 그냥 버튼 클릭시.
@Size(max = 1000, message = "요청 내용은 1000자 이하로 입력해주세요.") // 사용자가 겁나 길게 프롬프트 입력시
private String prompt; // 예: "300만원 안팎의 예산으로 컴퓨터 견적 맞춰줘."

}
```
프롬프트만  있으면 될듯 날짜나 내용도 보내야 하나? - > 토큰 여부를 백엔드에서 물어봐야한대

로그인 토큰(JWT, Session)을 사용할 때 추가 DTO 필요 없음
토큰 없이 유저 고유 고유 ID를 직접 넘길 때 확장형 DTO 필요
