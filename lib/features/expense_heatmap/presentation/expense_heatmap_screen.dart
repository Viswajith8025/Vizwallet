import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/expense_heatmap/data/expense_heatmap_repository.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_models.dart';
import 'package:rupee_track/features/expense_heatmap/presentation/widgets/contribution_heatmap_grid.dart';
import 'package:rupee_track/features/expense_heatmap/presentation/widgets/heatmap_day_detail_sheet.dart';
import 'package:rupee_track/features/expense_heatmap/presentation/widgets/heatmap_filters_sheet.dart';

class ExpenseHeatmapScreen extends ConsumerWidget {
  const ExpenseHeatmapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(expenseHeatmapReportProvider);
    final viewMode = ref.watch(heatmapViewModeProvider);
    final filters = ref.watch(heatmapFiltersProvider);
    final theme = Theme.of(context);
    final colors = HeatmapColorScheme.of(context);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Expense heatmap',
        subtitle: 'Your spending patterns',
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: filters.hasActiveFilters,
              child: const Icon(Icons.filter_list_rounded),
            ),
            tooltip: 'Filters',
            onPressed: () => showHeatmapFiltersSheet(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Thresholds',
            onPressed: reportAsync.maybeWhen(
              data: (report) => () => showHeatmapThresholdSheet(
                    context,
                    ref,
                    report.thresholds,
                  ),
              orElse: () => null,
            ),
          ),
        ],
      ),
      body: ResponsiveBody(
        child: reportAsync.when(
          loading: () => ListView(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xxl,
            ),
            children: const [
              SkeletonCard(height: 48),
              SizedBox(height: AppSpacing.sm),
              SkeletonCard(height: 220),
            ],
          ),
          error: (_, __) => ErrorState(
            message: 'We couldn\'t load your expense heatmap.',
            onRetry: () => ref.invalidate(expenseHeatmapReportProvider),
          ),
          data: (report) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(expenseHeatmapReportProvider);
            },
            child: ListView(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
                bottom: AppSpacing.xxl,
              ),
              children: [
                _ViewModeBar(viewMode: viewMode),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Previous period',
                      onPressed: () =>
                          ref.read(heatmapAnchorProvider.notifier).previous(),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Text(
                        report.rangeLabel,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Next period',
                      onPressed: () =>
                          ref.read(heatmapAnchorProvider.notifier).next(),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                PremiumCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContributionHeatmapGrid(
                        weeks: report.weeks,
                        colors: colors,
                        cellSize: viewMode == HeatmapViewMode.yearly ? 11 : 14,
                        onDayTap: (cell) => showHeatmapDayDetailSheet(
                          context,
                          ref,
                          cell,
                          report,
                        ),
                        onDayLongPress: (cell) async {
                          final detail = await ref
                              .read(expenseHeatmapRepositoryProvider)
                              .loadDayDetail(date: cell.date, report: report);
                          if (context.mounted) {
                            showHeatmapDayTimelineSheet(context, detail);
                          }
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      HeatmapLegend(
                        thresholds: report.thresholds,
                        colors: colors,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Insights',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...report.insights.map(
                  (i) => Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: ListTile(
                      leading: Icon(i.icon, color: theme.colorScheme.primary),
                      title: Text(i.message),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                HeatmapStatsCard(stats: report.statistics),
                const SizedBox(height: AppSpacing.lg),
                PremiumCard(
                  child: Text(
                    'Coming soon: AI pattern detection · bank import · '
                    'location heatmap · travel spending · habit analysis · cloud sync',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewModeBar extends ConsumerWidget {
  const _ViewModeBar({required this.viewMode});

  final HeatmapViewMode viewMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<HeatmapViewMode>(
        segments: const [
          ButtonSegment(
            value: HeatmapViewMode.monthly,
            label: Text('Month'),
          ),
          ButtonSegment(
            value: HeatmapViewMode.quarterly,
            label: Text('Quarter'),
          ),
          ButtonSegment(
            value: HeatmapViewMode.yearly,
            label: Text('Year'),
          ),
          ButtonSegment(
            value: HeatmapViewMode.salaryCycle,
            label: Text('Cycle'),
          ),
        ],
        selected: {viewMode},
        onSelectionChanged: (v) {
          ref.read(heatmapViewModeProvider.notifier).setMode(v.first);
        },
      ),
    );
  }
}
