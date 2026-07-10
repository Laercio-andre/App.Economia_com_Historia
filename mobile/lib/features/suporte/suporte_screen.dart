import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

class SuporteScreen extends StatelessWidget {
  const SuporteScreen({super.key});

  static const _faqs = [
    (
      'Como resetar minha senha?',
      'Clique em "Esqueci senha" na tela de login.'
    ),
    (
      'Como funciona o ranking?',
      'Complete exercícios e desafios para ganhar pontos e subir no ranking.'
    ),
    (
      'Posso usar em vários dispositivos?',
      'Sim! Seu progresso é sincronizado automaticamente.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Ajuda e Suporte'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.goldLight)),
              child: const Icon(Icons.help_outline, color: AppColors.goldLight, size: 28),
            ),
          ),
          const SizedBox(height: 24),
          Text('Entre em Contato', style: AppTextStyles.h3.copyWith(fontSize: 18)),
          const SizedBox(height: 12),
          AppCard(
            onTap: () => launchUrl(Uri.parse('https://wa.me/244923456789')),
            child: Row(
              children: [
                const CircleAvatar(radius: 18, backgroundColor: AppColors.wineCard, child: Icon(Icons.chat, color: AppColors.successGreen, size: 18)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('WhatsApp', style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
                      Text('+244 923 456 789', style: AppTextStyles.bodyMuted),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.greySoft2),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            onTap: () => launchUrl(Uri.parse('mailto:suporte@engenhariasoftware.ao')),
            child: Row(
              children: [
                const CircleAvatar(radius: 18, backgroundColor: AppColors.wineCard, child: Icon(Icons.mail_outline, color: AppColors.goldAccent, size: 18)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email', style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
                      Text('suporte@engenhariasoftware.ao', style: AppTextStyles.bodyMuted),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.greySoft2),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Perguntas Frequentes', style: AppTextStyles.h3.copyWith(fontSize: 18)),
          const SizedBox(height: 12),
          for (final faq in _faqs)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(faq.$1, style: AppTextStyles.body.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(faq.$2, style: AppTextStyles.bodyMuted),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.info_outline, color: AppColors.greySoft2, size: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
