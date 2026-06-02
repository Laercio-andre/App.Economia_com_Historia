import React, { useState } from 'react';
import { ArrowLeft, Search, Bookmark, Heart, BookOpen, Clock, Calendar, Share2, Award, Landmark, Sparkles, FileDown } from 'lucide-react';
import { generateArticlePDF } from '../utils/pdfGenerator';

interface Article {
  id: string;
  title: string;
  summary: string;
  content: string[];
  category: string;
  readTime: string;
  date: string;
  author: string;
  authorTitle: string;
  image: string;
}

interface ExploreProps {
  onSelectArticleOverride?: (id: string, select: () => void) => void;
  selectedArticleId: string | null;
  setSelectedArticleId: (id: string | null) => void;
}

export const Explore: React.FC<ExploreProps> = ({ 
  selectedArticleId, 
  setSelectedArticleId 
}) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [activeFilter, setActiveFilter] = useState('TODOS');

  const articles: Article[] = [
    {
      id: "ref-article",
      title: "O Impacto das Reformas Monetárias na Estabilidade do Investimento Privado em Angola",
      summary: "Uma investigação aprofundada sobre como a flexibilização do regime de câmbio decretado pelo BNA influenciou a entrada de capital estrangeiro.",
      category: "CONJUNTURA",
      readTime: "8 min de leitura",
      date: "28 de Maio de 2026",
      author: "Dra. Ana P. Mendes",
      authorTitle: "Economista da Comissão Económica de Luanda",
      image: "https://lh3.googleusercontent.com/aida-public/AB6AXuDiNTEi4DMi6yJhDw5O5Sp3JQuj1vRjoaq3Qk8CmX6wfOnJlv39FV6pZxYB557bQ8f55y90xauAcsjsF6lSe0xBIiSYV8sSlVn_tFW4yXZ2W3mblO8uRWwhRks5IKb0LULRFCQ6VWgGW21iDQQV3FD8s6Kw3d32f6YQTqKhGu8NrpJ8VZMbgjJ6CU373mcXSxz8GnZyoLlXBOqgFeQkLC6pnSFS0gzmOcK5n9qIVivfyVdz7byjtuLiTfRUp6YdERnKIKXPV1hl9sg",
      content: [
        "A arquitectura macroeconómica de Angola viveu uma inflexão histórica ao longo dos últimos cinco anos. Sob a premissa de desatar as amarras cambiárias remanescentes, o Banco Nacional de Angola (BNA) encabeçou uma transição metódica para um regime flutuante administrado. Esse movimento impôs impactos multidimensionais na estabilidade financeira e na consequente atratividade de Luanda para bolsas de capitais privadas internacionais.",
        "Historicamente, a fixação artificial da taxa cambial kwanza-dólar exauria os cofres de liquidez internacional nas fases de depressão do preço internacional do barril brent. A consequente escassez física de divisas estrangulava as remessas de dividendos por parte das petrolíferas e corporações de investimento industrial estrangeiras, travando reinvestimentos substantivos.",
        "Com a flutuação livre, a taxa cambial passou a reflectir fidedignamente os fundamentais comerciais e fluxos de balanço de pagamentos da economia real. Embora essa adequação tenha desencadeado repiques severos na inflação interna em virtude da profunda dependência de importações de consumo das famílias, os frutos estruturais operacionais começam agora a florescer de forma inequívoca.",
        "A consolidação do mercado secundário do tesouro promovido pela BODIVA (Bolsa de Dívida e Valores de Angola) é o testemunho vivo dessa maturidade. Pela primeira vez na história, multinacionais agro-industriais do Planalto Central encontram um canal financeiro transparente para angariar liquidez doméstica. A estabilidade monetária de longo prazo deixa de assentar em alicerces paliativos institucionais, integrando-se organicamente na competitividade agregada da produção doméstica angolana."
      ]
    },
    {
      id: "art-2",
      title: "Da Hiperinflação à Bodiva: A Crónica dos Três Ciclos do Kwanza",
      summary: "Como a moeda de Angola resistiu à volatilidade dos anos 90 e formou o actual complexo mercantil secundário de capitais públicos.",
      category: "HISTÓRIA",
      readTime: "12 min de leitura",
      date: "14 de Abril de 2026",
      author: "Dr. Manuel Vasconcelos",
      authorTitle: "Especialista em Legislação Monetária",
      image: "https://lh3.googleusercontent.com/aida-public/AB6AXuBH9lgHjCVOJaas_m26df83kVYbdCktQz3sQQtEl4icRIhwWdHeUSmeQu7lN8j2kCEU6vd2J2KNRlG6abexN0inbbWr4xMIgvuPq1laaT9fPwatD_qgKEMwOiTe2eKFHwXRx_l8BjFdwZjq9yFXcPSmtDX3xy4zISl3-jBq-wHmQbdEysAJ_J02SHTn-U0ZQIPTdctcQoP1Ve51mZLGj_HPpsbQTFZJO_twMmCimZ4nwMVk77vsEVMax5RPKL2XQY_AUeOSsabv730",
      content: [
        "A saga do Kwanza (AOA) funde-se intimamente com os capítulos mais agudos da auto-determinação política angolana. Nascida formalmente na grande emissão patriótica de 1977, sob a chancela oficial do Presidente Agostinho Neto, a divisa soberana assumiu a árdua missão de purificar a circulação mercantil do escudo herdado da administração ultramarina colonial.",
        "Todavia, a eclosão de tensões geopolíticas internas e o estrangulamento na logística produtiva rural de províncias agrícolas determinantes como Huambo e Bié catapultaram o país para um espiral inflacionário inédito. No auge da década de 90, as moedas intermédias - Novo Kwanza (AON) e Kwanza Reajustado (AOR) - testemunharam cortes de milhões de zeros, retratando geometricamente a perda real do poder de compra das massas populares urbanas.",
        "Estudar essa dinastia cambial nos capacita a prever as actuais dinâmicas de intermediação financeira. Hoje, as auditorias fiscais sob a alçada da BODIVA provam que a sobriedade institucional actual é um património inestimável, resguardado por dezenas de anos de resiliência popular e rectificação estrutural monetária permanente."
      ]
    },
    {
      id: "art-3",
      title: "O Despertar Agrícola: Diversificação Cambial nos Planaltos do Huambo",
      summary: "Uma reflexão sobre como o financiamento agrário cooperativo de pequena escala reequilibra a balança de divisas de Luanda.",
      category: "AGROINDÚSTRIA",
      readTime: "6 min de leitura",
      date: "02 de Março de 2026",
      author: "Isabel Castro",
      authorTitle: "Consultora de Agronegócio",
      image: "https://lh3.googleusercontent.com/aida-public/AB6AXuAiNL9f4DMz4RRQuDT_galTMMzJ0CZZpE28CYvkPTpiistdGR0daPvsRTaBXqWPpSsHfoAKVjetJyqwdGzz-81zJRpfpW_4FNu06E6HCh94NYUPAw0o-fkD98t9AJkOMtRtx9tOMaEQib3HQ1AkPf33qut9JMpY6Igr9JuCZ2A_ySi8P3uXB2dKO1pBivUmp99hWdDDqhihil2GU6m3GYKDuPc9uGS4VRrYckxELhQh2Fp4QVBaBb2-QymjHG8JogW5VhIvxFuePJE",
      content: [
        "O futuro macroeconómico de Angola não se decide unicamente nas salas refrigeradas das torres residenciais de Luanda, mas sim nos campos férteis do Planalto Central. Projetos pilotos baseados no agrocooperativismo financeiro estruturado estão a converter Huambo na principal turbina de substituição de importações do país.",
        "Historicamente, a economia nacional padeceu do chamado 'Mal Holandês', onde a pujança petrolífera apreciava o câmbio nacional e canibalizava a competitividade industrial manufacturada doméstica. Com a recente estabilidade do Kwanza e as restrições logísticas de divisas físicas, concorrentes estrangeiros perderam terreno para produtos regionais como milho, leguminosas e batata.",
        "Estimular essa agricultura de escala é a chave basilar para libertar divisas internacionais líquidas estratégicas do BNA, direcionando a liquidez soberana para infraestruturas estruturais primordiais e redes integradas de escoamento logístico ferroviário e marítimo."
      ]
    }
  ];

  const handleToggleLike = (id: string) => {
    alert("Conteúdo Favoritado: O ensaio académico foi adicionado à sua lista privada de teses guardadas com sucesso!");
  };

  const filteredArticles = articles.filter(art => {
    const matchesSearch = art.title.toLowerCase().includes(searchQuery.toLowerCase()) || 
                          art.summary.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = activeFilter === 'TODOS' || art.category === activeFilter;
    return matchesSearch && matchesCategory;
  });

  const currentArticle = articles.find(art => art.id === selectedArticleId);

  return (
    <div className="select-none animate-fadeIn">
      
      {/* 1. DETEL DE ARTIGO IMERSIVO */}
      {selectedArticleId && currentArticle ? (
        <div className="space-y-6 pb-24">
          <button 
            onClick={() => setSelectedArticleId(null)}
            className="text-bordeaux-accent hover:bg-cream-bg py-2 px-3 rounded-full transition-colors flex items-center gap-1 cursor-pointer font-bold font-sans text-xs uppercase tracking-wider"
          >
            <ArrowLeft className="w-5 h-5 line" />
            <span>Voltar para Explorar</span>
          </button>

          <article className="bg-white border border-outline-light rounded-xl overflow-hidden bordeaux-shadow">
            <div className="h-64 md:h-96 relative">
              <img 
                src={currentArticle.image} 
                alt={currentArticle.title} 
                className="w-full h-full object-cover filter sepia-[0.1]"
                referrerPolicy="no-referrer"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-bordeaux-primary/80 to-transparent"></div>
              <div className="absolute bottom-6 left-6 right-6">
                <span className="bg-gold-bright text-bordeaux-dark px-3 py-1 font-sans text-[9px] font-black tracking-widest rounded-sm uppercase inline-block mb-3">
                  {currentArticle.category}
                </span>
                <h1 className="font-display text-[22px] md:text-[34px] text-white font-extrabold leading-tight">
                  {currentArticle.title}
                </h1>
              </div>
            </div>

            <div className="p-6 md:p-8 space-y-6">
              
              {/* Info panel of the author */}
              <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4 border-b border-outline-light pb-5 text-xs">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-bordeaux-accent text-gold-bright rounded-full flex items-center justify-center font-bold">
                    {currentArticle.author.split(' ').map(n=>n[0]).join('')}
                  </div>
                  <div>
                    <p className="font-sans font-black text-bordeaux-primary leading-tight">{currentArticle.author}</p>
                    <p className="text-[10px] text-outline-dark font-sans">{currentArticle.authorTitle}</p>
                  </div>
                </div>

                <div className="flex gap-4 font-mono text-outline-dark">
                  <span className="flex items-center gap-1">
                    <Calendar className="w-3.5 h-3.5" />
                    {currentArticle.date}
                  </span>
                  <span className="flex items-center gap-1">
                    <Clock className="w-3.5 h-3.5" />
                    {currentArticle.readTime}
                  </span>
                </div>
              </div>

              {/* Immersive Text paragraphs in Georgia style display */}
              <div className="font-display text-[15.5px] md:text-[18px] text-bordeaux-dark-accent leading-relaxed space-y-5 max-w-2xl mx-auto p-0.5">
                {currentArticle.content.map((paragraph, idx) => (
                  <p key={idx} className="indent-4 md:indent-8">
                    {paragraph}
                  </p>
                ))}
              </div>

              {/* Final citation seal of Luanda Institute */}
              <div className="border border-outline-light rounded-lg bg-cream-bg p-5 max-w-xl mx-auto text-center space-y-3">
                <Landmark className="w-9 h-9 text-gold-premium mx-auto" />
                <p className="font-sans text-[11px] text-outline-dark leading-relaxed italic">
                  &ldquo;Este ensaio pertence à colecção restrita de investigação do Instituto Superior de Moeda e Investigação Fiduciária de Luanda. Proibida reprodução comercial.&rdquo;
                </p>
                <div className="flex justify-center gap-2 pt-1 font-sans text-[10px] font-black tracking-widest uppercase">
                  <button 
                    onClick={() => handleToggleLike(currentArticle.id)}
                    className="flex items-center gap-1 text-bordeaux-accent hover:text-gold-premium cursor-pointer"
                  >
                    <Bookmark className="w-3.5 h-3.5" />
                    <span>Guardar Estudo</span>
                  </button>
                  <span className="text-outline-light">|</span>
                  <button 
                    onClick={() => generateArticlePDF(currentArticle)}
                    className="flex items-center gap-1 text-bordeaux-accent hover:text-gold-premium cursor-pointer"
                  >
                    <FileDown className="w-3.5 h-3.5" />
                    <span>Baixar PDF</span>
                  </button>
                  <span className="text-outline-light">|</span>
                  <button 
                    onClick={() => alert("Link de tese copiado!")}
                    className="flex items-center gap-1 text-bordeaux-accent hover:text-gold-premium cursor-pointer"
                  >
                    <Share2 className="w-3.5 h-3.5" />
                    <span>Partilhar Link</span>
                  </button>
                </div>
              </div>

            </div>
          </article>
        </div>
      ) : (
        // 2. EXPLORE FEED LIST
        <div className="space-y-6 pb-24 animate-fadeIn">
          
          {/* Header context */}
          <div className="bg-white p-4 rounded-xl border border-outline-light">
            <p className="text-[10px] text-outline-dark font-black tracking-widest uppercase">INVESTIGAÇÃO ACADÉMICA</p>
            <h2 className="font-display text-[18px] md:text-[22px] text-bordeaux-primary font-bold">Biblioteca de Economia de Luanda</h2>
          </div>

          <div className="h-[2px] w-12 bg-gold-premium rounded-full" />

          {/* Search bar inputs */}
          <div className="relative w-full">
            <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 text-outline-dark w-4.5 h-4.5" />
            <input 
              type="text" 
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Pesquisar teses, ensaios monetários e crónicas do kwanza..."
              className="w-full bg-white border border-outline-light rounded-full pl-10 pr-4 py-2 text-xs md:text-sm text-bordeaux-primary focus:outline-none focus:border-bordeaux-accent transition-all"
            />
          </div>

          {/* Filter Chips */}
          <div className="flex gap-2 overflow-x-auto custom-scrollbar whitespace-nowrap py-1">
            {['TODOS', 'CONJUNTURA', 'HISTÓRIA', 'AGROINDÚSTRIA'].map((cat) => (
              <button
                key={cat}
                onClick={() => setActiveFilter(cat)}
                className={`px-4 py-1.5 rounded-full text-[10px] md:text-[11px] font-sans font-bold transition-all cursor-pointer ${
                  activeFilter === cat
                    ? 'bg-bordeaux-accent text-white shadow-sm'
                    : 'border border-outline-light bg-white text-bordeaux-accent hover:border-bordeaux-primary'
                }`}
              >
                {cat}
              </button>
            ))}
          </div>

          {/* Grid lists representing articles */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 pt-2">
            {filteredArticles.length > 0 ? (
              filteredArticles.map((art) => (
                <div 
                  key={art.id}
                  onClick={() => setSelectedArticleId(art.id)}
                  className="bg-white border border-outline-light rounded-xl overflow-hidden hover:border-gold-premium transition-all duration-200 cursor-pointer group flex flex-col justify-between"
                >
                  <div>
                    <div className="h-44 relative bg-cream-bg flex items-center justify-center">
                      <img 
                        src={art.image} 
                        alt={art.title} 
                        className="w-full h-full object-cover filter sepia-[0.2] transition-transform duration-300 group-hover:scale-105"
                        referrerPolicy="no-referrer"
                      />
                      <div className="absolute top-3 left-3">
                        <span className="bg-bordeaux-primary text-gold-light px-2.5 py-0.5 text-[9px] font-sans font-bold tracking-widest rounded uppercase">
                          {art.category}
                        </span>
                      </div>
                    </div>

                    <div className="p-5 space-y-2">
                      <h3 className="font-display text-[16px] md:text-[18px] text-bordeaux-primary font-bold leading-snug group-hover:text-gold-premium transition-colors line-clamp-2">
                        {art.title}
                      </h3>
                      <p className="text-outline-dark text-xs md:text-sm line-clamp-3 leading-relaxed">
                        {art.summary}
                      </p>
                    </div>
                  </div>

                  <div className="p-5 pt-0 border-t border-cream-bg mt-2 flex justify-between items-center text-[10.5px] font-mono text-outline-dark">
                    <span>{art.readTime}</span>
                    <span className="font-sans font-bold text-bordeaux-accent group-hover:text-gold-premium transition-colors flex items-center gap-0.5">
                      LER ENSAIO
                      <BookOpen className="w-3.5 h-3.5" />
                    </span>
                  </div>
                </div>
              ))
            ) : (
              <div className="col-span-1 md:col-span-2 bg-white border border-outline-light p-12 rounded-xl text-center">
                <Landmark className="w-12 h-12 text-outline-dark mx-auto mb-3 opacity-60" />
                <p className="text-sm font-sans font-bold text-bordeaux-accent">Nenhum estudo científico localizado.</p>
                <p className="text-xs text-outline-dark mt-1">Experimente ajustar o filtro de pesquisa categórica.</p>
              </div>
            )}
          </div>

        </div>
      )}

    </div>
  );
};
