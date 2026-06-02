import { UserProfile, ForumTopic, Quiz, RankingUser } from './types';

export const initialUserProfile: UserProfile = {
  name: "Carlos Lopes",
  email: "carlos.lopes@angolaeconomica.ao",
  role: "Investidor Nível III",
  avatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuA68R2rTuyHKXVi5cE5Ar_3R5_UqHQN2_1G90Fm0-DQRTGngIr7ePAOoWdkjLr0NXyZwUSzqFO-cTWPamdrGHiy2cxXS5TE7U0NKMZqZaMzaHKJmsAREqyJXHjsEyIL7GGsJxh8XRS9aX6UaJ-UfYOKBjle48S94K4vAOSlBhomnpeh9yFy0sdGIgf3qITEp1eoDQDXLnOjWbXaIzFu7UtCF0teY0-5jB9xlB-yxTEn0U3ix6gxENkTz8yE-eVTIysmKzuPJzfQiBI",
  points: 1845,
  globalRanking: 12,
  quizPercentage: 85,
  savedArticlesCount: 24,
  commentsCount: 156,
  pushNotifications: true,
  emailAlerts: false,
  darkMode: false,
  fontSize: 'Médio',
};

export const initialRankingUsers: RankingUser[] = [
  {
    position: 1,
    name: "Dra. Ana P.",
    title: "Especialista em Câmbio",
    avatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuAWtBzHbaRAh_C7aLGTLc-TOtqRBplKYlIyxC-BmGbCc9blfoVwOluJ86rlFcL1PJNoBckw_JLivlFdgrQUpFsyFe6owsTdUKZrL0sWMouoy3ObPjQd8rLbu2PtHr2aDQG_pLkb_jKsJwdLn-O2-SwfrJJwZXui7FbdUK2PFOJqDw01E4RGQ-wXLUnBGcZzvYygdZnMJwRJ2lEZ_pTbrV_CVfUbQT7wDJ-bXpAm8sW9yFdMY9ONs9L7C47-HRpbwQm7a25mUHeOMyY",
    points: 3120,
  },
  {
    position: 2,
    name: "Dr. Manuel",
    title: "Economista Chefe de Parcerias",
    avatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuCDPCZfnnY0O0HuKxvfqwnot0eZUptlqLxE2nJIGWf-s5yTCA1DXaQTdRb6Wo1E1Q0IF_sFR_P_k2vHkkABrhLe-4lygAQx2fvxPhngKeCX8o33p5aT_H3RGaV9xojkiCgachI8RBOj4m0aGhYvbVyhoSRE2MJbmOD25N-JYuYNUlhY74cH3pjN34yq5HGCX5d5Hhegj4txbfyrReQERyFQhkgHxZWitcy2Z3_dLvFhSkYfWTak4tFdV3gEDPZJt2pGXEEexQdSxwo",
    points: 2840,
  },
  {
    position: 3,
    name: "Dr. Bronze",
    title: "Consultor de Investimento",
    avatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuB5JIkLjVyRPs763Q40a0W5y8XYPsmiHdWbdvgkZX1lzY73_o8Grbtxtxh7N3NmP7QJ985NnRN2_DNM_TXmpAr9pq8onMcNI9vdRzgmuqK99bAq3sGXZPsVuqvGIjIrRk6HAu93FywHT33v-9PZDS8EQGwb1I5DxEMC0uq9yjAOIwuZ5VWtNGEtt6Ew2AwvYspS_s3vdoF6izXoFA7S_xFmNo7W-3uqyhhWNqlqpxQLSjlXdN3I7Uhy_rPF7Ce16qbiV_s4tg7RVQA",
    points: 2590,
  },
  {
    position: 4,
    name: "Eduardo B.",
    title: "Analista Sénior de Mercados",
    avatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuBkbC600SJW-jdmdRsM49njBOZTPk0RUzWVW7zWDz6HXaMbt1dypDljLEOvyIMzJz6Z35rQM383Ij7IfT_Eg2cBdvM89hWanDUvnj_wROzMbowtnD3y3StOxqkegcjCog7pLVkiBaFy0kn-9nMRR8GSmVziRwt5_BGNnVdYhfs2Reb6jxhKRZ7zC7Ox0R_WZ8qIrpiMeUth0QnT57uQHSUpBE3LMDOCs_B95Qqd6Rjr879vZGOiOWxsh9mEIDcD1zVtshRXbXmGOu0",
    points: 2410,
  },
  {
    position: 5,
    name: "Maria S.",
    title: "Investigadora em Finanças Públicas",
    avatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuCu7POEyWqforeeIn_R_9OuokyudaXa8Ib99895oM2oN5GuR_0XlBeAnQTLblReJuoO1JEDxtAEaLn8jsIAMzzEnNK3aVc4U0RN4s9NrruKgoCVUdCrg4jjfBX584EjS2V-GtrUZ9ECKbrHREK_4OyeqAQBeQxHUqV1Ydkie31hT9JPU5T1q0wMcFjh8qXIOq-wm41E6UMOgdiRtZGT2lTb1UF4cIUI8e1TsP_e9tmGmr4QHQ8KMvvr6qB63fMKODUcuW3COB7ErkE",
    points: 2395,
  },
  {
    position: 6,
    name: "João M.",
    title: "Macroeconomista Independente",
    avatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuBeaFzBFEOIecVLLY5e-JHCTPdYYbLdLZl5XqguYwlXHSnxFYd1w0bz_i2sn2PyklWjPNS9xxol8MiKcQ0xe4g8it3LHKwhXq36_PSphYhMDJwuaAxMMFU2ivnJi9gbEjhcXq0UotOX9quk7QYKnv86liSm1JOrVtypASB7Ens15LFglhpeGBr80PY0HIKjsSFaN3eq8WMoUwoOMLI-nvNfnc-0ncmF0WOtfqQbIBOkn5SYkhwsoWLQqZRBdfJmEt2eaj9uaEUOl4o",
    points: 2210,
  }
];

export const initialForumTopics: ForumTopic[] = [
  {
    id: "topic-1",
    title: "O impacto da nova taxa de câmbio nas importações de bens de consumo em Luanda",
    summary: "O recente ajuste cambial levado a cabo pelo BNA introduz uma nova dinâmica de preços no mercado retalhista de Luanda...",
    content: "O recente ajuste cambial levado a cabo pelo BNA introduz uma nova dinâmica de preços no mercado retalhista de Luanda. Observamos, historicamente, que a transmissão da desvalorização para os preços finais costuma ser imediata em bens não-perecíveis.\n\nGostaria de abrir o debate sobre a resiliência do setor logístico face a estes novos custos e como as empresas estão a adaptar as suas margens para evitar uma quebra acentuada no consumo das famílias de classe média.",
    category: "POLÍTICA MONETÁRIA",
    authorName: "Ana Mendes",
    authorTitle: "ESPECIALISTA EM MACROECONOMIA",
    authorAvatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuB5Fgt0faAVNDggghvbPcvglj8JkAxMMMl19sYTkZh-rc62LQTlNStTq9vfjNrJDGVjun18yy2xxUuYAwY5yfYz4n-Ob_7Ih1yYW63ZnVmvlsqmmMeVhaHU1xspa-PLh_rgz1hICKlfaf_BWMl1jb24f8xJFw-qhm3wCNn89xOHcgzAl-C2Au-K79KLVLYRy-PMTblHe4wwAO7Y8Km7kTYdUx-8EAkKAOltJeNajrKmTAWBcuhJ80_Ezt0HjxeqMKs688HpgQUYONM",
    timeAgo: "2h atrás",
    responsesCount: 48,
    likesCount: 124,
    isLiked: false,
    isSaved: true,
    isFeatured: false,
    comments: [
      {
        id: "c-1",
        authorName: "Dr. Ricardo Vasconcelos",
        authorTitle: "CONSULTOR BANCÁRIO",
        authorAvatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuAGYhpC3M50EWWeX5Lx1nPgYkiAEMiwktYXZEYV7SQE4ftxGMfgzTS9YDDU3Qnrx33YVOZc6afMmkJMxvYhr7zWDBQWqnRAPbYayqjk_gwo0pzu32oxHp04T3ZKqL15kT25t_3hZg1_A7RxMr54mQnNkMpWFhv0AztXOMYkt8bhe942XFcruVe8GAxTjMEfRuKymGQWk5CmFRFPN_h0KPGRAf5ic-7lCunz3-I3EtowWbipZ5kBMdePSmIeVzQgYU1OZmr42AjH8Hg",
        content: "Ana, excelente ponto. A minha análise indica que os grandes importadores já antecipavam este cenário no último trimestre. O desafio real reside no mercado informal, que regula uma fatia significativa do consumo alimentar em Luanda.",
        timeAgo: "45m atrás",
        likes: 12,
        isLiked: false
      },
      {
        id: "c-2",
        authorName: "Isabel Santos",
        authorTitle: "ANALISTA DE INVESTIMENTOS",
        authorAvatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuBCu6Mr9nQ1Uyax_593OZeKQaCaBvUS_qGJmpnkgAvo_39FZo_4Ls_b5_-y_I45D2JDVDYXxHXGV8nuUXAVlXxdKuPXUWsFS67nNJWPnivY2aqZ3Al68PMrZavimODoFBf0qGGkgWgklBGOBgwiLToDVYgSX-u7XSuBaYQ0luea3zGScMjcNaA_dujIJUm3JC5AmO1jY7GhLiL6AZ8zu5ls1Z2cONXUG6luZ3C820kw6NcTfb9JW_VOuDF52Pbd1M7vYyhBPzRcrRQ",
        content: "Temos de considerar também a pressão inflacionária nos produtos produzidos localmente que dependem de matéria-prima importada. A \"resiliência\" terá de passar pela otimização da cadeia de suprimentos interna.",
        timeAgo: "12m atrás",
        likes: 5,
        isLiked: false
      }
    ]
  },
  {
    id: "topic-2",
    title: "O Impacto Histórico da Desvalorização do Kwanza na Produção Nacional",
    summary: "Uma análise profunda sobre como a política monetária atual está redefinindo o parque industrial angolano frente aos novos desafios de importação.",
    content: "Uma análise profunda sobre como a política monetária atual está redefinindo o parque industrial angolano frente aos novos desafios de importação. Historicamente, os ciclos de flexibilização cambial forçam a substituição competitiva por suprimentos locais.",
    category: "MERCADOS",
    authorName: "Dr. Arnaldo Mendes",
    authorTitle: "ESPECIALISTA EM DESENVOLVIMENTO",
    authorAvatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuDvBEvdD2H5lwRpHTU1khotkOkB3qB9AYexTYQcAhN_t4Lr8kE_6UKKSTdc5PzBJquq_7Pw7jB_aa_qR8HhrweyZuVIYUhjLcFThz9TmhwpyQB3Y0mzgaUo9GtS82WxiRf_e3Y6siGKN04pJvS20rvDEkC2VggqezB31ZWUN1dZlE7hmDFKISo8-npiWZRx_ABSm7EAd765wqLsb5vEfKeod5N139cpM3uI-lad4MHasLMKBhxVnm0LV4EHWE5eoniM13CiZUIWOiU",
    timeAgo: "Há 2 horas",
    responsesCount: 42,
    likesCount: 198,
    isLiked: true,
    isSaved: false,
    isFeatured: true, // Destaque!
    comments: []
  },
  {
    id: "topic-3",
    title: "Privatização das empresas públicas: O que esperar do calendário da BODIVA para 2024?",
    summary: "Analistas sugerem que a entrada de novos players no setor diamantífero poderá impulsionar a liquidez do mercado secundário...",
    content: "A Bolsa de Dívida e Valores de Angola (BODIVA) publicou o cronograma atualizado do Programa de Privatizações (PROPRIV). A entrada das emblemáticas mineradoras e bancos estatais no mercado secundário trará um volume de capital estrangeiro inédito na última década. Como os corretores locais devem guiar o pequeno investidor angolano nesta fase de alta volatilidade?",
    category: "MERCADOS",
    authorName: "Mateus Tende",
    authorTitle: "ECONOMISTA CHEFE",
    authorAvatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuA68R2rTuyHKXVi5cE5Ar_3R5_UqHQN2_1G90Fm0-DQRTGngIr7ePAOoWdkjLr0NXyZwUSzqFO-cTWPamdrGHiy2cxXS5TE7U0NKMZqZaMzaHKJmsAREqyJXHjsEyIL7GGsJxh8XRS9aX6UaJ-UfYOKBjle48S94K4vAOSlBhomnpeh9yFy0sdGIgf3qITEp1eoDQDXLnOjWbXaIzFu7UtCF0teY0-5jB9xlB-yxTEn0U3ix6gxENkTz8yE-eVTIysmKzuPJzfQiBI",
    timeAgo: "Hoje, 09:15",
    responsesCount: 18,
    likesCount: 54,
    isLiked: false,
    isSaved: false,
    isFeatured: false,
    comments: []
  },
  {
    id: "topic-4",
    title: "Projectos de Escoamento no Planalto Central: Barreiras Logísticas e Oportunidades",
    summary: "Como a infraestrutura ferroviária pode reduzir os custos operacionais para os pequenos produtores de milho e soja em Huambo?",
    content: "O escoamento agrícola continua sendo o calcanhar de Aquiles do Planalto Central angolano. Apesar do esforço de reabilitação rodoviária, o custo do frete rodoviário canibaliza até 40% do valor final da saca de milho. O Caminho de Ferro de Benguela (CFB) apresenta-se como a única rota logística viável no longo prazo, necessitando, porém, de reformas urgentes para acolhimento de cargas de pequeno porte.",
    category: "AGRICULTURA",
    authorName: "Nuno Silva",
    authorTitle: "ANALISTA SENIOR",
    authorAvatar: "https://lh3.googleusercontent.com/aida-public/AB6AXuB6yPvdfs1pcwRUWA0LvftdS_f8HuNgrbTWb4fnI14PTLfpZGb2QroCtiMgHWRwWQOr-CQSK9PLqTmryXqNQJnbFsXi6IDh039CpKJ8Yezg9tU-thh6r12VtTQBbJxC8aem-bA2zgLIQIjDZVmwIEKwTEvsh0bQCWTyIcG9OtSjxgww5KJzAZZ3lSYHWi8O2BgQQIm2_bg2DxCE5sHtuhS7i7UGX_lpRwckm225bP_UPSJ49KkNSmUr1fm6ifts0Db6WzirY2nlS_s",
    timeAgo: "Ontem, 18:30",
    responsesCount: 24,
    likesCount: 39,
    isLiked: false,
    isSaved: false,
    isFeatured: false,
    comments: []
  }
];

export const initialQuizzes: Quiz[] = [
  {
    id: "quiz-1",
    title: "A Evolução do Kwanza: Da Independência à Atualidade",
    description: "Uma jornada histórica sobre os marcos monetários que moldaram a economia nacional.",
    category: "História Económica",
    difficulty: "Médio",
    timerSeconds: 30,
    allowTips: true,
    isTimed: true,
    questionsCount: 3,
    isInGlobalRanking: true,
    questions: [
      {
        id: "q-1",
        text: "Qual foi o principal fator determinante para a reforma monetária de 1999 que introduziu o Kwanza atual?",
        type: "multiple",
        options: [
          "A descoberta de novas reservas de ouro no Huambo.",
          "O controle da hiperinflação e a estabilização macroeconômica.",
          "A adesão imediata à União Monetária da África Central.",
          "A substituição total da circulação do Dólar americano."
        ],
        correctOptionIndex: 1,
        tip: "Lembre-se do período pós-reajuste de moedas desvalorizadas, como o Novo Kwanza e o Kwanza Reajustado.",
        explanation: "A reforma de 1999 foi um marco de soberania. Após anos de circulação de múltiplas moedas e reajustes constantes devido à inflação extrema, o novo Kwanza buscou ancorar as expectativas dos agentes econômicos em uma nova era de paz e reconstrução financeira estável."
      },
      {
        id: "q-2",
        text: "Em que ano foi realizada a primeira emissão de papel-moeda com a designação oficial de 'Kwanza'?",
        type: "multiple",
        options: [
          "1975",
          "1977",
          "1980",
          "1992"
        ],
        correctOptionIndex: 1,
        tip: "O processo ocorreu cerca de dois anos após a proclamação da independência nacional angolana.",
        explanation: "Em 8 de Janeiro de 1977, sob a liderança do Presidente Agostinho Neto, foi feita a histórica reforma cambial e emissão do Kwanza, substituindo o antigo Escudo angolano herdado do período colonial."
      },
      {
        id: "q-3",
        text: "O Kwanza Reajustado (AOR), circulante entre 1995 e 1999, foi emitido em qual proporção em relação à moeda anterior?",
        type: "multiple",
        options: [
          "1 AOR para cada 1.000 moedas anteriores",
          "1 AOR para cada 10.000 moedas anteriores",
          "1 AOR para cada 1.000.000 de moedas anteriores",
          "1 AOR para cada 10 moedas anteriores"
        ],
        correctOptionIndex: 2,
        tip: "A escala do corte em virtude da hiperinflação dos anos 90 foi gigantesca.",
        explanation: "Durante o auge do processo inflacionário na década de 1990, o Kwanza Reajustado cortou exatamente seis zeros da moeda precedente (o Novo Kwanza) para facilitar a escrituração e simplificar as transações cotidianas."
      }
    ]
  },
  {
    id: "quiz-2",
    title: "Macroeconomia Angolana 2024",
    description: "Desafios de balança de pagamentos, reservas internacionais líquidas e as novas diretivas do BNA.",
    category: "Macroeconomia",
    difficulty: "Avançado",
    timerSeconds: 45,
    allowTips: true,
    isTimed: true,
    questionsCount: 2,
    isInGlobalRanking: true,
    questions: [
      {
        id: "q2-1",
        text: "Qual destas commodities é o pilar dominante responsável por mais de 90% das receitas de exportação de Angola?",
        type: "multiple",
        options: [
          "Gás Natural Liquefeito (GNL)",
          "Diamantes Lapidados",
          "Petróleo Brent",
          "Café Robusta e Madeira Nobre"
        ],
        correctOptionIndex: 2,
        tip: "Refere-se ao principal combustível fóssil extraído amplamente no offshore da Bacia do Congo e Kwanza.",
        explanation: "Embora Angola detenha depósitos massivos de diamantes e gás natural, o petróleo cru continua sendo o principal fator de geração de divisas internacionais, respondendo por quase a totalidade da receita orçamental externa."
      },
      {
        id: "q2-2",
        text: "Qual é a instituição pública em Angola encarregue de regular a taxa básica de juros e as taxas diretoras cambiais?",
        type: "multiple",
        options: [
          "Banco de Poupança e Crédito (BPC)",
          "Banco Nacional de Angola (BNA)",
          "Ministério das Finanças (MINFIN)",
          "Bolsa de Dívida e Valores de Angola (BODIVA)"
        ],
        correctOptionIndex: 1,
        tip: "É o banco central e a autoridade de política monetária da nação.",
        explanation: "O Banco Nacional de Angola (BNA) actua de forma autónoma regulando o mercado monetário angolano, estabelecendo reservas compulsórias e a taxa de referência BNA."
      }
    ]
  }
];
