import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/daos/expenses_dao.dart';
import 'package:rupee_track/features/expenses/data/expense_repository.dart';
import 'package:rupee_track/features/smart_tagging/domain/classification_models.dart';
import 'package:rupee_track/features/smart_tagging/domain/default_tagging_rules.dart';

Future<void> showExpenseCorrectionSheet(
  BuildContext context,
  WidgetRef ref,
  ExpenseWithCategory item,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => ExpenseCorrectionSheet(item: item),
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
  late Set<String> _selectedTags;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.item.expense.categoryId;
    _titleController = TextEditingController(text: widget.item.expense.title);
    _selectedTags = parseTagsJson(widget.item.expense.tags).toSet();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(expenseRepositoryProvider).updateExpenseClassification(
            expenseId: widget.item.expense.id,
            categoryId: _categoryId,
            title: _titleController.text.trim(),
            tags: _selectedTags.toList(),
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
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 20 + bottom),
      child: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
        data: (categories) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Correct classification',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'We\'ll remember this for similar merchants',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Merchant / title',
                ),
              ),
              const SizedBox(height: 16),
              Text('Category', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final selected = _categoryId == cat.id;
                  return FilterChip(
                    label: Text(cat.name),
                    selected: selected,
                    onSelected: (_) => setState(() => _categoryId = cat.id),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Tags', style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: suggestedSpendingTags.map((tag) {
                  final selected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        if (selected) {
                          _selectedTags.remove(tag);
                        } else {
                          _selectedTags.add(tag);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: Text(_saving ? 'Saving…' : 'Save & remember'),
              ),
            ],
          );
        },
      ),
    );
  }
}
