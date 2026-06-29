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
import 'package:rupee_track/features/insights/presentation/widgets/insights_section_header.dart';
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
    final cycleLabel = formatCycleLabel(cycleKey, salaryDay: salaryDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const InsightsSectionHeader(
          emoji: '📊',
          title: 'Deep analytics',
          subtitle: 'Charts, trends, and spending patterns',
        ),
        PremiumCard(
          variant: PremiumCardVariant.tinted,
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _expanded ? 'Hide charts & breakdowns' : 'Show charts & breakdowns',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      _expanded
                          ? 'Tap to collapse'
                          : 'Period comparison · categories · heatmaps',
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
                    InsightsSectionHeader(
                      emoji: '📅',
                      title: 'Pay period',
                      subtitle: cycleLabel,
                    ),
                    const CycleSelector(),
                    const SizedBox(height: AppSpacing.sm),
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
                    const InsightsSectionHeader(
                      emoji: '❤️',
                      title: 'Financial health',
                      subtitle: 'Overall score from your habits',
                    ),
                    const FinancialHealthCard(),
                    const InsightsSectionHeader(
                      emoji: '🏷️',
                      title: 'Smart tags',
                      subtitle: 'How you label your spending',
                    ),
                    SpendingByTagsSection(cycleKey: cycleKey),
                    const InsightsSectionHeader(
                      emoji: '🔢',
                      title: 'Key numbers',
                      subtitle: 'Averages and top categories',
                    ),
                    _MetricsGrid(report: report),
                    const InsightsSectionHeader(
                      emoji: '📈',
                      title: 'Spending over time',
                      subtitle: 'Grey = last period · colour = this period',
                    ),
                    PremiumCard(
                      child: TrendsLineChart(points: report.timeSeries),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const InsightsSectionHeader(
                      emoji: '📊',
                      title: 'Category comparison',
                      subtitle: 'Side-by-side bar chart',
                    ),
                    PremiumCard(
                      child: TrendsBarChart(categories: report.categoryComparisons),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const InsightsSectionHeader(
                      emoji: '🥧',
                      title: 'Where money goes',
                      subtitle: 'Share by category',
                    ),
                    PremiumCard(
                      child: TrendsPieChart(categories: report.categoryComparisons),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PremiumCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: report.categoryComparisons.take(5).map(
                          (c) {
                            return PremiumRowTile(
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
                            );
                          },
                        ).toList(),
                      ),
                    ),
                    const InsightsSectionHeader(
                      emoji: '🗓️',
                      title: 'Calendar tools',
                      subtitle: 'See spending day by day',
                    ),
                    PremiumCard(
                      onTap: () => context.push(AppRoutes.calendar),
                      child: Row(
                        children: [
                          const Text('📅', style: TextStyle(fontSize: 22)),
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
                                  'Salary days, bills, and daily spend',
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
                    const SizedBox(height: AppSpacing.sm),
                    PremiumCard(
                      onTap: () => context.push(AppRoutes.expenseHeatmap),
                      child: Row(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 22)),
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
                                  'Which days you spend the most',
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
                    const InsightsSectionHeader(
                      emoji: '📆',
                      title: 'Day-of-week pattern',
                      subtitle: 'Weekday vs weekend split',
                    ),
                    PremiumCard(child: TrendsHeatMap(cells: report.heatMap)),
                    const SizedBox(height: AppSpacing.sm),
                    _WeekendWeekdayCard(split: report.weekendWeekday),
                    if (report.repeatedExpenses.isNotEmpty) ...[
                      InsightsSectionHeader(
                        emoji: '🔁',
                        title: 'Repeated expenses',
                        subtitle: 'Things you buy often',
                        count: report.repeatedExpenses.length,
                      ),
                      PremiumCard(
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: report.repeatedExpenses.take(5).map(
                            (r) {
                              return PremiumRowTile(
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
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ],
                    if (report.impulsePurchases.count > 0) ...[
                      const InsightsSectionHeader(
                        emoji: '⚡',
                        title: 'Quick buys',
                        subtitle: 'Larger discretionary purchases',
                        accentColor: BrandColors.warning,
                      ),
                      PremiumCard(
                        accentColor: BrandColors.warning,
                        child: PremiumRowTile(
                          title: '${report.impulsePurchases.count} impulse purchases',
                          subtitle:
                              'Total ${formatPaise(report.impulsePurchases.totalPaise)}',
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
      childAspectRatio: 0.96,
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
          label: 'Top category',
          icon: Icons.category_outlined,
          value: Text(report.highestCategory?.categoryName ?? '—'),
          subtitle: report.highestCategory != null
              ? formatPaise(report.highestCategory!.currentPaise)
              : null,
        ),
        SummaryCard(
          label: 'Fastest growing',
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
          Row(
            children: [
              const Text('🗓️', style: TextStyle(fontSize: 18)),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Weekend vs weekday',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
