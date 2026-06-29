import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';

/// Gradient and glass surface helpers for premium fintech UI.
abstract final class PremiumSurfaces {
  static BoxDecoration heroDecoration(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: BrandColors.heroGradient(brightness),
      ),
      borderRadius: BorderRadius.circular(AppRadius.card),
      border: Border.all(
        color: isDark
            ? BrandColors.cardBorderDark.withValues(alpha: 0.6)
            : BrandColors.cardBorderLight,
      ),
      boxShadow: [
        BoxShadow(
          color: BrandColors.glowColor(brightness),
          blurRadius: isDark ? 28 : 32,
          offset: const Offset(0, 12),
        ),
        ...AppShadows.card(isDark),
      ],
    );
  }

  static BoxDecoration tintedCard(BuildContext context, {Color? tint}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final base = tint ?? theme.colorScheme.primary;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color.alphaBlend(base.withValues(alpha: isDark ? 0.14 : 0.08), theme.cardColor),
          theme.cardColor,
        ],
      ),
      borderRadius: BorderRadius.circular(AppRadius.card),
      border: Border.all(color: theme.dividerColor),
      boxShadow: AppShadows.card(isDark),
    );
  }

  static Widget glassOverlay({
    required Widget child,
    double sigma = 12,
    double opacity = 0.72,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: opacity * 0.08),
          ),
          child: child,
        ),
      ),
    );
  }
}
