import React, { useState } from 'react';
import { Award, Trophy, Crown, ArrowUp, ArrowRight, UserPlus, Star, Landmark, ShieldCheck, Sparkles } from 'lucide-react';
import { RankingUser, UserProfile } from '../types';

interface LeaderboardProps {
  userProfile: UserProfile;
  rankingUsers: RankingUser[];
}

export const Leaderboard: React.FC<LeaderboardProps> = ({ userProfile, rankingUsers }) => {
  const [invited, setInvited] = useState<string[]>([]);

  // Split out the top 3 for the podium
  const top1Input = rankingUsers.find(u => u.position === 1);
  const top2Input = rankingUsers.find(u => u.position === 2);
  const top3Input = rankingUsers.find(u => u.position === 3);
  const standardRankings = rankingUsers.filter(u => u.position > 3);

  const handleInviteSpecialist = (name: string) => {
    if (invited.includes(name)) return;
    setInvited(prev => [...prev, name]);
    alert(`O link de convite oficial para colaboração foi enviado para o email corporativo de ${name}!`);
  };

  return (
    <div className="space-y-6 pb-24 select-none animate-fadeIn">
      
      {/* 1. SECTOR DE DESTAQUE: PODIUM EXPERTS */}
      <section className="bg-white border border-outline-light rounded-xl p-6 shadow-sm">
        <div className="text-center mb-6">
          <span className="bg-gold-light/40 text-bordeaux-accent px-3 py-1 font-sans text-[10px] font-black tracking-widest rounded-full inline-block uppercase">
            Quadro de Elite de Luanda
          </span>
          <h2 className="font-display text-[20px] md:text-[24px] text-bordeaux-primary font-bold mt-1">
            Especialistas em Foco
          </h2>
          <div className="h-[2px] w-12 bg-gold-premium rounded-full mx-auto mt-2" />
        </div>

        {/* Podium Row representation */}
        <div className="grid grid-cols-3 gap-3 md:gap-6 pt-4 max-w-lg mx-auto items-end text-center">
          
          {/* PODIUM 2ND PLACE */}
          {top2Input && (
            <div className="flex flex-col items-center space-y-2 pb-2">
              <div className="relative">
                <div className="w-14 h-14 md:w-18 md:h-18 rounded-full border-2 border-slate-300 overflow-hidden bg-cream-bg">
                  <img 
                    alt={top2Input.name} 
                    className="w-full h-full object-cover" 
                    src={top2Input.avatar}
                    referrerPolicy="no-referrer"
                  />
                </div>
                <div className="absolute -top-2.5 left-1/2 -translate-x-1/2 bg-slate-300 text-slate-800 w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold ring-2 ring-white">
                  2
                </div>
              </div>
              <div>
                <h4 className="font-sans font-bold text-[11px] md:text-sm text-bordeaux-primary leading-tight line-clamp-1">{top2Input.name}</h4>
                <p className="text-[10px] text-outline-dark uppercase tracking-wider scale-90">{top2Input.title.split(' ')[0]}</p>
                <span className="font-mono text-xs text-gold-premium font-bold block mt-1">{top2Input.points} pts</span>
              </div>
            </div>
          )}

          {/* PODIUM 1ST PLACE */}
          {top1Input && (
            <div className="flex flex-col items-center space-y-3 pb-6">
              <div className="relative">
                <Crown className="w-6 h-6 text-gold-bright absolute -top-5 left-1/2 -translate-x-1/2 drop-shadow-md animate-bounce" />
                <div className="w-18 h-18 md:w-22 md:h-22 rounded-full border-4 border-gold-bright overflow-hidden bg-cream-bg shadow-[0_0_16px_rgba(232,184,75,0.4)]">
                  <img 
                    alt={top1Input.name} 
                    className="w-full h-full object-cover" 
                    src={top1Input.avatar}
                    referrerPolicy="no-referrer"
                  />
                </div>
                <div className="absolute -bottom-2 left-1/2 -translate-x-1/2 bg-gold-bright text-bordeaux-dark w-6 h-6 rounded-full flex items-center justify-center text-xs font-black ring-2 ring-white">
                  1
                </div>
              </div>
              <div>
                <h4 className="font-sans font-black text-xs md:text-base text-bordeaux-primary leading-tight flex items-center gap-0.5 justify-center">
                  {top1Input.name}
                </h4>
                <p className="text-[10px] text-outline-dark uppercase tracking-wider font-bold">{top1Input.title.split(' ')[0]}</p>
                <div className="flex gap-0.5 justify-center py-0.5">
                  {[...Array(5)].map((_, i) => <Star key={i} className="w-2.5 h-2.5 fill-current text-gold-bright" />)}
                </div>
                <span className="font-mono text-xs md:text-sm text-bordeaux-accent font-black block">{top1Input.points} pts</span>
              </div>
            </div>
          )}

          {/* PODIUM 3RD PLACE */}
          {top3Input && (
            <div className="flex flex-col items-center space-y-2 pb-2">
              <div className="relative">
                <div className="w-12 h-12 md:w-16 md:h-16 rounded-full border-2 border-yellow-700/60 overflow-hidden bg-cream-bg">
                  <img 
                    alt={top3Input.name} 
                    className="w-full h-full object-cover" 
                    src={top3Input.avatar}
                    referrerPolicy="no-referrer"
                  />
                </div>
                <div className="absolute -top-2.5 left-1/2 -translate-x-1/2 bg-yellow-700 text-white w-5 h-5 rounded-full flex items-center justify-center text-xs font-bold ring-2 ring-white">
                  3
                </div>
              </div>
              <div>
                <h4 className="font-sans font-bold text-[11px] md:text-xs text-bordeaux-primary leading-tight line-clamp-1">{top3Input.name}</h4>
                <p className="text-[10px] text-outline-dark uppercase tracking-wider scale-90">{top3Input.title.split(' ')[0]}</p>
                <span className="font-mono text-xs text-gold-premium font-bold block mt-1">{top3Input.points} pts</span>
              </div>
            </div>
          )}

        </div>
      </section>

      {/* 2. COMPLETENESS RANKS LIST */}
      <section className="bg-white border border-outline-light rounded-xl overflow-hidden shadow-sm">
        
        {/* Table/List titles */}
        <div className="bg-cream-bg grid grid-cols-12 px-5 py-3.5 border-b border-outline-light text-[10px] font-sans font-black text-outline-dark tracking-wider uppercase select-none">
          <div className="col-span-2">CLASSIFICAÇÃO</div>
          <div className="col-span-6 md:col-span-7">NOMES E TÍTULO</div>
          <div className="col-span-4 md:col-span-3 text-right">PONTOS</div>
        </div>

        {/* Members ranks rows */}
        <div className="divide-y divide-cream-bg">
          {standardRankings.map((user) => (
            <div 
              key={user.position}
              className="grid grid-cols-12 px-5 py-4 items-center hover:bg-cream-bg/20 transition-all duration-150"
            >
              {/* Position */}
              <div className="col-span-2 flex items-center">
                <span className="font-mono font-bold text-xs md:text-sm text-outline-dark bg-outline-light/30 w-7 h-7 rounded-sm flex items-center justify-center">
                  #{user.position}
                </span>
              </div>

              {/* Avatar and name details */}
              <div className="col-span-6 md:col-span-7 flex gap-3 items-center">
                <div className="w-9 h-9 rounded-full border border-gold-premium overflow-hidden flex-shrink-0 bg-cream-bg">
                  <img 
                    src={user.avatar} 
                    alt={user.name} 
                    className="w-full h-full object-cover"
                    referrerPolicy="no-referrer"
                  />
                </div>
                <div>
                  <h4 className="font-sans font-bold text-xs md:text-sm text-bordeaux-primary flex items-center gap-1">
                    {user.name}
                  </h4>
                  <p className="text-[10px] text-outline-dark truncate font-sans">{user.title}</p>
                </div>
              </div>

              {/* Points */}
              <div className="col-span-4 md:col-span-3 flex flex-col items-end">
                <span className="font-mono font-bold text-xs md:text-sm text-bordeaux-accent">{user.points} pts</span>
                <span className="text-[9px] text-green-700 font-mono flex items-center font-bold">
                  <ArrowUp className="w-2.5 h-2.5" /> +120 hoje
                </span>
              </div>
            </div>
          ))}

          {/* USER HIGHLIGHT SCORE ROW INSERT (PERFECT SCREEN MATCH!) */}
          <div className="grid grid-cols-12 px-5 py-4.5 items-center bg-gold-light/25 border-y-2 border-gold-premium shadow-inner relative z-10">
            {/* Position */}
            <div className="col-span-2 flex items-center">
              <span className="font-mono font-black text-xs md:text-sm text-bordeaux-dark bg-gold-bright w-7 h-7 rounded-sm flex items-center justify-center border border-gold-premium/40 shadow-sm animate-pulse">
                #{userProfile.globalRanking}
              </span>
            </div>

            {/* Avatar and name details */}
            <div className="col-span-6 md:col-span-7 flex gap-3 items-center">
              <div className="w-10 h-10 rounded-full border-2 border-bordeaux-primary overflow-hidden flex-shrink-0 bg-cream-bg">
                <img 
                  src={userProfile.avatar} 
                  alt={userProfile.name} 
                  className="w-full h-full object-cover"
                  referrerPolicy="no-referrer"
                />
              </div>
              <div>
                <h4 className="font-sans font-black text-xs md:text-sm text-bordeaux-dark flex items-center gap-1">
                  {userProfile.name} (Você)
                  <ShieldCheck className="w-4 h-4 text-bordeaux-accent fill-current" />
                </h4>
                <p className="text-[10px] text-bordeaux-accent uppercase tracking-widest font-black leading-none mt-1">
                  {userProfile.role}
                </p>
              </div>
            </div>

            {/* Points */}
            <div className="col-span-4 md:col-span-3 flex flex-col items-end">
              <span className="font-mono font-black text-xs md:text-sm text-bordeaux-primary">{userProfile.points} pts</span>
              <span className="text-[9px] text-green-700 font-mono flex items-center font-bold bg-green-100 px-1 py-0.5 rounded-sm">
                <ArrowUp className="w-2.5 h-2.5" /> +240 hoje
              </span>
            </div>
          </div>

        </div>
      </section>

      {/* 3. INVITATION ROW CARD */}
      <section className="bg-cream-bg border border-outline-light p-5 rounded-xl flex flex-col md:flex-row items-center justify-between gap-4">
        <div className="space-y-1">
          <h4 className="font-display text-[16px] text-bordeaux-primary font-bold">Convide outros Economistas da BODIVA</h4>
          <p className="text-xs text-outline-dark">Partilhe o acesso restrito de investigação e aumente o alcance analítico do painel de Luanda.</p>
        </div>
        <button 
          onClick={() => handleInviteSpecialist("Amigos da BODIVA")}
          className="bg-bordeaux-accent text-white px-5 py-2.5 rounded-lg text-xs font-bold uppercase tracking-widest hover:bg-bordeaux-primary active:scale-95 transition-all flex items-center gap-1.5 cursor-pointer whitespace-nowrap shadow-sm"
        >
          <UserPlus className="w-4 h-4" />
          <span>Enviar Convite</span>
        </button>
      </section>

    </div>
  );
};
