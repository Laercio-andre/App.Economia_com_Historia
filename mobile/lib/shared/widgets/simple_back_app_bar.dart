import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SimpleBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const SimpleBackAppBar({super.key, required this.title, this.centerTitle = true, this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.goldLight),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(title, style: AppTextStyles.h3),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
