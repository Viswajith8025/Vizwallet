import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';

class CalendarMonthOverviewCard extends StatelessWidget {
  const CalendarMonthOverviewCard({required this.overview, super.key});

  final CalendarMonthOverview overview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PremiumCard(
      showShadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Monthly overview',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _OverviewRow(
            label: 'Income',
            value: formatPaise(overview.incomePaise),
            color: theme.colorScheme.primary,
          ),
          _OverviewRow(
            label: 'Expense',
            value: formatPaise(overview.expensePaise),
            color: theme.colorScheme.error,
          ),
          _OverviewRow(
            label: 'Savings',
            value: formatPaise(overview.savingsPaise),
            color: theme.colorScheme.tertiary,
          ),
          const Divider(height: AppSpacing.lg),
          _OverviewRow(
            label: 'Budget remaining',
            value: formatPaise(overview.budgetRemainingPaise),
          ),
          _OverviewRow(
            label: 'Subscriptions / mo',
            value: formatPaise(overview.subscriptionMonthlyPaise),
          ),
          _OverviewRow(
            label: 'Safe daily spend',
            value: formatPaise(overview.safeDailyPaise),
          ),
          if (overview.largestExpense != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Largest: ${overview.largestExpense!.title} · ${formatPaise(overview.largestExpense!.amountPaise)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (overview.highestSpendingDay != null) ...[
            Text(
              'Highest spend day: ${overview.highestSpendingDay!.day}/${overview.highestSpendingDay!.month} · ${formatPaise(overview.highestSpendingPaise)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${overview.noSpendDays} no-spend days · ${overview.overBudgetDays} over-budget days · ${overview.goalContributions} goal wins',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
