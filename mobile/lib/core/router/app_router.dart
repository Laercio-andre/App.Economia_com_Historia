import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/auth_repository.dart';
import '../../features/welcome/welcome_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_shell.dart';
import '../../features/home/inicio_screen.dart';
import '../../features/explorar/explorar_screen.dart';
import '../../features/explorar/article_detail_screen.dart';
import '../../features/quiz/quiz_screen.dart';
import '../../features/forum/forum_screen.dart';
import '../../features/perfil/perfil_screen.dart';
import '../../features/perfil/editar_perfil_screen.dart';
import '../../features/configuracoes/configuracoes_screen.dart';
import '../../features/configuracoes/alterar_senha_screen.dart';
import '../../features/legal/termos_screen.dart';
import '../../features/legal/privacidade_screen.dart';
import '../../features/suporte/suporte_screen.dart';
import '../../features/ranking/ranking_screen.dart';
import '../../features/notificacoes/notificacoes_screen.dart';
import '../../features/auth/recuperar_senha_screen.dart';
import '../../features/forum/forum_detail_screen.dart';
import '../../features/forum/topico_detail_screen.dart';

/// Rotas que exigem uma conta real (Authorization: Bearer <token> no
/// backend). Um convidado que tente navegar diretamente para uma destas e
/// redirecionado para o login em vez de ver a pagina.
const _authOnlyRoutes = [
  '/perfil/editar',
  '/configuracoes/senha',
  '/notificacoes',
];

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/recuperar-senha', builder: (context, state) => const RecuperarSenhaScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(
        path: '/artigo/:id',
        builder: (context, state) => ArticleDetailScreen(articleId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/perfil/editar', builder: (context, state) => const EditarPerfilScreen()),
      GoRoute(path: '/configuracoes', builder: (context, state) => const ConfiguracoesScreen()),
      GoRoute(path: '/configuracoes/senha', builder: (context, state) => const AlterarSenhaScreen()),
      GoRoute(path: '/legal/termos', builder: (context, state) => const TermosScreen()),
      GoRoute(path: '/legal/privacidade', builder: (context, state) => const PrivacidadeScreen()),
      GoRoute(path: '/suporte', builder: (context, state) => const SuporteScreen()),
      GoRoute(path: '/ranking', builder: (context, state) => const RankingScreen()),
      GoRoute(path: '/notificacoes', builder: (context, state) => const NotificacoesScreen()),
      GoRoute(
        path: '/forum/:id',
        builder: (context, state) => ForumDetailScreen(forumId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/topico/:id',
        builder: (context, state) => TopicoDetailScreen(topicoId: state.pathParameters['id']!),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home/inicio', builder: (context, state) => const InicioScreen()),
          GoRoute(path: '/home/explorar', builder: (context, state) => const ExplorarScreen()),
          GoRoute(path: '/home/quiz', builder: (context, state) => const QuizScreen()),
          GoRoute(path: '/home/forum', builder: (context, state) => const ForumScreen()),
          GoRoute(path: '/home/perfil', builder: (context, state) => const PerfilScreen()),
        ],
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final loggedInOrGuest = authState.user != null;
      final goingToAuthFlow = ['/welcome', '/login', '/register', '/recuperar-senha'].contains(state.matchedLocation);

      if (!loggedInOrGuest && !goingToAuthFlow) {
        return '/welcome';
      }

      // Convidado a tentar aceder a uma funcionalidade que exige
      // autenticacao real no backend: manda para o login.
      if (authState.isGuest && _authOnlyRoutes.contains(state.matchedLocation)) {
        return '/login';
      }

      return null;
    },
  );
});
