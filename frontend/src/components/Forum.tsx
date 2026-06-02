import React, { useState } from 'react';
import { MessageSquare, Heart, Bookmark, ArrowLeft, Send, Plus, Search, Check, ThumbsUp, Reply, HelpCircle, Image as ImageIcon, Paperclip, Sparkles, CheckCircle2 } from 'lucide-react';
import { ForumTopic, ForumComment, UserProfile } from '../types';

interface ForumProps {
  userProfile: UserProfile;
  initialTopics: ForumTopic[];
  onAddPoints: (pts: number) => void;
  onUpdateCommentsCount: (incrementBy: number) => void;
}

export const Forum: React.FC<ForumProps> = ({
  userProfile,
  initialTopics,
  onAddPoints,
  onUpdateCommentsCount
}) => {
  const [topics, setTopics] = useState<ForumTopic[]>(initialTopics);
  const [activeTab, setActiveTab] = useState<'feed' | 'detail' | 'create'>('feed');
  const [selectedTopic, setSelectedTopic] = useState<ForumTopic | null>(null);
  const [categoryFilter, setCategoryFilter] = useState<string>('TODOS');
  
  // Create Topic Form State
  const [newTitle, setNewTitle] = useState('');
  const [newContent, setNewContent] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('Mercados');
  const [attachmentName, setAttachmentName] = useState<string | null>(null);
  const [showSuccessToast, setShowSuccessToast] = useState(false);

  // Comment Form State
  const [commentText, setCommentText] = useState('');

  // Categories list for filters
  const filters = ['TODOS', 'MERCADOS', 'POLÍTICA FISCAL', 'AGRICULTURA', 'IMOBILIÁRIO'];
  
  const creatorCategories = ['Mercados', 'Agricultura', 'Legislação', 'Política Monetária', 'Petróleo & Gás'];

  // Handle filtering
  const filteredTopics = categoryFilter === 'TODOS' 
    ? topics 
    : topics.filter(t => t.category.toUpperCase() === categoryFilter);

  // Handle viewing topic
  const viewTopicDetail = (topic: ForumTopic) => {
    setSelectedTopic(topic);
    setActiveTab('detail');
  };

  // Like a topic
  const handleLikeTopic = (topicId: string, e: React.MouseEvent) => {
    e.stopPropagation();
    setTopics(prev => prev.map(t => {
      if (t.id === topicId) {
        const isCurrentlyLiked = !!t.isLiked;
        return {
          ...t,
          isLiked: !isCurrentlyLiked,
          likesCount: isCurrentlyLiked ? t.likesCount - 1 : t.likesCount + 1
        };
      }
      return t;
    }));

    // If currently viewing details, update selected topic views as well
    if (selectedTopic && selectedTopic.id === topicId) {
      setSelectedTopic(prev => {
        if (!prev) return null;
        const isCurrentlyLiked = !!prev.isLiked;
        return {
          ...prev,
          isLiked: !isCurrentlyLiked,
          likesCount: isCurrentlyLiked ? prev.likesCount - 1 : prev.likesCount + 1
        };
      });
    }
  };

  // Save/bookmark topic
  const handleSaveTopic = (topicId: string, e: React.MouseEvent) => {
    e.stopPropagation();
    setTopics(prev => prev.map(t => {
      if (t.id === topicId) {
        return { ...t, isSaved: !t.isSaved };
      }
      return t;
    }));

    if (selectedTopic && selectedTopic.id === topicId) {
      setSelectedTopic(prev => prev ? { ...prev, isSaved: !prev.isSaved } : null);
    }
  };

  // Submit new topic
  const handleCreateTopicSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newTitle.trim() || !newContent.trim()) {
      alert("Por favor, preencha o título e o conteúdo do seu debate!");
      return;
    }

    const newTopic: ForumTopic = {
      id: `topic-${Date.now()}`,
      title: newTitle,
      summary: newContent.slice(0, 140) + "...",
      content: newContent,
      category: selectedCategory.toUpperCase(),
      authorName: userProfile.name,
      authorTitle: userProfile.role,
      authorAvatar: userProfile.avatar,
      timeAgo: "Agora mesmo",
      responsesCount: 0,
      likesCount: 0,
      isLiked: false,
      isSaved: false,
      comments: [],
      attachmentName: attachmentName || undefined
    };

    setTopics(prev => [newTopic, ...prev]);
    onAddPoints(50); // Give 50 points for posting an expert essay!
    setShowSuccessToast(true);

    // reset fields
    setNewTitle('');
    setNewContent('');
    setSelectedCategory('Mercados');
    setAttachmentName(null);

    // Return to feed
    setTimeout(() => {
      setShowSuccessToast(false);
      setActiveTab('feed');
    }, 2000);
  };

  // Handle posting a comment
  const handlePostComment = (e: React.FormEvent) => {
    e.preventDefault();
    if (!commentText.trim() || !selectedTopic) return;

    const newComment: ForumComment = {
      id: `comment-${Date.now()}`,
      authorName: userProfile.name,
      authorTitle: userProfile.role,
      authorAvatar: userProfile.avatar,
      content: commentText,
      timeAgo: "Agora mesmo",
      likes: 0,
      isLiked: false
    };

    // Update topics state
    setTopics(prev => prev.map(t => {
      if (t.id === selectedTopic.id) {
        return {
          ...t,
          responsesCount: t.responsesCount + 1,
          comments: [...t.comments, newComment]
        };
      }
      return t;
    }));

    // Update currently viewed topic state
    setSelectedTopic(prev => {
      if (!prev) return null;
      return {
        ...prev,
        responsesCount: prev.responsesCount + 1,
        comments: [...prev.comments, newComment]
      };
    });

    setCommentText('');
    onAddPoints(15); // Give 15 points for constructive feedback
    onUpdateCommentsCount(1); // Increment count in profile
  };

  // Handle comment like
  const handleLikeComment = (commentId: string) => {
    if (!selectedTopic) return;

    // Update in actual list
    setTopics(prev => prev.map(t => {
      if (t.id === selectedTopic.id) {
        return {
          ...t,
          comments: t.comments.map(c => {
            if (c.id === commentId) {
              const isCurrentlyLiked = !!c.isLiked;
              return {
                ...c,
                isLiked: !isCurrentlyLiked,
                likes: isCurrentlyLiked ? c.likes - 1 : c.likes + 1
              };
            }
            return c;
          })
        };
      }
      return t;
    }));

    // Update in selected topic details view
    setSelectedTopic(prev => {
      if (!prev) return null;
      return {
        ...prev,
        comments: prev.comments.map(c => {
          if (c.id === commentId) {
            const isCurrentlyLiked = !!c.isLiked;
            return {
              ...c,
              isLiked: !isCurrentlyLiked,
              likes: isCurrentlyLiked ? c.likes - 1 : c.likes + 1
            };
          }
          return c;
        })
      };
    });
  };

  return (
    <div className="select-none animate-fadeIn">
      
      {/* ======================================================== */}
      {/* 1. FORUM MAIN FEED VIEW                                  */}
      {/* ======================================================== */}
      {activeTab === 'feed' && (
        <div className="space-y-6 pb-24">
          
          {/* Quick search & Filters */}
          <section className="flex flex-col gap-3">
            <div className="relative w-full">
              <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 text-outline-dark w-4.5 h-4.5" />
              <input 
                type="text" 
                placeholder="Pesquisar análises, oros e discussões..."
                className="w-full bg-white border border-outline-light rounded-full pl-10 pr-4 py-2 text-xs md:text-sm text-bordeaux-primary focus:outline-none focus:border-bordeaux-accent transition-all"
                onChange={(e) => {
                  // Simulating filtering state
                }}
              />
            </div>
            
            <div className="flex items-center gap-2 overflow-x-auto custom-scrollbar py-1">
              {filters.map((filter) => (
                <button
                  key={filter}
                  onClick={() => setCategoryFilter(filter)}
                  className={`px-4 py-1.5 rounded-full text-[10px] md:text-[11px] font-sans font-bold whitespace-nowrap tracking-wider transition-all cursor-pointer ${
                    categoryFilter === filter 
                      ? 'bg-bordeaux-accent text-white shadow-sm'
                      : 'border border-outline-light bg-white text-bordeaux-accent hover:border-bordeaux-primary'
                  }`}
                >
                  {filter}
                </button>
              ))}
            </div>
          </section>

          {/* Featured Post Highlight Card */}
          {categoryFilter === 'TODOS' && topics.some(t => !!t.isFeatured) && (
            <section className="mb-6">
              {topics.filter(t => !!t.isFeatured).map((item) => (
                <div 
                  key={item.id}
                  onClick={() => viewTopicDetail(item)}
                  className="bg-bordeaux-primary text-white rounded-xl p-6 relative overflow-hidden group cursor-pointer transition-transform duration-300 hover:scale-[1.01]"
                >
                  <div className="absolute top-0 right-0 w-64 h-64 bg-bordeaux-accent opacity-10 rounded-full -mr-20 -mt-20 blur-3xl group-hover:opacity-30 transition-opacity"></div>
                  <span className="inline-block px-3 py-0.5 bg-gold-bright text-bordeaux-dark font-sans text-[9px] font-black tracking-widest rounded-sm mb-4">
                    DESTAQUE DO MÊS
                  </span>
                  <h2 className="font-display text-[22px] md:text-[28px] text-white font-bold leading-tight mb-3">
                    {item.title}
                  </h2>
                  <p className="text-gold-light/80 text-xs md:text-sm mb-6 line-clamp-2">
                    {item.summary}
                  </p>
                  
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-full border border-gold-bright overflow-hidden">
                        <img 
                          alt={item.authorName} 
                          className="w-full h-full object-cover" 
                          src={item.authorAvatar}
                          referrerPolicy="no-referrer"
                        />
                      </div>
                      <div>
                        <p className="font-sans text-xs font-bold text-gold-bright">{item.authorName}</p>
                        <p className="text-[10px] text-gold-light/60 uppercase tracking-wider">{item.authorTitle}</p>
                      </div>
                    </div>
                    
                    <div className="flex items-center gap-1.5 text-gold-bright font-mono text-[11px] font-bold">
                      <MessageSquare className="w-4 h-4" />
                      <span>{item.responsesCount} RESPOSTAS</span>
                    </div>
                  </div>
                </div>
              ))}
            </section>
          )}

          {/* Main Layout containing Recent Discussions + Sidebar */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            
            {/* Left lists of recent discussions */}
            <div className="lg:col-span-2 space-y-4">
              <h3 className="font-display text-[18px] text-bordeaux-primary font-bold border-b border-outline-light pb-2">
                Discussões Recentes
              </h3>

              {filteredTopics.length > 0 ? (
                filteredTopics.filter(t => !t.isFeatured).map((topic) => (
                  <div 
                    key={topic.id}
                    onClick={() => viewTopicDetail(topic)}
                    className="bg-white border border-outline-light p-5 rounded-xl hover:shadow-[0_4px_16px_rgba(42,10,18,0.06)] transition-all duration-200 group cursor-pointer"
                  >
                    <div className="flex justify-between items-start mb-3">
                      <span className="px-2 py-0.5 bg-cream-bg text-bordeaux-accent font-sans text-[9px] font-black tracking-wider rounded uppercase">
                        {topic.category}
                      </span>
                      <span className="font-mono text-[10px] text-outline-dark">{topic.timeAgo}</span>
                    </div>
                    
                    <h4 className="font-display text-[16px] md:text-[18px] text-bordeaux-primary font-bold mb-2 group-hover:text-gold-premium transition-colors">
                      {topic.title}
                    </h4>
                    
                    <p className="text-outline-dark text-xs md:text-sm line-clamp-2 mb-4 leading-relaxed">
                      {topic.content}
                    </p>

                    <div className="flex items-center justify-between pt-4 border-t border-cream-bg">
                      <div className="flex items-center gap-2">
                        <div className="w-7 h-7 rounded-full border border-gold-premium overflow-hidden bg-cream-bg">
                          <img 
                            src={topic.authorAvatar} 
                            alt={topic.authorName} 
                            className="w-full h-full object-cover"
                            referrerPolicy="no-referrer"
                          />
                        </div>
                        <span className="font-sans text-[11px] font-bold text-bordeaux-primary">{topic.authorName}</span>
                      </div>
                      
                      <div className="flex items-center gap-4">
                        <button 
                          onClick={(e) => handleLikeTopic(topic.id, e)}
                          className={`flex items-center gap-1 text-[11px] font-mono transition-colors ${
                            topic.isLiked ? 'text-gold-premium font-bold' : 'text-outline-dark hover:text-bordeaux-accent'
                          }`}
                        >
                          <Heart className={`w-3.5 h-3.5 ${topic.isLiked ? 'fill-current' : ''}`} />
                          <span>{topic.likesCount}</span>
                        </button>

                        <button 
                          onClick={(e) => handleSaveTopic(topic.id, e)}
                          className={`flex items-center gap-1 text-[11px] font-mono transition-colors ${
                            topic.isSaved ? 'text-gold-premium font-bold' : 'text-outline-dark hover:text-bordeaux-accent'
                          }`}
                        >
                          <Bookmark className={`w-3.5 h-3.5 ${topic.isSaved ? 'fill-current' : ''}`} />
                        </button>
                        
                        <div className="flex items-center gap-1 text-bordeaux-accent font-mono text-[11px]">
                          <MessageSquare className="w-3.5 h-3.5" />
                          <span>{topic.responsesCount}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                ))
              ) : (
                <div className="bg-white border border-outline-light p-8 rounded-xl text-center">
                  <HelpCircle className="w-12 h-12 text-outline-dark mx-auto mb-3 opacity-60" />
                  <p className="text-sm font-sans font-bold text-bordeaux-accent">Nenhum debate encontrado nesta categoria.</p>
                  <p className="text-xs text-outline-dark mt-1">Seja o primeiro a levantar uma pauta de macroeconomia local!</p>
                </div>
              )}
            </div>

            {/* Sidebar with hashtag and influential members */}
            <aside className="space-y-6">
              {/* TOPICOS EM ALTA */}
              <div className="bg-cream-bg p-5 rounded-xl border border-outline-light">
                <h3 className="font-sans text-xs font-black text-bordeaux-accent border-b border-outline-light pb-2 mb-3.5 uppercase tracking-widest text-[#7B1A2E]">
                  Tópicos em Alta
                </h3>
                <div className="flex flex-wrap gap-2">
                  {['#Inflação2024', '#BODIVA', '#CâmbioLuanda', '#IVA_Zero', '#ReservaBNA', '#KwanzaForte'].map((tag) => (
                    <span 
                      key={tag}
                      onClick={() => alert(`Filtrando discussões reais sobre ${tag}...`)}
                      className="px-3 py-1 bg-white border border-outline-light text-outline-dark font-mono text-[10px] md:text-[11px] rounded-full cursor-pointer hover:border-gold-premium hover:text-bordeaux-primary transition-colors text-xs font-bold"
                    >
                      {tag}
                    </span>
                  ))}
                </div>
              </div>

              {/* MEMBROS INFLUENTES */}
              <div className="bg-cream-bg p-5 rounded-xl border border-outline-light">
                <h3 className="font-sans text-xs font-black text-bordeaux-accent border-b border-outline-light pb-2 mb-3.5 uppercase tracking-widest text-[#7B1A2E]">
                  Membros Influentes
                </h3>
                <div className="space-y-4">
                  {[
                    { name: "Nuno Silva", role: "Analista Sénior", initials: "NS", color: "bg-bordeaux-primary text-white", ver: true },
                    { name: "Isabel Castro", role: "Gestora de Activos", initials: "IC", color: "bg-gold-bright text-bordeaux-dark", ver: true },
                    { name: "Mateus Tende", role: "Economista Chefe", initials: "MT", color: "bg-bordeaux-light text-bordeaux-accent", ver: false }
                  ].map((memb, i) => (
                    <div key={i} className="flex items-center gap-3 group cursor-pointer hover:opacity-90">
                      <div className="relative">
                        <div className={`w-9 h-9 rounded-full ${memb.color} flex items-center justify-center font-bold text-xs`}>
                          {memb.initials}
                        </div>
                        {memb.ver && (
                          <div className="absolute -bottom-1 -right-0.5 bg-yellow-500 rounded-full p-0.5 border border-cream-bg">
                            <Check className="w-2.5 h-2.5 text-white stroke-[3.5]" />
                          </div>
                        )}
                      </div>
                      <div>
                        <p className="font-sans font-bold text-xs text-bordeaux-primary group-hover:text-gold-premium transition-colors">{memb.name}</p>
                        <p className="text-[10px] text-outline-dark capitalize tracking-wide font-sans">{memb.role}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </aside>

          </div>

          {/* Floating Action Button (FAB) relative to screen */}
          <button 
            onClick={() => setActiveTab('create')}
            className="fixed bottom-24 right-5 md:right-10 w-14 h-14 bg-gold-bright text-bordeaux-dark rounded-full shadow-lg flex items-center justify-center z-40 active:scale-90 transition-transform duration-100 hover:brightness-105 cursor-pointer outline-none border border-gold-premium/40"
            id="fab-create-topic"
            title="Criar novo tópico no fórum"
          >
            <Plus className="w-8 h-8 stroke-[3]" />
          </button>

        </div>
      )}

      {/* ======================================================== */}
      {/* 2. FORUM CREATE TOPIC FORM                               */}
      {/* ======================================================== */}
      {activeTab === 'create' && (
        <div className="max-w-xl mx-auto space-y-6 pb-24">
          <div className="flex items-center gap-3">
            <button 
              onClick={() => setActiveTab('feed')}
              className="text-bordeaux-accent p-2 rounded-full hover:bg-cream-bg transition-colors cursor-pointer"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
              <p className="font-sans text-[10px] font-bold text-outline-dark uppercase tracking-wider">Espaço de Análise Colectiva</p>
              <h2 className="font-display text-xl text-bordeaux-primary font-bold">Partilhe o seu Conhecimento</h2>
            </div>
          </div>
          
          <div className="h-[2px] w-12 bg-gold-premium rounded-full" />

          {showSuccessToast ? (
            <div className="bg-white border-2 border-green-600 rounded-xl p-8 shadow-2xl text-center space-y-4 animate-scaleUp">
              <div className="w-16 h-16 bg-green-100 text-green-700 rounded-full flex items-center justify-center mx-auto">
                <CheckCircle2 className="w-10 h-10" />
              </div>
              <h3 className="font-display text-xl text-bordeaux-primary font-bold">Publicação Concluída</h3>
              <p className="text-xs md:text-sm text-outline-dark">
                O seu tópico foi enviado para a comunidade de especialistas e <b>50 pontos</b> de prestígio foram somados ao seu perfil de analista!
              </p>
            </div>
          ) : (
            <form onSubmit={handleCreateTopicSubmit} className="bg-white border border-outline-light p-6 rounded-xl bordeaux-shadow space-y-5">
              
              {/* Título */}
              <div className="space-y-1">
                <label className="block text-[11px] font-bold text-[#7B1A2E] uppercase tracking-widest font-sans">
                  Título da Discussão
                </label>
                <input 
                  type="text" 
                  value={newTitle}
                  onChange={(e) => setNewTitle(e.target.value)}
                  placeholder="Ex: O impacto do IVA no consumo local e as margens corporativas"
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-lg px-4 py-3 text-bordeaux-primary placeholder:text-outline-dark/60 font-sans focus:outline-none focus:border-bordeaux-accent text-sm transition-all"
                />
              </div>

              {/* Categorias */}
              <div className="space-y-2">
                <label className="block text-[11px] font-bold text-[#7B1A2E] uppercase tracking-widest font-sans">
                  Categoria Principal
                </label>
                <div className="flex flex-wrap gap-2">
                  {creatorCategories.map((cat) => (
                    <button
                      key={cat}
                      type="button"
                      onClick={() => setSelectedCategory(cat)}
                      className={`px-4 py-1.5 rounded-full text-[10px] md:text-[11px] font-sans font-bold whitespace-nowrap transition-all cursor-pointer ${
                        selectedCategory === cat
                          ? 'bg-bordeaux-primary text-white shadow-sm'
                          : 'border border-outline-light bg-white text-outline-dark hover:border-bordeaux-accent'
                      }`}
                    >
                      {cat}
                    </button>
                  ))}
                </div>
              </div>

              {/* Conteúdo */}
              <div className="space-y-1">
                <label className="block text-[11px] font-bold text-[#7B1A2E] uppercase tracking-widest font-sans">
                  Conteúdo Analítico / Pergunta
                </label>
                <textarea 
                  value={newContent}
                  onChange={(e) => setNewContent(e.target.value)}
                  placeholder="Partilhe a sua análise, parecer de mercado ou dúvida histórica fundamentada com a comunidade angolana..."
                  rows={6}
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-lg p-4 text-bordeaux-primary placeholder:text-outline-dark/60 font-sans focus:outline-none focus:border-bordeaux-accent text-sm resize-none transition-all leading-relaxed"
                />
              </div>

              {/* Anexos */}
              <div className="space-y-2">
                <label className="block text-[11px] font-bold text-[#7B1A2E] uppercase tracking-widest font-sans">
                  Anexos (Opcional)
                </label>
                <div className="relative border-2 border-dashed border-outline-light rounded-xl bg-cream-bg/10 p-6 flex flex-col items-center justify-center cursor-pointer hover:bg-cream-bg/30 transition-colors group">
                  <Paperclip className="w-8 h-8 text-bordeaux-accent mb-2 group-hover:scale-110 transition-transform" />
                  <p className="font-sans text-xs text-bordeaux-primary font-bold">
                    {attachmentName ? `Anexo selecionado: ${attachmentName}` : 'Adicionar Anexo (PDF ou Imagem)'}
                  </p>
                  <p className="text-[10px] text-outline-dark uppercase tracking-wider mt-0.5">Limite de tamanho: 10MB</p>
                  <input 
                    type="file" 
                    className="absolute inset-0 opacity-0 cursor-pointer"
                    onChange={(e) => {
                      if (e.target.files && e.target.files[0]) {
                        setAttachmentName(e.target.files[0].name);
                      }
                    }}
                  />
                </div>
              </div>

              {/* Visual Decorative Context of Ledger Pen */}
              <div className="border border-outline-light rounded-lg overflow-hidden bg-cream-bg max-h-24 relative opacity-85 hover:opacity-100 transition-opacity flex items-center">
                <img 
                  className="w-full h-full object-cover filter sepia-[0.2]" 
                  src="https://lh3.googleusercontent.com/aida-public/AB6AXuBH9lgHjCVOJaas_m26df83kVYbdCktQz3sQQtEl4icRIhwWdHeUSmeQu7lN8j2kCEU6vd2J2KNRlG6abexN0inbbWr4xMIgvuPq1laaT9fPwatD_qgKEMwOiTe2eKFHwXRx_l8BjFdwZjq9yFXcPSmtDX3xy4zISl3-jBq-wHmQbdEysAJ_J02SHTn-U0ZQIPTdctcQoP1Ve51mZLGj_HPpsbQTFZJO_twMmCimZ4nwMVk77vsEVMax5RPKL2XQY_AUeOSsabv730"
                  alt="Decorative Fountain Pen"
                  referrerPolicy="no-referrer"
                />
              </div>

              {/* Submit */}
              <button
                type="submit"
                className="w-full h-12 bg-bordeaux-accent text-white rounded-lg font-sans text-xs font-bold uppercase tracking-widest shadow-md hover:bg-bordeaux-primary active:scale-[0.98] transition-all flex items-center justify-center gap-2 cursor-pointer"
              >
                <Send className="w-4 h-4" />
                Publicar Discussão
              </button>

            </form>
          )}
        </div>
      )}

      {/* ======================================================== */}
      {/* 3. FORUM TOPIC DETAIL VIEW                               */}
      {/* ======================================================== */}
      {activeTab === 'detail' && selectedTopic && (
        <div className="space-y-6 pb-32">
          {/* Back button header */}
          <div className="flex items-center justify-between">
            <button 
              onClick={() => setActiveTab('feed')}
              className="text-bordeaux-accent p-2 rounded-full hover:bg-cream-bg transition-colors flex items-center gap-1 cursor-pointer font-bold font-sans text-xs tracking-wider"
            >
              <ArrowLeft className="w-5 h-5" />
              <span>Voltar ao Fórum</span>
            </button>
            
            <button 
              onClick={() => alert("Discussão compartilhada! Link copiado para a área de transferência.")}
              className="text-bordeaux-accent p-2 rounded-full hover:bg-cream-bg"
            >
              <span className="material-symbols-outlined">share</span>
            </button>
          </div>

          {/* Original Post Main Card */}
          <article className="bg-white border-2 border-bordeaux-accent p-6 rounded-lg bordeaux-shadow">
            <div className="flex items-center gap-3.5 mb-5 md:mb-6">
              <div className="w-12 h-12 rounded-full border-2 border-gold-premium overflow-hidden bg-cream-bg">
                <img 
                  alt={selectedTopic.authorName} 
                  className="w-full h-full object-cover" 
                  src={selectedTopic.authorAvatar}
                  referrerPolicy="no-referrer"
                />
              </div>
              <div>
                <h3 className="font-sans font-bold text-bordeaux-dark text-sm md:text-base leading-none">
                  {selectedTopic.authorName}
                </h3>
                <p className="text-outline-dark text-[10px] md:text-[11px] font-sans font-black tracking-wider uppercase mt-1">
                  {selectedTopic.authorTitle}
                </p>
              </div>
              <span className="ml-auto font-mono text-[10px] text-outline-dark">{selectedTopic.timeAgo}</span>
            </div>

            <h2 className="font-display text-[20px] md:text-[26px] text-bordeaux-primary leading-tight font-extrabold mb-4 p-0.5">
              {selectedTopic.title}
            </h2>

            <div className="font-sans text-[14px] md:text-[16px] text-bordeaux-primary-accent leading-relaxed space-y-4 mb-6">
              {selectedTopic.content.split('\n\n').map((paragraph, index) => (
                <p key={index}>{paragraph}</p>
              ))}
            </div>

            {selectedTopic.attachmentName && (
              <div className="bg-cream-bg border border-outline-light rounded-lg p-3 flex items-center gap-2 mb-6">
                <Paperclip className="w-4 h-4 text-bordeaux-accent" />
                <span className="text-xs font-mono font-bold text-bordeaux-primary">{selectedTopic.attachmentName}</span>
                <span className="text-[10px] text-outline-dark ml-auto">Anexo adicionado</span>
              </div>
            )}

            {/* Interaction buttons */}
            <div className="flex items-center gap-3 pt-5 border-t border-cream-bg flex-wrap md:flex-nowrap">
              <button 
                onClick={(e) => handleLikeTopic(selectedTopic.id, e)}
                className={`px-4 py-1.5 rounded-full flex items-center gap-2 text-[10px] md:text-[11px] font-sans font-black tracking-wider uppercase transition-colors cursor-pointer ${
                  selectedTopic.isLiked 
                    ? 'bg-gold-bright text-bordeaux-dark font-black' 
                    : 'bg-cream-bg text-bordeaux-accent hover:bg-outline-light/40'
                }`}
              >
                <Heart className={`w-4 h-4 ${selectedTopic.isLiked ? 'fill-current' : ''}`} />
                <span>{selectedTopic.likesCount} GOSTOS</span>
              </button>

              <button 
                onClick={(e) => handleSaveTopic(selectedTopic.id, e)}
                className={`px-4 py-1.5 rounded-full flex items-center gap-2 text-[10px] md:text-[11px] font-sans font-black tracking-wider uppercase transition-colors cursor-pointer ml-1 ${
                  selectedTopic.isSaved 
                    ? 'bg-gold-bright text-bordeaux-dark font-black' 
                    : 'bg-cream-bg text-bordeaux-accent hover:bg-outline-light/40'
                }`}
              >
                <Bookmark className={`w-4 h-4 ${selectedTopic.isSaved ? 'fill-current' : ''}`} />
                <span>{selectedTopic.isSaved ? 'GUARDADO' : 'SALVAR'}</span>
              </button>
              
              <span className="ml-auto text-outline-dark text-[10px] md:text-[11px] font-sans font-black tracking-wider uppercase bg-cream-bg border border-outline-light px-3 py-1.5 rounded-full flex items-center gap-1.5">
                <MessageSquare className="w-3.5 h-3.5" />
                <span>{selectedTopic.responsesCount} RESPOSTAS</span>
              </span>
            </div>
          </article>

          {/* Expert Reviews - Contributions Section */}
          <section className="space-y-4">
            <h4 className="font-sans text-xs font-black text-outline-dark tracking-[0.15em] uppercase text-left pl-1">
              CONTRIBUIÇÕES DE ESPECIALISTAS
            </h4>

            {selectedTopic.comments.length > 0 ? (
              selectedTopic.comments.map((comment) => (
                <div key={comment.id} className="bg-white border border-outline-light p-4 rounded-xl shadow-sm transition-all duration-300">
                  <div className="flex gap-3">
                    <div className="flex-shrink-0">
                      <div className="w-10 h-10 rounded-full border border-gold-premium overflow-hidden bg-cream-bg">
                        <img 
                          className="w-full h-full object-cover" 
                          src={comment.authorAvatar} 
                          alt={comment.authorName}
                          referrerPolicy="no-referrer"
                        />
                      </div>
                    </div>
                    
                    <div className="flex-1">
                      <div className="flex justify-between items-start mb-1.5">
                        <div>
                          <h5 className="font-sans font-bold text-xs md:text-sm text-bordeaux-accent">{comment.authorName}</h5>
                          <p className="text-[10px] text-gold-premium font-sans font-bold uppercase tracking-wider">{comment.authorTitle}</p>
                        </div>
                        <span className="font-mono text-[9px] text-outline-dark">{comment.timeAgo}</span>
                      </div>
                      
                      <p className="text-bordeaux-primary-accent text-xs md:text-sm leading-relaxed mb-3">
                        {comment.content}
                      </p>

                      <div className="flex gap-4">
                        <button 
                          onClick={() => handleLikeComment(comment.id)}
                          className={`text-[10.5px] font-sans font-bold flex items-center gap-1 hover:text-bordeaux-accent transition-colors cursor-pointer ${
                            comment.isLiked ? 'text-gold-premium font-black' : 'text-outline-dark'
                          }`}
                        >
                          <ThumbsUp className={`w-3.5 h-3.5 ${comment.isLiked ? 'fill-current' : ''}`} />
                          <span>Útil ({comment.likes})</span>
                        </button>
                        
                        <button 
                          onClick={() => alert(`Responder directamente em comentário (brevemente)...`)}
                          className="text-[10.5px] font-sans font-bold text-outline-dark flex items-center gap-1 hover:text-bordeaux-accent transition-colors"
                        >
                          <Reply className="w-3.5 h-3.5" />
                          <span>Responder</span>
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
              ))
            ) : (
              <div className="bg-cream-bg border border-outline-light/60 p-6 rounded-lg text-center">
                <p className="text-xs text-outline-dark font-sans italic">Não há comentários com avaliações técnicas neste debate ainda.</p>
                <p className="text-[11px] font-sans font-bold text-bordeaux-accent mt-1">Seja o primeiro a emitir sua análise profissional!</p>
              </div>
            )}
          </section>

          {/* Sticky Quick Reply Bar component */}
          <div className="fixed bottom-0 left-0 right-0 w-full bg-white border-t border-outline-light py-4 px-4 z-40 pb-6 shadow-[0_-4px_16px_rgba(42,10,18,0.06)]">
            <div className="max-w-2xl mx-auto flex items-center gap-3">
              <div className="w-9 h-9 rounded-full bg-cream-bg flex items-center justify-center overflow-hidden border border-outline-light flex-shrink-0">
                <img 
                  alt={userProfile.name} 
                  className="w-full h-full object-cover" 
                  src={userProfile.avatar}
                  referrerPolicy="no-referrer"
                />
              </div>
              <form onSubmit={handlePostComment} className="flex-1 relative flex items-center">
                <input 
                  type="text" 
                  value={commentText}
                  onChange={(e) => setCommentText(e.target.value)}
                  placeholder="Adicione a sua análise especializada..."
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-full h-11 pl-4 pr-12 focus:ring-1 focus:ring-bordeaux-accent focus:border-bordeaux-accent transition-all text-xs md:text-sm text-bordeaux-primary focus:outline-none placeholder:text-outline-dark/50"
                />
                
                <button 
                  type="submit"
                  disabled={!commentText.trim()}
                  className={`absolute right-1 w-9 h-9 rounded-full flex items-center justify-center transition-all ${
                    commentText.trim() 
                      ? 'bg-bordeaux-accent text-white active:scale-95 cursor-pointer' 
                      : 'bg-cream-bg text-outline-dark/40 cursor-not-allowed'
                  }`}
                >
                  <Send className="w-4.5 h-4.5" />
                </button>
              </form>
            </div>
          </div>

        </div>
      )}

    </div>
  );
};
