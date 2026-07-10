import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

class PrivacidadeScreen extends StatelessWidget {
  const PrivacidadeScreen({super.key});

  static const _sections = [
    (
      'Coleta de Dados',
      'Coletamos apenas as informações necessárias para o funcionamento do aplicativo: nome, email e progresso de aprendizado.'
    ),
    (
      'Uso das Informações',
      'Seus dados são utilizados exclusivamente para personalizar a sua experiência de aprendizado e acompanhar o seu progresso académico.'
    ),
    (
      'Compartilhamento',
      'Nunca compartilhamos as suas informações pessoais com terceiros sem o seu consentimento explícito.'
    ),
    (
      'Segurança',
      'Utilizamos criptografia e medidas de segurança avançadas para proteger todos os seus dados.'
    ),
    (
      'Seus Direitos',
      'Você pode solicitar acesso, correção ou exclusão dos seus dados a qualquer momento através do suporte.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Privacidade'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.goldLight)),
              child: const Icon(Icons.shield_outlined, color: AppColors.goldLight, size: 28),
            ),
          ),
          const SizedBox(height: 24),
          for (final section in _sections)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(section.$1, style: AppTextStyles.h3),
                  const SizedBox(height: 6),
                  Text(section.$2, style: AppTextStyles.body),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
