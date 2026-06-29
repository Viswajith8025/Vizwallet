import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_surfaces.dart';
import 'package:rupee_track/core/widgets/pressable_scale.dart';

/// Elevated surface card with gradient, accent stripe, and press feedback.
class PremiumCard extends StatelessWidget {
  const PremiumCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
    this.accentColor,
    this.showShadow = true,
    this.margin,
    this.variant = PremiumCardVariant.standard,
    this.tintColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? accentColor;
  final bool showShadow;
  final EdgeInsetsGeometry? margin;
  final PremiumCardVariant variant;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final BoxDecoration decoration;
    switch (variant) {
      case PremiumCardVariant.hero:
        decoration = PremiumSurfaces.heroDecoration(context);
      case PremiumCardVariant.tinted:
        decoration = PremiumSurfaces.tintedCard(context, tint: tintColor);
      case PremiumCardVariant.elevated:
        decoration = BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: BrandColors.cardGradient(theme.brightness),
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: theme.dividerColor),
          boxShadow: showShadow ? AppShadows.elevated(isDark) : null,
        );
      case PremiumCardVariant.standard:
        decoration = BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: theme.dividerColor),
          boxShadow: showShadow ? AppShadows.card(isDark) : null,
        );
    }

    final card = Container(
      margin: margin,
      decoration: decoration,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (accentColor != null)
            Container(
              height: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor!,
                    accentColor!.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
            child: child,
          ),
        ],
      ),
    );

    if (onTap == null) {
      return Semantics(button: false, child: card);
    }

    return Semantics(
      button: true,
      child: PressableScale(
        onTap: onTap,
        scale: 0.98,
        child: card,
      ),
    );
  }
}

enum PremiumCardVariant { standard, elevated, hero, tinted }
