import 'package:flutter/material.dart';

/// Paleta de cores oficial da app "Economia com História".
/// Nunca uses cores fora desta classe — mantém consistência visual.
class AppColors {
  AppColors._();

  // Fundo base
  static const Color backgroundBlack = Color(0xFF1E1E1E);
  static const Color backgroundDark2 = Color(0xFF131313);
  static const Color backgroundDark3 = Color(0xFF1B1C1A);

  // Vinho / bordô (marca principal)
  static const Color wineDarkest = Color(0xFF31000A);
  static const Color wineDeep = Color(0xFF3D0411);
  static const Color wineMedium = Color(0xFF5D0225);
  static const Color wineCard = Color(0xFF5F1E29);
  static const Color wineAccentDark = Color(0xFF47131B);
  static const Color wineAccentDark2 = Color(0xFF430715);
  static const Color wineAccentDark3 = Color(0xFF51131F);

  // Dourado / âmbar (destaque / CTA)
  static const Color goldPrimary = Color(0xFFF8BC63);
  static const Color goldLight = Color(0xFFFDCE6C);
  static const Color goldAccent = Color(0xFFE9C349);
  static const Color goldBright = Color(0xFFFFD700);

  // Bronze / castanho dourado escuro
  static const Color bronzeDark = Color(0xFF452B00);
  static const Color bronzeMedium = Color(0xFF7A5900);
  static const Color bronzeMedium2 = Color(0xFF765600);
  static const Color bronzeDarkest = Color(0xFF352000);

  // Texto sobre fundo vinho
  static const Color textRose = Color(0xFFD9C1C2);
  static const Color textRoseLight = Color(0xFFFFD9DC);
  static const Color textCream = Color(0xFFF6ECEC);
  static const Color textCream2 = Color(0xFFEAE0E1);
  static const Color textOffWhite = Color(0xFFF5F3F0);
  static const Color textWhite = Color(0xFFFCFCFC);
  static const Color textWhite2 = Color(0xFFFAFAFA);

  // Neutros / placeholders
  static const Color greyMuted = Color(0xFF554245);
  static const Color greyMuted2 = Color(0xFF524344);
  static const Color greyMuted3 = Color(0xFF534344);
  static const Color greyMuted4 = Color(0xFF524343);
  static const Color greySoft = Color(0xFF787880);
  static const Color greySoft2 = Color(0xFFA18C8D);
  static const Color greySoft3 = Color(0xFFA8A29E);
  static const Color greySoft4 = Color(0xFF78716C);

  // Estados
  static const Color successGreen = Color(0xFF2ECC71);
  static const Color successGreenDark = Color(0xFF003416);
  static const Color errorRed = Color(0xFFE74C3C);

  // Puros
  static const Color white = Color(0xFFFFFFFF);
  static const Color greyLine = Color(0xFFD9D9D9);

  static const RadialGradient welcomeGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.2,
    colors: [wineMedium, wineDarkest],
  );

  static const LinearGradient goldCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, goldPrimary],
  );
}
