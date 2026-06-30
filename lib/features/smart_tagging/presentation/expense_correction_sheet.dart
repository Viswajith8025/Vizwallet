import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/daos/expenses_dao.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/shell_bottom_inset.dart';
import 'package:rupee_track/features/expenses/data/expense_repository.dart';
import 'package:rupee_track/features/expenses/domain/expense_classification_helper.dart';
import 'package:rupee_track/features/expenses/presentation/widgets/expense_delete_utils.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/features/smart_tagging/domain/classification_models.dart';

Future<void> showExpenseCorrectionSheet(
  BuildContext context,
  WidgetRef ref,
  ExpenseWithCategory item,
) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.75,
    minSize: 0.4,
    child: ExpenseCorrectionSheet(item: item),
  );
}

class ExpenseCorrectionSheet extends ConsumerStatefulWidget {
  const ExpenseCorrectionSheet({required this.item, super.key});

  final ExpenseWithCategory item;

  @override
  ConsumerState<ExpenseCorrectionSheet> createState() =>
      _ExpenseCorrectionSheetState();
}

class _ExpenseCorrectionSheetState extends ConsumerState<ExpenseCorrectionSheet> {
  late int _categoryId;
  late TextEditingController _titleController;
  final _merchantKey = GlobalKey();
  final _merchantFocus = FocusNode();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.item.expense.categoryId;
    _titleController = TextEditingController(text: widget.item.expense.title);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _merchantFocus.dispose();
    super.dispose();
  }

  void _onCategorySelected(int categoryId) {
    setState(() => _categoryId = categoryId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final target = _merchantKey.currentContext;
      if (target != null) {
        Scrollable.ensureVisible(
          target,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          alignment: 0.12,
        );
      }
      _merchantFocus.requestFocus();
    });
  }

  Future<void> _save(List<CategoriesTableData> categories) async {
    final category = categories.firstWhere((c) => c.id == _categoryId);
    final cleanedTags = parseTagsJson(widget.item.expense.tags)
        .where((t) => !tagRedundantWithCategory(t, category.name))
        .toList();

    setState(() => _saving = true);
    try {
      await ref.read(expenseRepositoryProvider).updateExpenseClassification(
            expenseId: widget.item.expense.id,
            categoryId: _categoryId,
            title: _titleController.text.trim(),
            tags: cleanedTags,
            notes: widget.item.expense.notes,
            monthKey: widget.item.expense.monthKey,
          );
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saved — future similar expenses will use this'),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Padding(
        padding: AppResponsive.screenPadding(context),
        child: Text(
          'Could not load categories. Please try again.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      ),
      data: (categories) {
        return ListView(
          padding: AppResponsive.screenPadding(
            context,
            bottom: ShellBottomInset.scrollBottom(context) + AppSpacing.lg,
          ),
          children: [
            Text(
              'Fix category',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xxs),
            Text(
              'Viswallet will remember this for similar expenses',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Category', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: categories.map((cat) {
                final selected = _categoryId == cat.id;
                return FilterChip(
                  label: Text(cat.name),
                  selected: selected,
                  onSelected: (_) => _onCategorySelected(cat.id),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            KeyedSubtree(
              key: _merchantKey,
              child: TextField(
                controller: _titleController,
                focusNode: _merchantFocus,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Merchant / title',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _saving ? null : () => _save(categories),
              child: Text(_saving ? 'Saving…' : 'Save & remember'),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextButton.icon(
              onPressed: _saving
                  ? null
                  : () => deleteExpenseWithFeedback(
                        context,
                        ref,
                        widget.item.expense.id,
                        popSheetFirst: true,
                      ),
              icon: Icon(
                Icons.delete_outline_rounded,
                color: theme.colorScheme.error,
              ),
              label: Text(
                'Delete expense',
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
