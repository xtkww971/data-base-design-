import {
  Ban,
  CircleQuestionMark,
  CloudOff,
  Database,
  PencilLine,
  TriangleAlert,
} from 'lucide-react';
import './Nl2sqlErrorCard.css';

// 백엔드 ErrorCode 별 톤과 머리말. 422 가 여러 종이라 HTTP 상태가 아니라 code 로 고른다.
// info 는 Jev 판정 거절(ADR 0004)이다. 에러가 아니라 안내이므로 code 태그를 숨긴다.
const CODE_STYLES = {
  NL2SQL_OUT_OF_SCOPE: { tone: 'info', label: '안내', Icon: Ban },
  NL2SQL_MISSING_DATA: { tone: 'info', label: '안내', Icon: Database },
  NL2SQL_AMBIGUOUS: { tone: 'info', label: '안내', Icon: CircleQuestionMark },
  // 견적 조합 요청(recommendation)은 거절하지 않으므로 코드가 오지 않는다. ADR 0004 참고.
  NL2SQL_GENERATION_FAILED: { tone: 'caution', label: '다시 표현해 주세요', Icon: PencilLine },
  INVALID_INPUT: { tone: 'caution', label: '입력 확인', Icon: PencilLine },
  INVALID_TYPE: { tone: 'caution', label: '입력 확인', Icon: PencilLine },
  NL2SQL_EXECUTION_FAILED: { tone: 'error', label: '조회 실패', Icon: TriangleAlert },
  NL2SQL_UNAVAILABLE: { tone: 'error', label: '서버 연결 실패', Icon: CloudOff },
  INTERNAL_SERVER_ERROR: { tone: 'error', label: '서버 오류', Icon: CloudOff },
};

const UNKNOWN_CODE_STYLE = { tone: 'error', label: '오류', Icon: TriangleAlert };

/**
 * errorCode 는 historyStore 가 붙인 "CODE · status" 형태다.
 * 서버에 닿지 못했으면 null, 응답 본문에 code 가 없으면 상태만("502") 들어온다.
 */
function resolveCard(errorCode) {
  if (!errorCode) {
    return { tone: 'error', label: '연결 실패', Icon: CloudOff, tag: 'code 없음' };
  }

  if (/^\d+$/.test(errorCode)) {
    return { tone: 'error', label: '응답 오류', Icon: CloudOff, tag: `code 없음 · ${errorCode}` };
  }

  const [code] = errorCode.split(' · ');
  return { ...(CODE_STYLES[code] ?? UNKNOWN_CODE_STYLE), tag: errorCode };
}

/**
 * 추천 페이지 AI 분석 결과 안에서 NL2SQL 질의 실패를 보여 주는 카드. message 는 받은 문구 그대로 쓴다.
 * 판정 거절 문구는 서버가 판정별로 고정해 보내므로 프런트에 따로 두지 않는다.
 */
export default function Nl2sqlErrorCard({ message, errorCode }) {
  const { tone, label, Icon, tag } = resolveCard(errorCode);

  return (
    <div className={`nl2sql-error-card nl2sql-error-card--${tone}`} role="alert">
      <span className="nl2sql-error-card__icon" aria-hidden="true">
        <Icon size={18} strokeWidth={2} />
      </span>

      <div className="nl2sql-error-card__body">
        <div className="nl2sql-error-card__meta">
          <span className="nl2sql-error-card__label">{label}</span>
          {tone === 'info' ? null : <code className="nl2sql-error-card__code">{tag}</code>}
        </div>
        <p className="nl2sql-error-card__message">{message}</p>
      </div>
    </div>
  );
}
