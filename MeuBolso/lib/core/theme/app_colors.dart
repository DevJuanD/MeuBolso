import 'package:flutter/material.dart';

/// Paleta extraída diretamente das telas de referência do MeuBolso.
abstract final class AppColors {
  static const Color primary = Color(0xFF8350FF);
  static const Color primaryDark = Color(0xFF653BE3);
  static const Color primaryDeep = Color(0xFF5A37DF);
  static const Color primarySoft = Color(0xFFF3EDFF);
  static const Color primarySofter = Color(0xFFF7F3FF);

  static const Color background = Color(0xFFF9FBFD);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF7F9FC);

  static const Color textPrimary = Color(0xFF343F56);
  static const Color textHeading = Color(0xFF2F3A50);
  static const Color textSecondary = Color(0xFF98A2B3);
  static const Color textTertiary = Color(0xFF8F9AAC);
  static const Color textBody = Color(0xFF667085);

  static const Color border = Color(0xFFE8EDF4);
  static const Color borderStrong = Color(0xFFDCE3EC);
  static const Color divider = Color(0xFFEDF1F6);

  static const Color positive = Color(0xFF22B98A);
  static const Color positiveDark = Color(0xFF0E9F74);
  static const Color positiveSoft = Color(0xFFE9FBF4);
  static const Color chartPositive = Color(0xFF00C495);

  static const Color negative = Color(0xFFF56A95);
  static const Color negativeDark = Color(0xFFED4C7D);
  static const Color negativeSoft = Color(0xFFFFEDF3);
  static const Color chartNegative = Color(0xFFFF3F82);
  static const Color danger = Color(0xFFE11D2E);

  static const Color purpleIconSoft = Color(0xFFF1EAFE);
  static const Color purpleLegend = Color(0xFF8350FF);
  static const Color purpleLegendSoft = Color(0xFFC4A9FF);

  static const Color navUnselected = Color(0xFF98A2B3);
  static const Color overlay = Color(0x99667085);

  static const Color walletGlass = Color(0x33FFFFFF);

  static const List<Color> categoryPalette = [
    Color(0xFF8350FF),
    Color(0xFFFF6B9D),
    Color(0xFF52C7B8),
    Color(0xFFFFB547),
    Color(0xFF5ED0A4),
    Color(0xFF6D9BF1),
    Color(0xFFCBD5E1),
  ];

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7846F5), Color(0xFFA457F7)],
  );
}
