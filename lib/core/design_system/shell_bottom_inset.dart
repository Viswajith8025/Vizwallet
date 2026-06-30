import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/responsive.dart';

/// Bottom space reserved for the floating shell navigation bar and quick-add FAB.
abstract final class ShellBottomInset {
  static const fabSize = 56.0;
  static const fabMargin = AppSpacing.md;

  /// Floating [PremiumBottomNav] height (margin + chrome, excluding gesture inset).
  static double navBarHeight(BuildContext context) {
    final compact = AppResponsive.useCompactNav(context);
    const outerMargin = AppSpacing.md;
    const innerPadding = AppSpacing.xs * 2;
    final itemHeight = compact ? 48.0 : 56.0;
    return outerMargin + innerPadding + itemHeight;
  }

  /// Height to keep scrollable content clear of [PremiumBottomNav].
  static double of(BuildContext context, {bool hasBottomNav = true}) {
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    if (!hasBottomNav) {
      return safeBottom + AppSpacing.md;
    }
    return safeBottom + navBarHeight(context);
  }

  /// Extra list padding so the FAB does not cover the last items.
  static double scrollBottom(BuildContext context) =>
      fabBottom(context) + fabSize + AppSpacing.xs;

  /// Symmetric horizontal + bottom padding for shell tab scroll views.
  static EdgeInsets scrollPadding(
    BuildContext context, {
    double top = 0,
  }) {
    final horizontal =
        AppResponsive.horizontalPadding(MediaQuery.sizeOf(context).width);
    return EdgeInsets.fromLTRB(
      horizontal,
      top,
      horizontal,
      scrollBottom(context),
    );
  }

  /// Use inside [ResponsiveBody] when horizontal padding is already applied.
  static EdgeInsets bottomOnly(BuildContext context) {
    return EdgeInsets.only(bottom: scrollBottom(context));
  }

  /// Pinned composer (e.g. Jithu chat input) above the floating nav — no FAB.
  static double composerBottom(BuildContext context) => of(context);

  /// Bottom offset for the anchored quick-add FAB above the nav bar.
  static double fabBottom(BuildContext context, {bool hasBottomNav = true}) {
    return of(context, hasBottomNav: hasBottomNav);
  }
}
