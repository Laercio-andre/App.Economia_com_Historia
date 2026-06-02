export interface UserProfile {
  name: string;
  email: string;
  role: string;
  avatar: string;
  points: number;
  globalRanking: number;
  quizPercentage: number;
  savedArticlesCount: number;
  commentsCount: number;
  pushNotifications: boolean;
  emailAlerts: boolean;
  darkMode: boolean;
  fontSize: 'Pequeno' | 'Médio' | 'Grande';
}

export interface ForumComment {
  id: string;
  authorName: string;
  authorTitle: string;
  authorAvatar: string;
  content: string;
  timeAgo: string;
  likes: number;
  isLiked?: boolean;
}

export interface ForumTopic {
  id: string;
  title: string;
  summary: string;
  content: string;
  category: string;
  authorName: string;
  authorTitle: string;
  authorAvatar: string;
  timeAgo: string;
  responsesCount: number;
  likesCount: number;
  isLiked?: boolean;
  isSaved?: boolean;
  isFeatured?: boolean;
  comments: ForumComment[];
  attachmentName?: string;
  attachmentType?: string;
}

export interface QuizQuestion {
  id: string;
  text: string;
  type: 'multiple' | 'boolean';
  options: string[];
  correctOptionIndex: number;
  tip?: string;
  explanation?: string;
}

export interface Quiz {
  id: string;
  title: string;
  description: string;
  category: string;
  difficulty: 'Básico' | 'Médio' | 'Avançado';
  timerSeconds: number;
  allowTips: boolean;
  isTimed: boolean;
  questionsCount: number;
  questions: QuizQuestion[];
  isInGlobalRanking: boolean;
  authorName?: string;
}

export interface RankingUser {
  position: number;
  name: string;
  title: string;
  avatar: string;
  points: number;
  isCurrentUser?: boolean;
  ptsToday?: string;
}
