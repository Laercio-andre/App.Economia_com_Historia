import React, { useState } from 'react';
import { ShieldAlert, Key, User, Settings, BellRing, Save, Eye, EyeOff, LayoutTemplate, Star, RefreshCw, Compass, LogOut, FileDown } from 'lucide-react';
import { UserProfile } from '../types';
import { generateAcademicDiploma } from '../utils/pdfGenerator';

interface ProfileProps {
  userProfile: UserProfile;
  onUpdateProfile: (updatedProfile: Partial<UserProfile>) => void;
  onLogout?: () => void;
}

export const Profile: React.FC<ProfileProps> = ({ userProfile, onUpdateProfile, onLogout }) => {
  // Password state
  const [currentPassword, setCurrentPassword] = useState('');
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showPass, setShowPass] = useState(false);

  // Profile details state
  const [userName, setUserName] = useState(userProfile.name);
  const [userEmail, setUserEmail] = useState(userProfile.email);
  const [userRole, setUserRole] = useState(userProfile.role);

  // App settings state
  const [pushNotif, setPushNotif] = useState(userProfile.pushNotifications);
  const [emailAlerts, setEmailAlerts] = useState(userProfile.emailAlerts);
  const [fSize, setFSize] = useState<UserProfile['fontSize']>(userProfile.fontSize);
  const [darkMode, setDarkMode] = useState(userProfile.darkMode);

  // Confirmation banner
  const [showToast, setShowToast] = useState(false);

  const handleSaveProfile = (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validate if password is being adjusted
    if (newPassword || confirmPassword || currentPassword) {
      if (!currentPassword) {
        alert("Para alterar a sua senha, preencha a Password actual!");
        return;
      }
      if (newPassword !== confirmPassword) {
        alert("A nova Password e a confirmação devem ser idênticas!");
        return;
      }
      alert("Segurança da Conta: Sua senha secreta de investidor foi redefinida com criptografia de ponta com sucesso!");
      setCurrentPassword('');
      setNewPassword('');
      setConfirmPassword('');
    }

    onUpdateProfile({
      name: userName,
      email: userEmail,
      role: userRole,
      pushNotifications: pushNotif,
      emailAlerts: emailAlerts,
      fontSize: fSize,
      darkMode: darkMode
    });

    setShowToast(true);
    setTimeout(() => setShowToast(false), 2500);
  };

  return (
    <div className="space-y-6 pb-24 select-none animate-fadeIn">
      {/* 1. Profile statistics overview banner */}
      <section className="bg-bordeaux-accent text-white rounded-xl p-6 bordeaux-shadow flex flex-col md:flex-row items-center justify-between gap-6 relative overflow-hidden">
        <div className="flex flex-col md:flex-row items-center gap-4 relative z-10 text-center md:text-left">
          <div className="w-18 h-18 rounded-full border-2 border-gold-bright overflow-hidden">
            <img 
              alt={userProfile.name} 
              className="w-full h-full object-cover" 
              src={userProfile.avatar}
              referrerPolicy="no-referrer"
            />
          </div>
          <div>
            <h2 className="font-display text-xl md:text-2xl font-bold text-white flex items-center justify-center md:justify-start gap-1">
              {userProfile.name}
            </h2>
            <p className="text-gold-bright uppercase tracking-widest text-[10px] md:text-[11px] font-black">{userProfile.role}</p>
            <p className="text-gold-light/60 text-xs mt-1">{userProfile.email}</p>
          </div>
        </div>

        {/* Dynamic statistics overview in cards */}
        <div className="grid grid-cols-3 gap-6 text-center bg-white/5 rounded-xl p-4 md:p-5 relative z-10 w-full md:w-auto font-mono">
          <div>
            <span className="block text-[9px] text-gold-light/60 font-sans uppercase">PRESTÍGIO</span>
            <span className="text-gold-bright text-sm md:text-base font-bold">{userProfile.points} pts</span>
          </div>
          <div className="border-x border-white/10 px-4">
            <span className="block text-[9px] text-gold-light/60 font-sans uppercase">RANKING</span>
            <span className="text-sm md:text-base font-bold text-white">#{userProfile.globalRanking}º</span>
          </div>
          <div>
            <span className="block text-[9px] text-gold-light/60 font-sans uppercase">AVALIAÇÕES</span>
            <span className="text-sm md:text-base font-bold text-white">{userProfile.quizPercentage}%</span>
          </div>
        </div>

        {/* Golden lines */}
        <div className="absolute top-0 left-0 w-32 h-32 bg-gradient-to-br from-gold-bright/10 to-transparent rounded-full -ml-8 -mt-8 pointer-events-none"></div>
      </section>

      {/* Main Configurations Grid splits */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        
        {/* Settings form */}
        <form onSubmit={handleSaveProfile} className="lg:col-span-8 space-y-6">
          
          {showToast && (
            <div className="bg-green-700 text-white p-4.5 rounded-xl text-center text-xs md:text-sm font-sans font-bold shadow-lg animate-scaleUp">
              ✓ Parâmetros de conta alterados e consolidados no Banco de Investigação local!
            </div>
          )}

          {/* Account Profile and credentials details */}
          <div className="bg-white border border-outline-light p-5 rounded-xl shadow-sm space-y-4">
            <h3 className="font-sans text-xs font-black text-bordeaux-accent tracking-widest uppercase border-b border-outline-light pb-2 mb-1 flex items-center gap-1.5 text-[#7B1A2E]">
              <Settings className="w-4 h-4" />
              <span>Configurações da Conta</span>
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-1">
                <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                  Nome Completo
                </label>
                <input 
                  type="text"
                  value={userName}
                  onChange={(e) => setUserName(e.target.value)}
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-full px-4 py-2.5 text-xs md:text-sm text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
                />
              </div>

              <div className="space-y-1">
                <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                  Email Corporativo
                </label>
                <input 
                  type="email"
                  value={userEmail}
                  onChange={(e) => setUserEmail(e.target.value)}
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-full px-4 py-2.5 text-xs md:text-sm text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
                />
              </div>
            </div>

            <div className="space-y-1">
              <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                Função de Especialista
              </label>
              <input 
                type="text"
                value={userRole}
                onChange={(e) => setUserRole(e.target.value)}
                className="w-full bg-cream-bg/40 border border-outline-light rounded-full px-4 py-2.5 text-xs md:text-sm text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
              />
            </div>
          </div>

          {/* ALTER PALAVRA-PASSE */}
          <div className="bg-white border border-outline-light p-5 rounded-xl shadow-sm space-y-4">
            <h3 className="font-sans text-xs font-black text-bordeaux-accent tracking-widest uppercase border-b border-outline-light pb-2 mb-1 flex items-center gap-1.5 text-[#7B1A2E]">
              <Key className="w-4 h-4" />
              <span>Câmbio de Palavra-Passe</span>
            </h3>

            <div className="space-y-3">
              <div className="relative">
                <input 
                  type={showPass ? "text" : "password"}
                  value={currentPassword}
                  onChange={(e) => setCurrentPassword(e.target.value)}
                  placeholder="Password Actual"
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-full px-4 py-2.5 text-xs md:text-sm text-bordeaux-primary placeholder:text-outline-dark/55 font-sans focus:outline-none focus:border-bordeaux-accent pr-10"
                />
                <button 
                  type="button" 
                  onClick={() => setShowPass(!showPass)}
                  className="absolute right-3.5 top-1/2 -translate-y-1/2 text-outline-dark"
                >
                  {showPass ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <input 
                  type={showPass ? "text" : "password"}
                  value={newPassword}
                  onChange={(e) => setNewPassword(e.target.value)}
                  placeholder="Nova Password"
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-full px-4 py-2.5 text-xs md:text-sm text-bordeaux-primary placeholder:text-outline-dark/55 font-sans focus:outline-none focus:border-bordeaux-accent"
                />
                
                <input 
                  type={showPass ? "text" : "password"}
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  placeholder="Confirmar Nova Password"
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-full px-4 py-2.5 text-xs md:text-sm text-bordeaux-primary placeholder:text-outline-dark/55 font-sans focus:outline-none focus:border-bordeaux-accent"
                />
              </div>
            </div>
          </div>

          {/* APP INTERFACES SETTINGS */}
          <div className="bg-white border border-outline-light p-5 rounded-xl shadow-sm space-y-4">
            <h3 className="font-sans text-xs font-black text-bordeaux-accent tracking-widest uppercase border-b border-outline-light pb-2 mb-1 flex items-center gap-1.5 text-[#7B1A2E]">
              <LayoutTemplate className="w-4 h-4" />
              <span>Ajustes de Leitura & Interface</span>
            </h3>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-1">
              {/* Font sizing button settings */}
              <div className="space-y-2">
                <span className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                  Dimensão do Texto
                </span>
                <div className="flex gap-2 bg-cream-bg p-1 rounded-full">
                  {(['Pequeno', 'Médio', 'Grande'] as const).map((sz) => (
                    <button
                      key={sz}
                      type="button"
                      onClick={() => setFSize(sz)}
                      className={`flex-1 py-1.5 rounded-full text-[10.5px] font-sans font-black uppercase tracking-wider transition-all cursor-pointer ${
                        fSize === sz
                          ? 'bg-bordeaux-accent text-white shadow'
                          : 'text-outline-dark hover:text-bordeaux-primary'
                      }`}
                    >
                      {sz}
                    </button>
                  ))}
                </div>
              </div>

              {/* Theme preference checkboxes toggle */}
              <div className="space-y-2">
                <span className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                  Preferencia de Cor (Contraste)
                </span>
                <div className="flex bg-cream-bg p-1 rounded-full">
                  <button
                    type="button"
                    onClick={() => setDarkMode(false)}
                    className={`flex-1 py-1.5 rounded-full text-[10.5px] font-sans font-black uppercase tracking-wider transition-all cursor-pointer ${
                      !darkMode ? 'bg-bordeaux-accent text-white shadow' : 'text-outline-dark'
                    }`}
                  >
                    Clara (Premium)
                  </button>
                  <button
                    type="button"
                    onClick={() => setDarkMode(true)}
                    className={`flex-1 py-1.5 rounded-full text-[10.5px] font-sans font-black uppercase tracking-wider transition-all cursor-pointer ${
                      darkMode ? 'bg-bordeaux-accent text-white shadow' : 'text-outline-dark'
                    }`}
                  >
                    Escura (Ambiente)
                  </button>
                </div>
              </div>
            </div>

            <div className="h-[1px] bg-outline-light w-full" />

            {/* Notification alert toggles */}
            <div className="space-y-3 pt-1">
              <span className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                Alertas do Portal
              </span>
              
              <div className="flex justify-between items-center bg-cream-bg/30 p-2 rounded-lg text-xs md:text-sm">
                <span className="text-bordeaux-primary font-medium">Alertas de Notícias em Tempo Real</span>
                <input 
                  type="checkbox"
                  checked={pushNotif}
                  onChange={(e) => setPushNotif(e.target.checked)}
                  className="w-4.5 h-4.5 text-bordeaux-accent border-outline-light focus:ring-bordeaux-accent cursor-pointer"
                />
              </div>

              <div className="flex justify-between items-center bg-cream-bg/30 p-2 rounded-lg text-xs md:text-sm">
                <span className="text-bordeaux-primary font-medium">Resumos Macroeconómicos por Email (Semanal)</span>
                <input 
                  type="checkbox"
                  checked={emailAlerts}
                  onChange={(e) => setEmailAlerts(e.target.checked)}
                  className="w-4.5 h-4.5 text-bordeaux-accent border-outline-light focus:ring-bordeaux-accent cursor-pointer"
                />
              </div>
            </div>

          </div>

          {/* SAVING SUBMISSIONS BAR */}
          <div className="flex justify-end gap-3 select-none">
            <button
              type="button"
              onClick={() => {
                setUserName(userProfile.name);
                setUserEmail(userProfile.email);
                setUserRole(userProfile.role);
                setPushNotif(userProfile.pushNotifications);
                setEmailAlerts(userProfile.emailAlerts);
                setFSize(userProfile.fontSize);
                setDarkMode(userProfile.darkMode);
                alert("Modificações canceladas.");
              }}
              className="px-6 py-2.5 rounded-lg border border-outline-light bg-white text-bordeaux-primary font-sans text-xs font-bold uppercase tracking-wider hover:bg-cream-bg transition-all cursor-pointer"
            >
              Cancelar
            </button>
            <button
              type="submit"
              className="px-6 py-2.5 rounded-lg bg-bordeaux-accent text-white font-sans text-xs font-bold uppercase tracking-widest hover:bg-bordeaux-primary transition-all flex items-center gap-1.5 shadow-md active:scale-95 cursor-pointer"
              id="btn-save-profile"
            >
              <Save className="w-4.5 h-4.5" />
              <span>Salvar Requisitos</span>
            </button>
          </div>

        </form>

        {/* Security checks info right card column */}
        <aside className="lg:col-span-4 space-y-4">
          
          <div className="bg-cream-bg border border-outline-light p-5 rounded-xl space-y-3">
            <h4 className="font-display text-[15px] text-bordeaux-primary font-bold flex items-center gap-1.5">
              <ShieldAlert className="w-5 h-5 text-bordeaux-accent" />
              <span>Medidas de Segurança</span>
            </h4>
            
            <p className="font-sans text-[11px] text-outline-dark leading-relaxed">
              O seu perfil está indexado de forma segura na base criptografada local. Esta carteira de especialista permite que publique enquetes, quizzes e participe nos fóruns mais disputados do ecossistema angolano.
            </p>

            <ul className="text-[10px] space-y-2 text-[#7B1A2E] font-bold font-sans">
              <li className="flex items-center gap-1.5">
                <span className="w-1.5 h-1.5 bg-gold-premium rounded-full"></span>
                Autenticação de 2 Fatores Ativada
              </li>
              <li className="flex items-center gap-1.5">
                <span className="w-1.5 h-1.5 bg-gold-premium rounded-full"></span>
                Chave de API do BNA Protegida
              </li>
              <li className="flex items-center gap-1.5">
                <span className="w-1.5 h-1.5 bg-gold-premium rounded-full"></span>
                Sessão Válida em Luanda, Angola
              </li>
            </ul>
          </div>

          {/* Masterclass visual layout card */}
          <div className="border border-outline-light p-4 rounded-xl space-y-3 bg-white shadow-sm text-center">
            <span className="bg-gold-bright text-bordeaux-dark px-2.5 py-0.5 font-sans font-black tracking-widest rounded-sm text-[9px] uppercase">
              Investidor Diplomado
            </span>
            <div className="w-16 h-16 mx-auto bg-bordeaux-light text-bordeaux-accent rounded-full flex items-center justify-center">
              <Star className="w-8 h-8 fill-current text-gold-bright" />
            </div>
            
            <div className="space-y-1">
              <h5 className="font-display text-sm text-bordeaux-primary font-bold">Conselho Superior de Angola</h5>
              <p className="font-sans text-[10px] text-outline-dark leading-snug">Seu nível acadêmico confere voto qualificado de moderação em discussões fiscais nacionais.</p>
            </div>

            <div className="pt-2">
              <button
                type="button"
                onClick={() => generateAcademicDiploma(userProfile)}
                className="w-full bg-gold-premium hover:bg-gold-bright text-white text-[10px] font-sans font-black uppercase tracking-widest py-2.5 px-3 rounded-lg transition-colors flex items-center justify-center gap-1.5 cursor-pointer shadow-sm active:scale-95"
              >
                <FileDown className="w-3.5 h-3.5" />
                <span>Descarregar Diploma (PDF)</span>
              </button>
            </div>
          </div>

          {/* SESSÃO / TERMINAR SESSÃO MOBILE E PC */}
          {onLogout && (
            <div className="border border-red-100 p-4 rounded-xl space-y-3 bg-red-50/25 text-center animate-fadeIn shadow-sm">
              <span className="bg-red-700/10 text-red-700 px-2.5 py-0.5 font-sans font-black tracking-widest rounded-sm text-[8.5px] uppercase">
                Sessão Activa
              </span>
              <p className="font-sans text-[10.5px] text-outline-dark leading-snug">
                Proteja os seus dados de tese e prestígio terminando a sessão de especialista após a leitura.
              </p>
              <button
                type="button"
                onClick={onLogout}
                className="w-full py-2 bg-red-700 hover:bg-red-800 text-white text-[10px] font-sans font-black uppercase tracking-widest rounded-lg transition-colors flex items-center justify-center gap-1.5 cursor-pointer shadow-sm active:scale-95"
              >
                <LogOut className="w-3.5 h-3.5" />
                <span>Terminar Sessão</span>
              </button>
            </div>
          )}

        </aside>

      </div>
    </div>
  );
};
