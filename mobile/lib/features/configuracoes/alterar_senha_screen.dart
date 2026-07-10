import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/auth_repository.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

/// CONFIRMADO no documento "ROTAS E CONFIGURACAO PARA APP MOBILE":
/// PATCH /api/usuarios/me/senha com {"senhaAtual":..., "novaSenha":...}.
class AlterarSenhaScreen extends ConsumerStatefulWidget {
  const AlterarSenhaScreen({super.key});

  @override
  ConsumerState<AlterarSenhaScreen> createState() => _AlterarSenhaScreenState();
}

class _AlterarSenhaScreenState extends ConsumerState<AlterarSenhaScreen> {
  final _senhaAtualController = TextEditingController();
  final _novaSenhaController = TextEditingController();
  final _confirmarController = TextEditingController();
  bool _sucesso = false;

  Future<void> _salvar() async {
    if (_novaSenhaController.text != _confirmarController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('As senhas novas não coincidem.')));
      return;
    }
    if (_novaSenhaController.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('A nova senha precisa de pelo menos 8 caracteres.')));
      return;
    }
    try {
      await ref.read(authProvider.notifier).changePassword(
            senhaAtual: _senhaAtualController.text,
            novaSenha: _novaSenhaController.text,
          );
      setState(() => _sucesso = true);
    } on ApiException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Alterar Senha', centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _sucesso
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Icon(Icons.check_circle_outline, color: AppColors.goldPrimary, size: 56),
                  const SizedBox(height: 16),
                  Text('Senha alterada', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text('A tua senha foi atualizada com sucesso.', style: AppTextStyles.bodyMuted),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Concluído', showArrow: false, onPressed: () => Navigator.of(context).maybePop()),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Introduz a tua senha atual e a nova senha.', style: AppTextStyles.bodyMuted),
                  const SizedBox(height: 22),
                  AppTextField(label: 'Senha Atual', hint: '••••••••', icon: Icons.lock_outline, isPassword: true, controller: _senhaAtualController),
                  const SizedBox(height: 16),
                  AppTextField(label: 'Nova Senha', hint: 'mínimo 8 caracteres', icon: Icons.lock_reset, isPassword: true, controller: _novaSenhaController),
                  const SizedBox(height: 16),
                  AppTextField(label: 'Confirmar Nova Senha', hint: '••••••••', icon: Icons.lock_reset, isPassword: true, controller: _confirmarController),
                  const SizedBox(height: 24),
                  PrimaryButton(label: 'Guardar', showArrow: false, isLoading: isLoading, onPressed: _salvar),
                ],
              ),
      ),
    );
  }
}
