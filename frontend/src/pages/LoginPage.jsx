import { useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import './LoginPage.css';
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
    <div className="login-page">
      <Header />

      <main className="login-page__content">
        <section className="login-page__panel">
          <h1>다시 오신 걸 환영해요.</h1>
          <p className="login-page__subtitle">로그인하고 나만의 견적을 이어서 만들어 보세요.</p>

          <form className="login-page__form" onSubmit={handleSubmit} noValidate>
            {signedUpLoginId && !errorMessage && (
              <p className="login-page__alert is-success">회원가입이 완료되었습니다. 로그인해 주세요.</p>
            )}
            {errorMessage && <p className="login-page__alert" role="alert">{errorMessage}</p>}

            <div className="login-page__field">
              <label className="login-page__label" htmlFor="login-id">아이디</label>
              <input
                id="login-id"
                className={`login-page__input ${fieldErrors.loginId ? 'is-invalid' : ''}`}
                type="text"
                autoComplete="username"
                value={loginId}
                onChange={(event) => setLoginId(event.target.value)}
                placeholder="아이디를 입력하세요"
              />
              {fieldErrors.loginId && <p className="login-page__message is-error">{fieldErrors.loginId}</p>}
            </div>

            <div className="login-page__field">
              <label className="login-page__label" htmlFor="login-password">비밀번호</label>
              <input
                id="login-password"
                className={`login-page__input ${fieldErrors.password ? 'is-invalid' : ''}`}
                type="password"
                autoComplete="current-password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                placeholder="비밀번호를 입력하세요"
              />
              {fieldErrors.password && <p className="login-page__message is-error">{fieldErrors.password}</p>}
            </div>

            <button type="submit" className="login-page__submit" disabled={isSubmitting}>
              {isSubmitting ? '로그인 중...' : '로그인'}
            </button>
          </form>

          <p className="login-page__switch">
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
