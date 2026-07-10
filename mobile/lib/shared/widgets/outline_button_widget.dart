import "package:flutter/material.dart";
import "../../core/theme/app_colors.dart";
import "../../core/theme/app_text_styles.dart";

class AppOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppOutlineButton({super.key, required this.label, required this.onPressed, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.textRose.withOpacity(0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.textRose),
              const SizedBox(width: 8),
            ],
            Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textRose)),
          ],
        ),
      ),
    );
  }
}
