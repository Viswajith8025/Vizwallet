import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/providers/month_provider.dart';
import 'package:rupee_track/core/widgets/empty_state.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/expenses/data/expense_repository.dart';
import 'package:rupee_track/features/quick_add/presentation/quick_add_hub_sheet.dart';
import 'package:rupee_track/features/smart_tagging/domain/classification_models.dart';
import 'package:rupee_track/features/smart_tagging/presentation/expense_correction_sheet.dart';

class ExpenseListScreen extends ConsumerWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthKey = ref.watch(selectedMonthKeyProvider);
    final expensesAsync = ref.watch(expensesForMonthProvider(monthKey));
    final dateFormat = DateFormat('d MMM · h:mm a');

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Expenses',
        subtitle: monthKey,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => showQuickAddSheet(context, ref),
            tooltip: 'Add expense',
          ),
        ],
      ),
      body: expensesAsync.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.lg,
          ),
          itemCount: 8,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
          itemBuilder: (_, __) => const SkeletonCard(height: 80),
        ),
        error: (e, _) => ErrorState(
          message: 'We couldn\'t load your expenses.',
          onRetry: () => ref.invalidate(expensesForMonthProvider(monthKey)),
        ),
        data: (expenses) {
          if (expenses.isEmpty) {
            return EmptyStates.expenses(
              onAdd: () => showQuickAddSheet(context, ref),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            itemCount: expenses.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
            itemBuilder: (context, index) {
              final item = expenses[index];
              final expense = item.expense;
              final labels = (jsonDecode(expense.autoLabels) as List)
                  .cast<String>();
              final tags = parseTagsJson(expense.tags);
              final allTags = [...labels, ...tags];

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
                  final activityId = await repo.deleteExpense(expense.id);
                  if (!context.mounted) return;
                  showPremiumSnackBar(
                    context,
                    message: 'Expense deleted',
                    actionLabel: activityId != null ? 'Undo' : null,
                    onAction: activityId != null
                        ? () async {
                            await repo.undoExpenseActivity(activityId);
                          }
                        : null,
                  );
                },
                child: PremiumExpenseTile(
                  title: expense.title,
                  amountPaise: expense.amountPaise,
                  categoryName: item.category.name,
                  categoryColor: item.category.colorValue,
                  meta: '${expense.paymentMethod} · ${dateFormat.format(expense.occurredAt.toLocal())}',
                  tags: allTags,
                  onTap: () => showExpenseCorrectionSheet(context, ref, item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
