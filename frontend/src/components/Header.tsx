import React from 'react';
import { Menu, Bell, TrendingUp, ChevronLeft, User, MessageCircle } from 'lucide-react';
import { UserProfile } from '../types';

interface HeaderProps {
  currentTab: string;
  onNavigate: (tab: string) => void;
  onGoBack?: () => void;
  userProfile: UserProfile;
  titleOverride?: string;
  hasUnreadNotifications?: boolean;
  onToggleNotificationList?: () => void;
}

export const Header: React.FC<HeaderProps> = ({
  currentTab,
  onNavigate,
  onGoBack,
  userProfile,
  titleOverride,
  hasUnreadNotifications = true
}) => {
  
  const getHeaderTitle = () => {
    if (titleOverride) return titleOverride;
    switch (currentTab) {
      case 'dashboard':
        return "Economia Angola";
      case 'forum':
        return "Fórum Económico";
      case 'quiz':
        return "Economia Angola — Quiz";
      case 'leaderboard':
        return "Ranking de Especialistas";
      case 'profile':
        return "Definições de Conta";
      default:
        return "Economia Angola";
    }
  };

  return (
    <header className="bg-white border-b border-outline-light flex justify-between items-center w-full px-4 md:px-10 h-14 sticky top-0 z-50 shadow-sm select-none">
      <div className="flex items-center gap-2 md:gap-4">
        {onGoBack ? (
          <button 
            onClick={onGoBack}
            className="text-bordeaux-accent hover:bg-cream-bg p-2 rounded-full transition-colors active:scale-95 duration-100 flex items-center justify-center cursor-pointer"
            id="btn-back"
          >
            <ChevronLeft className="w-5 h-5 stroke-[2.5]" />
          </button>
        ) : (
          <button 
            onClick={() => onNavigate('dashboard')}
            className="text-bordeaux-accent hover:bg-cream-bg p-2 rounded-full transition-colors active:scale-95 duration-100 flex items-center justify-center cursor-pointer md:hidden"
            id="btn-menu-mobile"
          >
            <Menu className="w-5 h-5" />
          </button>
        )}
        
        <div className="flex flex-col">
          <div className="flex items-center gap-1.5 md:gap-2">
            <span className="w-8 h-8 bg-bordeaux-primary text-gold-bright flex items-center justify-center rounded-sm font-bold text-lg font-display select-none">
              B
            </span>
            <h1 className="font-display text-[18px] md:text-[22px] text-bordeaux-primary tracking-tight font-bold leading-none cursor-pointer hover:opacity-90 transition-opacity" onClick={() => onNavigate('dashboard')}>
              {getHeaderTitle()}
            </h1>
          </div>
          <div className="h-[2px] w-12 bg-gold-premium rounded-full mt-0.5" />
        </div>
      </div>

      <div className="flex items-center gap-2 md:gap-4">
        <button 
          className="text-bordeaux-accent hover:bg-cream-bg p-2 rounded-full transition-colors active:scale-95 duration-100 relative cursor-pointer"
          onClick={() => {
            alert("Sistema de Notificações: Não há novas análises para ler no momento. Desfrute da sua jornada!");
          }}
          id="btn-notifications"
          title="Notificações"
        >
          <Bell className="w-5 h-5" />
          {hasUnreadNotifications && (
            <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-gold-bright rounded-full border border-white animate-pulse" />
          )}
        </button>

        <div 
          onClick={() => onNavigate('profile')}
          className="w-8 h-8 rounded-full border-2 border-gold-premium overflow-hidden cursor-pointer hover:border-bordeaux-accent transition-colors active:scale-95 flex items-center justify-center bg-cream-bg"
          id="btn-profile-avatar"
          title="Ver o meu perfil"
        >
          <img 
            alt={userProfile.name} 
            className="w-full h-full object-cover" 
            src={userProfile.avatar}
            referrerPolicy="no-referrer"
          />
        </div>
      </div>
    </header>
  );
};
