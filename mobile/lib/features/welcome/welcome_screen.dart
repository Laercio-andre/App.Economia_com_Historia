import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';
import '../../shared/widgets/primary_button.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.welcomeGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundBlack.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.account_balance, color: AppColors.goldLight, size: 32),
                ),
                const SizedBox(height: 20),
                Text('ECONOMIA COM HISTÓRIA', style: AppTextStyles.eyebrow),
                const SizedBox(height: 24),
                Text('Seja', textAlign: TextAlign.center, style: AppTextStyles.heroSerifWhite),
                Text('Bem-Vindo', textAlign: TextAlign.center, style: AppTextStyles.heroSerif),
                const SizedBox(height: 20),
                Text(
                  'Explore o percurso económico de Angola, desde as suas raízes históricas até ao desenvolvimento contemporâneo em uma experiência digital imersiva.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 36),
                PrimaryButton(
                  label: 'Fazer Login',
                  showArrow: false,
                  onPressed: () => context.push('/login'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).continueAsGuest();
                    if (context.mounted) context.go('/home/inicio');
                  },
                  child: Text(
                    'EXPLORAR SEM CONTA  →',
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textRose),
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
