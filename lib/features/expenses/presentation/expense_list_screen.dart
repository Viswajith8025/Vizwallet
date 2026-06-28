import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/premium_chip.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/design_system/shell_bottom_inset.dart';
import 'package:rupee_track/core/providers/settings_provider.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/widgets/empty_state.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/expenses/data/expense_repository.dart';
import 'package:rupee_track/features/expenses/domain/expense_date_filter.dart';
import 'package:rupee_track/features/expenses/domain/expense_display_utils.dart';
import 'package:rupee_track/features/quick_add/presentation/quick_add_hub_sheet.dart';
import 'package:rupee_track/features/smart_tagging/domain/classification_models.dart';
import 'package:rupee_track/features/smart_tagging/presentation/expense_correction_sheet.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(expenseDateFilterProvider);
    final settings = ref.watch(appSettingsProvider).valueOrNull;
    final expensesAsync = ref.watch(expensesForDateFilterProvider);
    final dateFormat = DateFormat('d MMM · h:mm a');
    final today = toIst(DateTime.now());
    final headerDate = DateFormat('EEEE, d MMM yyyy').format(today);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Expenses',
        subtitle: headerDate,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => showQuickAddSheet(context, ref),
            tooltip: 'Add expense',
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                PremiumFilterChip(
                  label: 'Today',
                  selected: filter.mode == ExpenseDateFilterMode.today,
                  onSelected: (_) =>
                      ref.read(expenseDateFilterProvider.notifier).setToday(),
                ),
                PremiumFilterChip(
                  label: 'Pick date',
                  selected: filter.mode == ExpenseDateFilterMode.pickDate,
                  onSelected: (_) => _pickDate(context, ref, filter),
                ),
                PremiumFilterChip(
                  label: 'Pay cycle',
                  selected: filter.mode == ExpenseDateFilterMode.payCycle,
                  onSelected: (_) => ref
                      .read(expenseDateFilterProvider.notifier)
                      .setPayCycle(),
                ),
              ],
            ),
          ),
          Expanded(
            child: expensesAsync.when(
              loading: () => ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  ShellBottomInset.scrollBottom(context),
                ),
                itemCount: 8,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.xs),
                itemBuilder: (_, __) => const SkeletonCard(height: 80),
              ),
              error: (e, _) => ErrorState(
                message: 'We couldn\'t load your expenses.',
                onRetry: () => ref.invalidate(expensesForDateFilterProvider),
              ),
              data: (expenses) {
                if (expenses.isEmpty) {
                  return EmptyStates.expenses(
                    onAdd: () => showQuickAddSheet(context, ref),
                  );
                }

                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    ShellBottomInset.scrollBottom(context),
                  ),
                  itemCount: expenses.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final item = expenses[index];
                    final expense = item.expense;
                    final tags = parseTagsJson(expense.tags);
                    final amountLabels = settings == null
                        ? <String>[]
                        : expenseAmountLabels(
                            settings: settings,
                            amountPaise: expense.amountPaise,
                          );
                    final displayTags = expenseDisplayTags(
                      title: expense.title,
                      categoryName: item.category.name,
                      amountLabels: amountLabels,
                      classificationTags: tags,
                    );
                    final subtitle = expenseDisplaySubtitle(
                      categoryName: item.category.name,
                      title: expense.title,
                      meta:
                          '${expense.paymentMethod} · ${dateFormat.format(expense.occurredAt.toLocal())}',
                    );

                    return Dismissible(
                      key: ValueKey(expense.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                        ),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Delete expense?'),
                                content: const Text(
                                  'This will remove the transaction from your records.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text('Cancel'),
                                  ),
                                  FilledButton(
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ) ??
                            false;
                      },
                      onDismissed: (_) async {
                        final repo = ref.read(expenseRepositoryProvider);
                        final activityId =
                            await repo.deleteExpense(expense.id);
                        if (!context.mounted) return;
                        if (activityId != null) {
                          showPremiumSnackBar(
                            context,
                            message: 'Expense deleted',
                            actionLabel: 'Undo',
                            onAction: () =>
                                repo.undoExpenseActivity(activityId),
                          );
                        }
                      },
                      child: PremiumExpenseTile(
                        title: expense.title,
                        amountPaise: expense.amountPaise,
                        categoryName: item.category.name,
                        categoryColor: item.category.colorValue,
                        subtitle: subtitle,
                        tags: displayTags,
                        onTap: () =>
                            showExpenseCorrectionSheet(context, ref, item),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    WidgetRef ref,
    ExpenseDateFilter filter,
  ) async {
    final initial = filter.pickedDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      ref.read(expenseDateFilterProvider.notifier).setPickedDate(picked);
    }
  }
}
