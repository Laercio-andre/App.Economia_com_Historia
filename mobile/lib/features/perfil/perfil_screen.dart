import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/auth/auth_guard.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/outline_button_widget.dart';
import '../../shared/widgets/primary_button.dart';

class PerfilScreen extends ConsumerWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Container(
      color: AppColors.wineDarkest,
      child: SafeArea(
        bottom: false,
        child: authState.isGuest
            ? _GuestPerfilView(ref: ref)
            : _AuthenticatedPerfilView(ref: ref),
      ),
    );
  }
}

/// Convidado: sem sessão real no backend, por isso sem avatar, nome, email,
/// quizzes, artigos guardados, participações ou histórico — só o que não
/// depende de autenticação (Configurações) mais Notificações, que fica
/// visível mas pede login ao ser tocada.
class _GuestPerfilView extends StatelessWidget {
  final WidgetRef ref;
  const _GuestPerfilView({required this.ref});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
      child: Column(
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.wineCard,
              border: Border.all(color: AppColors.greySoft2.withOpacity(0.4), width: 2),
            ),
            child: const Icon(Icons.person_outline, size: 40, color: AppColors.greySoft2),
          ),
          const SizedBox(height: 16),
          Text('Modo Convidado', style: AppTextStyles.h2.copyWith(fontSize: 20)),
          const SizedBox(height: 8),
          Text(
            'Cria uma conta para guardar o teu progresso, participar no fórum, fazer quizzes com pontos e ver notificações.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 22),
          PrimaryButton(
            label: 'Criar Conta',
            showArrow: false,
            onPressed: () => context.push('/register'),
          ),
          const SizedBox(height: 12),
          AppOutlineButton(label: 'Já Tenho Conta · Login', onPressed: () => context.push('/login')),
          const SizedBox(height: 28),
          _ProfileListButton(
            icon: Icons.notifications_none,
            label: 'Notificações',
            onTap: () => requireAuth(
              context,
              ref,
              message: 'Cria uma conta para receberes notificações sobre o fórum, quizzes e mais.',
            ),
          ),
          const SizedBox(height: 10),
          _ProfileListButton(icon: Icons.settings_outlined, label: 'Configurações', onTap: () => context.push('/configuracoes')),
          const SizedBox(height: 10),
          _ProfileListButton(
            icon: Icons.logout,
            label: 'Sair do Modo Convidado',
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/welcome');
            },
          ),
        ],
      ),
    );
  }
}

class _AuthenticatedPerfilView extends StatelessWidget {
  final WidgetRef ref;
  const _AuthenticatedPerfilView({required this.ref});

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user!;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.goldPrimary, width: 3),
              color: AppColors.wineCard,
            ),
            child: const Icon(Icons.person, size: 46, color: AppColors.greySoft2),
          ),
          const SizedBox(height: 14),
          Text(user.displayName, style: AppTextStyles.h2.copyWith(fontSize: 22)),
          const SizedBox(height: 4),
          Text(
            [user.email, if (user.regiao != null && user.regiao!.isNotEmpty) user.regiao].join(' · '),
            style: AppTextStyles.bodyMuted,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: 200,
            child: AppOutlineButton(
              icon: Icons.edit_outlined,
              label: 'Editar Perfil',
              onPressed: () => context.push('/perfil/editar'),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  onTap: () => context.push('/ranking'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.emoji_events, color: AppColors.goldPrimary, size: 20),
                      const SizedBox(width: 8),
                      Text(user.role.label, style: AppTextStyles.h3),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppCard(
                  color: AppColors.wineCard,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: AppColors.goldBright, size: 20),
                      const SizedBox(width: 8),
                      Text('${user.pontosAcumulados} Pts', style: AppTextStyles.h3),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Quizzes Realizados', style: AppTextStyles.h3),
                    const Icon(Icons.description_outlined, color: AppColors.goldAccent, size: 20),
                  ],
                ),
                const SizedBox(height: 14),
                _QuizProgress(title: 'Política Monetária Angolana', subtitle: 'ECONOMIA · 20 QUESTÕES', percent: 0.85),
                const SizedBox(height: 14),
                _QuizProgress(title: 'Fundamentos de Macroeconomia', subtitle: 'ECONOMIA · 15 QUESTÕES', percent: 0.60),
                const SizedBox(height: 10),
                _SeeAllLink(onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Artigos Guardados', style: AppTextStyles.h3),
                    const Icon(Icons.bookmark_outline, color: AppColors.goldAccent, size: 20),
                  ],
                ),
                const SizedBox(height: 14),
                _SavedArticleRow(title: 'O Impacto das Taxas de Juro no Kwanza', subtitle: 'ECONOMIA LOCAL · 2 DIAS ATRÁS'),
                const SizedBox(height: 12),
                _SavedArticleRow(title: 'Diversificação Económica: Relatório 2024', subtitle: 'MERCADO · 1 SEMANA ATRÁS'),
                const SizedBox(height: 10),
                _SeeAllLink(onTap: () {}),
              ],
            ),
          ),
          const SizedBox(height: 14),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Minhas Participações', style: AppTextStyles.h3),
                    const Icon(Icons.chat_bubble_outline, color: AppColors.goldAccent, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text('"Acredito que a flutuação atual é temporária..."',
                    style: AppTextStyles.body.copyWith(fontStyle: FontStyle.italic)),
                const SizedBox(height: 6),
                Text('TÓPICO: FUTURO DO PETRÓLEO', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text('12 TÓPICOS', style: AppTextStyles.bodyMuted),
                    const SizedBox(width: 16),
                    Text('84 RESPOSTAS', style: AppTextStyles.bodyMuted),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Histórico de Artigos', style: AppTextStyles.h3.copyWith(fontSize: 20)),
              TextButton(onPressed: () {}, child: Text('VER TODOS', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent))),
            ],
          ),
          const SizedBox(height: 10),
          _HistoryRow(date: 'MAI\n24', title: 'A Economia de Angola: Perspectivas 2025', subtitle: 'Uma análise profunda sobre o impacto do petróleo no PIB nacional.'),
          const SizedBox(height: 12),
          _HistoryRow(date: 'ABR\n12', title: 'Investimentos Estratégicos na Zona Especial', subtitle: 'Como a ZEE Luanda-Bento está atraindo capital estrangeiro.'),
          const SizedBox(height: 12),
          _HistoryRow(date: 'MAR\n02', title: 'O Papel do Kwanza no Comércio Regional', subtitle: 'Desafios da volatilidade cambial na SADC.'),
          const SizedBox(height: 24),
          _ProfileListButton(icon: Icons.notifications_none, label: 'Notificações', onTap: () => context.push('/notificacoes')),
          const SizedBox(height: 10),
          _ProfileListButton(icon: Icons.settings_outlined, label: 'Configurações', onTap: () => context.push('/configuracoes')),
          const SizedBox(height: 10),
          _ProfileListButton(
            icon: Icons.logout,
            label: 'Terminar Sessão',
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.wineDeep,
                  title: Text('Terminar sessão', style: AppTextStyles.h3),
                  content: Text('Tens a certeza que queres sair da tua conta?', style: AppTextStyles.body),
                  actions: [
                    TextButton(onPressed: () => context.pop(false), child: const Text('Cancelar')),
                    TextButton(onPressed: () => context.pop(true), child: const Text('Sair')),
                  ],
                ),
              );
              if (confirm == true) {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) context.go('/welcome');
              }
            },
          ),
        ],
      ),
    );
  }
}

class _QuizProgress extends StatelessWidget {
  final String title;
  final String subtitle;
  final double percent;
  const _QuizProgress({required this.title, required this.subtitle, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textWhite)),
        Text(subtitle, style: AppTextStyles.label),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 5,
            backgroundColor: AppColors.wineCard,
            valueColor: const AlwaysStoppedAnimation(AppColors.goldPrimary),
          ),
        ),
        const SizedBox(height: 4),
        Text('${(percent * 100).round()}%', style: AppTextStyles.bodyMuted),
      ],
    );
  }
}

class _SavedArticleRow extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SavedArticleRow({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textWhite)),
        Text(subtitle, style: AppTextStyles.label),
      ],
    );
  }
}

class _SeeAllLink extends StatelessWidget {
  final VoidCallback onTap;
  const _SeeAllLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text('VER TODOS →', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String date;
  final String title;
  final String subtitle;
  const _HistoryRow({required this.date, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 40,
          child: Text(date, style: AppTextStyles.label.copyWith(color: AppColors.goldAccent), textAlign: TextAlign.center),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textWhite)),
              Text(subtitle, style: AppTextStyles.bodyMuted),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: AppColors.greySoft2),
      ],
    );
  }
}

class _ProfileListButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProfileListButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.goldAccent, size: 20),
          const SizedBox(width: 10),
          Text(label.toUpperCase(), style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textWhite)),
        ],
      ),
    );
  }
}
