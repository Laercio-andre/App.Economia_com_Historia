import React, { useState, useEffect } from 'react';
import { initialUserProfile, initialRankingUsers, initialForumTopics, initialQuizzes } from './data';
import { UserProfile } from './types';
import { Ticker } from './components/Ticker';
import { Header } from './components/Header';
import { BottomNav } from './components/BottomNav';
import { Dashboard } from './components/Dashboard';
import { Explore } from './components/Explore';
import { QuizView } from './components/QuizView';
import { Forum } from './components/Forum';
import { Profile } from './components/Profile';
import { AuthScreen } from './components/AuthScreen';
import { Home, Compass, Award, MessageSquare, UserCircle, Landmark, ShieldCheck, LogOut } from 'lucide-react';

export default function App() {
  const [isAuthenticated, setIsAuthenticated] = useState<boolean>(() => {
    return localStorage.getItem('ao_economy_portal_is_logged_in') === 'true';
  });
  
  const [currentTab, setCurrentTab] = useState<string>('dashboard');
  const [userProfile, setUserProfile] = useState<UserProfile>(() => {
    const saved = localStorage.getItem('ao_economy_portal_user');
    if (saved) {
      try {
        return JSON.parse(saved);
      } catch (e) {
        return initialUserProfile;
      }
    }
    return initialUserProfile;
  });
  const [selectedArticleId, setSelectedArticleId] = useState<string | null>(null);

  const handleLoginSuccess = (profile: UserProfile) => {
    setUserProfile(profile);
    setIsAuthenticated(true);
    localStorage.setItem('ao_economy_portal_is_logged_in', 'true');
    localStorage.setItem('ao_economy_portal_user', JSON.stringify(profile));
  };

  const handleLogout = () => {
    setIsAuthenticated(false);
    localStorage.removeItem('ao_economy_portal_is_logged_in');
    localStorage.removeItem('ao_economy_portal_user');
    setCurrentTab('dashboard');
    setSelectedArticleId(null);
  };

  // Points additions helper
  const handleUpdatePoints = (ptsToAdd: number) => {
    setUserProfile(prev => {
      const newPts = prev.points + ptsToAdd;
      // calculate ranking dynamically as points go up to make game feel responsive!
      let newRank = prev.globalRanking;
      if (newPts > 3100) newRank = 1;
      else if (newPts > 2800) newRank = 2;
      else if (newPts > 2500) newRank = 3;
      else if (newPts > 2400) newRank = 4;
      else if (newPts > 2200) newRank = 5;
      else if (newPts > 2000) newRank = 10;
      else if (newPts > 1900) newRank = 11;
      else if (newPts > 1850) newRank = 12;

      return {
        ...prev,
        points: newPts,
        globalRanking: newRank
      };
    });
  };

  const handleUpdateCommentsCount = (incrementBy: number) => {
    setUserProfile(prev => ({
      ...prev,
      commentsCount: prev.commentsCount + incrementBy
    }));
  };

  const handleUpdateProfile = (updated: Partial<UserProfile>) => {
    setUserProfile(prev => {
      const next = {
        ...prev,
        ...updated
      };
      localStorage.setItem('ao_economy_portal_user', JSON.stringify(next));
      return next;
    });
  };

  const handleNavigate = (tab: string) => {
    setCurrentTab(tab);
    // Auto collapse deep views when moving across primary segments
    setSelectedArticleId(null);
    window.scrollTo({ top: 0, behavior: 'instant' });
  };

  const handleSelectArticleFromDashboard = (articleId: string) => {
    setSelectedArticleId(articleId);
    setCurrentTab('explore');
    window.scrollTo({ top: 0, behavior: 'instant' });
  };

  // Determine back function header integration
  const getGoBackAction = () => {
    if (currentTab === 'explore' && selectedArticleId) {
      return () => setSelectedArticleId(null);
    }
    return undefined;
  };

  const menuItems = [
    { id: 'dashboard', label: 'Início', icon: Home },
    { id: 'explore', label: 'Explorar', icon: Compass },
    { id: 'quiz', label: 'Quiz Académico', icon: Award },
    { id: 'forum', label: 'Fórum de Estudos', icon: MessageSquare },
    { id: 'profile', label: 'Configurações', icon: UserCircle },
  ];

  if (!isAuthenticated) {
    return <AuthScreen onLoginSuccess={handleLoginSuccess} defaultUser={initialUserProfile} />;
  }

  return (
    <div className={`min-h-screen bg-cream-bg flex flex-col transition-colors duration-150 ${userProfile.darkMode ? 'dark filter brightness-95' : ''}`}>
      
      {/* Dynamic continuous stock/commodities marquee ticker */}
      <Ticker />

      {/* Dynamic top navigation header bar */}
      <Header 
        currentTab={currentTab} 
        onNavigate={handleNavigate}
        onGoBack={getGoBackAction()}
        userProfile={userProfile}
        titleOverride={selectedArticleId ? "Análise Académica" : undefined}
      />

      {/* Main Container Layout: responsive desktop sidebar and responsive central viewport container */}
      <div className="flex flex-1 w-full max-w-7xl mx-auto md:px-6 lg:px-10 mt-4 md:mt-6">
        
        {/* Desktop Sidebar Rail Navigation (Hidden on mobile) */}
        <aside className="hidden md:flex flex-col w-64 bg-white border border-outline-light rounded-xl h-[calc(100vh-170px)] sticky top-20 p-5 space-y-6 select-none shadow-sm mr-6">
          <div className="border-b border-outline-light pb-4">
            <div className="flex items-center gap-2.5">
              <div className="w-10 h-10 rounded-full border border-gold-premium overflow-hidden bg-cream-bg">
                <img 
                  alt={userProfile.name} 
                  className="w-full h-full object-cover" 
                  src={userProfile.avatar}
                  referrerPolicy="no-referrer"
                />
              </div>
              <div className="truncate">
                <h4 className="font-sans font-black text-xs text-bordeaux-primary truncate leading-tight">{userProfile.name}</h4>
                <p className="text-[10px] text-gold-premium font-black tracking-widest uppercase truncate mt-0.5">{userProfile.role}</p>
              </div>
            </div>
          </div>

          <nav className="space-y-1.5">
            {menuItems.map((item) => {
              const Icon = item.icon;
              const isActive = currentTab === item.id;
              
              return (
                <button
                  key={item.id}
                  onClick={() => handleNavigate(item.id)}
                  className={`w-full flex items-center gap-3 px-4.5 py-3 rounded-lg text-xs font-bold uppercase tracking-widest text-left transition-all cursor-pointer ${
                    isActive 
                      ? 'bg-bordeaux-primary text-white shadow-sm font-black' 
                      : 'text-outline-dark hover:bg-cream-bg hover:text-bordeaux-accent'
                  }`}
                  id={`sidebar-item-${item.id}`}
                >
                  <Icon className="w-4 h-4" />
                  <span>{item.label}</span>
                  {isActive && (
                    <span className="ml-auto w-1.5 h-1.5 bg-gold-bright rounded-full" />
                  )}
                </button>
              );
            })}
          </nav>

          {/* Golden Badge of verified security */}
          <div className="mt-auto space-y-3">
            <button
              onClick={handleLogout}
              className="w-full flex items-center justify-between px-4 py-2.5 border border-dashed border-red-200 hover:border-red-400 bg-red-50/10 hover:bg-red-50/40 rounded-lg text-[10.5px] font-black uppercase tracking-widest text-red-700 transition-all cursor-pointer"
              id="sidebar-item-logout"
            >
              <span className="flex items-center gap-1.5">
                <LogOut className="w-3.5 h-3.5" />
                <span>Terminar Sessão</span>
              </span>
            </button>

            <div className="border border-gold-premium/30 bg-gold-light/20 p-3 flex items-center gap-2.5 rounded-lg">
              <div className="bg-gold-bright text-bordeaux-dark p-1.5 rounded-lg">
                <ShieldCheck className="w-4 h-4 fill-current" />
              </div>
              <div className="leading-tight">
                <span className="block text-[9.5px] text-bordeaux-accent font-black uppercase tracking-wider">Acesso Seguro</span>
                <span className="block text-[8.5px] text-outline-dark font-mono mt-0.5">Sessão Luanda</span>
              </div>
            </div>
          </div>
        </aside>

        {/* Central viewports controller grid */}
        <main className="flex-1 px-4 md:px-0 max-w-full overflow-hidden">
          
          {currentTab === 'dashboard' && (
            <Dashboard 
              userProfile={userProfile} 
              onNavigate={handleNavigate}
              onSelectArticle={handleSelectArticleFromDashboard}
            />
          )}

          {currentTab === 'explore' && (
            <Explore 
              selectedArticleId={selectedArticleId}
              setSelectedArticleId={setSelectedArticleId}
            />
          )}

          {currentTab === 'quiz' && (
            <QuizView 
              userProfile={userProfile}
              initialQuizzes={initialQuizzes}
              onAddPoints={handleUpdatePoints}
            />
          )}

          {currentTab === 'forum' && (
            <Forum 
              userProfile={userProfile}
              initialTopics={initialForumTopics}
              onAddPoints={handleUpdatePoints}
              onUpdateCommentsCount={handleUpdateCommentsCount}
            />
          )}

          {currentTab === 'profile' && (
            <Profile 
              userProfile={userProfile}
              onUpdateProfile={handleUpdateProfile}
              onLogout={handleLogout}
            />
          )}

        </main>
      </div>

      {/* Floating Sticky Mobile Bottom Nav bar (Hidden on desktop) */}
      <div className="md:hidden">
        <BottomNav currentTab={currentTab} onNavigate={handleNavigate} />
      </div>

    </div>
  );
}
