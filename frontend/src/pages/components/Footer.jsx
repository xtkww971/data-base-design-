import './Footer.css';

export default function Footer() {
  return (
    <footer className="footer">
      <div className="footer__inner">
        <div className="footer__brand-wrap">
          <div className="footer__brand">DB-design-team</div>
          <div className="footer__copyright">© 2026 DB-design-team. All rights reserved.</div>
        </div>

        <div className="footer__meta">
          <div className="footer__meta-item">
            <span className="footer__label">이용약관</span>
          </div>
          <div className="footer__meta-item">
            <span className="footer__label">개인정보처리방침</span>
          </div>
          <div className="footer__meta-item">
            <span className="footer__label">제휴·문의</span>
          </div>
        </div>
      </div>
    </footer>
  );
}
