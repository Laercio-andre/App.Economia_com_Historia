import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundBlack,
        fontFamily: GoogleFonts.poppins().fontFamily,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.goldPrimary,
          secondary: AppColors.goldAccent,
          surface: AppColors.wineDeep,
          error: AppColors.errorRed,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.goldLight),
        ),
        splashColor: AppColors.goldPrimary.withOpacity(0.08),
        highlightColor: Colors.transparent,
      );
}
