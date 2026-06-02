import React, { useState } from 'react';
import { Award, Sparkles, CheckCircle2, ChevronRight, ArrowRight, Lightbulb, Clock, ShieldCheck, Play, ArrowLeft, ArrowRightLeft, X, Rocket, FileEdit, Plus, Trash2, HelpCircle } from 'lucide-react';
import { Quiz, QuizQuestion, UserProfile } from '../types';

interface QuizViewProps {
  userProfile: UserProfile;
  initialQuizzes: Quiz[];
  onAddPoints: (pts: number) => void;
}

export const QuizView: React.FC<QuizViewProps> = ({ userProfile, initialQuizzes, onAddPoints }) => {
  const [quizzes, setQuizzes] = useState<Quiz[]>(initialQuizzes);
  const [viewState, setViewState] = useState<'selection' | 'taking' | 'wizard'>('selection');
  
  // Quiz taking state
  const [activeQuiz, setActiveQuiz] = useState<Quiz | null>(null);
  const [currentQuestionIdx, setCurrentQuestionIdx] = useState(0);
  const [selectedOption, setSelectedOption] = useState<number | null>(null);
  const [showTip, setShowTip] = useState(false);
  const [answerConfirmed, setAnswerConfirmed] = useState(false);
  const [score, setScore] = useState(0);
  const [userAnswers, setUserAnswers] = useState<number[]>([]);
  const [showExplanation, setShowExplanation] = useState(false);

  // Quiz wizard (creator) state
  const [wizardStep, setWizardStep] = useState<1 | 2 | 3>(1);
  const [wizTitle, setWizTitle] = useState('');
  const [wizDesc, setWizDesc] = useState('');
  const [wizCat, setWizCat] = useState('Macroeconomia');
  const [wizDifficulty, setWizDifficulty] = useState<'Básico' | 'Médio' | 'Avançado'>('Médio');
  const [wizTimer, setWizTimer] = useState(30);
  const [wizAllowTips, setWizAllowTips] = useState(true);
  const [wizIsTimed, setWizIsTimed] = useState(true);
  
  // Wizard questions list
  const [wizQuestions, setWizQuestions] = useState<QuizQuestion[]>([
    {
      id: "wq-1",
      text: "",
      type: "multiple",
      options: ["", "", "", ""],
      correctOptionIndex: 0,
      tip: "",
      explanation: ""
    }
  ]);
  const [currentWizQIdx, setCurrentWizQIdx] = useState(0);
  const [pubOption, setPubOption] = useState<'now' | 'schedule' | 'draft'>('now');
  const [includeRanking, setIncludeRanking] = useState(true);

  // STARTING A QUIZ
  const handleStartQuiz = (quiz: Quiz) => {
    setActiveQuiz(quiz);
    setCurrentQuestionIdx(0);
    setSelectedOption(null);
    setShowTip(false);
    setAnswerConfirmed(false);
    setScore(0);
    setUserAnswers([]);
    setShowExplanation(false);
    setViewState('taking');
  };

  // CONFIRMING ANSWER
  const handleConfirmAnswer = () => {
    if (selectedOption === null || !activeQuiz) return;
    
    const question = activeQuiz.questions[currentQuestionIdx];
    const isCorrect = selectedOption === question.correctOptionIndex;
    
    if (isCorrect) {
      setScore(prev => prev + 1);
    }
    
    setUserAnswers(prev => [...prev, selectedOption]);
    setAnswerConfirmed(true);
    setShowExplanation(true);
  };

  // NEXT QUESTION OR FINISH
  const handleNextQuestion = () => {
    if (!activeQuiz) return;
    
    if (currentQuestionIdx < activeQuiz.questions.length - 1) {
      setCurrentQuestionIdx(prev => prev + 1);
      setSelectedOption(null);
      setShowTip(false);
      setAnswerConfirmed(false);
      setShowExplanation(false);
    } else {
      // Quiz completed! Award strategic points for completing strategic quizzes
      const strategicPointsEarned = score * 30 + 50; // 30 points per correct answer + 50 base completion points
      onAddPoints(strategicPointsEarned);
      alert(`Parabéns! Completou o quiz com sucesso. Acertou ${score} de ${activeQuiz.questions.length} perguntas e somou ${strategicPointsEarned} pontos de prestígio monetário!`);
      setViewState('selection');
    }
  };

  // CREATOR WIZARD LOGICS:
  const handleAddQuestionToWiz = () => {
    const newQ: QuizQuestion = {
      id: `wq-${Date.now()}`,
      text: "",
      type: "multiple",
      options: ["", "", "", ""],
      correctOptionIndex: 0,
      tip: "",
      explanation: ""
    };
    setWizQuestions(prev => [...prev, newQ]);
    setCurrentWizQIdx(prev => prev + 1);
  };

  const handleUpdateWizQText = (val: string) => {
    setWizQuestions(prev => prev.map((q, idx) => idx === currentWizQIdx ? { ...q, text: val } : q));
  };

  const handleUpdateWizQOption = (optIdx: number, val: string) => {
    setWizQuestions(prev => prev.map((q, idx) => {
      if (idx === currentWizQIdx) {
        const newOpts = [...q.options];
        newOpts[optIdx] = val;
        return { ...q, options: newOpts };
      }
      return q;
    }));
  };

  const handleSetWizQCorrect = (optIdx: number) => {
    setWizQuestions(prev => prev.map((q, idx) => idx === currentWizQIdx ? { ...q, correctOptionIndex: optIdx } : q));
  };

  const handleUpdateWizQTip = (val: string) => {
    setWizQuestions(prev => prev.map((q, idx) => idx === currentWizQIdx ? { ...q, tip: val } : q));
  };

  const handleUpdateWizQExplanation = (val: string) => {
    setWizQuestions(prev => prev.map((q, idx) => idx === currentWizQIdx ? { ...q, explanation: val } : q));
  };

  const handleRemoveWizQOption = (optIdx: number) => {
    // Delete validation
    setWizQuestions(prev => prev.map((q, idx) => {
      if (idx === currentWizQIdx) {
        const newOpts = q.options.filter((_, oIdx) => oIdx !== optIdx);
        return { 
          ...q, 
          options: newOpts,
          correctOptionIndex: q.correctOptionIndex >= newOpts.length ? 0 : q.correctOptionIndex
        };
      }
      return q;
    }));
  };

  const handleWizStep1Submit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!wizTitle.trim() || !wizDesc.trim()) {
      alert("Por favor, preencha o título e a descrição do seu quiz!");
      return;
    }
    setWizardStep(2);
  };

  const handleWizStep2Submit = () => {
    // validate that questions have text and options
    const isInvalid = wizQuestions.some(q => !q.text.trim() || q.options.some(o => !o.trim()));
    if (isInvalid) {
      alert("Por favor, certifique-se de preencher o enunciado e todas as opções de resposta em todas as perguntas!");
      return;
    }
    setWizardStep(3);
  };

  const handlePublishQuiz = () => {
    const finalQuiz: Quiz = {
      id: `quiz-manual-${Date.now()}`,
      title: wizTitle,
      description: wizDesc,
      category: wizCat,
      difficulty: wizDifficulty,
      timerSeconds: wizTimer,
      allowTips: wizAllowTips,
      isTimed: wizIsTimed,
      questionsCount: wizQuestions.length,
      questions: wizQuestions,
      isInGlobalRanking: includeRanking,
      authorName: userProfile.name
    };

    setQuizzes(prev => [finalQuiz, ...prev]);
    onAddPoints(100); // 100 points for publication of high caliber strategic quiz!
    alert(`Sucesso! O seu quiz "${wizTitle}" foi publicado com as configurações de elite e adicionou 100 pontos ao seu perfil!`);
    
    // reset wizard
    setWizTitle('');
    setWizDesc('');
    setWizQuestions([{
      id: "wq-1",
      text: "",
      type: "multiple",
      options: ["", "", "", ""],
      correctOptionIndex: 0,
      tip: "",
      explanation: ""
    }]);
    setCurrentWizQIdx(0);
    setWizardStep(1);
    setViewState('selection');
  };

  return (
    <div className="select-none animate-fadeIn">
      
      {/* ======================================================== */}
      {/* 1. SELECTION SCREEN                                      */}
      {/* ======================================================== */}
      {viewState === 'selection' && (
        <div className="space-y-6 pb-24">
          <div className="flex justify-between items-center bg-white p-4 rounded-xl border border-outline-light">
            <div>
              <p className="text-[10px] text-outline-dark font-black tracking-widest uppercase">MÓDULOS DE EDUCAÇÃO MONETÁRIA</p>
              <h2 className="font-display text-[18px] md:text-[22px] text-bordeaux-primary font-bold">Desafie a sua Mente Financeira</h2>
            </div>
            
            <button 
              onClick={() => setViewState('wizard')}
              className="bg-bordeaux-accent text-white px-4 py-2 rounded-full text-xs font-bold uppercase tracking-wider flex items-center gap-1.5 cursor-pointer shadow-sm hover:bg-bordeaux-primary"
            >
              <Plus className="w-4 h-4 stroke-[2.5]" />
              <span>Criar Quiz</span>
            </button>
          </div>

          <div className="h-[2px] w-12 bg-gold-premium rounded-full" />

          {/* List of active quizzes */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {quizzes.map((quiz) => (
              <div 
                key={quiz.id}
                className="bg-white border border-outline-light p-6 rounded-xl hover:border-gold-premium transition-all duration-200 shadow-sm flex flex-col justify-between"
              >
                <div>
                  <div className="flex justify-between items-start mb-3">
                    <span className="px-2 py-0.5 bg-bordeaux-light text-bordeaux-primary font-sans text-[9px] font-black tracking-wider rounded uppercase">
                      {quiz.category}
                    </span>
                    <span className={`text-[10px] uppercase tracking-wider font-bold ${
                      quiz.difficulty === 'Básico' ? 'text-green-700' : quiz.difficulty === 'Médio' ? 'text-yellow-700' : 'text-red-700'
                    }`}>
                      Nível {quiz.difficulty}
                    </span>
                  </div>

                  <h3 className="font-display text-[18px] text-bordeaux-primary font-bold leading-snug mb-2">
                    {quiz.title}
                  </h3>

                  <p className="text-outline-dark text-xs md:text-sm leading-relaxed mb-6 line-clamp-2">
                    {quiz.description}
                  </p>
                </div>

                <div className="flex items-center justify-between pt-4 border-t border-cream-bg">
                  <div className="flex items-center gap-4 text-[11px] font-mono text-outline-dark">
                    <span className="flex items-center gap-1">
                      <HelpCircle className="w-3.5 h-3.5" />
                      {quiz.questions.length} Perguntas
                    </span>
                    {quiz.isTimed && (
                      <span className="flex items-center gap-1">
                        <Clock className="w-3.5 h-3.5" />
                        {quiz.timerSeconds}s / Pergunta
                      </span>
                    )}
                  </div>

                  <button 
                    onClick={() => handleStartQuiz(quiz)}
                    className="flex items-center gap-1 bg-cream-bg text-bordeaux-accent hover:bg-gold-bright hover:text-bordeaux-dark px-4 py-1.5 rounded-full text-xs font-bold tracking-widest uppercase transition-all cursor-pointer"
                  >
                    <span>Iniciar</span>
                    <Play className="w-3 h-3 fill-current" />
                  </button>
                </div>
              </div>
            ))}
          </div>

          {/* Premium study promotional banner */}
          <div className="bg-bordeaux-primary text-white p-6 rounded-xl relative overflow-hidden bordeaux-shadow">
            <div className="relative z-10 max-w-lg space-y-2">
              <span className="text-[10px] text-gold-bright font-black tracking-widest uppercase font-sans">
                CONTEÚDO ACADÉMICO EXCLUSIVO
              </span>
              <h3 className="font-display text-xl md:text-2xl font-bold text-white">
                Masterclass: História Monetária de Angola
              </h3>
              <p className="text-gold-light/80 text-xs md:text-sm leading-relaxed pt-1">
                Desbloqueie o curso audiovisual completo de economia colonial para membros diplomados e domine a transição estrutural dos ciclos produtivos nacionais.
              </p>
              <button 
                onClick={() => alert("Serviço Premium: Esta masterclass está em fase de auditoria pelo Conselho Editorial. Fique atento às notificações!")}
                className="bg-gold-bright text-bordeaux-dark px-6 py-2.5 rounded-lg text-xs font-bold uppercase tracking-wider hover:brightness-105 active:scale-95 transition-all mt-4 cursor-pointer"
              >
                Quero Aceder agora
              </button>
            </div>
            
            <div className="absolute right-0 bottom-0 opacity-10 pointer-events-none translate-x-6 translate-y-6">
              <Award className="w-48 h-48" />
            </div>
          </div>
        </div>
      )}

      {/* ======================================================== */}
      {/* 2. TAKING INTERACTIVE SCREEN                              */}
      {/* ======================================================== */}
      {viewState === 'taking' && activeQuiz && (
        <div className="max-w-4xl mx-auto space-y-6 pb-24">
          <div className="flex justify-between items-center">
            <button 
              onClick={() => setViewState('selection')}
              className="text-bordeaux-accent p-2 rounded-full hover:bg-cream-bg transition-colors flex items-center gap-1 cursor-pointer font-bold font-sans text-xs tracking-wider"
            >
              <X className="w-5 h-5" />
              <span>Desistir do Módulo</span>
            </button>
            
            <div className="flex flex-col items-end">
              <span className="font-mono text-xs text-gold-premium font-bold uppercase tracking-wider">
                Pergunta {currentQuestionIdx + 1} de {activeQuiz.questions.length}
              </span>
            </div>
          </div>

          {/* Progress bar indication */}
          <div className="w-full bg-outline-light h-1 rounded-full overflow-hidden">
            <div 
              className="bg-bordeaux-accent h-full transition-all duration-300"
              style={{ width: `${((currentQuestionIdx) / activeQuiz.questions.length) * 100}%` }}
            />
          </div>

          {/* QUESTION SECTION & DESKTOP BENTO LAYOUT */}
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
            
            <div className="lg:col-span-8 space-y-4">
              
              {/* Question Statement Card */}
              <section className="bg-bordeaux-primary p-6 md:p-8 rounded-xl text-white relative overflow-hidden bordeaux-shadow">
                <div className="relative z-10">
                  <span className="bg-gold-bright text-bordeaux-dark px-2.5 py-0.5 rounded-full text-[9px] font-sans font-black tracking-widest uppercase mb-4 inline-block">
                    {activeQuiz.category.toUpperCase()}
                  </span>
                  <h2 className="font-display text-[18px] md:text-[22px] font-bold leading-normal text-white">
                    {activeQuiz.questions[currentQuestionIdx].text}
                  </h2>
                </div>
              </section>

              {/* Multiple Choice Options List */}
              <div className="space-y-3">
                {activeQuiz.questions[currentQuestionIdx].options.map((option, optIdx) => {
                  const isSelected = selectedOption === optIdx;
                  const isCorrectAnswerIdx = optIdx === activeQuiz.questions[currentQuestionIdx].correctOptionIndex;
                  
                  let optionStyle = "border-outline-light bg-white text-bordeaux-primary hover:border-bordeaux-accent";
                  if (answerConfirmed) {
                    if (isCorrectAnswerIdx) {
                      optionStyle = "border-green-600 bg-green-50/50 text-green-800 font-bold ring-2 ring-green-600";
                    } else if (isSelected) {
                      optionStyle = "border-red-600 bg-red-50/50 text-red-800 ring-2 ring-red-600 opacity-90";
                    } else {
                      optionStyle = "border-outline-light bg-white text-outline-dark opacity-60";
                    }
                  } else if (isSelected) {
                    optionStyle = "border-bordeaux-accent bg-bordeaux-light/30 text-bordeaux-primary ring-2 ring-bordeaux-accent";
                  }

                  return (
                    <button
                      key={optIdx}
                      disabled={answerConfirmed}
                      onClick={() => setSelectedOption(optIdx)}
                      className={`w-full flex items-center p-4 rounded-xl border text-left text-xs md:text-sm transition-all duration-150 ${
                        answerConfirmed ? 'cursor-default' : 'hover:scale-[1.005] active:scale-[0.995] cursor-pointer'
                      } ${optionStyle}`}
                    >
                      <div className={`w-8 h-8 rounded-full border flex items-center justify-center mr-3 font-mono font-bold text-xs ${
                        answerConfirmed && isCorrectAnswerIdx
                          ? 'bg-green-600 border-green-600 text-white'
                          : answerConfirmed && isSelected
                          ? 'bg-red-600 border-red-600 text-white'
                          : isSelected
                          ? 'bg-bordeaux-accent border-bordeaux-accent text-white'
                          : 'border-outline-dark/30 text-outline-dark'
                      }`}>
                        {String.fromCharCode(65 + optIdx)}
                      </div>
                      <span className="flex-1 leading-normal">{option}</span>
                    </button>
                  );
                })}
              </div>

              {/* Action and Tips Bar */}
              <div className="flex justify-between items-center pt-3">
                {activeQuiz.allowTips && activeQuiz.questions[currentQuestionIdx].tip && (
                  <button
                    onClick={() => setShowTip(!showTip)}
                    className="flex items-center gap-1.5 text-gold-premium hover:text-bordeaux-primary transition-colors font-sans text-[11px] font-black uppercase tracking-wider cursor-pointer"
                  >
                    <Lightbulb className={`w-4 h-4 ${showTip ? 'fill-current' : ''}`} />
                    <span>Dica de Especialista</span>
                  </button>
                )}

                {!answerConfirmed ? (
                  <button
                    disabled={selectedOption === null}
                    onClick={handleConfirmAnswer}
                    className={`px-8 py-3 rounded-lg font-sans text-xs font-bold uppercase tracking-widest shadow-md transition-all ${
                      selectedOption !== null
                        ? 'bg-gold-bright text-bordeaux-dark hover:brightness-105 active:scale-95 cursor-pointer'
                        : 'bg-cream-bg text-outline-dark/50 cursor-not-allowed border border-outline-light'
                    }`}
                  >
                    Confirmar Resposta
                  </button>
                ) : (
                  <button
                    onClick={handleNextQuestion}
                    className="bg-bordeaux-primary text-white border border-gold-premium/40 px-8 py-3 rounded-lg font-sans text-xs font-bold uppercase tracking-widest hover:bg-bordeaux-accent active:scale-95 transition-all flex items-center gap-1.5 cursor-pointer"
                  >
                    <span>
                      {currentQuestionIdx < activeQuiz.questions.length - 1 ? 'Seguinte Pergunta' : 'Ver Nota Final'}
                    </span>
                    <ArrowRight className="w-4 h-4" />
                  </button>
                )}
              </div>

              {/* Hint output info */}
              {showTip && !answerConfirmed && activeQuiz.questions[currentQuestionIdx].tip && (
                <div className="bg-yellow-50/50 border border-yellow-200 rounded-xl p-4 text-xs text-yellow-900 leading-relaxed font-sans">
                  <b>Dica:</b> {activeQuiz.questions[currentQuestionIdx].tip}
                </div>
              )}

              {/* Explanation section */}
              {showExplanation && activeQuiz.questions[currentQuestionIdx].explanation && (
                <div className="bg-cream-bg border border-outline-light rounded-xl p-5 space-y-2 font-sans text-xs md:text-sm leading-relaxed animate-fadeIn">
                  <h4 className="font-bold text-bordeaux-primary">Explicação Editorial Clarificadora:</h4>
                  <p className="text-outline-dark italic">{activeQuiz.questions[currentQuestionIdx].explanation}</p>
                </div>
              )}

            </div>

            {/* Desktop right sidebar content */}
            <div className="lg:col-span-4 space-y-4">
              
              {/* Performance Indicator */}
              <div className="bg-cream-bg border border-outline-light rounded-xl p-5 text-center">
                <h3 className="font-sans text-[11px] font-bold text-outline-dark uppercase tracking-wider mb-4">SEU DESEMPENHO ATUAL</h3>
                
                {/* SVG circular track */}
                <div className="relative w-24 h-24 mx-auto mb-4 flex items-center justify-center">
                  <svg className="w-full h-full transform -rotate-90">
                    <circle className="text-outline-light" cx="48" cy="48" fill="transparent" r="42" stroke="currentColor" strokeWidth="6"></circle>
                    <circle 
                      className="text-bordeaux-accent" 
                      cx="48" 
                      cy="48" 
                      fill="transparent" 
                      r="42" 
                      stroke="currentColor" 
                      strokeWidth="6"
                      strokeDasharray="263.8"
                      strokeDashoffset={263.8 - (263.8 * (score / activeQuiz.questions.length))}
                      strokeLinecap="round"
                    ></circle>
                  </svg>
                  <div className="absolute inset-0 flex flex-col items-center justify-center font-mono">
                    <span className="text-xl font-bold text-bordeaux-primary">
                      {Math.round((score / activeQuiz.questions.length) * 100)}%
                    </span>
                  </div>
                </div>

                <p className="font-sans font-bold text-sm text-bordeaux-primary">{score} de {activeQuiz.questions.length} Acertos</p>
                <p className="text-[10px] text-outline-dark capitalize tracking-wide font-sans mt-0.5">Analista Júnior no Módulo</p>
              </div>

              {/* Historical coin context illustration card representation */}
              <div className="bg-white border border-outline-light rounded-xl overflow-hidden shadow-sm">
                <div className="h-32 overflow-hidden relative">
                  <img 
                    alt="Colecção de Moedas de Angola" 
                    className="w-full h-full object-cover filter sepia-[0.3]" 
                    src="https://lh3.googleusercontent.com/aida-public/AB6AXuAiNL9f4DMz4RRQuDT_galTMMzJ0CZZpE28CYvkPTpiistdGR0daPvsRTaBXqWPpSsHfoAKVjetJyqwdGzz-81zJRpfpW_4FNu06E6HCh94NYUPAw0o-fkD98t9AJkOMtRtx9tOMaEQib3HQ1AkPf33qut9JMpY6Igr9JuCZ2A_ySi8P3uXB2dKO1pBivUmp99hWdDDqhihil2GU6m3GYKDuPc9uGS4VRrYckxELhQh2Fp4QVBaBb2-QymjHG8JogW5VhIvxFuePJE"
                    referrerPolicy="no-referrer"
                  />
                  <div className="absolute inset-0 bg-gradient-to-t from-bordeaux-primary/80 to-transparent"></div>
                  <div className="absolute bottom-3 left-3">
                    <span className="bg-gold-bright text-bordeaux-dark px-2 py-0.5 text-[9px] font-sans font-bold tracking-widest rounded-sm uppercase">
                      Estudo Monetário
                    </span>
                  </div>
                </div>
                <div className="p-4 space-y-2">
                  <p className="font-sans text-[11px] text-outline-dark leading-relaxed italic">
                    &ldquo;Dada a natureza de dependência cambial e a fragilidade do kwanza nos choques dos anos 90, as sucessivas reformas no regime regulatório sedimentaram a estabilidade do poder de compra angolano moderno...&rdquo;
                  </p>
                  <p className="text-[9px] font-mono font-bold text-gold-premium tracking-wider uppercase pt-1">Fonte: Arquivo Histórico de Luanda</p>
                </div>
              </div>

            </div>

          </div>

        </div>
      )}

      {/* ======================================================== */}
      {/* 3. WIZARD CREATION FORM (QUIZ GENERATOR)                 */}
      {/* ======================================================== */}
      {viewState === 'wizard' && (
        <div className="max-w-xl mx-auto space-y-6 pb-24">
          <div className="flex items-center gap-3">
            <button 
              onClick={() => setViewState('selection')}
              className="text-bordeaux-accent p-2 rounded-full hover:bg-cream-bg transition-colors cursor-pointer"
            >
              <ArrowLeft className="w-5 h-5" />
            </button>
            <div>
              <p className="font-sans text-[10px] font-bold text-outline-dark uppercase tracking-wider">Laboratório de Avaliação</p>
              <h2 className="font-display text-xl text-bordeaux-primary font-bold">Criar Novo Quiz</h2>
            </div>
          </div>

          <div className="h-[2px] w-12 bg-gold-premium rounded-full" />

          {/* Stepper indicators representing screen wizards */}
          <div className="flex items-center justify-between mb-8 px-4 select-none">
            <div className="flex flex-col items-center gap-1">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs ${
                wizardStep === 1 ? 'bg-bordeaux-primary text-white ring-4 ring-bordeaux-light' : 'bg-green-600 text-white'
              }`}>
                {wizardStep > 1 ? <CheckCircle2 className="w-5 h-5" /> : '1'}
              </div>
              <span className={`text-[10px] font-sans font-bold ${wizardStep === 1 ? 'text-bordeaux-primary' : 'text-outline-dark'}`}>
                Informações
              </span>
            </div>
            <div className="flex-1 h-[1.5px] bg-outline-light mx-2" />
            <div className="flex flex-col items-center gap-1">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center border text-xs font-bold ${
                wizardStep === 2 ? 'bg-bordeaux-primary text-white ring-4 ring-bordeaux-light' : wizardStep === 3 ? 'bg-green-600 text-white' : 'border-outline-light text-outline-dark bg-white'
              }`}>
                {wizardStep > 2 ? <CheckCircle2 className="w-5 h-5" /> : '2'}
              </div>
              <span className={`text-[10px] font-sans font-bold ${wizardStep === 2 ? 'text-bordeaux-primary' : 'text-outline-dark'}`}>
                Perguntas
              </span>
            </div>
            <div className="flex-1 h-[1.5px] bg-outline-light mx-2" />
            <div className="flex flex-col items-center gap-1">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center border text-xs font-bold ${
                wizardStep === 3 ? 'bg-bordeaux-primary text-white ring-4 ring-bordeaux-light' : 'border-outline-light text-outline-dark bg-white'
              }`}>
                3
              </div>
              <span className={`text-[10px] font-sans font-bold ${wizardStep === 3 ? 'text-bordeaux-primary' : 'text-outline-dark'}`}>
                Publicar
              </span>
            </div>
          </div>

          {/* STEP 1: GENERAL INFO */}
          {wizardStep === 1 && (
            <form onSubmit={handleWizStep1Submit} className="bg-white border border-outline-light p-6 rounded-xl bordeaux-shadow space-y-5">
              <div className="space-y-1">
                <label className="block text-[11px] font-bold text-bordeaux-accent uppercase tracking-widest font-sans">
                  Título do Quiz
                </label>
                <input 
                  type="text"
                  value={wizTitle}
                  onChange={(e) => setWizTitle(e.target.value)}
                  placeholder="Ex: Macroeconomia Angolana 2024"
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-full px-4 py-3 text-bordeaux-primary placeholder:text-outline-dark/60 font-sans focus:outline-none focus:border-bordeaux-accent text-sm"
                />
              </div>

              <div className="space-y-1">
                <label className="block text-[11px] font-bold text-bordeaux-accent uppercase tracking-widest font-sans">
                  Descrição do Módulo
                </label>
                <textarea 
                  value={wizDesc}
                  onChange={(e) => setWizDesc(e.target.value)}
                  placeholder="Descreva brevemente os temas abordados neste quiz de macroeconomia ou finanças..."
                  rows={3}
                  className="w-full bg-cream-bg/40 border border-outline-light rounded-xl p-4 text-bordeaux-primary placeholder:text-outline-dark/60 font-sans focus:outline-none focus:border-bordeaux-accent text-sm resize-none"
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
                <div className="space-y-1">
                  <label className="block text-[11px] font-bold text-bordeaux-accent uppercase tracking-widest font-sans">
                    Categoria
                  </label>
                  <select 
                    value={wizCat}
                    onChange={(e) => setWizCat(e.target.value)}
                    className="w-full bg-white border border-outline-light rounded-full px-4 py-3 text-bordeaux-primary font-sans focus:outline-none focus:border-bordeaux-accent text-sm appearance-none"
                  >
                    <option>Macroeconomia</option>
                    <option>Mercado de Câmbio</option>
                    <option>História Económica</option>
                    <option>Finanças Públicas</option>
                  </select>
                </div>

                <div className="space-y-1">
                  <label className="block text-[11px] font-bold text-bordeaux-accent uppercase tracking-widest font-sans">
                    Nível de Dificuldade
                  </label>
                  <div className="flex gap-2">
                    {(['Básico', 'Médio', 'Avançado'] as const).map((diff) => (
                      <button
                        key={diff}
                        type="button"
                        onClick={() => setWizDifficulty(diff)}
                        className={`flex-1 py-2 rounded-full border text-[10px] md:text-[11.5px] font-sans font-bold transition-all cursor-pointer ${
                          wizDifficulty === diff
                            ? 'bg-bordeaux-primary text-white border-bordeaux-primary'
                            : 'bg-white text-outline-dark border-outline-light hover:border-bordeaux-accent'
                        }`}
                      >
                        {diff}
                      </button>
                    ))}
                  </div>
                </div>
              </div>

              {/* Range timer slider */}
              <div className="space-y-3 pt-2">
                <div className="flex justify-between items-center text-xs md:text-sm">
                  <label className="text-[11px] font-bold text-bordeaux-accent uppercase tracking-widest font-sans">
                    Tempo Limite por Pergunta
                  </label>
                  <span className="text-bordeaux-primary font-mono font-bold px-3 py-1 bg-bordeaux-light rounded-full text-[11px]">
                    {wizTimer} segundos
                  </span>
                </div>
                <input 
                  type="range"
                  min={10}
                  max={120}
                  step={5}
                  value={wizTimer}
                  onChange={(e) => setWizTimer(parseInt(e.target.value))}
                  className="w-full h-2 bg-outline-light rounded-lg appearance-none cursor-pointer accent-gold-premium"
                />
              </div>

              {/* Toggle controls */}
              <div className="space-y-4 pt-3 border-t border-outline-light">
                <span className="block text-[11px] font-bold text-bordeaux-accent uppercase tracking-widest font-sans">
                  Configurações Adicionais
                </span>
                
                <div className="flex justify-between items-center bg-cream-bg/30 p-2.5 rounded-lg">
                  <div className="flex items-center gap-2 text-xs md:text-sm text-bordeaux-primary font-medium">
                    <Lightbulb className="w-4 h-4 text-gold-premium" />
                    <span>Permitir dicas nas perguntas</span>
                  </div>
                  <input 
                    type="checkbox"
                    checked={wizAllowTips}
                    onChange={(e) => setWizAllowTips(e.target.checked)}
                    className="w-5 h-5 rounded text-bordeaux-accent border-outline-light focus:ring-bordeaux-accent"
                  />
                </div>

                <div className="flex justify-between items-center bg-cream-bg/30 p-2.5 rounded-lg">
                  <div className="flex items-center gap-2 text-xs md:text-sm text-bordeaux-primary font-medium">
                    <Clock className="w-4 h-4 text-bordeaux-accent" />
                    <span>Módulo com Cronómetro</span>
                  </div>
                  <input 
                    type="checkbox"
                    checked={wizIsTimed}
                    onChange={(e) => setWizIsTimed(e.target.checked)}
                    className="w-5 h-5 rounded text-bordeaux-accent border-outline-light focus:ring-bordeaux-accent"
                  />
                </div>
              </div>

              <button
                type="submit"
                className="w-full h-12 bg-bordeaux-accent text-white rounded-lg font-sans text-xs font-bold uppercase tracking-widest shadow-md hover:bg-bordeaux-primary active:scale-[0.98] transition-all flex items-center justify-center gap-1.5 cursor-pointer"
              >
                <span>Continuar para as Perguntas</span>
                <ChevronRight className="w-4 h-4" />
              </button>

            </form>
          )}

          {/* STEP 2: CREATING QUESTIONS */}
          {wizardStep === 2 && (
            <div className="bg-white border border-outline-light p-6 rounded-xl bordeaux-shadow space-y-6">
              
              <div className="flex justify-between items-center">
                <span className="text-xs font-mono font-bold text-gold-premium tracking-wider uppercase">
                  Pergunta {currentWizQIdx + 1} de {wizQuestions.length}
                </span>

                <div className="flex items-center gap-1.5 text-xs font-sans text-outline-dark">
                  {wizQuestions.length > 1 && (
                    <button
                      onClick={() => {
                        setWizQuestions(prev => prev.filter((_, idx) => idx !== currentWizQIdx));
                        setCurrentWizQIdx(prev => Math.max(0, prev - 1));
                      }}
                      className="text-red-700 hover:bg-red-50 p-1.5 rounded transition-colors flex items-center gap-1"
                      title="Apagar esta pergunta"
                    >
                      <Trash2 className="w-3.5 h-3.5" />
                      <span>Apagar</span>
                    </button>
                  )}
                </div>
              </div>

              {/* Question text */}
              <div className="space-y-1">
                <label className="block text-[11px] font-bold text-[#7B1A2E] uppercase tracking-widest font-sans">
                  Texto da Pergunta
                </label>
                <textarea 
                  value={wizQuestions[currentWizQIdx].text}
                  onChange={(e) => handleUpdateWizQText(e.target.value)}
                  placeholder="Ex: Em que ano foi decretada a unificação das caixas de previdência de Luanda e Huambo?"
                  rows={2}
                  className="w-full bg-[#FAF6F2] border border-outline-light focus:border-bordeaux-accent rounded p-3 text-bordeaux-primary placeholder:text-outline-dark/40 font-sans focus:outline-none text-sm"
                />
              </div>

              {/* Choices option boxes */}
              <div className="space-y-3">
                <label className="block text-[11px] font-bold text-[#7B1A2E] uppercase tracking-widest font-sans">
                  Opções de Resposta (Marque a correcta)
                </label>

                {wizQuestions[currentWizQIdx].options.map((opt, oIdx) => (
                  <div key={oIdx} className="flex items-center gap-3">
                    <input 
                      type="radio"
                      name={`wizCorrect-${currentWizQIdx}`}
                      checked={wizQuestions[currentWizQIdx].correctOptionIndex === oIdx}
                      onChange={() => handleSetWizQCorrect(oIdx)}
                      className="w-4.5 h-4.5 text-bordeaux-accent focus:ring-bordeaux-accent border-outline-light cursor-pointer"
                    />
                    <input 
                      type="text"
                      value={opt}
                      onChange={(e) => handleUpdateWizQOption(oIdx, e.target.value)}
                      placeholder={`Opção ${String.fromCharCode(65 + oIdx)}`}
                      className="flex-1 bg-white border border-outline-light rounded-full px-4 py-2.5 text-xs md:text-sm text-bordeaux-primary focus:outline-none focus:border-bordeaux-accent placeholder:text-outline-dark/40 transition-all font-sans"
                    />
                    {wizQuestions[currentWizQIdx].options.length > 2 && (
                      <button
                        type="button"
                        onClick={() => handleRemoveWizQOption(oIdx)}
                        className="text-outline-dark hover:text-red-700 transition-colors"
                        title="Remover opção"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    )}
                  </div>
                ))}
              </div>

              {/* Add option if less than 6 */}
              {wizQuestions[currentWizQIdx].options.length < 6 && (
                <button
                  type="button"
                  onClick={() => {
                    setWizQuestions(prev => prev.map((q, idx) => {
                      if (idx === currentWizQIdx) {
                        return { ...q, options: [...q.options, ""] };
                      }
                      return q;
                    }));
                  }}
                  className="text-xs font-bold text-bordeaux-accent hover:text-bordeaux-primary flex items-center gap-1"
                >
                  <Plus className="w-3.5 h-3.5" /> Adicionar Opção Extra
                </button>
              )}

              {/* Help tip and Explanation */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4 border-t border-outline-light">
                <div className="space-y-1">
                  <label className="block text-[11px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                    Dica Informativa (Opconal)
                  </label>
                  <input 
                    type="text"
                    value={wizQuestions[currentWizQIdx].tip || ""}
                    onChange={(e) => handleUpdateWizQTip(e.target.value)}
                    placeholder="Dica útil para guiar as decisões..."
                    className="w-full bg-white border border-outline-light rounded-full px-4 py-2.5 text-xs text-bordeaux-primary focus:outline-none focus:border-bordeaux-accent placeholder:text-outline-dark/40 font-medium font-sans"
                  />
                </div>

                <div className="space-y-1">
                  <label className="block text-[11px] font-bold text-outline-dark uppercase tracking-widest font-sans">
                    Explicação da Resposta
                  </label>
                  <input 
                    type="text"
                    value={wizQuestions[currentWizQIdx].explanation || ""}
                    onChange={(e) => handleUpdateWizQExplanation(e.target.value)}
                    placeholder="Explicação explicativa esclarecedora..."
                    className="w-full bg-white border border-outline-light rounded-full px-4 py-2.5 text-xs text-bordeaux-primary focus:outline-none focus:border-bordeaux-accent placeholder:text-outline-dark/40 font-medium font-sans"
                  />
                </div>
              </div>

              {/* Add Question Slot to form */}
              <button 
                type="button"
                onClick={handleAddQuestionToWiz}
                className="w-full border-2 border-dashed border-bordeaux-accent text-bordeaux-accent hover:bg-bordeaux-light/20 py-3 rounded-lg font-sans font-bold text-xs uppercase tracking-widest flex items-center justify-center gap-1.5 transition-colors cursor-pointer"
              >
                <Plus className="w-4 h-4 stroke-[2]" />
                Adicionar Nova Pergunta
              </button>

              {/* Wizard navigation bar slots */}
              <div className="flex justify-between items-center pt-4 border-t border-outline-light select-none">
                <button
                  disabled={currentWizQIdx === 0}
                  onClick={() => setCurrentWizQIdx(prev => Math.max(0, prev - 1))}
                  className={`flex items-center gap-1 text-[11px] font-sans font-bold uppercase transition-opacity ${
                    currentWizQIdx === 0 ? 'text-outline-dark opacity-35 cursor-not-allowed' : 'text-bordeaux-accent hover:text-bordeaux-primary cursor-pointer'
                  }`}
                >
                  <ArrowLeft className="w-4 h-4" />
                  <span>Pergunta Anterior</span>
                </button>

                <button
                  onClick={() => {
                    if (currentWizQIdx < wizQuestions.length - 1) {
                      setCurrentWizQIdx(prev => prev + 1);
                    } else {
                      handleWizStep2Submit();
                    }
                  }}
                  className="flex items-center gap-1 text-[11px] font-sans font-bold text-bordeaux-accent hover:text-bordeaux-primary uppercase h-10 px-4 rounded hover:bg-cream-bg transition-colors cursor-pointer"
                >
                  <span>
                    {currentWizQIdx < wizQuestions.length - 1 ? 'Seguinte Pergunta' : 'Revisão Final'}
                  </span>
                  <ArrowRight className="w-4 h-4" />
                </button>
              </div>

            </div>
          )}

          {/* STEP 3: PREVIEW, RANKING OPTIONS & PUBLICATION */}
          {wizardStep === 3 && (
            <div className="space-y-6">
              
              <section className="space-y-3">
                <h3 className="font-sans text-xs font-black text-outline-dark tracking-widest uppercase pl-1">
                  PRÉ-VISUALIZAÇÃO DE PUBLICAÇÃO
                </h3>
                
                {/* Visual template box showing finalized outline */}
                <div className="bg-bordeaux-primary text-white p-6 rounded-xl bordeaux-shadow space-y-4">
                  <div className="flex justify-between items-start">
                    <span className="bg-gold-bright text-bordeaux-dark px-3 py-1 font-sans text-[9px] font-black tracking-widest rounded-sm uppercase">
                      {wizCat.toUpperCase()}
                    </span>
                    <Award className="w-6 h-6 text-gold-bright" />
                  </div>

                  <h3 className="font-display text-[20px] font-bold text-white leading-tight">
                    {wizTitle || 'Sem Título Declarado'}
                  </h3>

                  <p className="text-gold-light/80 font-sans text-xs leading-relaxed">
                    {wizDesc || 'Sem descrição cadastrada do escopo do módulo académico.'}
                  </p>

                  <div className="flex items-center gap-4 text-xs font-mono text-gold-light opacity-90 pt-1">
                    <span>{wizQuestions.length} Perguntas</span>
                    <span>Nível {wizDifficulty}</span>
                    <span>{wizTimer}s limite por item</span>
                  </div>
                </div>
              </section>

              {/* Publication options configuration parameters */}
              <section className="bg-white border border-outline-light p-6 rounded-xl bordeaux-shadow space-y-5">
                <h3 className="font-sans text-xs font-black text-outline-dark tracking-widest uppercase border-b border-outline-light pb-2 mb-1">
                  OPÇÕES DE PUBLICAÇÃO
                </h3>

                <div className="space-y-3">
                  {[
                    { id: 'now', title: "Publicar Agora", desc: "O quiz ficará disponível imediatamente para todos os utilizadores no portal comum." },
                    { id: 'schedule', title: "Agendar Publicação", desc: "Escolha uma data e intervalo de horas para o lançamento automatizado programado." },
                    { id: 'draft', title: "Salvar como Rascunho", desc: "Guarde as suas alterações em seu laboratório para continuar o trabalho mais tarde." }
                  ].map((opt) => (
                    <label 
                      key={opt.id}
                      onClick={() => setPubOption(opt.id as any)}
                      className={`flex items-center gap-4 p-4 rounded-xl border transition-all cursor-pointer ${
                        pubOption === opt.id 
                          ? 'border-bordeaux-accent bg-bordeaux-light/35' 
                          : 'border-outline-light bg-white hover:bg-cream-bg/30'
                      }`}
                    >
                      <input 
                        type="radio"
                        name="wizPubOption"
                        checked={pubOption === opt.id}
                        onChange={() => setPubOption(opt.id as any)}
                        className="w-4.5 h-4.5 text-bordeaux-accent focus:ring-bordeaux-accent border-outline-light"
                      />
                      <div className="flex-1">
                        <span className="block font-sans font-bold text-xs md:text-sm text-bordeaux-primary">{opt.title}</span>
                        <span className="text-[10px] md:text-[11px] text-outline-dark font-sans leading-tight block">{opt.desc}</span>
                      </div>
                    </label>
                  ))}
                </div>

                <div className="h-[1px] bg-outline-light w-full" />

                {/* Inclusion global ranking checkbox */}
                <div className="flex items-center justify-between p-1 select-none">
                  <div className="flex flex-col">
                    <span className="font-sans font-bold text-xs md:text-sm text-bordeaux-primary">Incluir no Ranking Global</span>
                    <span className="text-[10px] md:text-[11px] text-outline-dark font-sans block mt-0.5">Permite que as pontuações e percentuais de acertos sejam comparados mundialmente.</span>
                  </div>
                  
                  <input 
                    type="checkbox"
                    checked={includeRanking}
                    onChange={(e) => setIncludeRanking(e.target.checked)}
                    className="w-5 h-5 rounded text-bordeaux-accent border-outline-light focus:ring-bordeaux-accent cursor-pointer"
                  />
                </div>
              </section>

              {/* Action operations buttons */}
              <div className="flex flex-col gap-3">
                <button
                  type="button"
                  onClick={handlePublishQuiz}
                  className="bg-gold-bright text-bordeaux-dark font-sans text-xs font-black uppercase tracking-widest h-12 rounded-lg flex items-center justify-center gap-1.5 shadow-md hover:brightness-105 active:scale-[0.98] transition-all cursor-pointer"
                >
                  <Rocket className="w-4.5 h-4.5 fill-current" />
                  <span>Publicar Módulo do Quiz</span>
                </button>

                <button
                  type="button"
                  onClick={() => setWizardStep(2)}
                  className="border-2 border-bordeaux-accent text-bordeaux-accent hover:bg-bordeaux-light/10 font-sans text-xs font-bold uppercase tracking-widest h-12 rounded-lg flex items-center justify-center transition-all cursor-pointer"
                >
                  Regressar para Edição
                </button>
              </div>

            </div>
          )}

        </div>
      )}

    </div>
  );
};
