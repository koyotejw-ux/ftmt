import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpaceNavyTheme {
  // Backgrounds
  static const Color backgroundDeep = Color(0xFF070A12);
  static const Color backgroundSurface = Color(0xFF0D1224);
  static const Color backgroundCard = Color(0xFF141B33);

  // Luxury Accents
  static const Color goldChampagne = Color(0xFFE5C07B);
  static const Color goldBright = Color(0xFFFFD700);
  static const Color goldBorder = Color(0x33DFB76C); // 20% opacity 1px border

  // Mystical Lights
  static const Color violetAurora = Color(0xFF8A2BE2);
  static const Color cyanNeon = Color(0xFF00E5FF);
  static const Color magentaStardust = Color(0xFFFF007F);

  // Text
  static const Color textPrimary = Color(0xFFF0F4FC);
  static const Color textSecondary = Color(0xFF9AA7C7);
  static const Color textMuted = Color(0xFF637194);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDeep,
      primaryColor: goldChampagne,
      colorScheme: const ColorScheme.dark(
        primary: goldChampagne,
        secondary: violetAurora,
        tertiary: cyanNeon,
        surface: backgroundSurface,
      ),
      textTheme: GoogleFonts.cinzelTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        bodyLarge: GoogleFonts.notoSans(color: textPrimary, fontSize: 16),
        bodyMedium: GoogleFonts.notoSans(color: textSecondary, fontSize: 14),
        bodySmall: GoogleFonts.notoSans(color: textMuted, fontSize: 12),
        titleLarge: GoogleFonts.cinzel(
          color: goldChampagne,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontSize: 22,
        ),
        titleMedium: GoogleFonts.cinzel(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
          fontSize: 16,
        ),
      ),
    );
  }
}
