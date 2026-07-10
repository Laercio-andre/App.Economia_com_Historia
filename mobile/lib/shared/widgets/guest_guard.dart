import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';

/// Verifica se o utilizador é convidado.
/// Se for, mostra um diálogo a pedir login em vez de executar [onPressed].
/// Usa-se assim:
///   GuestGuard.run(context, ref, () { /* acção protegida */ });
class GuestGuard {
  GuestGuard._();

  static void run(BuildContext context, WidgetRef ref, VoidCallback onAllowed) {
    final isGuest = ref.read(authProvider).isGuest;
    if (isGuest) {
      _showDialog(context);
    } else {
      onAllowed();
    }
  }

  static void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.wineDeep,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.lock_outline, color: AppColors.goldPrimary, size: 22),
            const SizedBox(width: 10),
            Text('Acesso restrito', style: AppTextStyles.h2.copyWith(fontSize: 18)),
          ],
        ),
        content: Text(
          'Esta funcionalidade requer uma conta.\nCria uma conta ou faz login para continuar.',
          style: AppTextStyles.bodyMuted,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar', style: AppTextStyles.label),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.goldPrimary),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.go('/login');
            },
            child: Text(
              'Fazer Login',
              style: AppTextStyles.label.copyWith(color: AppColors.wineDarkest),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tela de substituição para quando o convidado acede a uma tab completamente bloqueada.
class GuestBlockedScreen extends ConsumerWidget {
  final String mensagem;
  final IconData icone;

  const GuestBlockedScreen({
    super.key,
    required this.mensagem,
    this.icone = Icons.lock_outline,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.wineDarkest,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.wineCard,
                    border: Border.all(color: AppColors.goldPrimary.withOpacity(0.4), width: 2),
                  ),
                  child: Icon(icone, color: AppColors.goldPrimary, size: 36),
                ),
                const SizedBox(height: 24),
                Text(
                  mensagem,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.goldPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Fazer Login',
                      style: AppTextStyles.label.copyWith(color: AppColors.wineDarkest),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: Text(
                    'Criar conta gratuita',
                    style: AppTextStyles.label.copyWith(color: AppColors.goldAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
