import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/empty_state.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/core/widgets/theme_toggle_button.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';
import 'package:rupee_track/features/budget/presentation/widgets/budget_bucket_card.dart';

class BudgetPlannerScreen extends ConsumerWidget {
  const BudgetPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final salaryDay = ref.watch(salaryDayProvider);
    final planAsync = ref.watch(budgetPlanStatusProvider(cycleKey));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Category budgets',
            onPressed: () => context.push(AppRoutes.categoryBudget),
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Edit plan',
            onPressed: () => context.push(AppRoutes.budgetSetup),
          ),
          const ThemeToggleButton(),
        ],
      ),
      body: planAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: 'We couldn\'t load your budget plan.',
          onRetry: () => ref.invalidate(budgetPlanStatusProvider(cycleKey)),
        ),
        data: (plan) {
          if (plan == null) {
            return EmptyState(
              title: 'No budget plan yet',
              message:
                  'Add your salary, then set a monthly limit for each category like Food, Travel, and Bills.',
              icon: Icons.pie_chart_outline,
              action: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.categoryBudget),
                    icon: const Icon(Icons.category_outlined),
                    label: const Text('Set category budgets'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () => context.push(AppRoutes.budgetSetup),
                    icon: const Icon(Icons.tune),
                    label: const Text('Use budget wizard'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(budgetPlanStatusProvider(cycleKey));
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatCycleLabel(cycleKey, salaryDay: salaryDay),
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Salary ${formatPaise(plan.salaryPaise)} · ${plan.allocationMode.label}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (plan.rolloverEnabled)
                          Text(
                            'Leftover money carries forward',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (plan.insights.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Things to notice', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...plan.insights.map(
                    (insight) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          _insightIcon(insight.severity),
                          color: _insightColor(context, insight.severity),
                        ),
                        title: Text(insight.title),
                        subtitle: Text(insight.message),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  plan.allocationMode == AllocationMode.perCategory
                      ? 'Category budgets'
                      : 'Spending groups',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...plan.buckets.map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: BudgetBucketCard(bucket: b),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _insightIcon(BudgetAlertLevel level) => switch (level) {
        BudgetAlertLevel.exceeded => Icons.error_outline,
        BudgetAlertLevel.critical90 => Icons.warning_amber_outlined,
        BudgetAlertLevel.watch75 => Icons.info_outline,
        _ => Icons.check_circle_outline,
      };

  Color _insightColor(BuildContext context, BudgetAlertLevel level) {
    final scheme = Theme.of(context).colorScheme;
    return switch (level) {
      BudgetAlertLevel.exceeded => scheme.error,
      BudgetAlertLevel.critical90 => const Color(0xFFF97316),
      BudgetAlertLevel.watch75 => scheme.tertiary,
      _ => scheme.primary,
    };
  }
}
