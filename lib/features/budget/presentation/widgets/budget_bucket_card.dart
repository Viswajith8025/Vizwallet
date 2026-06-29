import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';
import 'package:rupee_track/features/budget/domain/bucket_status.dart';
import 'package:rupee_track/core/design_system/compact_label.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
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
                  if (bucket.colorValue != null) ...[
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: Color(bucket.colorValue!)
                          .withValues(alpha: 0.18),
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: Color(bucket.colorValue!),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: SingleLineLabel(
                      bucket.displayName,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  if (bucket.alertLevel != BudgetAlertLevel.none)
                    Flexible(
                      child: Container(
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
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: _alertColor(context, bucket.alertLevel),
                            fontWeight: FontWeight.w600,
                          ),
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
                    label: 'Planned',
                    value: formatPaise(bucket.totalBudgetPaise),
                  ),
                  _Metric(
                    label: 'Used',
                    value: formatPaise(bucket.spentPaise),
                  ),
                  _Metric(
                    label: 'Money left',
                    value: formatPaise(bucket.remainingPaise),
                    highlight: bucket.remainingPaise < 0,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: SingleLineLabel(
                      '${bucket.percentUsed.toStringAsFixed(0)}% used',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: SingleLineLabel(
                      '${formatPaise(bucket.dailyAllowancePaise)} per day · ${bucket.daysRemaining} days left',
                      textAlign: TextAlign.end,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              if (bucket.rolloverPaise > 0) ...[
                const SizedBox(height: 6),
                Text(
                  'Includes ${formatPaise(bucket.rolloverPaise)} left from last month',
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
          FittingLabel(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          FittingLabel(
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
