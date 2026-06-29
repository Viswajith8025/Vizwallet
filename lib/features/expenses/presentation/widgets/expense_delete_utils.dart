import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/features/expenses/data/expense_repository.dart';

Future<bool> confirmDeleteExpense(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Delete expense?'),
      content: const Text(
        'This removes the transaction from your records. You can restore it from the recycle bin.',
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
  );
  return result ?? false;
}

Future<void> deleteExpenseWithFeedback(
  BuildContext context,
  WidgetRef ref,
  int expenseId, {
  bool popSheetFirst = false,
}) async {
  final confirmed = await confirmDeleteExpense(context);
  if (!confirmed || !context.mounted) return;

  final repo = ref.read(expenseRepositoryProvider);
  final activityId = await repo.deleteExpense(expenseId);
  if (!context.mounted) return;

  if (popSheetFirst) {
    Navigator.pop(context);
  }

  if (activityId != null) {
    showPremiumSnackBar(
      context,
      message: 'Expense deleted',
      actionLabel: 'Undo',
      onAction: () => repo.undoExpenseActivity(activityId),
    );
  }
}
