import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/branding/brand_typography.dart';
import 'package:rupee_track/core/design_system/animated_money_text.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/compact_label.dart';
import 'package:rupee_track/core/design_system/greeting_utils.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/progress_ring.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/dashboard/domain/monthly_summary.dart';

/// Financial command-center hero — money left, cycle progress, key stats.
class DashboardHero extends StatelessWidget {
  const DashboardHero({
    required this.summary,
    super.key,
  });

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = summary.moneyLeftPaise >= 0;
    final moneyColor = isPositive
        ? theme.colorScheme.onSurface
        : theme.colorScheme.error;
    final spentProgress = summary.salaryPaise > 0
        ? (summary.spentPaise / summary.salaryPaise).clamp(0.0, 1.0)
        : 0.0;
    final ringColor = spentProgress > 0.85
        ? theme.colorScheme.error
        : spentProgress > 0.65
            ? BrandColors.warning
            : theme.colorScheme.primary;

    return PremiumCard(
      variant: PremiumCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      GreetingUtils.timeOfDayGreeting(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Your financial snapshot',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              ProgressRing(
                progress: spentProgress,
                size: 64,
                strokeWidth: 5,
                color: ringColor,
                child: Text(
                  '${(spentProgress * 100).round()}%',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Money left this cycle',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AnimatedMoneyText(
            summary.moneyLeftPaise,
            style: BrandTypography.moneyHero(context, color: moneyColor),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            GreetingUtils.motivationalLine(
              moneyLeftPaise: summary.moneyLeftPaise,
              savingsPercent: summary.savingsPercent,
              isOverBudget: summary.spentPaise > summary.salaryPaise,
            ),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          LayoutBuilder(
            builder: (context, constraints) {
              final stats = [
                _HeroStat(
                  label: 'Spent',
                  value: formatPaise(summary.spentPaise),
                  icon: Icons.trending_down_rounded,
                ),
                _HeroStat(
                  label: 'Safe daily',
                  value: summary.daysToSalary > 0
                      ? formatPaise(
                          (summary.moneyLeftPaise / summary.daysToSalary)
                              .round(),
                        )
                      : '—',
                  icon: Icons.shield_outlined,
                  valueColor: theme.colorScheme.tertiary,
                ),
                _HeroStat(
                  label: 'Days to salary',
                  value: '${summary.daysToSalary}',
                  icon: Icons.calendar_today_outlined,
                ),
              ];

              if (constraints.maxWidth < 340) {
                return Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: stats
                      .map(
                        (stat) => SizedBox(
                          width: (constraints.maxWidth - AppSpacing.sm) / 2,
                          child: stat,
                        ),
                      )
                      .toList(),
                );
              }

              return Row(
                children: stats.map((s) => Expanded(child: s)).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.xs),
          FittingLabel(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          FittingLabel(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
