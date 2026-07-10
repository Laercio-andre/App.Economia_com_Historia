import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class NavItemData {
  final IconData icon;
  final String label;

  const NavItemData(this.icon, this.label);
}

const List<NavItemData> kNavItems = [
  NavItemData(Icons.home_outlined, 'Início'),
  NavItemData(Icons.explore_outlined, 'Explorar'),
  NavItemData(Icons.quiz_outlined, 'Quiz'),
  NavItemData(Icons.forum_outlined, 'Fórum'),
  NavItemData(Icons.person_outline, 'Perfil'),
];

/// Barra de navegação inferior com 5 itens. O item central (Quiz) fica
/// ligeiramente elevado, com destaque circular dourado quando activo.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.wineDarkest,
        border: Border(top: BorderSide(color: Colors.black26, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(kNavItems.length, (index) {
            final item = kNavItems[index];
            final isActive = index == currentIndex;
            final isCenter = index == 2;
            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: Transform.translate(
                offset: Offset(0, isCenter ? -6 : 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.goldPrimary : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item.icon,
                        size: 22,
                        color: isActive ? AppColors.wineDarkest : AppColors.greySoft2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label.toUpperCase(),
                      style: AppTextStyles.label.copyWith(
                        color: isActive ? AppColors.goldLight : AppColors.greySoft2,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
