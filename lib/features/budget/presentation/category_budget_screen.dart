import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/core/widgets/theme_toggle_button.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/dashboard/data/dashboard_repository.dart';
import 'package:rupee_track/features/expenses/data/expense_repository.dart';

class CategoryBudgetScreen extends HookConsumerWidget {
  const CategoryBudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final salaryDay = ref.watch(salaryDayProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final planAsync = ref.watch(budgetPlanStatusProvider(cycleKey));
    final salaryController = useTextEditingController();
    final amountControllers = useRef<Map<int, TextEditingController>>({});
    final rollover = useState(true);
    final isSaving = useState(false);
    final isReady = useState(false);
    final refreshTick = useState(0);
    final theme = Theme.of(context);

    useEffect(() {
      return () {
        for (final controller in amountControllers.value.values) {
          controller.dispose();
        }
      };
    }, const []);

    Future<void> bootstrap(
      List<CategoriesTableData> categories,
      int? salaryPaise,
      Map<int, int> seedAmounts,
    ) async {
      if (isReady.value) return;

      if (salaryPaise != null && salaryPaise > 0) {
        salaryController.text = paiseToRupees(salaryPaise).round().toString();
      } else {
        final dao = await ref.read(salaryDaoProvider.future);
        final salary =
            await dao.getTotalCycleInflowPaise(cycleKey);
        if (salary > 0) {
          salaryController.text =
              paiseToRupees(salary).round().toString();
        }
      }

      var amounts = Map<int, int>.from(seedAmounts);
      if (amounts.isEmpty) {
        final salary = rupeesToPaise(salaryController.text);
        final lines =
            await ref.read(budgetRepositoryProvider).buildCategoryAllocations(
                  monthKey: cycleKey,
                  salaryPaise: salary > 0 ? salary : 1,
                );
        amounts = {
          for (final line in lines)
            if (line.categoryId != null) line.categoryId!: line.allocatedPaise,
        };
      }

      for (final category in categories) {
        if (amountControllers.value.containsKey(category.id)) continue;
        amountControllers.value[category.id] = TextEditingController(
          text: _initialAmountText(amounts[category.id]),
        );
      }

      isReady.value = true;
    }

    void bump() => refreshTick.value++;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category budgets'),
        actions: const [ThemeToggleButton()],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: 'We couldn\'t load your categories.',
          onRetry: () => ref.invalidate(categoriesProvider),
        ),
        data: (categories) {
          final plan = planAsync.valueOrNull;
          final seedAmounts = <int, int>{
            for (final bucket in plan?.buckets ?? [])
              if (bucket.categoryId != null)
                bucket.categoryId!: bucket.allocatedPaise,
          };

          if (!isReady.value) {
            bootstrap(categories, plan?.salaryPaise, seedAmounts);
          }

          if (!isReady.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Trigger rebuild when salary/category amounts change.
          // ignore: unused_local_variable
          final _ = refreshTick.value;

          final salaryPaise = rupeesToPaise(salaryController.text);
          final allocatedPaise = categories.fold<int>(0, (sum, category) {
            final text = amountControllers.value[category.id]?.text ?? '';
            return sum + rupeesToPaise(text);
          });

          return ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,
              AppSpacing.xl,
            ),
            children: [
              Text(
                formatCycleLabel(cycleKey, salaryDay: salaryDay),
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Set how much you want to spend in each category this month. '
                'Expenses will count against the matching category.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: salaryController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Monthly salary',
                  prefixText: '₹ ',
                ),
                onChanged: (_) => bump(),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Carry forward money left over'),
                subtitle: const Text(
                  'Add unused category budget to next month.',
                ),
                value: rollover.value,
                onChanged: (value) => rollover.value = value,
              ),
              const SizedBox(height: 8),
              Text(
                'Categories',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ...categories.map((category) {
                final controller = amountControllers.value[category.id];
                if (controller == null) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(category.colorValue)
                                .withValues(alpha: 0.18),
                            child: Icon(
                              Icons.circle,
                              size: 12,
                              color: Color(category.colorValue),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              category.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                prefixText: '₹',
                                isDense: true,
                              ),
                              onChanged: (_) => bump(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total planned', style: theme.textTheme.titleSmall),
                  Text(
                    '${formatPaise(allocatedPaise)} / ${formatPaise(salaryPaise)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: allocatedPaise > salaryPaise && salaryPaise > 0
                          ? theme.colorScheme.error
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: isSaving.value
                    ? null
                    : () async {
                        final salary = rupeesToPaise(salaryController.text);
                        if (salary <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Enter a valid salary first.'),
                            ),
                          );
                          return;
                        }

                        final amounts = <int, int>{};
                        for (final category in categories) {
                          final controller =
                              amountControllers.value[category.id];
                          if (controller == null) continue;
                          final amount = rupeesToPaise(controller.text);
                          if (amount > 0) {
                            amounts[category.id] = amount;
                          }
                        }

                        if (amounts.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Add a budget for at least one category.',
                              ),
                            ),
                          );
                          return;
                        }

                        if (amounts.values.fold<int>(0, (a, b) => a + b) >
                            salary) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Category budgets cannot be more than your salary.',
                              ),
                            ),
                          );
                          return;
                        }

                        isSaving.value = true;
                        try {
                          await ref
                              .read(budgetRepositoryProvider)
                              .saveCategoryBudgets(
                                monthKey: cycleKey,
                                salaryPaise: salary,
                                amountByCategoryId: amounts,
                                rolloverEnabled: rollover.value,
                              );
                          ref.invalidate(budgetPlanStatusProvider(cycleKey));
                          ref.invalidate(monthlySummaryProvider(cycleKey));
                          if (context.mounted) {
                            context.go(AppRoutes.budget);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Category budgets saved'),
                              ),
                            );
                          }
                        } finally {
                          isSaving.value = false;
                        }
                      },
                child: Text(
                  isSaving.value ? 'Saving...' : 'Save category budgets',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static String _initialAmountText(int? paise) {
    if (paise == null || paise <= 0) return '';
    return paiseToRupees(paise).round().toString();
  }
}
