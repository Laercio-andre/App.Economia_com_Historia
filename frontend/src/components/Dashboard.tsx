import React, { useState } from 'react';
import { TrendingUp, Droplets, Landmark, BarChart3, ChevronRight, FileText, Globe, Share2, Mail, ExternalLink, Sparkles, BookOpen } from 'lucide-react';
import { UserProfile } from '../types';

interface DashboardProps {
  userProfile: UserProfile;
  onNavigate: (tab: string) => void;
  onSelectArticle: (articleId: string) => void;
}

export const Dashboard: React.FC<DashboardProps> = ({ userProfile, onNavigate, onSelectArticle }) => {
  const [showReservesModal, setShowReservesModal] = useState(false);
  const [brentPrice, setBrentPrice] = useState(82.14);
  const [kwanzaUsd, setKwanzaUsd] = useState(924.50);

  // Small interaction simulation: slightly fluctuate commodities on click!
  const stimulateMarket = () => {
    setBrentPrice(prev => parseFloat((prev + (Math.random() * 0.4 - 0.2)).toFixed(2)));
    setKwanzaUsd(prev => parseFloat((prev + (Math.random() * 1.0 - 0.5)).toFixed(2)));
  };

  return (
    <div className="space-y-6 pb-24 select-none animate-fadeIn">
      {/* 1. SECTOR DE DESTAQUE: RESERVAS INTERNACIONAIS */}
      <section 
        onClick={() => setShowReservesModal(true)}
        className="w-full bg-bordeaux-accent text-white rounded-xl p-6 bordeaux-shadow relative overflow-hidden cursor-pointer group transition-all duration-300 hover:scale-[1.01] hover:brightness-105"
      >
        <div className="relative z-10 flex flex-col justify-between h-full">
          <div>
            <span className="bg-gold-bright px-3 py-1 text-bordeaux-dark font-sans text-[10px] font-black tracking-widest rounded-sm inline-block mb-3.5">
              DESTAQUE DO DIA
            </span>
            <p className="font-sans text-[11px] font-semibold text-gold-light tracking-wide mb-1 uppercase">
              RESERVAS INTERNACIONAIS LÍQUIDAS — BNA
            </p>
            <div className="flex items-end gap-3.5 mb-5">
              <h2 className="font-mono text-[36px] md:text-[44px] text-gold-bright font-extrabold leading-none">
                $124.7B
              </h2>
              <span className="bg-green-700 text-white px-2 py-1 rounded font-mono text-[11px] mb-1.5 flex items-center gap-1 font-bold">
                <TrendingUp className="w-3.5 h-3.5" /> +2.8%
              </span>
            </div>
          </div>

          {/* Mini elegant bar charts inside the card */}
          <div className="flex items-end gap-2.5 h-16 w-full max-w-sm">
            <div className="bg-white/10 w-full h-[35%] rounded-t-sm transition-all duration-300 group-hover:h-[40%]"></div>
            <div className="bg-white/10 w-full h-[55%] rounded-t-sm transition-all duration-300 group-hover:h-[60%]"></div>
            <div className="bg-white/10 w-full h-[65%] rounded-t-sm transition-all duration-300 group-hover:h-[70%]"></div>
            <div className="bg-gold-bright w-full h-[95%] rounded-t-sm shadow-[0_0_12px_#E8B84B] rounded-t-sm"></div>
            <div className="bg-white/20 w-full h-[60%] rounded-t-sm"></div>
            <div className="bg-white/20 w-full h-[50%] rounded-t-sm"></div>
            <div className="bg-white/25 w-full h-[75%] rounded-t-sm"></div>
          </div>
          
          <p className="text-[10px] text-gold-light/70 font-mono mt-3 text-right group-hover:text-gold-light transition-colors">
            Toque para ver histórico analítico completo →
          </p>
        </div>

        {/* Watermark building outline */}
        <div className="absolute right-0 bottom-0 opacity-10 pointer-events-none translate-x-6 translate-y-6">
          <Landmark className="w-48 h-48" />
        </div>
      </section>

      {/* 2. COMANDOS DE MERCADO & CUSTOS EM TEMPO REAL */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        
        {/* PETRÓLEO BRENT */}
        <div className="bg-white border border-outline-light p-5 rounded-xl shadow-sm hover:border-gold-premium transition-all duration-200">
          <div className="flex items-center justify-between mb-3">
            <div className="flex items-center gap-2">
              <span className="p-2 bg-bordeaux-light rounded-lg text-bordeaux-primary">
                <Droplets className="w-5 h-5 fill-current" />
              </span>
              <h3 className="font-display text-[18px] text-bordeaux-primary font-bold">
                Petróleo Brent
              </h3>
            </div>
            <span className="text-[10px] bg-gold-light/50 text-bordeaux-accent px-2 py-0.5 rounded font-mono font-bold">
              SONANGOL REF
            </span>
          </div>

          <p className="font-mono text-[30px] text-bordeaux-primary font-bold mb-3">
            ${brentPrice.toFixed(2)}
          </p>

          <div className="space-y-2 mb-4">
            <div className="flex justify-between text-[9px] font-mono font-bold text-outline-dark">
              <span>MIN $79.20</span>
              <span>MAX $84.50</span>
            </div>
            
            {/* Custom interactive progress scale */}
            <div className="w-full h-1.5 bg-bordeaux-light rounded-full relative">
              <div className="absolute left-[20%] right-[30%] h-full bg-gold-premium rounded-full" />
              {/* Pin indicating current value */}
              <div 
                className="absolute w-3 h-3 bg-bordeaux-primary border border-white rounded-full -top-1 transition-all duration-500" 
                style={{ left: `${((brentPrice - 79.2) / (84.5 - 79.2)) * 100}%` }}
              />
            </div>
          </div>

          <button 
            onClick={stimulateMarket}
            className="w-full text-left text-[11px] font-sans font-bold text-bordeaux-accent hover:text-gold-premium transition-colors flex items-center gap-1 cursor-pointer"
          >
            ESTIMULAR MERCADO AO VIVO 
            <Sparkles className="w-3.5 h-3.5 text-gold-premium animate-pulse" />
          </button>
        </div>

        {/* CÂMBIO KWANZA */}
        <div className="bg-bordeaux-dark p-5 rounded-xl flex flex-col justify-between text-white shadow-sm duration-200 hover:brightness-110">
          <div>
            <div className="flex justify-between items-center mb-1">
              <span className="font-sans text-gold-premium text-[11px] font-bold tracking-widest uppercase">
                CÂMBIO REAL-TIME
              </span>
              <span className="text-[9px] font-mono text-gold-light/70 uppercase">
                AOA / USD
              </span>
            </div>
            <h4 className="font-mono text-[38px] text-white font-extrabold leading-none pt-1">
              {kwanzaUsd.toFixed(2)}
            </h4>
            <p className="text-[11px] text-gold-light/60 font-mono mt-1">
              Kwanza por Dólar Americano
            </p>
          </div>
          
          <div className="flex justify-between items-center mt-3 pt-3 border-t border-white/10">
            <span className="text-[10px] text-gold-light">Taxa média de mercado BNA</span>
            <button 
              onClick={stimulateMarket} 
              className="text-gold-bright hover:scale-110 transition-transform cursor-pointer"
              title="Simular actualização de dados"
            >
              <Landmark className="w-4.5 h-4.5" />
            </button>
          </div>
        </div>

        {/* INFLAÇÃO ANUAL */}
        <div className="bg-white border border-outline-light p-5 rounded-xl flex flex-col justify-between shadow-sm hover:border-bordeaux-accent transition-all duration-200">
          <div className="flex justify-between items-start">
            <div>
              <p className="font-sans text-outline-dark text-[11px] font-bold tracking-wider uppercase mb-1">
                INFLAÇÃO ANUAL (YOY)
              </p>
              <h4 className="font-mono text-[34px] text-bordeaux-primary font-bold leading-none">
                24.8%
              </h4>
            </div>
            <span className="p-2 bg-cream-bg rounded-lg text-bordeaux-accent">
              <BarChart3 className="w-6 h-6" />
            </span>
          </div>

          <div className="mt-4 pt-4 border-t border-outline-light flex items-center justify-between">
            <span className="font-sans text-outline-dark text-xs">Acumulado dos últimos 12 meses</span>
            <span className="text-red-600 font-mono font-bold text-xs bg-red-50 px-1.5 py-0.5 rounded">
              +1.2%
            </span>
          </div>
        </div>

      </div>

      {/* 3. AGROINDÚSTRIA ROW STATUS */}
      <div className="w-full bg-white p-4 rounded-xl flex items-center justify-between border border-outline-light shadow-sm">
        <div className="flex items-center gap-3">
          <div className="bg-bordeaux-light p-2 rounded-full text-bordeaux-accent">
            <Globe className="w-5 h-5" />
          </div>
          <div>
            <h5 className="font-display text-[16px] text-bordeaux-primary font-bold">
              Agroindústria Regional
            </h5>
            <p className="font-sans text-[10px] text-outline-dark font-bold uppercase tracking-wider">
              CRESCIMENTO INDUSTRIAL TRIMESTRAL DO PLANALTO CENTRAL
            </p>
          </div>
        </div>
        <div className="flex items-center gap-1.5">
          <span className="font-mono text-xl text-green-700 font-bold">+12.4%</span>
          <TrendingUp className="w-4 h-4 text-green-700" />
        </div>
      </div>

      {/* 4. SELECÇÃO DE ARTIGO DE HISTÓRIA ECONÓMICA */}
      <article className="bg-white border border-outline-light rounded-xl overflow-hidden shadow-sm flex flex-col md:flex-row hover:border-gold-premium transition-colors duration-200">
        <div className="md:w-[35%] h-56 md:h-auto relative bg-cream-bg flex items-center justify-center">
          <img 
            alt="Luanda Skyline" 
            className="w-full h-full object-cover select-none filter sepia-[0.1]" 
            src="https://lh3.googleusercontent.com/aida-public/AB6AXuDiNTEi4DMi6yJhDw5O5Sp3JQuj1vRjoaq3Qk8CmX6wfOnJlv39FV6pZxYB557bQ8f55y90xauAcsjsF6lSe0xBIiSYV8sSlVn_tFW4yXZ2W3mblO8uRWwhRks5IKb0LULRFCQ6VWgGW21iDQQV3FD8s6Kw3d32f6YQTqKhGu8NrpJ8VZMbgjJ6CU373mcXSxz8GnZyoLlXBOqgFeQkLC6pnSFS0gzmOcK5n9qIVivfyVdz7byjtuLiTfRUp6YdERnKIKXPV1hl9sg"
            referrerPolicy="no-referrer"
          />
          <div className="absolute top-3 left-3">
            <span className="bg-gold-bright text-bordeaux-dark px-2 py-0.5 text-[9px] font-sans font-bold tracking-widest rounded-sm uppercase">
              EXCLUSIVO
            </span>
          </div>
        </div>
        
        <div className="md:w-[65%] p-5 md:p-6 flex flex-col justify-center">
          <span className="font-sans text-gold-premium text-[11px] font-bold tracking-widest uppercase mb-1">
            História Económica de Angola
          </span>
          <h3 className="font-display text-[20px] md:text-[24px] text-bordeaux-primary mb-3 leading-tight font-extrabold">
            O Impacto das Reformas Monetárias na Estabilidade do Investimento Privado em Angola
          </h3>
          <p className="text-outline-dark font-sans text-[13px] md:text-[14px] leading-relaxed mb-4 line-clamp-3">
            Uma investigação histórica aprofundada sobre como as recentes directivas do Banco Nacional de Angola estão a moldar o apetite dos investidores internacionais pelo mercado doméstico de capitais e infraestruturas locais.
          </p>
          <button 
            onClick={() => onSelectArticle("ref-article")}
            className="flex items-center gap-1.5 text-bordeaux-accent font-sans text-xs font-black tracking-widest group cursor-pointer border-b border-bordeaux-light pb-0.5 max-w-fit hover:border-gold-premium transition-colors"
          >
            LER ENSAIO COMPLETO 
            <ChevronRight className="w-4 h-4 transition-transform group-hover:translate-x-1" />
          </button>
        </div>
      </article>

      {/* 5. HISTORIC RESERVES SHADOW STUDY MODAL (INTERACTIVE VALUE ADDED!) */}
      {showReservesModal && (
        <div className="fixed inset-0 bg-bordeaux-dark/40 backdrop-blur-sm z-[100] flex items-center justify-center p-4 animate-fadeIn">
          <div className="bg-white rounded-xl border border-outline-dark p-6 max-w-lg w-full shadow-2xl space-y-4">
            <div className="flex justify-between items-start border-b border-outline-light pb-3">
              <div>
                <span className="text-[10px] font-bold text-gold-premium uppercase tracking-widest">
                  Estudo de Divisas de Elite
                </span>
                <h3 className="font-display text-xl text-bordeaux-primary font-bold mt-1">
                  Reservas Estratégicas Angolanas
                </h3>
              </div>
              <button 
                onClick={() => setShowReservesModal(false)}
                className="text-outline-dark hover:text-bordeaux-primary text-xl font-bold p-1 overflow-visible cursor-pointer"
              >
                ✕
              </button>
            </div>

            <div className="space-y-3 font-sans text-xs md:text-sm text-bordeaux-primary-accent leading-relaxed">
              <p>
                As <b>Reservas Internacionais Líquidas (RIL)</b> de Angola actitam como o principal escudo contra volatilidades externas, garantindo o pagamento de mais de 7 meses de importações líquidas.
              </p>
              
              {/* Micro data comparisons */}
              <div className="grid grid-cols-3 gap-2 py-2 text-center text-xs font-mono font-bold">
                <div className="bg-cream-bg p-2 rounded border border-outline-light">
                  <span className="block text-[9px] text-outline-dark font-sans">META 2024</span>
                  <span className="text-bordeaux-primary">$10.5B</span>
                </div>
                <div className="bg-cream-bg p-2 rounded border border-outline-light">
                  <span className="block text-[9px] text-outline-dark font-sans">VALOR ACTUAL</span>
                  <span className="text-gold-premium">$14.2B</span>
                </div>
                <div className="bg-cream-bg p-2 rounded border border-outline-light">
                  <span className="block text-[9px] text-outline-dark font-sans">HISTORICO DE MAIO</span>
                  <span className="text-bordeaux-primary">$13.9B</span>
                </div>
              </div>

              <p className="italic text-outline-dark text-xs">
                &ldquo;A gestão criteriosa e o superavit cambial oriundo do aumento produtivo na Bacia de Cabinda possibilitaram ao BNA reforçar as posições em ouro monetário e títulos sob custódia do Fed no último quadrimestre.&rdquo;
              </p>
            </div>

            <div className="pt-3 border-t border-outline-light flex gap-2 justify-end">
              <button 
                onClick={() => {
                  alert("As informações foram exportadas e salvas em sua biblioteca com sucesso!");
                  setShowReservesModal(false);
                }}
                className="bg-bordeaux-accent text-white px-5 py-2 rounded-lg text-xs font-bold hover:bg-bordeaux-dark transition-colors cursor-pointer"
              >
                Salvar para Consultas
              </button>
              <button 
                onClick={() => setShowReservesModal(false)}
                className="bg-cream-bg text-bordeaux-primary px-5 py-2 rounded-lg text-xs font-bold border border-outline-light hover:bg-outline-light transition-colors cursor-pointer"
              >
                Fechar
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
