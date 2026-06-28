import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/premium_chip.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/month_selector.dart';
import 'package:rupee_track/core/widgets/summary_card.dart';
import 'package:rupee_track/features/health_score/presentation/widgets/financial_health_card.dart';
import 'package:rupee_track/features/smart_tagging/data/tagging_repository.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_report.dart';
import 'package:rupee_track/features/trends/data/spending_trends_repository.dart';
import 'package:rupee_track/features/trends/domain/trends_comparison_mode.dart';
import 'package:rupee_track/features/trends/presentation/widgets/trends_charts.dart';
import 'package:rupee_track/features/smart_tagging/presentation/widgets/smart_tagging_widgets.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final salaryDay = ref.watch(salaryDayProvider);
    final mode = ref.watch(trendsComparisonModeProvider);
    final trendsAsync = ref.watch(spendingTrendsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Insights',
        subtitle: 'Spending trends & patterns',
      ),
      body: trendsAsync.when(
        loading: () => const DashboardSkeleton(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (report) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(spendingTrendsProvider);
              ref.invalidate(spendingByTagsProvider(cycleKey));
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                0,
                AppSpacing.screenHorizontal,
                AppSpacing.xxl,
              ),
              children: [
                Text(
                  formatCycleLabel(cycleKey, salaryDay: salaryDay),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const CycleSelector(),
                const SizedBox(height: AppSpacing.md),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
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
                ),
                const SizedBox(height: AppSpacing.lg),
                const FinancialHealthCard(),
                const SizedBox(height: AppSpacing.lg),
                SpendingByTagsSection(cycleKey: cycleKey),
                const SizedBox(height: AppSpacing.lg),
                if (report.summaries.isNotEmpty)
                  PremiumCard(
                    accentColor: theme.colorScheme.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              'AI-style insights',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...report.summaries.map(
                          (line) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: Text(
                              line,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 1.45,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.lg),
                _MetricsGrid(report: report),
                const SizedBox(height: AppSpacing.xl),
                const PremiumSectionHeader(
                  title: 'Spend over time',
                  subtitle: 'Grey = previous · colour = current',
                ),
                PremiumCard(
                  child: TrendsLineChart(points: report.timeSeries),
                ),
                const SizedBox(height: AppSpacing.xl),
                const PremiumSectionHeader(title: 'Category comparison'),
                PremiumCard(
                  child: TrendsBarChart(categories: report.categoryComparisons),
                ),
                const SizedBox(height: AppSpacing.xl),
                const PremiumSectionHeader(title: 'Category split'),
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
                const PremiumSectionHeader(title: 'Weekday heat map'),
                PremiumCard(
                  child: TrendsHeatMap(cells: report.heatMap),
                ),
                const SizedBox(height: AppSpacing.sm),
                _WeekendWeekdayCard(split: report.weekendWeekday),
                if (report.repeatedExpenses.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xl),
                  const PremiumSectionHeader(title: 'Repeated expenses'),
                  ...report.repeatedExpenses.take(5).map(
                        (r) => PremiumRowTile(
                          title: r.title,
                          subtitle: '${r.categoryName} · ${r.count} times',
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
                      title: 'Impulse-style purchases',
                      subtitle:
                          '${report.impulsePurchases.count} totalling ${formatPaise(report.impulsePurchases.totalPaise)}',
                      leading: Icon(
                        Icons.flash_on_rounded,
                        color: BrandColors.warning,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
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
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.45,
      children: [
        SummaryCard(
          label: 'Avg daily',
          icon: Icons.today_outlined,
          value: Text(formatPaise(report.current.avgDailyPaise)),
        ),
        SummaryCard(
          label: 'Avg weekly',
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
