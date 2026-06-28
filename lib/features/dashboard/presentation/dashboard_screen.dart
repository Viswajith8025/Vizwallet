import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/branding/vis_wallet_logo.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/widgets/month_selector.dart';
import 'package:rupee_track/core/widgets/money_text.dart';
import 'package:rupee_track/core/widgets/summary_card.dart';
import 'package:rupee_track/features/budget/presentation/widgets/budget_overview_section.dart';
import 'package:rupee_track/features/budget_alerts/presentation/widgets/budget_alerts_panel.dart';
import 'package:rupee_track/features/dashboard/data/dashboard_repository.dart';
import 'package:rupee_track/features/safe_spend/data/safe_spend_repository.dart';
import 'package:rupee_track/features/health_score/presentation/widgets/financial_health_card.dart';
import 'package:rupee_track/features/monthly_report/presentation/widgets/monthly_report_widgets.dart';
import 'package:rupee_track/features/dashboard/presentation/widgets/dashboard_hero.dart';
import 'package:rupee_track/features/safe_spend/presentation/widgets/safe_spend_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final salaryDay = ref.watch(salaryDayProvider);
    final summaryAsync = ref.watch(monthlySummaryProvider(cycleKey));
    final safeSpendAsync = ref.watch(safeSpendProvider(cycleKey));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VisWalletLogo(size: 28),
            const SizedBox(width: 10),
            Text(
              AppConstants.appName,
              style: theme.textTheme.titleLarge,
            ),
          ],
        ),
      ),
      body: summaryAsync.when(
        loading: () => const DashboardSkeleton(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (summary) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(monthlySummaryProvider(cycleKey));
              ref.invalidate(safeSpendProvider(cycleKey));
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                0,
                AppSpacing.screenHorizontal,
                100,
              ),
              children: [
                Text(
                  formatCycleLabel(cycleKey, salaryDay: salaryDay),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                const MonthSelector(),
                const SizedBox(height: AppSpacing.lg),
                DashboardHero(summary: summary),
                const SizedBox(height: AppSpacing.md),
                if (!summary.salaryEntered)
                  PremiumCard(
                    accentColor: theme.colorScheme.primary,
                    onTap: () => context.push(AppRoutes.budgetSetup),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Set up your budget',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Allocate salary into buckets and track spending.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: theme.colorScheme.onSurfaceVariant),
                      ],
                    ),
                  ),
                if (!summary.salaryEntered) const SizedBox(height: 16),
                safeSpendAsync.when(
                  loading: () => const SkeletonCard(height: 140),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (safeSpend) => SafeSpendCard(snapshot: safeSpend),
                ),
                const SizedBox(height: 16),
                const FinancialHealthCard(compact: true),
                const SizedBox(height: 16),
                const MonthlyReportSummaryCard(),
                const SizedBox(height: 8),
                const BudgetAlertsPanel(),
                const SizedBox(height: AppSpacing.md),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.35,
                  children: [
                    SummaryCard(
                      label: 'Salary',
                      icon: Icons.payments_outlined,
                      value: MoneyText(summary.salaryPaise),
                      onTap: () => context.push(AppRoutes.salary),
                    ),
                    SummaryCard(
                      label: 'Spent',
                      icon: Icons.trending_down,
                      value: MoneyText(summary.spentPaise),
                      accentColor: theme.colorScheme.error,
                    ),
                    SummaryCard(
                      label: 'Savings',
                      icon: Icons.savings_outlined,
                      value: MoneyText(summary.savingsPaise),
                      subtitle: formatPercent(summary.savingsPercent),
                    ),
                    SummaryCard(
                      label: 'Subscriptions / mo',
                      icon: Icons.subscriptions_outlined,
                      value: MoneyText(summary.subscriptionMonthlyPaise),
                      onTap: () => context.push(AppRoutes.subscriptions),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                BudgetOverviewSection(monthKey: cycleKey),
                const SizedBox(height: 24),
                if (summary.categoryBreakdown.isNotEmpty) ...[
                  const PremiumSectionHeader(title: 'Expense breakdown'),
                  PremiumCard(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 48,
                              sections: summary.categoryBreakdown
                                  .take(6)
                                  .map(
                                    (row) => PieChartSectionData(
                                      value: row.totalPaise.toDouble(),
                                      title: '',
                                      color: Color(row.colorValue),
                                      radius: 54,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...summary.categoryBreakdown.take(5).map(
                              (row) => PremiumRowTile(
                                title: row.categoryName,
                                leading: CircleAvatar(
                                  radius: 6,
                                  backgroundColor: Color(row.colorValue),
                                ),
                                trailing: Text(
                                  formatPaise(row.totalPaise),
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
                if (summary.pendingBorrowedPaise > 0 ||
                    summary.overdueLoansCount > 0) ...[
                  const SizedBox(height: AppSpacing.md),
                  PremiumCard(
                    accentColor: summary.overdueLoansCount > 0
                        ? theme.colorScheme.error
                        : null,
                    onTap: () => context.push(AppRoutes.loans),
                    child: PremiumRowTile(
                      title: summary.overdueLoansCount > 0
                          ? '${summary.overdueLoansCount} overdue loan(s)'
                          : 'Pending borrowed money',
                      subtitle: formatPaise(summary.pendingBorrowedPaise),
                      leading: Icon(
                        Icons.handshake_outlined,
                        color: summary.overdueLoansCount > 0
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
                if (summary.upcomingSubscriptionsCount > 0) ...[
                  const SizedBox(height: AppSpacing.sm),
                  PremiumCard(
                    onTap: () => context.push(AppRoutes.subscriptions),
                    child: PremiumRowTile(
                      title:
                          '${summary.upcomingSubscriptionsCount} subscription(s) due soon',
                      leading: Icon(
                        Icons.event_outlined,
                        color: theme.colorScheme.tertiary,
                      ),
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
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
