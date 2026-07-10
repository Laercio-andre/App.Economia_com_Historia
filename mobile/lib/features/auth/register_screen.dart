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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _regiaoController = TextEditingController(text: 'Luanda');
  final _instituicaoController = TextEditingController(text: 'ISPTEC');

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.goldLight),
                  onPressed: () => context.pop(),
                ),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.wineDeep.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Criar Conta', style: AppTextStyles.heroSerifWhite.copyWith(fontSize: 28)),
                      const SizedBox(height: 6),
                      Text('Junte-se à nova era da educação económica', style: AppTextStyles.bodyMuted),
                      const SizedBox(height: 22),
                      AppTextField(
                        label: 'Email',
                        hint: 'exemplo@email.com',
                        icon: Icons.mail_outline,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Senha',
                        hint: 'mínimo 8 caracteres',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Região (opcional)',
                        hint: 'Luanda',
                        icon: Icons.location_on_outlined,
                        controller: _regiaoController,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        label: 'Instituição (opcional)',
                        hint: 'ISPTEC',
                        icon: Icons.school_outlined,
                        controller: _instituicaoController,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        label: 'Cadastrar',
                        isLoading: authState.isLoading,
                        onPressed: () async {
                          try {
                            await ref.read(authProvider.notifier).register(
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                  regiao: _regiaoController.text.trim(),
                                  instituicao: _instituicaoController.text.trim(),
                                );
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
                              const TextSpan(text: 'Já possui uma conta? '),
                              TextSpan(
                                text: 'Fazer Login',
                                style: const TextStyle(color: AppColors.goldAccent, fontWeight: FontWeight.w700),
                                recognizer: TapGestureRecognizer()..onTap = () => context.pop(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
