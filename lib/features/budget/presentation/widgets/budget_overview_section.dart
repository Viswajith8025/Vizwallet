import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/budget/presentation/widgets/budget_progress_bar.dart';

class BudgetOverviewSection extends ConsumerWidget {
  const BudgetOverviewSection({required this.monthKey, super.key});

  final String monthKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(budgetPlanStatusProvider(monthKey));
    final theme = Theme.of(context);

    return planAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (plan) {
        if (plan == null) return const SizedBox.shrink();

        final alerts = plan.alertBuckets;
        final topSpending = [...plan.spendingBuckets]
          ..sort((a, b) => b.percentUsed.compareTo(a.percentUsed));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Budget plan', style: theme.textTheme.titleLarge),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push(AppRoutes.budget),
                  child: const Text('View all'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (alerts.isNotEmpty)
              Card(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.35),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications_active_outlined,
                    color: theme.colorScheme.error,
                  ),
                  title: Text('${alerts.length} budget alert(s)'),
                  subtitle: Text(alerts.first.displayName),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.budget),
                ),
              ),
            if (alerts.isNotEmpty) const SizedBox(height: 12),
            ...topSpending.take(3).map(
                  (b) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(b.displayName)),
                            Text(
                              '${b.percentUsed.toStringAsFixed(0)}%',
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        BudgetProgressBar(
                          percentUsed: b.percentUsed,
                          alertLevel: b.alertLevel,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formatPaise(b.remainingPaise)} left · ${formatPaise(b.dailyAllowancePaise)}/day',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}
