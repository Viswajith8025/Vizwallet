import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/expense_heatmap/data/expense_heatmap_repository.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_models.dart';

Future<void> showHeatmapDayDetailSheet(
  BuildContext context,
  WidgetRef ref,
  HeatmapDayCell cell,
  ExpenseHeatmapReport report,
) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.72,
    child: _HeatmapDayDetailSheet(cell: cell, report: report),
  );
}

Future<void> showHeatmapDayTimelineSheet(
  BuildContext context,
  HeatmapDayDetail detail,
) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.65,
    child: _HeatmapTimelineSheet(detail: detail),
  );
}

class _HeatmapDayDetailSheet extends ConsumerStatefulWidget {
  const _HeatmapDayDetailSheet({
    required this.cell,
    required this.report,
  });

  final HeatmapDayCell cell;
  final ExpenseHeatmapReport report;

  @override
  ConsumerState<_HeatmapDayDetailSheet> createState() =>
      _HeatmapDayDetailSheetState();
}

class _HeatmapDayDetailSheetState extends ConsumerState<_HeatmapDayDetailSheet> {
  late Future<HeatmapDayDetail> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = ref.read(expenseHeatmapRepositoryProvider).loadDayDetail(
          date: widget.cell.date,
          report: widget.report,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<HeatmapDayDetail>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('Could not load day details'));
        }
        final detail = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              '${widget.cell.date.day}/${widget.cell.date.month}/${widget.cell.date.year}',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _Row('Total spent', formatPaise(detail.totalSpentPaise)),
            _Row('Total income', formatPaise(detail.totalIncomePaise)),
            _Row('Safe daily spend', formatPaise(detail.safeDailySpendPaise)),
            _Row('Budget remaining', formatPaise(detail.budgetRemainingPaise)),
            if (detail.healthScore != null)
              _Row('Health score', '${detail.healthScore}'),
            if (detail.goalContributionsPaise > 0)
              _Row(
                'Goal contributions',
                formatPaise(detail.goalContributionsPaise),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text('Merchants', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.sm),
            if (detail.merchants.isEmpty)
              Text(
                'No transactions this day',
                style: theme.textTheme.bodySmall,
              )
            else
              ...detail.merchants.take(5).map(
                    (m) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(m.name),
                      subtitle: Text('${m.count} transaction${m.count == 1 ? '' : 's'}'),
                      trailing: Text(formatPaise(m.totalPaise)),
                    ),
                  ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                showHeatmapDayTimelineSheet(context, detail);
              },
              icon: const Icon(Icons.timeline_outlined),
              label: const Text('View timeline'),
            ),
          ],
        );
      },
    );
  }
}

class _HeatmapTimelineSheet extends StatelessWidget {
  const _HeatmapTimelineSheet({required this.detail});

  final HeatmapDayDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Timeline', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        ...detail.transactions.map(
          (t) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: t.isIncome
                  ? Colors.teal.withValues(alpha: 0.15)
                  : theme.colorScheme.primaryContainer,
              child: Icon(
                t.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                size: 18,
                color: t.isIncome
                    ? Colors.teal
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(t.title),
            subtitle: Text(
              '${t.categoryName} · ${t.paymentMethod} · '
              '${t.occurredAt.toLocal().hour.toString().padLeft(2, '0')}:'
              '${t.occurredAt.toLocal().minute.toString().padLeft(2, '0')}',
            ),
            trailing: Text(
              formatPaise(t.amountPaise),
              style: TextStyle(
                color: t.isIncome ? Colors.teal : null,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
