import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/premium_chip.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/app_scroll_behavior.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/month_selector.dart';
import 'package:rupee_track/core/widgets/summary_card.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/features/health_score/presentation/widgets/financial_health_card.dart';
import 'package:rupee_track/features/smart_tagging/presentation/widgets/smart_tagging_widgets.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_report.dart';
import 'package:rupee_track/features/trends/domain/trends_comparison_mode.dart';
import 'package:rupee_track/features/trends/data/spending_trends_repository.dart';
import 'package:rupee_track/features/trends/presentation/widgets/trends_charts.dart';

/// Deep analytics — collapsed by default so the feed stays focused.
class InsightsAnalyticsPanel extends ConsumerStatefulWidget {
  const InsightsAnalyticsPanel({
    required this.report,
    super.key,
  });

  final SpendingTrendsReport report;

  @override
  ConsumerState<InsightsAnalyticsPanel> createState() =>
      _InsightsAnalyticsPanelState();
}

class _InsightsAnalyticsPanelState extends ConsumerState<InsightsAnalyticsPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final salaryDay = ref.watch(salaryDayProvider);
    final mode = ref.watch(trendsComparisonModeProvider);
    final report = widget.report;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PremiumCard(
            variant: PremiumCardVariant.tinted,
            onTap: () => setState(() => _expanded = !_expanded),
            child: Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analytics & charts',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _expanded
                            ? 'Tap to collapse detailed charts'
                            : 'Spending trends, categories, heatmaps',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: AppDurations.fast,
                  child: Icon(
                    Icons.expand_more_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: AppDurations.normal,
            curve: AppCurves.standard,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.lg),
                PremiumSectionHeader(
                  title: 'Analytics',
                  subtitle: formatCycleLabel(cycleKey, salaryDay: salaryDay),
                ),
                const SizedBox(height: AppSpacing.sm),
                const CycleSelector(),
                const SizedBox(height: AppSpacing.md),
                PremiumCard(
                  onTap: () => context.push(AppRoutes.calendar),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Financial calendar',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Day-by-day spending & renewals',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppHorizontalScrollRow(
                  padding: EdgeInsets.zero,
                  height: 40,
                  children: TrendsComparisonMode.values.map((m) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.xs),
                      child: PremiumFilterChip(
                        label: m.label,
                        selected: m == mode,
                        onSelected: (_) => ref
                            .read(trendsComparisonModeProvider.notifier)
                            .setMode(m),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                const FinancialHealthCard(),
                const SizedBox(height: AppSpacing.lg),
                SpendingByTagsSection(cycleKey: cycleKey),
                const SizedBox(height: AppSpacing.lg),
                _MetricsGrid(report: report),
                const SizedBox(height: AppSpacing.xl),
                const PremiumSectionHeader(
                  title: 'Spending over time',
                  subtitle: 'Grey = last period · colour = this period',
                ),
                PremiumCard(
                  child: TrendsLineChart(points: report.timeSeries),
                ),
                const SizedBox(height: AppSpacing.xl),
                const PremiumSectionHeader(title: 'Compare categories'),
                PremiumCard(
                  child: TrendsBarChart(categories: report.categoryComparisons),
                ),
                const SizedBox(height: AppSpacing.xl),
                const PremiumSectionHeader(title: 'Where money goes'),
                PremiumCard(
                  child: TrendsPieChart(categories: report.categoryComparisons),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...report.categoryComparisons.take(5).map(
                      (c) => PremiumRowTile(
                        title: c.categoryName,
                        leading: CircleAvatar(
                          radius: 6,
                          backgroundColor: Color(c.colorValue),
                        ),
                        trailing: Text(
                          formatPaise(c.currentPaise),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                const SizedBox(height: AppSpacing.xl),
                PremiumCard(
                  onTap: () => context.push(AppRoutes.expenseHeatmap),
                  child: Row(
                    children: [
                      Icon(
                        Icons.grid_on_rounded,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expense heatmap',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Calendar view of daily spending',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const PremiumSectionHeader(title: 'Spending by day of week'),
                PremiumCard(child: TrendsHeatMap(cells: report.heatMap)),
                const SizedBox(height: AppSpacing.sm),
                _WeekendWeekdayCard(split: report.weekendWeekday),
                if (report.repeatedExpenses.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xl),
                  const PremiumSectionHeader(title: 'Repeated expenses'),
                  ...report.repeatedExpenses.take(5).map(
                        (r) => PremiumRowTile(
                          title: r.title,
                          subtitle: '${r.categoryName} · ${r.count}×',
                          leading: Icon(
                            Icons.repeat_rounded,
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          trailing: Text(
                            formatPaise(r.totalPaise),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                ],
                if (report.impulsePurchases.count > 0) ...[
                  const SizedBox(height: AppSpacing.md),
                  PremiumCard(
                    accentColor: BrandColors.warning,
                    child: PremiumRowTile(
                      title: 'Quick buys',
                      subtitle:
                          '${report.impulsePurchases.count} totalling ${formatPaise(report.impulsePurchases.totalPaise)}',
                      leading: Icon(
                        Icons.flash_on_rounded,
                        color: BrandColors.warning,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
              ],
            )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.report});

  final SpendingTrendsReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ResponsiveSummaryGrid(
      childAspectRatio: 1.05,
      children: [
        SummaryCard(
          label: 'Daily average',
          icon: Icons.today_outlined,
          value: Text(formatPaise(report.current.avgDailyPaise)),
        ),
        SummaryCard(
          label: 'Weekly average',
          icon: Icons.date_range_outlined,
          value: Text(formatPaise(report.current.avgWeeklyPaise)),
        ),
        SummaryCard(
          label: 'Biggest category',
          icon: Icons.category_outlined,
          value: Text(report.highestCategory?.categoryName ?? '—'),
          subtitle: report.highestCategory != null
              ? formatPaise(report.highestCategory!.currentPaise)
              : null,
        ),
        SummaryCard(
          label: 'Growing fastest',
          icon: Icons.trending_up_rounded,
          value: Text(report.fastestGrowingCategory?.categoryName ?? '—'),
          subtitle: report.fastestGrowingCategory?.changePercent != null
              ? '+${report.fastestGrowingCategory!.changePercent!.round()}%'
              : null,
          accentColor: theme.colorScheme.tertiary,
        ),
      ],
    );
  }
}

class _WeekendWeekdayCard extends StatelessWidget {
  const _WeekendWeekdayCard({required this.split});

  final WeekendWeekdaySplit split;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = split.total;
    if (total <= 0) return const SizedBox.shrink();

    final weekdayFlex = split.weekdayPaise.clamp(1, 1 << 30);
    final weekendFlex = split.weekendPaise.clamp(1, 1 << 30);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekend vs weekday',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Row(
              children: [
                Expanded(
                  flex: weekdayFlex,
                  child: Container(
                    height: 10,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  flex: weekendFlex,
                  child: Container(
                    height: 10,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekday ${formatPaise(split.weekdayPaise)}',
                style: theme.textTheme.labelSmall,
              ),
              Text(
                'Weekend ${formatPaise(split.weekendPaise)}',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
