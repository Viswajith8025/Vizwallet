import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/branding/brand_typography.dart';
import 'package:rupee_track/core/design_system/animated_money_text.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/greeting_utils.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/features/dashboard/domain/monthly_summary.dart';

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

    return PremiumCard(
      showShadow: true,
      accentColor: isPositive ? BrandColors.secondary : BrandColors.error,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GreetingUtils.timeOfDayGreeting(),
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'How you\'re doing',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
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
          const SizedBox(height: AppSpacing.md),
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
                  label: 'Cycle spent',
                  value: _formatCompact(summary.spentPaise),
                  icon: Icons.trending_down_rounded,
                ),
                _HeroStat(
                  label: 'Days to salary',
                  value: '${summary.daysToSalary}',
                  icon: Icons.calendar_today_outlined,
                ),
                _HeroStat(
                  label: 'Savings',
                  value: '${summary.savingsPercent.round()}%',
                  icon: Icons.savings_outlined,
                  valueColor: BrandColors.secondary,
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
                children: stats
                    .map((stat) => Expanded(child: stat))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  static String _formatCompact(int paise) {
    final rupees = paise / 100;
    if (rupees >= 100000) return '₹${(rupees / 100000).toStringAsFixed(1)}L';
    if (rupees >= 1000) return '₹${(rupees / 1000).toStringAsFixed(1)}K';
    return '₹${rupees.round()}';
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
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest
              .withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
