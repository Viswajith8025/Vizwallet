import 'package:flutter/material.dart';

/// Viswallet — premium fintech palette.
///
/// Dark: luxurious deep purple · Light: calm sky blue
abstract final class BrandColors {
  // Dark mode — purple luxury
  static const primaryDark = Color(0xFF5B3FA6);
  static const primaryDarkMuted = Color(0xFF7C5CBF);
  static const secondaryDark = Color(0xFF4A2F8C);
  static const accentDark = Color(0xFF9B6DFF);
  static const highlightDark = Color(0xFFC4B5FD);
  static const backgroundDark = Color(0xFF121218);
  static const surfaceDark = Color(0xFF1A1A22);
  static const cardDark = Color(0xFF22202C);
  static const cardTintDark = Color(0xFF2A2438);
  static const cardBorderDark = Color(0xFF3A3348);
  static const onBackgroundDark = Color(0xFFF4F2F8);
  static const onSurfaceVariantDark = Color(0xFFA8A3B8);
  static const dividerDark = Color(0xFF2E2A38);

  // Light mode — sky blue calm
  static const primaryLight = Color(0xFF4A9FD9);
  static const primaryLightDeep = Color(0xFF2E7BB5);
  static const secondaryLight = Color(0xFF7EC8F2);
  static const accentLight = Color(0xFF2563EB);
  static const highlightLight = Color(0xFFDBEAFE);
  static const backgroundLight = Color(0xFFFFFFFF);
  static const surfaceLight = Color(0xFFF5F7FA);
  static const cardLight = Color(0xFFFFFFFF);
  static const cardBorderLight = Color(0xFFE2E8F0);
  static const onBackgroundLight = Color(0xFF0F172A);
  static const onSurfaceVariantLight = Color(0xFF64748B);
  static const dividerLight = Color(0xFFF1F5F9);

  // Semantic (shared)
  static const success = Color(0xFF10B981);
  static const successContainer = Color(0xFFD1FAE5);
  static const warning = Color(0xFFF59E0B);
  static const warningContainer = Color(0xFFFEF3C7);
  static const error = Color(0xFFEF4444);
  static const errorContainer = Color(0xFFFEE2E2);

  static ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryLightDeep,
    onPrimary: Colors.white,
    primaryContainer: highlightLight,
    onPrimaryContainer: Color(0xFF1E3A5F),
    secondary: secondaryLight,
    onSecondary: Color(0xFF0C4A6E),
    secondaryContainer: Color(0xFFE0F2FE),
    onSecondaryContainer: Color(0xFF0C4A6E),
    tertiary: accentLight,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFDBEAFE),
    onTertiaryContainer: Color(0xFF1E3A8A),
    error: error,
    onError: Colors.white,
    errorContainer: errorContainer,
    onErrorContainer: Color(0xFF7F1D1D),
    surface: surfaceLight,
    onSurface: onBackgroundLight,
    onSurfaceVariant: onSurfaceVariantLight,
    outline: cardBorderLight,
    outlineVariant: dividerLight,
    shadow: Color(0x1A2563EB),
    scrim: Colors.black54,
    inverseSurface: surfaceDark,
    onInverseSurface: onBackgroundDark,
    inversePrimary: secondaryLight,
    surfaceTint: primaryLight,
  );

  static ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryDarkMuted,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF3D2A6B),
    onPrimaryContainer: highlightDark,
    secondary: secondaryDark,
    onSecondary: highlightDark,
    secondaryContainer: Color(0xFF352560),
    onSecondaryContainer: highlightDark,
    tertiary: accentDark,
    onTertiary: Color(0xFF2E1065),
    tertiaryContainer: Color(0xFF4C2D8A),
    onTertiaryContainer: highlightDark,
    error: Color(0xFFF87171),
    onError: Color(0xFF7F1D1D),
    errorContainer: Color(0xFF450A0A),
    onErrorContainer: Color(0xFFFECACA),
    surface: surfaceDark,
    onSurface: onBackgroundDark,
    onSurfaceVariant: onSurfaceVariantDark,
    outline: cardBorderDark,
    outlineVariant: dividerDark,
    shadow: Colors.black,
    scrim: Colors.black87,
    inverseSurface: surfaceLight,
    onInverseSurface: onBackgroundLight,
    inversePrimary: primaryLightDeep,
    surfaceTint: primaryDarkMuted,
  );

  static List<Color> heroGradient(Brightness brightness) => brightness == Brightness.dark
      ? const [Color(0xFF3D2A6B), Color(0xFF22202C), Color(0xFF1A1A22)]
      : const [Color(0xFFDBEAFE), Color(0xFFF0F9FF), Color(0xFFFFFFFF)];

  static List<Color> cardGradient(Brightness brightness) => brightness == Brightness.dark
      ? const [Color(0xFF2A2438), Color(0xFF22202C)]
      : const [Color(0xFFFFFFFF), Color(0xFFF8FAFC)];

  static Color glowColor(Brightness brightness) => brightness == Brightness.dark
      ? accentDark.withValues(alpha: 0.25)
      : primaryLight.withValues(alpha: 0.18);

  /// Semantic aliases used across legacy widgets — prefer [ColorScheme] in new UI.
  static const primary = primaryLightDeep;
  static const secondary = success;
  static const accent = accentLight;
}
