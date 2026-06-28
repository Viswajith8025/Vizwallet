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
  }}
