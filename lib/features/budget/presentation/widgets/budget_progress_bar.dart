import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    required this.percentUsed,
    required this.alertLevel,
    super.key,
    this.height = 8,
  });

  final double percentUsed;
  final BudgetAlertLevel alertLevel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = (percentUsed / 100).clamp(0.0, 1.2);

    Color fillColor = scheme.primary;
    switch (alertLevel) {
      case BudgetAlertLevel.watch50:
        fillColor = BrandColors.secondary;
      case BudgetAlertLevel.watch75:
        fillColor = BrandColors.warning;
      case BudgetAlertLevel.critical90:
        fillColor = const Color(0xFFF97316);
      case BudgetAlertLevel.exceeded:
        fillColor = BrandColors.error;
      case BudgetAlertLevel.none:
        fillColor = scheme.primary;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Container(color: scheme.surfaceContainerHighest),
            AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              widthFactor: progress > 1 ? 1 : progress,
              child: Container(color: fillColor),
            ),
            if (progress > 1)
              Container(color: BrandColors.error.withValues(alpha: 0.3)),
          ],
        ),
      ),
    );
  }
}
