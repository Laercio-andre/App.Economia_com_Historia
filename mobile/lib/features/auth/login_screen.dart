import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.welcomeGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundBlack.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.account_balance, color: AppColors.goldLight, size: 26),
                ),
                const SizedBox(height: 16),
                Text('Economia com Historia', style: AppTextStyles.heroSerif.copyWith(fontSize: 26)),
                const SizedBox(height: 6),
                Text(
                  'APRENDER, DEBATER E TRANSFORMAR\nREALIDADES EM ANGOLA',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.wineDeep.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Text('Login', style: AppTextStyles.h2)),
                      const SizedBox(height: 20),
                      AppTextField(
                        label: 'Email',
                        hint: 'exemplo@planalto.ao',
                        icon: Icons.mail_outline,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Palavra-passe',
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        controller: _passwordController,
                        trailing: TextButton(
                          onPressed: () => context.push('/recuperar-senha'),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                          child: Text('ESQUECEU-SE?', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                        ),
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Entrar',
                        isLoading: authState.isLoading,
                        onPressed: () async {
                          try {
                            await ref
                                .read(authProvider.notifier)
                                .login(_emailController.text.trim(), _passwordController.text);
                            if (context.mounted) context.go('/home/inicio');
                          } on ApiException catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.bodyMuted,
                            children: [
                              const TextSpan(text: 'Ainda não tem acesso? '),
                              TextSpan(
                                text: 'Criar conta',
                                style: const TextStyle(color: AppColors.goldAccent, fontWeight: FontWeight.w700),
                                recognizer: TapGestureRecognizer()..onTap = () => context.push('/register'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _FooterLink('PRIVACIDADE', () => context.push('/legal/privacidade')),
                    const SizedBox(width: 16),
                    _FooterLink('TERMOS', () => context.push('/legal/termos')),
                    const SizedBox(width: 16),
                    _FooterLink('SUPORTE', () => context.push('/suporte')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink(this.label, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: AppTextStyles.label),
    );
  }
}
