import { BrowserRouter, Navigate, Route, Routes, useLocation } from 'react-router-dom';
import './index.css';
import Mainpage from './pages/MainPage.jsx';
import RecommendationPage from './pages/RecommendationPage.jsx';
import SearchPage from './pages/SearchPage.jsx';

function AppRoutes() {
  const location = useLocation();

  return (
    <div key={location.pathname} className="page-transition">
      <Routes location={location}>
        <Route path="/" element={<Mainpage />} />
        <Route path="/recommendation" element={<RecommendationPage />} />
        <Route path="/search" element={<SearchPage />} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </div>
  );
}

export default function App() {
  return (
    <BrowserRouter>
      <AppRoutes />
    </BrowserRouter>
  );
}