import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Estilos tipográficos oficiais. Serifado (Playfair Display) para hero/H1,
/// sans-serif (Poppins) para o resto.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get heroSerif => GoogleFonts.playfairDisplay(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: AppColors.goldLight,
        height: 1.1,
      );

  static TextStyle get heroSerifWhite => heroSerif.copyWith(color: AppColors.textWhite);

  static TextStyle get h2 => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
        height: 1.2,
      );

  static TextStyle get h3 => GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textWhite,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textRose,
        height: 1.4,
      );

  static TextStyle get bodyMuted => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.greySoft2,
        height: 1.4,
      );

  static TextStyle get eyebrow => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.goldAccent,
        letterSpacing: 1.6,
      );

  static TextStyle get statLarge => GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: AppColors.textWhite,
      );

  static TextStyle get buttonLabel => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.wineDarkest,
        letterSpacing: 0.5,
      );

  static TextStyle get label => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.greySoft2,
        letterSpacing: 1.2,
      );
}
