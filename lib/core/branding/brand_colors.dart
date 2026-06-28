import 'package:flutter/material.dart';

/// Vizwallet — premium fintech palette.
///
/// Primary: Deep Royal Blue · Secondary: Emerald · Accent: Electric Cyan
abstract final class BrandColors {
  // Core brand
  static const primary = Color(0xFF1A2F5C);
  static const primaryLight = Color(0xFF2A4578);
  static const secondary = Color(0xFF059669);
  static const accent = Color(0xFF22D3EE);

  // Semantic
  static const success = Color(0xFF10B981);
  static const successContainer = Color(0xFFD1FAE5);
  static const warning = Color(0xFFF59E0B);
  static const warningContainer = Color(0xFFFEF3C7);
  static const error = Color(0xFFF87171);
  static const errorContainer = Color(0xFFFEE2E2);

  // Light mode surfaces
  static const backgroundLight = Color(0xFFFAFBFC);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const cardLight = Color(0xFFFFFFFF);
  static const cardBorderLight = Color(0xFFE8ECF1);
  static const onBackgroundLight = Color(0xFF0F172A);
  static const onSurfaceVariantLight = Color(0xFF64748B);
  static const dividerLight = Color(0xFFF1F5F9);

  // Dark mode surfaces — rich charcoal, not inverted
  static const backgroundDark = Color(0xFF0F1419);
  static const surfaceDark = Color(0xFF161B22);
  static const cardDark = Color(0xFF1C2128);
  static const cardBorderDark = Color(0xFF2D333B);
  static const onBackgroundDark = Color(0xFFF0F3F6);
  static const onSurfaceVariantDark = Color(0xFF8B949E);
  static const dividerDark = Color(0xFF21262D);

  static ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE8EEF8),
    onPrimaryContainer: Color(0xFF0F1D38),
    secondary: secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFD1FAE5),
    onSecondaryContainer: Color(0xFF064E3B),
    tertiary: accent,
    onTertiary: Color(0xFF083344),
    tertiaryContainer: Color(0xFFCFFAFE),
    onTertiaryContainer: Color(0xFF164E63),
    error: error,
    onError: Colors.white,
    errorContainer: errorContainer,
    onErrorContainer: Color(0xFF7F1D1D),
    surface: surfaceLight,
    onSurface: onBackgroundLight,
    onSurfaceVariant: onSurfaceVariantLight,
    outline: cardBorderLight,
    outlineVariant: dividerLight,
    shadow: Colors.black12,
    scrim: Colors.black54,
    inverseSurface: surfaceDark,
    onInverseSurface: onBackgroundDark,
    inversePrimary: Color(0xFF6B9BD1),
    surfaceTint: primary,
  );

  static ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF6B9BD1),
    onPrimary: Color(0xFF0F1D38),
    primaryContainer: Color(0xFF1A2F5C),
    onPrimaryContainer: Color(0xFFE8EEF8),
    secondary: Color(0xFF34D399),
    onSecondary: Color(0xFF064E3B),
    secondaryContainer: Color(0xFF065F46),
    onSecondaryContainer: Color(0xFFD1FAE5),
    tertiary: accent,
    onTertiary: Color(0xFF083344),
    tertiaryContainer: Color(0xFF164E63),
    onTertiaryContainer: Color(0xFFCFFAFE),
    error: error,
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
    inversePrimary: primary,
    surfaceTint: Color(0xFF6B9BD1),
  );
}
