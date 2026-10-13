import { Link, Navigate, useNavigate } from 'react-router-dom';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import './MyPage.css';
import { clearCurrentUser, useCurrentUser } from '../auth/authStore.js';

const formatDate = (value) => {
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? '-' : new Intl.DateTimeFormat('ko-KR', { dateStyle: 'long' }).format(date);
};

// 프로토타입 화면. 로그인할 때 받아 둔 유저 정보만 보여주고, 저장한 견적 목록은 아직 없다.
export default function MyPage() {
  const navigate = useNavigate();
  const currentUser = useCurrentUser();

  if (!currentUser) {
    // 로그인 후 마이페이지로 돌아오도록 현재 경로를 넘긴다.
    return <Navigate to="/login" replace state={{ from: '/mypage' }} />;
  }

  const handleLogout = () => {
    clearCurrentUser();
    navigate('/', { replace: true });
  };

  return (
    <div className="my-page">
      <Header />

      <main className="my-page__content">
        <section className="my-page__panel">
          <div className="my-page__header">
            <div>
              <h1>마이페이지</h1>
              <p className="my-page__subtitle">{currentUser.nickname}님, 반가워요.</p>
            </div>

            <button type="button" className="my-page__logout" onClick={handleLogout}>
              로그아웃
            </button>
          </div>

          <div className="my-page__layout">
            <section className="my-page__card">
              <h2>내 정보</h2>

              <dl className="my-page__info-list">
                <div>
                  <dt>닉네임</dt>
                  <dd>{currentUser.nickname}</dd>
                </div>
                <div>
                  <dt>아이디</dt>
                  <dd>{currentUser.loginId}</dd>
                </div>
                <div>
                  <dt>가입일</dt>
                  <dd>{formatDate(currentUser.createdAt)}</dd>
                </div>
              </dl>
            </section>

            <section className="my-page__card">
              <h2>저장한 견적</h2>

              <div className="my-page__empty-state">
                <p>아직 저장한 견적이 없습니다.</p>
                <Link to="/cart" className="my-page__primary-button">
                  장바구니 보러 가기
                </Link>
              </div>
            </section>
          </div>
        </section>
      </main>

      <Footer />
    </div>
  );
}
