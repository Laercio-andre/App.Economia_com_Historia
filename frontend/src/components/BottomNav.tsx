import React from 'react';
import { Home, Compass, Award, MessageSquare, UserCircle } from 'lucide-react';

interface BottomNavProps {
  currentTab: string;
  onNavigate: (tab: string) => void;
}

export const BottomNav: React.FC<BottomNavProps> = ({ currentTab, onNavigate }) => {
  const tabs = [
    { id: 'dashboard', label: 'Início', icon: Home },
    { id: 'explore', label: 'Explorar', icon: Compass },
    { id: 'quiz', label: 'Quiz', icon: Award },
    { id: 'forum', label: 'Fórum', icon: MessageSquare },
    { id: 'profile', label: 'Perfil', icon: UserCircle },
  ];

  return (
    <nav className="fixed bottom-0 left-0 right-0 w-full z-50 bg-white border-t border-outline-light shadow-[0_-4px_16px_rgba(42,10,18,0.06)] h-16 flex justify-around items-center px-2 select-none">
      {tabs.map((tab) => {
        const Icon = tab.icon;
        const isActive = currentTab === tab.id;
        
        return (
          <button
            key={tab.id}
            onClick={() => onNavigate(tab.id)}
            className={`flex flex-col items-center justify-center flex-1 h-full relative transition-all duration-150 cursor-pointer ${
              isActive 
                ? 'text-bordeaux-primary' 
                : 'text-outline-dark hover:text-bordeaux-accent'
            }`}
            id={`nav-item-${tab.id}`}
          >
            <Icon 
              className={`w-5 h-5 transition-transform duration-100 ${
                isActive ? 'scale-110 stroke-[2.5]' : 'scale-100'
              }`} 
            />
            <span className={`text-[10px] uppercase font-bold tracking-wider mt-1 ${
              isActive ? 'font-black' : 'font-medium'
            }`}>
              {tab.label}
            </span>
            
            {isActive && (
              <span className="absolute bottom-1.5 w-1.5 h-1.5 bg-gold-premium rounded-full" />
            )}
          </button>
        );
      })}
    </nav>
  );
};
