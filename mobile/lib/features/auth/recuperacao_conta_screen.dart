import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/api_client.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/primary_button.dart';

class RecuperacaoContaScreen extends StatefulWidget {
  const RecuperacaoContaScreen({super.key});

  @override
  State<RecuperacaoContaScreen> createState() => _RecuperacaoContaScreenState();
}

class _RecuperacaoContaScreenState extends State<RecuperacaoContaScreen> {
  final _api = ApiClient.instance;

  // Controladores dos 3 passos
  final _emailCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmarCtrl = TextEditingController();

  int _passo = 1; // 1: email, 2: OTP, 3: nova senha
  bool _loading = false;
  String _erro = '';
  String _sucesso = '';

  // ── Passo 1: solicitar OTP ──────────────────────────────
  Future<void> _solicitarOtp() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _erro = 'Insere o teu email.');
      return;
    }
    setState(() { _loading = true; _erro = ''; });
    try {
      await _api.post('/api/recuperacao/solicitar', {'email': email});
      setState(() { _passo = 2; _sucesso = 'Código enviado para $email'; });
    } catch (e) {
      setState(() => _erro = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  // ── Passo 2: validar OTP ────────────────────────────────
  Future<void> _validarOtp() async {
    final codigo = _otpCtrl.text.trim();
    if (codigo.length != 6) {
      setState(() => _erro = 'O código deve ter 6 dígitos.');
      return;
    }
    setState(() { _loading = true; _erro = ''; });
    try {
      await _api.post('/api/recuperacao/validar', {
        'email': _emailCtrl.text.trim(),
        'codigo': codigo,
      });
      setState(() { _passo = 3; _sucesso = 'Código validado.'; });
    } catch (e) {
      setState(() => _erro = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  // ── Passo 3: redefinir senha ────────────────────────────
  Future<void> _redefinirSenha() async {
    final senha = _senhaCtrl.text;
    if (senha.length < 8) {
      setState(() => _erro = 'A senha deve ter no mínimo 8 caracteres.');
      return;
    }
    if (senha != _confirmarCtrl.text) {
      setState(() => _erro = 'As senhas não coincidem.');
      return;
    }
    setState(() { _loading = true; _erro = ''; });
    try {
      await _api.post('/api/recuperacao/redefinir-senha', {
        'email': _emailCtrl.text.trim(),
        'codigo': _otpCtrl.text.trim(),
        'novaSenha': senha,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha redefinida! Faz login.')),
      );
      context.go('/login');
    } catch (e) {
      setState(() => _erro = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: const Icon(Icons.lock_reset, color: AppColors.goldLight, size: 26),
                ),
                const SizedBox(height: 16),
                Text('Recuperar Conta', style: AppTextStyles.heroSerif.copyWith(fontSize: 24)),
                const SizedBox(height: 6),
                _PassoIndicador(passoActual: _passo),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.wineDeep.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_passo == 1) ..._buildPasso1(),
                      if (_passo == 2) ..._buildPasso2(),
                      if (_passo == 3) ..._buildPasso3(),
                      if (_sucesso.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(_sucesso,
                          style: const TextStyle(color: Colors.greenAccent, fontSize: 13),
                          textAlign: TextAlign.center),
                      ],
                      if (_erro.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(_erro,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                          textAlign: TextAlign.center),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text('Voltar ao login',
                    style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPasso1() => [
    Center(child: Text('Insere o teu email', style: AppTextStyles.h2)),
    const SizedBox(height: 6),
    Center(child: Text('Vais receber um código de 6 dígitos.',
      style: AppTextStyles.bodyMuted, textAlign: TextAlign.center)),
    const SizedBox(height: 20),
    AppTextField(
      label: 'Email',
      hint: 'exemplo@planalto.ao',
      icon: Icons.mail_outline,
      controller: _emailCtrl,
      keyboardType: TextInputType.emailAddress,
    ),
    const SizedBox(height: 24),
    PrimaryButton(label: 'Enviar código', isLoading: _loading, onPressed: _solicitarOtp),
  ];

  List<Widget> _buildPasso2() => [
    Center(child: Text('Código de verificação', style: AppTextStyles.h2)),
    const SizedBox(height: 6),
    Center(child: Text('Insere o código de 6 dígitos enviado por email.',
      style: AppTextStyles.bodyMuted, textAlign: TextAlign.center)),
    const SizedBox(height: 20),
    AppTextField(
      label: 'Código OTP',
      hint: '123456',
      icon: Icons.pin_outlined,
      controller: _otpCtrl,
      keyboardType: TextInputType.number,
    ),
    const SizedBox(height: 24),
    PrimaryButton(label: 'Validar código', isLoading: _loading, onPressed: _validarOtp),
    const SizedBox(height: 12),
    TextButton(
      onPressed: _loading ? null : () => setState(() { _passo = 1; _erro = ''; _sucesso = ''; }),
      child: Text('Reenviar código', style: AppTextStyles.label.copyWith(color: AppColors.goldAccent)),
    ),
  ];

  List<Widget> _buildPasso3() => [
    Center(child: Text('Nova senha', style: AppTextStyles.h2)),
    const SizedBox(height: 6),
    Center(child: Text('Define a tua nova senha (mín. 8 caracteres).',
      style: AppTextStyles.bodyMuted, textAlign: TextAlign.center)),
    const SizedBox(height: 20),
    AppTextField(
      label: 'Nova senha',
      hint: '••••••••',
      icon: Icons.lock_outline,
      controller: _senhaCtrl,
      isPassword: true,
    ),
    const SizedBox(height: 16),
    AppTextField(
      label: 'Confirmar senha',
      hint: '••••••••',
      icon: Icons.lock_outline,
      controller: _confirmarCtrl,
      isPassword: true,
    ),
    const SizedBox(height: 24),
    PrimaryButton(label: 'Redefinir senha', isLoading: _loading, onPressed: _redefinirSenha),
  ];
}

class _PassoIndicador extends StatelessWidget {
  final int passoActual;
  const _PassoIndicador({required this.passoActual});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final activo = i + 1 <= passoActual;
        return Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activo ? AppColors.goldPrimary : Colors.white12,
              ),
              child: Center(
                child: Text('${i + 1}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: activo ? AppColors.wineDarkest : Colors.white38,
                  )),
              ),
            ),
            if (i < 2)
              Container(
                width: 32,
                height: 2,
                color: i + 1 < passoActual ? AppColors.goldPrimary : Colors.white12,
              ),
          ],
        );
      }),
    );
  }
}
