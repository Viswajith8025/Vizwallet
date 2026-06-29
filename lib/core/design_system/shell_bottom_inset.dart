import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';

/// Bottom space reserved for the floating shell navigation bar and quick-add FAB.
abstract final class ShellBottomInset {
  static const fabSize = 56.0;
  static const fabMargin = AppSpacing.md;

  /// Height to keep scrollable content clear of [PremiumBottomNav].
  static double of(BuildContext context, {bool hasBottomNav = true}) {
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    if (!hasBottomNav) {
      return safeBottom + AppSpacing.md;
    }
    // PremiumBottomNav: outer margin + inner padding + icon/label column.
    const navChrome = AppSpacing.md + AppSpacing.md + 56.0;
    return safeBottom + navChrome + AppSpacing.sm;
  }

  /// Extra list padding so the FAB does not cover the last items.
  static const fabClearance = fabSize + AppSpacing.lg;

  /// Right inset so amounts and chart legends clear the anchored FAB.
  static double fabZoneRight(BuildContext context) =>
      fabSize + fabMargin + AppSpacing.sm;

  /// Bottom padding for scroll views inside the main shell (phone layout).
  static double scrollBottom(BuildContext context) =>
      fabClearance + AppSpacing.md;

  /// Standard list padding inside the main shell (clears FAB + bottom nav).
  static EdgeInsets scrollPadding(
    BuildContext context, {
    bool reserveFabRight = true,
    double top = 0,
    double horizontal = AppSpacing.md,
  }) {
    return EdgeInsets.fromLTRB(
      horizontal,
      top,
      reserveFabRight ? fabZoneRight(context) : horizontal,
      scrollBottom(context),
    );
  }

  /// Bottom offset for the anchored quick-add FAB above the nav bar.
  static double fabBottom(BuildContext context, {bool hasBottomNav = true}) {
    return of(context, hasBottomNav: hasBottomNav) + AppSpacing.sm;
  }
}
