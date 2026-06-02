import React, { useState } from 'react';
import { motion } from 'motion/react';
import { 
  ShieldCheck, 
  Key, 
  Mail, 
  User, 
  TrendingUp, 
  Compass, 
  Award, 
  MessageSquare, 
  Eye, 
  EyeOff, 
  ArrowRight, 
  Landmark, 
  Sparkles, 
  CheckCircle, 
  AlertCircle 
} from 'lucide-react';
import { UserProfile } from '../types';

interface AuthScreenProps {
  onLoginSuccess: (user: UserProfile) => void;
  defaultUser: UserProfile;
}

const PRESET_AVATARS = [
  "https://lh3.googleusercontent.com/aida-public/AB6AXuA68R2rTuyHKXVi5cE5Ar_3R5_UqHQN2_1G90Fm0-DQRTGngIr7ePAOoWdkjLr0NXyZwUSzqFO-cTWPamdrGHiy2cxXS5TE7U0NKMZqZaMzaHKJmsAREqyJXHjsEyIL7GGsJxh8XRS9aX6UaJ-UfYOKBjle48S94K4vAOSlBhomnpeh9yFy0sdGIgf3qITEp1eoDQDXLnOjWbXaIzFu7UtCF0teY0-5jB9xlB-yxTEn0U3ix6gxENkTz8yE-eVTIysmKzuPJzfQiBI",
  "https://lh3.googleusercontent.com/aida-public/AB6AXuAWtBzHbaRAh_C7aLGTLc-TOtqRBplKYlIyxC-BmGbCc9blfoVwOluJ86rlFcL1PJNoBckw_JLivlFdgrQUpFsyFe6owsTdUKZrL0sWMouoy3ObPjQd8rLbu2PtHr2aDQG_pLkb_jKsJwdLn-O2-SwfrJJwZXui7FbdUK2PFOJqDw01E4RGQ-wXLUnBGcZzvYygdZnMJwRJ2lEZ_pTbrV_CVfUbQT7wDJ-bXpAm8sW9yFdMY9ONs9L7C47-HRpbwQm7a25mUHeOMyY",
  "https://lh3.googleusercontent.com/aida-public/AB6AXuCDPCZfnnY0O0HuKxvfqwnot0eZUptlqLxE2nJIGWf-s5yTCA1DXaQTdRb6Wo1E1Q0IF_sFR_P_k2vHkkABrhLe-4lygAQx2fvxPhngKeCX8o33p5aT_H3RGaV9xojkiCgachI8RBOj4m0aGhYvbVyhoSRE2MJbmOD25N-JYuYNUlhY74cH3pjN34yq5HGCX5d5Hhegj4txbfyrReQERyFQhkgHxZWitcy2Z3_dLvFhSkYfWTak4tFdV3gEDPZJt2pGXEEexQdSxwo",
  "https://lh3.googleusercontent.com/aida-public/AB6AXuBkbC600SJW-jdmdRsM49njBOZTPk0RUzWVW7zWDz6HXaMbt1dypDljLEOvyIMzJz6Z35rQM383Ij7IfT_Eg2cBdvM89hWanDUvnj_wROzMbowtnD3y3StOxqkegcjCog7pLVkiBaFy0kn-9nMRR8GSmVziRwt5_BGNnVdYhfs2Reb6jxhKRZ7zC7Ox0R_WZ8qIrpiMeUth0QnT57uQHSUpBE3LMDOCs_B95Qqd6Rjr879vZGOiOWxsh9mEIDcD1zVtshRXbXmGOu0"
];

export const AuthScreen: React.FC<AuthScreenProps> = ({ onLoginSuccess, defaultUser }) => {
  // auth mode: 'landing' | 'login' | 'register'
  const [authMode, setAuthMode] = useState<'landing' | 'login' | 'register'>('landing');
  
  // Login form inputs
  const [loginEmail, setLoginEmail] = useState('');
  const [loginPassword, setLoginPassword] = useState('');
  const [showLoginPassword, setShowLoginPassword] = useState(false);
  const [loginError, setLoginError] = useState('');

  // Register form inputs
  const [regName, setRegName] = useState('');
  const [regEmail, setRegEmail] = useState('');
  const [regRole, setRegRole] = useState('Especialista Júnior');
  const [regPassword, setRegPassword] = useState('');
  const [regConfirmPassword, setRegConfirmPassword] = useState('');
  const [selectedAvatarIdx, setSelectedAvatarIdx] = useState(0);
  const [showRegPassword, setShowRegPassword] = useState(false);
  const [regError, setRegError] = useState('');
  const [regSuccess, setRegSuccess] = useState('');

  const handleDemoSignIn = () => {
    // Sign-in with default simulated user instantly 
    onLoginSuccess({
      ...defaultUser,
      name: "Carlos Lopes",
      email: "carlos.lopes@angolaeconomica.ao",
      role: "Investidor Nível III"
    });
  };

  const handleCustomLogin = (e: React.FormEvent) => {
    e.preventDefault();
    setLoginError('');

    if (!loginEmail || !loginPassword) {
      setLoginError('Por favor, preencha todos os campos obrigatórios.');
      return;
    }

    if (!loginEmail.includes('@') || loginEmail.length < 5) {
      setLoginError('Por favor, insira um email corporativo válido.');
      return;
    }

    if (loginPassword.length < 4) {
      setLoginError('A sua senha provisória deve conter pelo menos 4 caracteres.');
      return;
    }

    // Capture custom name from local storage if they registered before, or default
    const savedUsersStr = localStorage.getItem('ao_economy_portal_users');
    let authenticatedUser: UserProfile = { ...defaultUser };
    
    if (savedUsersStr) {
      const savedUsersList = JSON.parse(savedUsersStr) as Array<UserProfile & { password?: string }>;
      const matched = savedUsersList.find(u => u.email.toLowerCase() === loginEmail.toLowerCase());
      if (matched) {
        if (matched.password && matched.password !== loginPassword) {
          setLoginError('A palavra-passe inserida está incorreta.');
          return;
        }
        authenticatedUser = matched;
      } else {
        // Log in as new auto-generated profile mapped to their typed email
        const displayParts = loginEmail.split('@')[0];
        const formattedName = displayParts.charAt(0).toUpperCase() + displayParts.slice(1).replace('.', ' ');
        authenticatedUser = {
          ...defaultUser,
          name: formattedName,
          email: loginEmail,
          role: "Especialista Adjunto"
        };
      }
    } else {
      // Direct login simulation
      if (loginEmail.toLowerCase() === defaultUser.email.toLowerCase()) {
        authenticatedUser = defaultUser;
      } else {
        const displayParts = loginEmail.split('@')[0];
        const formattedName = displayParts.charAt(0).toUpperCase() + displayParts.slice(1).replace('.', ' ');
        authenticatedUser = {
          ...defaultUser,
          name: formattedName,
          email: loginEmail,
          role: "Analista Independente"
        };
      }
    }

    onLoginSuccess(authenticatedUser);
  };

  const handleCustomRegister = (e: React.FormEvent) => {
    e.preventDefault();
    setRegError('');
    setRegSuccess('');

    if (!regName || !regEmail || !regPassword || !regConfirmPassword) {
      setRegError('Existem dados fundamentais em falta no formulário.');
      return;
    }

    if (regPassword !== regConfirmPassword) {
      setRegError('A palavra-passe e a respectiva confirmação não correspondem.');
      return;
    }

    if (regPassword.length < 4) {
      setRegError('Escolha uma palavra-passe de segurança mais robusta (mínimo 4 caracteres).');
      return;
    }

    // Save profile to simulated db
    const newRegisteredProfile: UserProfile & { password?: string } = {
      name: regName,
      email: regEmail,
      role: regRole,
      avatar: PRESET_AVATARS[selectedAvatarIdx],
      points: 100, // start premium points
      globalRanking: 34,
      quizPercentage: 0,
      savedArticlesCount: 0,
      commentsCount: 0,
      pushNotifications: true,
      emailAlerts: true,
      darkMode: false,
      fontSize: 'Médio',
      password: regPassword
    };

    // Store in localStorage db array
    const savedUsersStr = localStorage.getItem('ao_economy_portal_users');
    const savedUsersList = savedUsersStr ? JSON.parse(savedUsersStr) : [];
    
    // Check duplication
    const emailExists = savedUsersList.some((u: any) => u.email.toLowerCase() === regEmail.toLowerCase());
    if (emailExists) {
      setRegError('Este endereço de email já se encontra qualificado para outro especialista.');
      return;
    }

    savedUsersList.push(newRegisteredProfile);
    localStorage.setItem('ao_economy_portal_users', JSON.stringify(savedUsersList));

    setRegSuccess('Conta qualificada com preceito académico! Encaminhando para acesso seguro...');
    
    setTimeout(() => {
      onLoginSuccess(newRegisteredProfile);
    }, 1500);
  };

  return (
    <div className="min-h-screen bg-cream-bg flex flex-col items-center justify-center p-4 relative overflow-hidden select-none">
      
      {/* Background Ornaments */}
      <div className="absolute top-0 right-0 w-[40rem] h-[40rem] bg-gradient-to-br from-gold-light/10 to-transparent rounded-full -mr-32 -mt-32 pointer-events-none"></div>
      <div className="absolute bottom-0 left-0 w-[30rem] h-[30rem] bg-gradient-to-tr from-bordeaux-light/40 to-transparent rounded-full -ml-32 -mb-32 pointer-events-none"></div>

      {/* Main Container Card */}
      <div className="w-full max-w-lg bg-white border border-outline-light rounded-2xl shadow-xl overflow-hidden relative z-10">
        
        {/* Superior golden accent stripe & credentials title */}
        <div className="bg-bordeaux-primary px-6 py-5 flex flex-col items-center text-center relative">
          <span className="w-9 h-9 bg-bordeaux-accent text-gold-bright flex items-center justify-center rounded-sm font-bold text-xl font-display mb-1.5 border border-gold-premium/40">
            B
          </span>
          <h1 className="font-display text-lg md:text-xl text-white font-extrabold tracking-tight">
            BIBLIOTECA & FÓRUM ECONÓMICO
          </h1>
          <p className="text-gold-bright text-[9px] uppercase tracking-widest font-black mt-0.5">
            Plataforma Superior de Estudos Monetários de Angola
          </p>
          <div className="absolute bottom-0 left-0 right-0 h-1 bg-gradient-to-r from-gold-premium via-gold-bright to-gold-premium"></div>
        </div>

        {/* 1. LANDING WELCOME PAGE */}
        {authMode === 'landing' && (
          <motion.div 
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="p-6 md:p-8 space-y-6"
          >
            <div className="text-center space-y-2">
              <h2 className="font-display text-xl text-bordeaux-primary font-bold">
                Bem-vindo à vanguarda da conjuntura nacional
              </h2>
              <p className="text-xs text-outline-dark leading-relaxed max-w-sm mx-auto">
                Espaço de análise especializado em políticas de câmbio, mercados do tesouro, índices habitacionais, mineração e commodities agrícolas em Angola.
              </p>
            </div>

            {/* Feature presentation lists */}
            <div className="space-y-3 bg-cream-bg/50 p-4.5 rounded-xl border border-outline-light/60">
              <div className="flex items-start gap-3">
                <div className="p-1.5 bg-bordeaux-light text-bordeaux-accent rounded-lg mt-0.5">
                  <Compass className="w-4 h-4" />
                </div>
                <div>
                  <h4 className="font-sans text-xs font-black text-bordeaux-primary uppercase tracking-wider">Acervo Científico</h4>
                  <p className="text-[11px] text-outline-dark mt-0.5 leading-snug">Monografias dedicadas às decisões do BNA e dinâmica de liquidez soberana nos mercados.</p>
                </div>
              </div>

              <div className="flex items-start gap-3">
                <div className="p-1.5 bg-bordeaux-light text-bordeaux-accent rounded-lg mt-0.5">
                  <Award className="w-4 h-4" />
                </div>
                <div>
                  <h4 className="font-sans text-xs font-black text-bordeaux-primary uppercase tracking-wider">Quizzes de Sabedoria</h4>
                  <p className="text-[11px] text-outline-dark mt-0.5 leading-snug">Avalie o seu conhecimento histórico kwanza-dólar e consolide o seu posicionamento global.</p>
                </div>
              </div>

              <div className="flex items-start gap-3">
                <div className="p-1.5 bg-bordeaux-light text-bordeaux-accent rounded-lg mt-0.5">
                  <MessageSquare className="w-4 h-4" />
                </div>
                <div>
                  <h4 className="font-sans text-xs font-black text-bordeaux-primary uppercase tracking-wider">Fórum de Especialistas</h4>
                  <p className="text-[11px] text-outline-dark mt-0.5 leading-snug">Troque teses de investimento doméstico e debata as decisões de balanço com voto qualificado.</p>
                </div>
              </div>
            </div>

            {/* Double buttons CTAs */}
            <div className="space-y-2.5">
              <button
                onClick={() => setAuthMode('login')}
                className="w-full bg-bordeaux-accent text-white py-3 rounded-xl font-sans text-xs font-black uppercase tracking-widest hover:bg-bordeaux-primary transition-all flex items-center justify-center gap-1.5 cursor-pointer shadow-md"
              >
                <span>Aceder como Especialista</span>
                <ArrowRight className="w-4 h-4" />
              </button>

              <button
                onClick={() => setAuthMode('register')}
                className="w-full bg-white border border-outline-light hover:border-bordeaux-accent text-bordeaux-primary py-3 rounded-xl font-sans text-xs font-black uppercase tracking-widest transition-all cursor-pointer"
              >
                Registar Nova Conta
              </button>
            </div>

            {/* Automatic Guest demonstration CTA */}
            <div className="pt-3 border-t border-cream-bg text-center">
              <button
                onClick={handleDemoSignIn}
                className="text-[11px] text-gold-premium hover:text-bordeaux-accent transition-colors font-bold font-sans uppercase tracking-wider cursor-pointer"
              >
                Acesso Instantâneo Demo (Carlos Lopes)
              </button>
            </div>
          </motion.div>
        )}

        {/* 2. SECURE LOGIN VIEW */}
        {authMode === 'login' && (
          <motion.div
            initial={{ opacity: 0, x: -10 }}
            animate={{ opacity: 1, x: 0 }}
            className="p-6 md:p-8 space-y-6"
          >
            <div className="text-center space-y-1">
              <h2 className="font-display text-lg text-bordeaux-primary font-bold">Introduzir Credenciais de Acesso</h2>
              <p className="text-xs text-outline-dark">Use as credenciais corporativas registadas.</p>
            </div>

            {loginError && (
              <div className="bg-red-50 text-red-800 p-3 rounded-lg flex items-center gap-2 text-xs font-medium border border-red-100 select-none">
                <AlertCircle className="w-4 h-4 shrink-0" />
                <span>{loginError}</span>
              </div>
            )}

            <form onSubmit={handleCustomLogin} className="space-y-4">
              <div className="space-y-1">
                <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                  Email Cooperativo de Investidor
                </label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 -translate-y-1/2 text-outline-dark/70 w-4 h-4" />
                  <input
                    type="email"
                    value={loginEmail}
                    onChange={(e) => setLoginEmail(e.target.value)}
                    placeholder="exemplo@angolaeconomica.ao"
                    className="w-full bg-cream-bg/40 border border-outline-light rounded-xl pl-9 pr-4 py-2.5 text-xs text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
                  />
                </div>
              </div>

              <div className="space-y-1">
                <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans flex justify-between h-4">
                  <span>Senha de Segurança</span>
                </label>
                <div className="relative">
                  <Key className="absolute left-3 top-1/2 -translate-y-1/2 text-outline-dark/70 w-4 h-4" />
                  <input
                    type={showLoginPassword ? "text" : "password"}
                    value={loginPassword}
                    onChange={(e) => setLoginPassword(e.target.value)}
                    placeholder="Mínimo 4 dígitos"
                    className="w-full bg-cream-bg/40 border border-outline-light rounded-xl pl-9 pr-10 py-2.5 text-xs text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
                  />
                  <button
                    type="button"
                    onClick={() => setShowLoginPassword(!showLoginPassword)}
                    className="absolute right-3.5 top-1/2 -translate-y-1/2 text-outline-dark hover:text-bordeaux-accent transition-colors cursor-pointer"
                  >
                    {showLoginPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                  </button>
                </div>
              </div>

              {/* Action Buttons */}
              <button
                type="submit"
                className="w-full bg-bordeaux-accent text-white py-3 rounded-xl font-sans text-xs font-black uppercase tracking-widest hover:bg-bordeaux-primary transition-all cursor-pointer shadow-md mt-2"
              >
                Iniciar Sessão Segura
              </button>
            </form>

            <div className="flex flex-col gap-3 pt-4 border-t border-cream-bg text-center text-xs">
              <div className="flex justify-between items-center text-[11px] font-bold uppercase tracking-wider">
                <button
                  type="button"
                  onClick={() => setAuthMode('register')}
                  className="text-bordeaux-accent hover:underline cursor-pointer"
                >
                  Registar Nova Conta
                </button>
                <button
                  type="button"
                  onClick={() => setAuthMode('landing')}
                  className="text-outline-dark hover:text-bordeaux-primary cursor-pointer"
                >
                  Voltar para Boas-vindas
                </button>
              </div>

              <div className="bg-gold-light/20 border border-gold-premium/30 rounded-xl p-3 flex justify-between items-center text-left">
                <div className="leading-tight">
                  <span className="block text-[9.5px] font-sans font-black text-bordeaux-primary uppercase tracking-wide">Acesso de Demonstração</span>
                  <p className="text-[9px] text-outline-dark mt-0.5">Aceda como Carlos Lopes Instantaneamente </p>
                </div>
                <button
                  onClick={handleDemoSignIn}
                  type="button"
                  className="bg-gold-premium hover:bg-gold-bright text-white text-[9px] font-sans font-black uppercase tracking-widest py-1.5 px-3 rounded-lg transition-colors cursor-pointer"
                >
                  CONECTAR
                </button>
              </div>
            </div>
          </motion.div>
        )}

        {/* 3. SIGN UP / REGISTER ACCOUNT */}
        {authMode === 'register' && (
          <motion.div
            initial={{ opacity: 0, x: 10 }}
            animate={{ opacity: 1, x: 0 }}
            className="p-6 md:p-8 space-y-5"
          >
            <div className="text-center space-y-1">
              <h2 className="font-display text-lg text-bordeaux-primary font-bold">Qualificar Perfil de Especialista</h2>
              <p className="text-xs text-outline-dark">Preencha os dados oficiais na rede de cooperação de Luanda.</p>
            </div>

            {regError && (
              <div className="bg-red-50 text-red-800 p-3 rounded-lg flex items-center gap-2 text-xs font-medium border border-red-100 select-none animate-fadeIn">
                <AlertCircle className="w-4 h-4 shrink-0" />
                <span>{regError}</span>
              </div>
            )}

            {regSuccess && (
              <div className="bg-green-50 text-green-800 p-3 rounded-lg flex items-center gap-2 text-xs font-bold border border-green-100 select-none animate-scaleUp">
                <CheckCircle className="w-4 h-4 shrink-0 text-green-600" />
                <span>{regSuccess}</span>
              </div>
            )}

            <form onSubmit={handleCustomRegister} className="space-y-3.5">
              
              {/* Profile Avatar Selection Carousel */}
              <div className="space-y-1.5">
                <span className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans text-center">
                  Selecione a sua Identidade Visual (Avatar)
                </span>
                <div className="flex justify-center gap-3 py-1">
                  {PRESET_AVATARS.map((av, idx) => (
                    <button
                      key={idx}
                      type="button"
                      onClick={() => setSelectedAvatarIdx(idx)}
                      className={`w-11 h-11 rounded-full overflow-hidden border-2 transition-all p-0.5 cursor-pointer ${
                        selectedAvatarIdx === idx 
                          ? 'border-gold-bright scale-105 shadow-md bg-bordeaux-light' 
                          : 'border-outline-light/60 hover:border-outline-dark opacity-75'
                      }`}
                    >
                      <img src={av} alt={`Avatar ${idx}`} className="w-full h-full object-cover rounded-full" referrerPolicy="no-referrer" />
                    </button>
                  ))}
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                <div className="space-y-1">
                  <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                    Nome Completo
                  </label>
                  <div className="relative">
                    <User className="absolute left-2.5 top-1/2 -translate-y-1/2 text-outline-dark/70 w-3.5 h-3.5" />
                    <input
                      type="text"
                      value={regName}
                      onChange={(e) => setRegName(e.target.value)}
                      placeholder="Ex: Pedro Miguel"
                      className="w-full bg-cream-bg/40 border border-outline-light rounded-xl pl-8 pr-3 py-2 text-xs text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
                    />
                  </div>
                </div>

                <div className="space-y-1">
                  <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                    Email Corporativo
                  </label>
                  <div className="relative">
                    <Mail className="absolute left-2.5 top-1/2 -translate-y-1/2 text-outline-dark/70 w-3.5 h-3.5" />
                    <input
                      type="email"
                      value={regEmail}
                      onChange={(e) => setRegEmail(e.target.value)}
                      placeholder="pedro.m@uniluanda.ao"
                      className="w-full bg-cream-bg/40 border border-outline-light rounded-xl pl-8 pr-3 py-2 text-xs text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
                    />
                  </div>
                </div>
              </div>

              <div className="space-y-1">
                <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                  Título e Qualificação
                </label>
                <input
                  type="text"
                  value={regRole}
                  onChange={(e) => setRegRole(e.target.value)}
                  placeholder="Ex: Auditor de Risco / Estudante de Economia"
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-xl px-4 py-2 text-xs text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                <div className="space-y-1">
                  <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                    Senha
                  </label>
                  <div className="relative">
                    <Key className="absolute left-2.5 top-1/2 -translate-y-1/2 text-outline-dark/70 w-3.5 h-3.5" />
                    <input
                      type={showRegPassword ? "text" : "password"}
                      value={regPassword}
                      onChange={(e) => setRegPassword(e.target.value)}
                      placeholder="Mínimo 4 dig."
                      className="w-full bg-cream-bg/40 border border-outline-light rounded-xl pl-8 pr-8 py-2 text-xs text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
                    />
                    <button
                      type="button"
                      onClick={() => setShowRegPassword(!showRegPassword)}
                      className="absolute right-2.5 top-1/2 -translate-y-1/2 text-outline-dark hover:text-bordeaux-accent transition-colors cursor-pointer"
                    >
                      {showRegPassword ? <EyeOff className="w-3.5 h-3.5" /> : <Eye className="w-3.5 h-3.5" />}
                    </button>
                  </div>
                </div>

                <div className="space-y-1">
                  <label className="block text-[10px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                    Confirmar Senha
                  </label>
                  <input
                    type={showRegPassword ? "text" : "password"}
                    value={regConfirmPassword}
                    onChange={(e) => setRegConfirmPassword(e.target.value)}
                    placeholder="Repita a senha"
                    className="w-full bg-cream-bg/40 border border-outline-light rounded-xl px-4 py-2 text-xs text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent"
                  />
                </div>
              </div>

              <button
                type="submit"
                className="w-full bg-bordeaux-accent text-white py-3 rounded-xl font-sans text-xs font-black uppercase tracking-widest hover:bg-bordeaux-primary transition-all cursor-pointer shadow-md mt-2"
              >
                Ativar Investidor Diplomado
              </button>
            </form>

            <div className="flex justify-between items-center text-[11px] font-bold uppercase tracking-wider pt-3 border-t border-cream-bg">
              <button
                type="button"
                onClick={() => setAuthMode('login')}
                className="text-bordeaux-accent hover:underline cursor-pointer"
              >
                Voltar à página de login
              </button>
              <button
                type="button"
                onClick={() => setAuthMode('landing')}
                className="text-outline-dark hover:text-bordeaux-primary cursor-pointer"
              >
                Ver Boas-vindas
              </button>
            </div>
          </motion.div>
        )}

        {/* Footer badge of real state security */}
        <div className="bg-cream-bg px-6 py-4 border-t border-outline-light/60 flex items-center justify-between text-[10px] text-outline-dark select-none">
          <span className="flex items-center gap-1.5 font-bold uppercase text-[9px]">
            <ShieldCheck className="w-3.5 h-3.5 text-gold-premium shrink-0" />
            <span>Encriptação SHA-256</span>
          </span>
          <span className="font-mono text-[9px]">LUANDA IP-SECURE</span>
        </div>

      </div>
    </div>
  );
};
