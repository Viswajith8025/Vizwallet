import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/constants/category_defaults.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/expense_heatmap/data/expense_heatmap_repository.dart';
import 'package:rupee_track/features/expense_heatmap/data/heatmap_threshold_store.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_models.dart';

Future<void> showHeatmapFiltersSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.55,
    child: const _HeatmapFiltersSheet(),
  );
}

Future<void> showHeatmapThresholdSheet(
  BuildContext context,
  WidgetRef ref,
  HeatmapThresholds current,
) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.5,
    child: _HeatmapThresholdSheet(current: current),
  );
}

class _HeatmapFiltersSheet extends ConsumerWidget {
  const _HeatmapFiltersSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(heatmapFiltersProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Filters', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        Text('Type', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: HeatmapFilterKind.values.map((kind) {
            final selected = filters.kind == kind;
            return FilterChip(
              label: Text(_kindLabel(kind)),
              selected: selected,
              onSelected: (_) {
                ref.read(heatmapFiltersProvider.notifier).state =
                    filters.copyWith(kind: kind);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Category', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: defaultCategories.take(8).map((cat) {
            return FilterChip(
              label: Text(cat.name),
              selected: false,
              onSelected: (_) {
                // Category id resolved at runtime via repository — use slug hint
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Merchant',
            hintText: 'Swiggy, Amazon…',
          ),
          onChanged: (v) {
            ref.read(heatmapFiltersProvider.notifier).state =
                filters.copyWith(merchantQuery: v);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Payment method'),
          initialValue: filters.paymentMethod?.isEmpty == true
              ? null
              : filters.paymentMethod,
          items: [
            const DropdownMenuItem(value: null, child: Text('All')),
            ...paymentMethods.map(
              (m) => DropdownMenuItem(value: m, child: Text(m)),
            ),
          ],
          onChanged: (v) {
            ref.read(heatmapFiltersProvider.notifier).state =
                filters.copyWith(paymentMethod: v);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Tag',
            hintText: 'food, medical…',
          ),
          onChanged: (v) {
            ref.read(heatmapFiltersProvider.notifier).state =
                filters.copyWith(tagQuery: v);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: () {
            ref.read(heatmapFiltersProvider.notifier).state =
                const HeatmapFilters();
            Navigator.pop(context);
          },
          child: const Text('Clear filters'),
        ),
      ],
    );
  }

  static String _kindLabel(HeatmapFilterKind kind) => switch (kind) {
        HeatmapFilterKind.all => 'All',
        HeatmapFilterKind.income => 'Income',
        HeatmapFilterKind.expense => 'Expense',
        HeatmapFilterKind.subscriptions => 'Subscriptions',
        HeatmapFilterKind.loans => 'Loans',
        HeatmapFilterKind.goals => 'Goals',
        HeatmapFilterKind.wishlist => 'Wishlist',
      };
}

class _HeatmapThresholdSheet extends ConsumerStatefulWidget {
  const _HeatmapThresholdSheet({required this.current});

  final HeatmapThresholds current;

  @override
  ConsumerState<_HeatmapThresholdSheet> createState() =>
      _HeatmapThresholdSheetState();
}

class _HeatmapThresholdSheetState extends ConsumerState<_HeatmapThresholdSheet> {
  late final _lowController = TextEditingController(
    text: paiseToRupees(widget.current.veryLowMaxPaise).toStringAsFixed(0),
  );
  late final _medController = TextEditingController(
    text: paiseToRupees(widget.current.mediumMaxPaise).toStringAsFixed(0),
  );
  late final _highController = TextEditingController(
    text: paiseToRupees(widget.current.highMaxPaise).toStringAsFixed(0),
  );

  @override
  void dispose() {
    _lowController.dispose();
    _medController.dispose();
    _highController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          'Color thresholds',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _lowController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Low max (₹)',
            helperText: 'Green — spending up to this amount',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _medController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Medium max (₹)',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _highController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'High max (₹)',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: () {
            ref.read(heatmapThresholdsProvider.notifier).setThresholds(
                  HeatmapThresholds(
                    veryLowMaxPaise: rupeesToPaise(_lowController.text),
                    mediumMaxPaise: rupeesToPaise(_medController.text),
                    highMaxPaise: rupeesToPaise(_highController.text),
                  ),
                );
            ref.invalidate(expenseHeatmapReportProvider);
            Navigator.pop(context);
          },
          child: const Text('Save thresholds'),
        ),
        TextButton(
          onPressed: () {
            ref.read(heatmapThresholdsProvider.notifier).reset();
            ref.invalidate(expenseHeatmapReportProvider);
            Navigator.pop(context);
          },
          child: const Text('Reset to auto'),
        ),
      ],
    );
  }
}

class HeatmapStatsCard extends StatelessWidget {
  const HeatmapStatsCard({required this.stats, super.key});

  final HeatmapStatistics stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Statistics', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          _StatRow(
            'Highest day',
            stats.highestSpendingDay != null
                ? '${stats.highestSpendingDay!.day}/${stats.highestSpendingDay!.month} · ${formatPaise(stats.highestSpendingPaise)}'
                : '—',
          ),
          _StatRow(
            'Avg daily',
            formatPaise(stats.averageDailySpendingPaise),
          ),
          _StatRow('No spend days', '${stats.noSpendDays}'),
          _StatRow(
            'Most active week',
            '${stats.mostActiveWeekLabel} · ${formatPaise(stats.mostActiveWeekPaise)}',
          ),
          _StatRow(
            'Longest no-spend streak',
            '${stats.longestNoSpendStreak} days',
          ),
          _StatRow(
            'Highest month',
            '${stats.highestSpendingMonthLabel} · ${formatPaise(stats.highestSpendingMonthPaise)}',
          ),
          _StatRow(
            'Weekend avg',
            formatPaise(stats.averageWeekendSpendingPaise),
          ),
          _StatRow(
            'Weekday avg',
            formatPaise(stats.averageWeekdaySpendingPaise),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
