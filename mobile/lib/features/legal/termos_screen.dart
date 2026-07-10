import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/simple_back_app_bar.dart';

class TermosScreen extends StatelessWidget {
  const TermosScreen({super.key});

  static const _sections = [
    (
      '1. Aceitação dos Termos',
      'Ao utilizar o Economia com História, você concorda com todos os termos e condições estabelecidos neste documento.'
    ),
    (
      '2. Uso do Serviço',
      'O Economia com História é destinado exclusivamente para fins educacionais. Você compromete-se a não usar o serviço para actividades ilegais ou inadequadas.'
    ),
    (
      '3. Conta de Usuário',
      'Você é responsável por manter a confidencialidade da sua senha e por todas as actividades realizadas na sua conta.'
    ),
    (
      '4. Propriedade Intelectual',
      'Todo o conteúdo do Economia com História, incluindo textos, gráficos e código, é protegido por direitos autorais.'
    ),
    (
      '5. Modificações',
      'Reservamo-nos o direito de modificar estes termos a qualquer momento. Notificaremos sobre mudanças significativas.'
    ),
    (
      '6. Cancelamento',
      'Você pode cancelar sua conta a qualquer momento. Reservamo-nos o direito de suspender contas que violem estes termos.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wineDarkest,
      appBar: const SimpleBackAppBar(title: 'Termos de Uso'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: AppColors.wineDeep, borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.description_outlined, color: AppColors.goldLight, size: 28),
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
          Text('Última atualização: 25/06/2026', style: AppTextStyles.bodyMuted),
        ],
      ),
    );
  }
}
