import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';
import 'package:rupee_track/features/budget/domain/bucket_status.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/features/budget/presentation/widgets/budget_progress_bar.dart';

class BudgetBucketCard extends StatelessWidget {
  const BudgetBucketCard({
    required this.bucket,
    super.key,
    this.onTap,
  });

  final BucketStatus bucket;
  final VoidCallback? onTap;

  String get _alertLabel => switch (bucket.alertLevel) {
        BudgetAlertLevel.exceeded => 'Over budget',
        BudgetAlertLevel.critical90 => '90% used',
        BudgetAlertLevel.watch75 => '75% used',
        BudgetAlertLevel.watch50 => '50% used',
        BudgetAlertLevel.none => '',
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PremiumCard(
      onTap: onTap,
      accentColor: _alertColor(context, bucket.alertLevel),
      child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      bucket.displayName,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (bucket.alertLevel != BudgetAlertLevel.none)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _alertColor(context, bucket.alertLevel)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _alertLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _alertColor(context, bucket.alertLevel),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              BudgetProgressBar(
                percentUsed: bucket.percentUsed,
                alertLevel: bucket.alertLevel,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Metric(
                    label: 'Budget',
                    value: formatPaise(bucket.totalBudgetPaise),
                  ),
                  _Metric(
                    label: 'Spent',
                    value: formatPaise(bucket.spentPaise),
                  ),
                  _Metric(
                    label: 'Left',
                    value: formatPaise(bucket.remainingPaise),
                    highlight: bucket.remainingPaise < 0,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${bucket.percentUsed.toStringAsFixed(0)}% used',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${formatPaise(bucket.dailyAllowancePaise)}/day · ${bucket.daysRemaining}d left',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              if (bucket.rolloverPaise > 0) ...[
                const SizedBox(height: 6),
                Text(
                  'Includes ${formatPaise(bucket.rolloverPaise)} rollover',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ],
            ],
          ),
    );
  }

  Color _alertColor(BuildContext context, BudgetAlertLevel level) =>
      switch (level) {
        BudgetAlertLevel.exceeded => Theme.of(context).colorScheme.error,
        BudgetAlertLevel.critical90 => const Color(0xFFF97316),
        BudgetAlertLevel.watch75 => BrandColors.warning,
        BudgetAlertLevel.watch50 => BrandColors.secondary,
        BudgetAlertLevel.none => Theme.of(context).colorScheme.primary,
      };
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: highlight ? theme.colorScheme.error : null,
            ),
          ),
        ],
      ),
    );
  }
}
