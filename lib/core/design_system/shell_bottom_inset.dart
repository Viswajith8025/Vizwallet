import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
/// Bottom space reserved for the floating shell navigation bar.
abstract final class ShellBottomInset {
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

  /// Extra list padding so the draggable FAB does not cover the last items.
  static const fabClearance = 56.0 + AppSpacing.lg;

  /// Bottom padding for scroll views inside the main shell (phone layout).
  static double scrollBottom(BuildContext context) =>
      fabClearance + AppSpacing.md;
}
