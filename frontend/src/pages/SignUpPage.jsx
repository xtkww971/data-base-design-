import { useState } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import './AuthPage.css';
import { checkLoginId, signUp } from '../api/authApi.js';

// 백엔드 SignUpRequest 검증 규칙과 같게 맞춘다.
const LOGIN_ID_PATTERN = /^[a-zA-Z0-9_]{4,30}$/;

function validate({ loginId, password, passwordConfirm, nickname }) {
  const errors = {};
  if (!LOGIN_ID_PATTERN.test(loginId)) {
    errors.loginId = '아이디는 영문/숫자/밑줄 4~30자여야 합니다.';
  }
  if (password.length < 8 || password.length > 64) {
    errors.password = '비밀번호는 8~64자여야 합니다.';
  }
  if (passwordConfirm !== password) {
    errors.passwordConfirm = '비밀번호가 일치하지 않습니다.';
  }
  const trimmedNickname = nickname.trim();
  if (trimmedNickname.length < 2 || trimmedNickname.length > 20) {
    errors.nickname = '닉네임은 2~20자여야 합니다.';
  }
  return errors;
}

export default function SignUpPage() {
  const navigate = useNavigate();
  const location = useLocation();

  const [form, setForm] = useState({ loginId: '', password: '', passwordConfirm: '', nickname: '' });
  const [fieldErrors, setFieldErrors] = useState({});
  const [errorMessage, setErrorMessage] = useState(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  // 중복 확인 결과. 확인한 아이디가 지금 입력값과 같을 때만 의미가 있다.
  const [idCheck, setIdCheck] = useState({ loginId: null, available: null, isChecking: false });
  const idCheckResult = idCheck.loginId === form.loginId ? idCheck.available : null;

  const updateField = (name) => (event) => {
    setForm((prev) => ({ ...prev, [name]: event.target.value }));
    setFieldErrors((prev) => ({ ...prev, [name]: undefined }));
  };

  const handleCheckLoginId = async () => {
    if (!LOGIN_ID_PATTERN.test(form.loginId)) {
      setFieldErrors((prev) => ({ ...prev, loginId: '아이디는 영문/숫자/밑줄 4~30자여야 합니다.' }));
      return;
    }

    const target = form.loginId;
    setIdCheck({ loginId: target, available: null, isChecking: true });
    try {
      const { available } = await checkLoginId(target);
      setIdCheck({ loginId: target, available, isChecking: false });
    } catch (error) {
      setIdCheck({ loginId: null, available: null, isChecking: false });
      setErrorMessage(error.message);
    }
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setErrorMessage(null);

    const errors = validate(form);
    if (idCheckResult === false) {
      errors.loginId = '이미 사용 중인 아이디입니다.';
    }
    setFieldErrors(errors);
    if (Object.keys(errors).length > 0) return;

    setIsSubmitting(true);
    try {
      const user = await signUp({ loginId: form.loginId, password: form.password, nickname: form.nickname.trim() });
      navigate('/login', { replace: true, state: { signedUpLoginId: user.loginId, from: location.state?.from } });
    } catch (error) {
      // 아이디 중복(409)은 아이디 칸에, 나머지 검증 오류는 각 칸에 보여준다.
      if (error.code === 'DUPLICATE_LOGIN_ID') {
        setFieldErrors({ loginId: error.message });
      } else if (Object.keys(error.fieldErrors ?? {}).length > 0) {
        setFieldErrors(error.fieldErrors);
      } else {
        setErrorMessage(error.message);
      }
      setIsSubmitting(false);
    }
  };

  const renderFieldMessage = (name, hint) => {
    if (fieldErrors[name]) {
      return <p className="auth-page__message is-error">{fieldErrors[name]}</p>;
    }
    return hint ? <p className="auth-page__message">{hint}</p> : null;
  };

  return (
    <div className="auth-page">
      <Header />

      <main className="auth-page__content">
        <section className="auth-page__panel">
          <span className="auth-page__eyebrow">회원가입</span>
          <h1>새 계정을 만들어 보세요.</h1>
          <p className="auth-page__subtitle">가입하면 AI 추천 견적과 검색한 부품을 내 계정으로 관리할 수 있어요.</p>

          <form className="auth-page__form" onSubmit={handleSubmit} noValidate>
            {errorMessage && <p className="auth-page__alert" role="alert">{errorMessage}</p>}

            <div className="auth-page__field">
              <label className="auth-page__label" htmlFor="signup-login-id">아이디</label>
              <div className="auth-page__input-row">
                <input
                  id="signup-login-id"
                  className={`auth-page__input ${fieldErrors.loginId || idCheckResult === false ? 'is-invalid' : ''}`}
                  type="text"
                  autoComplete="username"
                  value={form.loginId}
                  onChange={updateField('loginId')}
                  placeholder="영문/숫자/밑줄 4~30자"
                />
                <button
                  type="button"
                  className="auth-page__check-button"
                  onClick={handleCheckLoginId}
                  disabled={idCheck.isChecking || !form.loginId}
                >
                  {idCheck.isChecking ? '확인 중...' : '중복 확인'}
                </button>
              </div>
              {fieldErrors.loginId ? (
                <p className="auth-page__message is-error">{fieldErrors.loginId}</p>
              ) : idCheckResult === true ? (
                <p className="auth-page__message is-success">사용할 수 있는 아이디입니다.</p>
              ) : idCheckResult === false ? (
                <p className="auth-page__message is-error">이미 사용 중인 아이디입니다.</p>
              ) : null}
            </div>

            <div className="auth-page__field">
              <label className="auth-page__label" htmlFor="signup-password">비밀번호</label>
              <input
                id="signup-password"
                className={`auth-page__input ${fieldErrors.password ? 'is-invalid' : ''}`}
                type="password"
                autoComplete="new-password"
                value={form.password}
                onChange={updateField('password')}
                placeholder="8~64자"
              />
              {renderFieldMessage('password')}
            </div>

            <div className="auth-page__field">
              <label className="auth-page__label" htmlFor="signup-password-confirm">비밀번호 확인</label>
              <input
                id="signup-password-confirm"
                className={`auth-page__input ${fieldErrors.passwordConfirm ? 'is-invalid' : ''}`}
                type="password"
                autoComplete="new-password"
                value={form.passwordConfirm}
                onChange={updateField('passwordConfirm')}
                placeholder="비밀번호를 한 번 더 입력하세요"
              />
              {renderFieldMessage('passwordConfirm')}
            </div>

            <div className="auth-page__field">
              <label className="auth-page__label" htmlFor="signup-nickname">닉네임</label>
              <input
                id="signup-nickname"
                className={`auth-page__input ${fieldErrors.nickname ? 'is-invalid' : ''}`}
                type="text"
                autoComplete="nickname"
                value={form.nickname}
                onChange={updateField('nickname')}
                placeholder="2~20자"
              />
              {renderFieldMessage('nickname')}
            </div>

            <button type="submit" className="auth-page__submit" disabled={isSubmitting}>
              {isSubmitting ? '가입 중...' : '회원가입'}
            </button>
          </form>

          <p className="auth-page__switch">
            이미 계정이 있으신가요?
            <Link to="/login" state={location.state?.from ? { from: location.state.from } : undefined}>
              로그인
            </Link>
          </p>
        </section>
      </main>

      <Footer />
    </div>
  );
}
