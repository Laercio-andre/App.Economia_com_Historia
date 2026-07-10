import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/recovery_repository.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

/// Fluxo em 2 ecrãs: pedir o código por email, depois indicar o código +
/// nova senha na mesma chamada (POST /api/recuperacao/redefinir-senha).
///
/// NOTA: propositadamente não chamamos /api/recuperacao/validar antes de
/// redefinir a senha. No backend, /validar já marca o código como usado
/// (foiUtilizado = true), o que faria o /redefinir-senha subsequente falhar
/// com "Código inválido ou utilizado". O código só é consumido uma vez, por
/// isso pedimos código + nova senha juntos e chamamos só /redefinir-senha.
class RecuperarSenhaScreen extends StatefulWidget {
  const RecuperarSenhaScreen({super.key});

  @override
  State<RecuperarSenhaScreen> createState() => _RecuperarSenhaScreenState();
}

class _RecuperarSenhaScreenState extends State<RecuperarSenhaScreen> {
  final _repo = RecoveryRepository();
  final _emailController = TextEditingController();
  final _codigoController = TextEditingController();
  final _novaSenhaController = TextEditingController();

  int _step = 0;
  bool _isLoading = false;
  String? _info;

  Future<void> _solicitar() async {
    if (_emailController.text.trim().isEmpty) return;
    setState(() {
      _isLoading = true;
      _info = null;
    });
    try {
      final mensagem = await _repo.solicitar(_emailController.text.trim());
      setState(() {
        _step = 1;
        _info = mensagem;
        _isLoading = false;
      });
    } on ApiException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  Future<void> _redefinir() async {
    setState(() => _isLoading = true);
    try {
      final mensagem = await _repo.redefinirSenha(
        _emailController.text.trim(),
        _codigoController.text.trim(),
        _novaSenhaController.text,
      );
      setState(() {
        _isLoading = false;
        _info = mensagem;
        _step = 2;
      });
    } on ApiException catch (e) {
      setState(() => _isLoading = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Recuperar Senha', centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_step == 0) ..._buildStepEmail(),
            if (_step == 1) ..._buildStepCodigo(),
            if (_step == 2) ..._buildStepConcluido(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildStepEmail() {
    return [
      Text('Introduz o teu email e enviamos um código de 6 dígitos.', style: AppTextStyles.bodyMuted),
      const SizedBox(height: 22),
      AppTextField(
        label: 'Email',
        hint: 'exemplo@email.com',
        icon: Icons.mail_outline,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 24),
      PrimaryButton(label: 'Enviar Código', isLoading: _isLoading, onPressed: _solicitar),
    ];
  }

  List<Widget> _buildStepCodigo() {
    return [
      if (_info != null) ...[
        Text(_info!, style: AppTextStyles.body.copyWith(color: AppColors.goldAccent)),
        const SizedBox(height: 14),
      ],
      Text('O código expira em 10 minutos. Introduz o código e a nova senha.', style: AppTextStyles.bodyMuted),
      const SizedBox(height: 22),
      AppTextField(
        label: 'Código (6 dígitos)',
        hint: '000000',
        icon: Icons.pin_outlined,
        controller: _codigoController,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 16),
      AppTextField(
        label: 'Nova Senha',
        hint: 'mínimo 8 caracteres',
        icon: Icons.lock_outline,
        isPassword: true,
        controller: _novaSenhaController,
      ),
      const SizedBox(height: 24),
      PrimaryButton(label: 'Redefinir Senha', isLoading: _isLoading, onPressed: _redefinir),
      const SizedBox(height: 12),
      TextButton(
        onPressed: _isLoading ? null : _solicitar,
        child: Text('Reenviar código', style: AppTextStyles.bodyMuted),
      ),
    ];
  }

  List<Widget> _buildStepConcluido() {
    return [
      const SizedBox(height: 40),
      const Icon(Icons.check_circle_outline, color: AppColors.goldPrimary, size: 56),
      const SizedBox(height: 16),
      Text('Senha redefinida', style: AppTextStyles.h2.copyWith(fontSize: 20)),
      const SizedBox(height: 8),
      Text('Já podes iniciar sessão com a tua nova senha.', style: AppTextStyles.bodyMuted),
      const SizedBox(height: 24),
      PrimaryButton(label: 'Voltar ao Login', showArrow: false, onPressed: () => Navigator.of(context).maybePop()),
    ];
  }
}
