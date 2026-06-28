import 'package:flutter/material.dart';

/// 8-point spacing system and premium design tokens for Vizwallet.
abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
  static const huge = 48.0;

  static const screenHorizontal = lg;
  static const cardPadding = lg;
  static const sectionGap = xl;
}

abstract final class AppRadius {
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const pill = 999.0;

  static const card = lg;
  static const button = md;
  static const sheet = xl;
  static const fab = 20.0;
}

abstract final class AppDurations {
  static const instant = Duration(milliseconds: 100);
  static const fast = Duration(milliseconds: 200);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 450);
  static const emphasis = Duration(milliseconds: 600);
}

abstract final class AppCurves {
  static const standard = Curves.easeOutCubic;
  static const enter = Curves.easeOutQuart;
  static const exit = Curves.easeInCubic;
  static const spring = Curves.easeOutBack;
}

abstract final class AppShadows {
  static List<BoxShadow> card(bool isDark) => [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.35)
              : const Color(0xFF1A2F5C).withValues(alpha: 0.06),
          blurRadius: isDark ? 16 : 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> navBar(bool isDark) => [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.5)
              : const Color(0xFF1A2F5C).withValues(alpha: 0.08),
          blurRadius: 32,
          offset: const Offset(0, -4),
        ),
      ];

  static List<BoxShadow> fab(bool isDark) => [
        BoxShadow(
          color: const Color(0xFF1A2F5C).withValues(alpha: isDark ? 0.45 : 0.22),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];
}
