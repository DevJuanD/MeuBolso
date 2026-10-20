import 'package:flutter/material.dart';

/// Paleta extraída diretamente das telas de referência do MeuBolso.
///
/// Os valores públicos são atualizados por [aplicar] conforme o brilho
/// escolhido no aplicativo, permitindo que as telas existentes continuem
/// usando [AppColors] sem precisar receber um contexto de tema.
abstract final class AppColors {
  // Paleta clara
  static const Color _lightPrimary = Color(0xFF8350FF);
  static const Color _lightPrimaryDark = Color(0xFF653BE3);
  static const Color _lightPrimaryDeep = Color(0xFF5A37DF);
  static const Color _lightPrimarySoft = Color(0xFFF3EDFF);
  static const Color _lightPrimarySofter = Color(0xFFF7F3FF);
  static const Color _lightBackground = Color(0xFFF9FBFD);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightSurfaceMuted = Color(0xFFF7F9FC);
  static const Color _lightTextPrimary = Color(0xFF343F56);
  static const Color _lightTextHeading = Color(0xFF2F3A50);
  static const Color _lightTextSecondary = Color(0xFF98A2B3);
  static const Color _lightTextTertiary = Color(0xFF8F9AAC);
  static const Color _lightTextBody = Color(0xFF667085);
  static const Color _lightBorder = Color(0xFFE8EDF4);
  static const Color _lightBorderStrong = Color(0xFFDCE3EC);
  static const Color _lightDivider = Color(0xFFEDF1F6);
  static const Color _lightPositive = Color(0xFF22B98A);
  static const Color _lightPositiveDark = Color(0xFF0E9F74);
  static const Color _lightPositiveSoft = Color(0xFFE9FBF4);
  static const Color _lightChartPositive = Color(0xFF00C495);
  static const Color _lightNegative = Color(0xFFF56A95);
  static const Color _lightNegativeDark = Color(0xFFED4C7D);
  static const Color _lightNegativeSoft = Color(0xFFFFEDF3);
  static const Color _lightChartNegative = Color(0xFFFF3F82);
  static const Color _lightDanger = Color(0xFFE11D2E);
  static const Color _lightPurpleIconSoft = Color(0xFFF1EAFE);
  static const Color _lightPurpleLegend = Color(0xFF8350FF);
  static const Color _lightPurpleLegendSoft = Color(0xFFC4A9FF);
  static const Color _lightNavUnselected = Color(0xFF98A2B3);
  static const Color _lightOverlay = Color(0x99667085);
  static const Color _lightWalletGlass = Color(0x33FFFFFF);
  static const LinearGradient _lightPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7846F5), Color(0xFFA457F7)],
  );

  // Paleta escura
  static const Color _darkPrimary = Color(0xFF9C74FF);
  static const Color _darkPrimaryDark = Color(0xFF8350FF);
  static const Color _darkPrimaryDeep = Color(0xFF6E43E8);
  static const Color _darkPrimarySoft = Color(0xFF241A3D);
  static const Color _darkPrimarySofter = Color(0xFF1B142E);
  static const Color _darkBackground = Color(0xFF0B0D10);
  static const Color _darkSurface = Color(0xFF15181D);
  static const Color _darkSurfaceMuted = Color(0xFF1B1F26);
  static const Color _darkTextPrimary = Color(0xFFF4F6FA);
  static const Color _darkTextHeading = Color(0xFFFFFFFF);
  static const Color _darkTextSecondary = Color(0xFF98A2B3);
  static const Color _darkTextTertiary = Color(0xFF7E8898);
  static const Color _darkTextBody = Color(0xFFB4BDCB);
  static const Color _darkBorder = Color(0xFF262C36);
  static const Color _darkBorderStrong = Color(0xFF333B48);
  static const Color _darkDivider = Color(0xFF232933);
  static const Color _darkPositive = Color(0xFF2BD4A0);
  static const Color _darkPositiveDark = Color(0xFF22B98A);
  static const Color _darkPositiveSoft = Color(0xFF10291F);
  static const Color _darkChartPositive = Color(0xFF00D6A0);
  static const Color _darkNegative = Color(0xFFFF7EA8);
  static const Color _darkNegativeDark = Color(0xFFF56A95);
  static const Color _darkNegativeSoft = Color(0xFF2A1620);
  static const Color _darkChartNegative = Color(0xFFFF5C97);
  static const Color _darkDanger = Color(0xFFFF5A6A);
  static const Color _darkPurpleIconSoft = Color(0xFF241A3D);
  static const Color _darkPurpleLegend = Color(0xFF9C74FF);
  static const Color _darkPurpleLegendSoft = Color(0xFF6D4CC7);
  static const Color _darkNavUnselected = Color(0xFF7E8898);
  static const Color _darkOverlay = Color(0xCC000000);
  static const Color _darkWalletGlass = Color(0x22FFFFFF);
  static const LinearGradient _darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B32C9), Color(0xFF7A3FD9)],
  );

  static Color primary = _lightPrimary;
  static Color primaryDark = _lightPrimaryDark;
  static Color primaryDeep = _lightPrimaryDeep;
  static Color primarySoft = _lightPrimarySoft;
  static Color primarySofter = _lightPrimarySofter;

  static Color background = _lightBackground;
  static Color surface = _lightSurface;
  static Color surfaceMuted = _lightSurfaceMuted;

  static Color textPrimary = _lightTextPrimary;
  static Color textHeading = _lightTextHeading;
  static Color textSecondary = _lightTextSecondary;
  static Color textTertiary = _lightTextTertiary;
  static Color textBody = _lightTextBody;

  static Color border = _lightBorder;
  static Color borderStrong = _lightBorderStrong;
  static Color divider = _lightDivider;

  static Color positive = _lightPositive;
  static Color positiveDark = _lightPositiveDark;
  static Color positiveSoft = _lightPositiveSoft;
  static Color chartPositive = _lightChartPositive;

  static Color negative = _lightNegative;
  static Color negativeDark = _lightNegativeDark;
  static Color negativeSoft = _lightNegativeSoft;
  static Color chartNegative = _lightChartNegative;
  static Color danger = _lightDanger;

  static Color purpleIconSoft = _lightPurpleIconSoft;
  static Color purpleLegend = _lightPurpleLegend;
  static Color purpleLegendSoft = _lightPurpleLegendSoft;

  static Color navUnselected = _lightNavUnselected;
  static Color overlay = _lightOverlay;

  static Color walletGlass = _lightWalletGlass;

  static const List<Color> categoryPalette = [
    Color(0xFF8350FF),
    Color(0xFFFF6B9D),
    Color(0xFF52C7B8),
    Color(0xFFFFB547),
    Color(0xFF5ED0A4),
    Color(0xFF6D9BF1),
    Color(0xFFCBD5E1),
  ];

  static LinearGradient primaryGradient = _lightPrimaryGradient;

  static Brightness _brightness = Brightness.light;
  static Brightness get brightness => _brightness;

  /// Atualiza a paleta global para o brilho informado.
  static void aplicar(Brightness brightness) {
    _brightness = brightness;
    final escuro = brightness == Brightness.dark;

    primary = escuro ? _darkPrimary : _lightPrimary;
    primaryDark = escuro ? _darkPrimaryDark : _lightPrimaryDark;
    primaryDeep = escuro ? _darkPrimaryDeep : _lightPrimaryDeep;
    primarySoft = escuro ? _darkPrimarySoft : _lightPrimarySoft;
    primarySofter = escuro ? _darkPrimarySofter : _lightPrimarySofter;

    background = escuro ? _darkBackground : _lightBackground;
    surface = escuro ? _darkSurface : _lightSurface;
    surfaceMuted = escuro ? _darkSurfaceMuted : _lightSurfaceMuted;

    textPrimary = escuro ? _darkTextPrimary : _lightTextPrimary;
    textHeading = escuro ? _darkTextHeading : _lightTextHeading;
    textSecondary = escuro ? _darkTextSecondary : _lightTextSecondary;
    textTertiary = escuro ? _darkTextTertiary : _lightTextTertiary;
    textBody = escuro ? _darkTextBody : _lightTextBody;

    border = escuro ? _darkBorder : _lightBorder;
    borderStrong = escuro ? _darkBorderStrong : _lightBorderStrong;
    divider = escuro ? _darkDivider : _lightDivider;

    positive = escuro ? _darkPositive : _lightPositive;
    positiveDark = escuro ? _darkPositiveDark : _lightPositiveDark;
    positiveSoft = escuro ? _darkPositiveSoft : _lightPositiveSoft;
    chartPositive = escuro ? _darkChartPositive : _lightChartPositive;

    negative = escuro ? _darkNegative : _lightNegative;
    negativeDark = escuro ? _darkNegativeDark : _lightNegativeDark;
    negativeSoft = escuro ? _darkNegativeSoft : _lightNegativeSoft;
    chartNegative = escuro ? _darkChartNegative : _lightChartNegative;
    danger = escuro ? _darkDanger : _lightDanger;

    purpleIconSoft = escuro ? _darkPurpleIconSoft : _lightPurpleIconSoft;
    purpleLegend = escuro ? _darkPurpleLegend : _lightPurpleLegend;
    purpleLegendSoft = escuro ? _darkPurpleLegendSoft : _lightPurpleLegendSoft;

    navUnselected = escuro ? _darkNavUnselected : _lightNavUnselected;
    overlay = escuro ? _darkOverlay : _lightOverlay;
    walletGlass = escuro ? _darkWalletGlass : _lightWalletGlass;

    primaryGradient =
        escuro ? _darkPrimaryGradient : _lightPrimaryGradient;
  }
}
