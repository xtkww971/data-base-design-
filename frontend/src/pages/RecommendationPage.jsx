import { useState, useEffect } from 'react';
import Header from './components/Header.jsx';
import Footer from './components/Footer.jsx';
import './RecommendationPage.css';

const SIDEBAR_BREAKPOINT = 900; // 이 폭 이하면 자동으로 닫힘

const defaultPrompt =
  '300만원 안팎의 예산으로 컴퓨터 견적 맞춰줘.';

const initialRecentPrompts = [];


const CONFIG_LIMITS = {
  ram: 4,
  monitor: 2,
};

const formatConfigurationValue = (key, value) => {
  if (value === undefined || value === null || value === '') {
    return 'Null';
  }

  if (Array.isArray(value)) {
    const limit = CONFIG_LIMITS[key] ?? value.length;
    const limitedItems = value.slice(0, limit);

    if (key === 'ram' || key === 'monitor') {
      return limitedItems.length > 0 ? `x${limitedItems.length}` : '미정';
    }

    return limitedItems.length > 0 ? limitedItems.join(', ') : '미정';
  }

  return value;
};

export default function RecommendationPage() {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [recentPrompts, setRecentPrompts] = useState(initialRecentPrompts);
  const [selectedPromptIndex, setSelectedPromptIndex] = useState(null);
  const [promptText, setPromptText] = useState(defaultPrompt);
  const [isGenerating, setIsGenerating] = useState(false);

  const selectedPrompt = selectedPromptIndex === null ? null : recentPrompts[selectedPromptIndex];

  const handleSubmitPrompt = () => {
    const trimmedPrompt = promptText.trim();

    if (!trimmedPrompt || isGenerating) {
      return;
    }

    setIsGenerating(true);

    const now = new Date();
    const formattedDate = `${now.getFullYear()}.${String(now.getMonth() + 1).padStart(2, '0')}.${String(
      now.getDate()
    ).padStart(2, '0')}`;

    const newEntry = {
      date: formattedDate,
      prompt: trimmedPrompt,
      configuration: {
        cpu: undefined,
        motherboard: undefined,
        ram: undefined,
        gpu: undefined,
        power: undefined,
        ssd: undefined,
        hdd: undefined,
        monitor: undefined,
      },
    };

    setRecentPrompts((prev) => [newEntry, ...prev]);
    setSelectedPromptIndex(0);
    setPromptText('');

    setTimeout(() => {
      setIsGenerating(false);
    }, 1800);
  };

  const handleDeletePrompt = (indexToDelete) => {
    setRecentPrompts((prev) => {
      const next = prev.filter((_, index) => index !== indexToDelete);

      if (selectedPromptIndex === indexToDelete) {
        setSelectedPromptIndex(next.length > 0 ? 0 : null);
      } else if (selectedPromptIndex !== null && selectedPromptIndex > indexToDelete) {
        setSelectedPromptIndex((prevIndex) => prevIndex - 1);
      }

      return next;
    });
  };

  useEffect(() => {
    function handleResize() {
      setIsSidebarOpen(window.innerWidth > SIDEBAR_BREAKPOINT);
    }

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  return (
    <div className="recommendation-page">
      <Header />

      <button
        type="button"
        className={`recommendation-page__sidebar-toggle ${
          isSidebarOpen ? 'is-open' : 'is-closed'
        }`}
        onClick={() => setIsSidebarOpen((prev) => !prev)}
        aria-label="사이드바 토글"
      >
        ☰
      </button>

      <div className="recommendation-page__stage recommendation-page__header--animated">
        <main className="recommendation-page__content recommendation-page__content--animated">
          <aside
            className={`recommendation-page__sidebar ${
              isSidebarOpen ? 'is-open' : 'is-closed'
            }`}
          >
            <div className="recommendation-page__sidebar-header">
              <span className="recommendation-page__sidebar-icon" aria-hidden="true" />
              질문 내역
            </div>

            <div className="recommendation-page__sidebar-body">
              <ul className="recommendation-page__recent-list">
                {recentPrompts.map((item, index) => (
                  <li key={`${item.date}-${item.prompt}-${index}`}>
                    <div
                      className={`recommendation-page__recent-item-wrapper ${
                        selectedPromptIndex === index ? 'is-selected' : ''
                      }`}
                    >
                      <button
                        type="button"
                        className="recommendation-page__recent-item"
                        onClick={() => setSelectedPromptIndex(index)}
                      >
                        <span className="recommendation-page__recent-date">{item.date}</span>
                        <p>{item.prompt}</p>
                      </button>

                      <button
                        type="button"
                        className="recommendation-page__recent-delete"
                        onClick={(event) => {
                          event.stopPropagation();
                          handleDeletePrompt(index);
                        }}
                        aria-label={`${item.date} 항목 삭제`}
                      >
                        ×
                      </button>
                    </div>
                  </li>
                ))}
              </ul>
            </div>
          </aside>

          <section
            className={`recommendation-page__main-column ${
              isSidebarOpen ? 'sidebar-open' : 'sidebar-closed'
            }`}
          >
            <div className="recommendation-page__hero">
              <div className="recommendation-page__hero-badge">AI 추천</div>
              <h1>필요한 조건과 서비스를 자연어로 입력해보세요.</h1>
              <p>
               " 예시: 300만원 안팎의 예산으로 컴퓨터 견적 맞춰줘. "
              </p>

              <div className="recommendation-page__prompt-box">
                <textarea
                  className="recommendation-page__chat-input"
                  value={promptText}
                  onChange={(event) => setPromptText(event.target.value)}
                  rows={5}
                />

                <div className="recommendation-page__prompt-actions">
                  <button
                    type="button"
                    className="recommendation-page__primary-button"
                    onClick={handleSubmitPrompt}
                  >
                    AI 추천 분석
                  </button>
                </div>
              </div>

              {isGenerating ? (
                <div className="recommendation-page__loading-card">
                  <div className="recommendation-page__loading-spinner" aria-hidden="true" />
                  <div className="recommendation-page__loading-text">
                    견적을 생성중입니다. 잠시만 기다려주세요!
                  </div>
                </div>
              ) : selectedPrompt ? (
                <div className="recommendation-page__analysis-card recommendation-page__analysis-card--full recommendation-page__selected-panel">
                  <div className="recommendation-page__analysis-title">사용자가 구성한 컴퓨터 구성사항</div>

                  <div className="recommendation-page__selected-summary">
                    <span className="recommendation-page__selected-date">{selectedPrompt.date}</span>
                    <p>{selectedPrompt.prompt}</p>
                  </div>

                  <div className="recommendation-page__config-grid">
                    {Object.entries(selectedPrompt.configuration).map(([key, value]) => (
                      <div key={key} className="recommendation-page__config-item">
                        <span>{key}</span>
                        <strong
                          className={
                            key === 'ram' || key === 'monitor' ? 'is-count-chip' : ''
                          }
                        >
                          {formatConfigurationValue(key, value)}
                        </strong>
                      </div>
                    ))}
                  </div>
                </div>
              ) : null}
            </div>
          </section>
        </main>
      </div>

      <Footer />
    </div>
  );
}