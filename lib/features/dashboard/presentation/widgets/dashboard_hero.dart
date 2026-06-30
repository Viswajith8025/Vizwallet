import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/branding/brand_typography.dart';
import 'package:rupee_track/core/branding/vis_wallet_logo.dart';
import 'package:rupee_track/core/design_system/animated_money_text.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/compact_label.dart';
import 'package:rupee_track/core/design_system/greeting_utils.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/progress_ring.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/dashboard/domain/monthly_summary.dart';

/// Financial command-center hero — compact when salary is missing.
class DashboardHero extends StatelessWidget {
  const DashboardHero({
    required this.summary,
    super.key,
  });

  final MonthlySummary summary;

  @override
  Widget build(BuildContext context) {
    if (!summary.salaryEntered) {
      return _SalarySetupHero(onAddSalary: () => context.push(AppRoutes.salary));
    }
    return _BalanceHero(summary: summary);
  }
}

class _SalarySetupHero extends StatelessWidget {
  const _SalarySetupHero({required this.onAddSalary});

  final VoidCallback onAddSalary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PremiumCard(
      variant: PremiumCardVariant.hero,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const VisWalletLogo(size: 52, showShadow: true),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  GreetingUtils.timeOfDayGreeting(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Add your salary to start',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Unlock daily spending guide, savings, and AI Jithu.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          FilledButton(
            onPressed: onAddSalary,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _BalanceHero extends StatelessWidget {
  const _BalanceHero({required this.summary});

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
      padding: const EdgeInsets.all(AppSpacing.lg),
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
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Money left this cycle',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    AnimatedMoneyText(
                      summary.moneyLeftPaise,
                      style: BrandTypography.moneyHero(context, color: moneyColor),
                    ),
                  ],
                ),
              ),
              ProgressRing(
                progress: spentProgress,
                size: 56,
                strokeWidth: 4.5,
                color: ringColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(spentProgress * 100).round()}%',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'spent',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 8,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            GreetingUtils.motivationalLine(
              moneyLeftPaise: summary.moneyLeftPaise,
              savingsPercent: summary.savingsPercent,
              isOverBudget: summary.moneyLeftPaise < 0,
            ),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  label: 'Spent',
                  value: formatPaise(summary.spentPaise),
                  icon: Icons.trending_down_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _HeroStat(
                  label: 'Safe daily',
                  value: summary.safeDailyLimitPaise > 0
                      ? formatPaise(summary.safeDailyLimitPaise)
                      : '—',
                  icon: Icons.shield_outlined,
                  valueColor: theme.colorScheme.tertiary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _HeroStat(
                  label: 'To salary',
                  value: '${summary.daysToSalary}d',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ],
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(height: AppSpacing.xxs),
          FittingLabel(
            value,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          FittingLabel(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
