import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/outline_button_widget.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.wineDarkest,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 14,
                      children: [
                        _TickerText('AOA/USD 825.40 (+0.2%)'),
                        _TickerText('BRENT CRUDE \$82.45'),
                      ],
                    ),
                  ),
                  const Icon(Icons.notifications_none, color: AppColors.goldLight),
                ],
              ),
              const SizedBox(height: 18),
              // Cartão de destaque PIB
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.goldCardGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DESTAQUE DO DIA', style: AppTextStyles.eyebrow.copyWith(color: AppColors.wineDarkest)),
                    const SizedBox(height: 10),
                    Text('PIB Angola', style: AppTextStyles.h3.copyWith(color: AppColors.wineDarkest)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('\$124.7B', style: AppTextStyles.statLarge.copyWith(color: AppColors.wineDarkest)),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text('+3.2%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 46,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(7, (i) {
                          final heights = [14.0, 20.0, 16.0, 26.0, 22.0, 34.0, 44.0];
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: Container(
                                height: heights[i],
                                decoration: BoxDecoration(
                                  color: AppColors.wineDarkest.withOpacity(0.55 + i * 0.05),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('PROJECÇÃO TRIMESTRAL 2024',
                        style: AppTextStyles.label.copyWith(color: AppColors.wineDarkest.withOpacity(0.7))),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('BRENT OIL', style: AppTextStyles.label),
              const SizedBox(height: 6),
              Text('US\$ 82.45', style: AppTextStyles.h2),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: 0.55,
                  minHeight: 6,
                  backgroundColor: AppColors.wineCard,
                  valueColor: const AlwaysStoppedAnimation(AppColors.goldPrimary),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Min: 79.10', style: AppTextStyles.bodyMuted),
                  Text('Max: 85.30', style: AppTextStyles.bodyMuted),
                ],
              ),
              const SizedBox(height: 16),
              AppOutlineButton(label: 'Detalhes do Mercado', onPressed: () {}),
              const SizedBox(height: 20),
              AppCard(
                color: AppColors.wineCard,
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: AppColors.successGreen),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Inflação', style: AppTextStyles.h3),
                          Text('Índice Preços Consumidor', style: AppTextStyles.bodyMuted),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('24.8%', style: AppTextStyles.h2.copyWith(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text('Aumento de 1.2pp', style: AppTextStyles.bodyMuted),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.greySoft2),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                color: AppColors.wineCard,
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(Icons.agriculture_outlined, color: AppColors.goldAccent),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Agricultura', style: AppTextStyles.h3),
                          Text('Produção Nacional', style: AppTextStyles.bodyMuted),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text('+12.4%', style: AppTextStyles.h2.copyWith(fontSize: 20)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.successGreen.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text('Meta Atingida',
                                    style: AppTextStyles.bodyMuted.copyWith(color: AppColors.successGreen, fontSize: 11)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.greySoft2),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kwanza em Tempo Real', style: AppTextStyles.h3),
                    const SizedBox(height: 6),
                    Text(
                      'Acompanhe a variação cambial face ao Dólar e Euro com actualizações a cada 15 minutos do BNA.',
                      style: AppTextStyles.bodyMuted,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('832.4', style: AppTextStyles.h2.copyWith(fontSize: 22)),
                              Text('AOA/USD', style: AppTextStyles.label),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('904.1', style: AppTextStyles.h2.copyWith(fontSize: 22)),
                              Text('AOA/EUR', style: AppTextStyles.label),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TickerText extends StatelessWidget {
  final String text;
  const _TickerText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.bodyMuted.copyWith(fontSize: 11));
  }
}
