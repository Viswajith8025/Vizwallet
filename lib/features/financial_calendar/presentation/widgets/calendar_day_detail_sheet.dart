import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/design_system/compact_label.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/financial_calendar/data/financial_calendar_repository.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';
import 'package:rupee_track/features/financial_calendar/presentation/widgets/calendar_event_tile.dart';
import 'package:rupee_track/features/quick_add/presentation/quick_add_hub_sheet.dart';

Future<void> showCalendarDayDetailSheet(
  BuildContext context,
  WidgetRef ref,
  DateTime day,
) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.82,
    child: _CalendarDayDetailSheet(day: day),
  );
}

class _CalendarDayDetailSheet extends ConsumerWidget {
  const _CalendarDayDetailSheet({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(calendarDaySummaryProvider(day));
    final theme = Theme.of(context);

    return summaryAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Padding(
        padding: AppResponsive.screenPadding(context),
        child: Text('Could not load this day.', style: theme.textTheme.bodyMedium),
      ),
      data: (summary) {
        return ListView(
          padding: AppResponsive.screenPadding(context, bottom: AppSpacing.xl),
          children: [
            Text(
              DateFormat.yMMMEd().format(summary.day),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              summary.cycleLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _SummaryGrid(summary: summary),
            const SizedBox(height: AppSpacing.md),
            if (summary.indicators.isNotEmpty) ...[
              Wrap(
                spacing: AppSpacing.xs,
                children: summary.indicators
                    .map(
                      (i) => Chip(
                        visualDensity: VisualDensity.compact,
                        label: Text(_indicatorLabel(i)),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (summary.healthScore != null)
              ListTile(
                leading: const Icon(Icons.favorite_outline),
                title: const Text('Financial health (this cycle)'),
                subtitle: Text(summary.healthLabel ?? ''),
                trailing: Text(
                  '${summary.healthScore}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            _Section(
              title: 'Transactions',
              events: summary.transactions,
              empty: 'No expenses logged',
            ),
            _Section(
              title: 'Subscriptions',
              events: summary.subscriptions,
              empty: 'No renewals due',
            ),
            _Section(
              title: 'Bills',
              events: summary.bills,
              empty: 'No bills logged',
            ),
            _Section(
              title: 'Goals',
              events: summary.goals,
              empty: 'No goal milestones',
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                showQuickAddSheet(context, ref);
              },
              icon: const Icon(Icons.add),
              label: const Text('Quick add expense'),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                context.push(AppRoutes.insights);
              },
              icon: const Icon(Icons.insights_outlined),
              label: const Text('Open insights'),
            ),
          ],
        );
      },
    );
  }

  String _indicatorLabel(CalendarIndicator i) => switch (i) {
        CalendarIndicator.salaryDay => 'Salary day',
        CalendarIndicator.overBudget => 'Over budget',
        CalendarIndicator.noSpend => 'No spend',
        CalendarIndicator.subscriptionRenewal => 'Renewal',
        CalendarIndicator.goalMilestone => 'Goal',
        CalendarIndicator.loanDue => 'Loan due',
        CalendarIndicator.billDue => 'Bill',
        CalendarIndicator.wishlistPurchase => 'Wishlist',
        CalendarIndicator.cycleStart => 'Cycle start',
      };
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.summary});

  final CalendarDaySummary summary;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.8,
      children: [
        _StatCard(
          label: 'Spent',
          value: formatPaise(summary.spentPaise),
          icon: Icons.trending_down,
        ),
        _StatCard(
          label: 'Received',
          value: formatPaise(summary.receivedPaise),
          icon: Icons.trending_up,
        ),
        _StatCard(
          label: 'Net savings',
          value: formatPaise(summary.savingsPaise),
          icon: Icons.savings_outlined,
        ),
        _StatCard(
          label: 'Safe daily',
          value: formatPaise(summary.safeDailyPaise),
          icon: Icons.shield_outlined,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(height: 4),
            SingleLineLabel(label, style: theme.textTheme.labelSmall),
            SingleLineLabel(
              value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.events,
    required this.empty,
  });

  final String title;
  final List<FinancialCalendarEvent> events;
  final String empty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.sm),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (events.isEmpty)
          Text(
            empty,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          ...events.map((e) => CalendarEventTile(event: e)),
      ],
    );
  }
}
