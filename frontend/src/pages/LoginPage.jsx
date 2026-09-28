import { useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import './AuthPage.css';
import { login } from '../api/authApi.js';
import { setCurrentUser } from '../auth/authStore.js';

export default function LoginPage() {
  const navigate = useNavigate();
  const location = useLocation();
  // 회원가입 직후라면 가입한 아이디와 안내 문구를 넘겨받는다.
  const signedUpLoginId = location.state?.signedUpLoginId ?? '';

  const [loginId, setLoginId] = useState(signedUpLoginId);
  const [password, setPassword] = useState('');
  const [fieldErrors, setFieldErrors] = useState({});
  const [errorMessage, setErrorMessage] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleSubmit = async (event) => {
    event.preventDefault();

    const nextFieldErrors = {};
    if (!loginId.trim()) nextFieldErrors.loginId = '아이디를 입력해 주세요.';
    if (!password) nextFieldErrors.password = '비밀번호를 입력해 주세요.';
    setFieldErrors(nextFieldErrors);
    setErrorMessage(null);
    if (Object.keys(nextFieldErrors).length > 0) return;

    setIsSubmitting(true);
    try {
      const user = await login({ loginId: loginId.trim(), password });
      setCurrentUser(user);
      // 로그인 버튼을 누르기 전에 있던 페이지로 돌려보낸다.
      navigate(location.state?.from ?? '/', { replace: true });
    } catch (error) {
      setFieldErrors(error.fieldErrors ?? {});
      setErrorMessage(error.message);
      setIsSubmitting(false);
    }
  };

  return (
    <div className="auth-page">
      <Header />

      <main className="auth-page__content">
        <section className="auth-page__panel">
          <span className="auth-page__eyebrow">로그인</span>
          <h1>다시 오신 걸 환영해요.</h1>
          <p className="auth-page__subtitle">로그인하고 나만의 견적을 이어서 만들어 보세요.</p>

          <form className="auth-page__form" onSubmit={handleSubmit} noValidate>
            {signedUpLoginId && !errorMessage && (
              <p className="auth-page__alert is-success">회원가입이 완료되었습니다. 로그인해 주세요.</p>
            )}
            {errorMessage && <p className="auth-page__alert" role="alert">{errorMessage}</p>}

            <div className="auth-page__field">
              <label className="auth-page__label" htmlFor="login-id">아이디</label>
              <input
                id="login-id"
                className={`auth-page__input ${fieldErrors.loginId ? 'is-invalid' : ''}`}
                type="text"
                autoComplete="username"
                value={loginId}
                onChange={(event) => setLoginId(event.target.value)}
                placeholder="아이디를 입력하세요"
              />
              {fieldErrors.loginId && <p className="auth-page__message is-error">{fieldErrors.loginId}</p>}
            </div>

            <div className="auth-page__field">
              <label className="auth-page__label" htmlFor="login-password">비밀번호</label>
              <input
                id="login-password"
                className={`auth-page__input ${fieldErrors.password ? 'is-invalid' : ''}`}
                type="password"
                autoComplete="current-password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                placeholder="비밀번호를 입력하세요"
              />
              {fieldErrors.password && <p className="auth-page__message is-error">{fieldErrors.password}</p>}
            </div>

            <button type="submit" className="auth-page__submit" disabled={isSubmitting}>
              {isSubmitting ? '로그인 중...' : '로그인'}
            </button>
          </form>

          <p className="auth-page__switch">
            아직 계정이 없으신가요?
            <Link to="/signup" state={location.state?.from ? { from: location.state.from } : undefined}>
              회원가입
            </Link>
          </p>
        </section>
      </main>

      <Footer />
    </div>
  );
}
