import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rupee_track/core/constants/category_defaults.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/core/widgets/theme_toggle_button.dart';
import 'package:rupee_track/features/expenses/data/expense_repository.dart';
import 'package:rupee_track/features/smart_tagging/data/tagging_repository.dart';
import 'package:rupee_track/features/smart_tagging/domain/default_tagging_rules.dart';
import 'package:rupee_track/features/smart_tagging/presentation/widgets/smart_tagging_widgets.dart';

class QuickAddExpenseScreen extends HookConsumerWidget {
  const QuickAddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountController = useTextEditingController();
    final titleController = useTextEditingController();
    final selectedCategoryId = useState<int?>(null);
    final paymentMethod = useState(paymentMethods.first);
    final isSaving = useState(false);
    final showDetails = useState(false);
    final selectedTags = useState<Set<String>>({});

    final categoriesAsync = ref.watch(categoriesProvider);
    useListenable(titleController);
    final title = titleController.text.trim();
    final classificationAsync = title.isNotEmpty
        ? ref.watch(transactionClassificationProvider(title))
        : null;

    useEffect(() {
      final c = classificationAsync?.valueOrNull;
      if (c != null && c.tags.isNotEmpty && selectedTags.value.isEmpty) {
        selectedTags.value = c.tags.toSet();
      }
      if (c?.categoryId != null && selectedCategoryId.value == null) {
        selectedCategoryId.value = c!.categoryId;
      }
      return null;
    }, [classificationAsync?.valueOrNull?.categoryId, title]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add expense'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: const [ThemeToggleButton()],
      ),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: 'We couldn\'t load your categories.',
          onRetry: () => ref.invalidate(categoriesProvider),
        ),
        data: (categories) {
          selectedCategoryId.value ??=
              categories.isNotEmpty ? categories.first.id : null;

          return ResponsiveBody(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              children: [
              TextField(
                controller: amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                autofocus: true,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                decoration: const InputDecoration(
                  prefixText: '₹ ',
                  hintText: '0',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Spotify, Lunch, Petrol...',
                ),
              ),
              const SizedBox(height: 8),
              ClassificationSuggestionBanner(title: title),
              const SizedBox(height: 16),
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: categories.map((cat) {
                  final selected = selectedCategoryId.value == cat.id;
                  return FilterChip(
                    label: Text(cat.name),
                    selected: selected,
                    onSelected: (_) => selectedCategoryId.value = cat.id,
                    showCheckmark: false,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('Tags', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: suggestedSpendingTags.map((tag) {
                  final selected = selectedTags.value.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: selected,
                    onSelected: (_) {
                      final next = {...selectedTags.value};
                      if (selected) {
                        next.remove(tag);
                      } else {
                        next.add(tag);
                      }
                      selectedTags.value = next;
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('More details'),
                initiallyExpanded: showDetails.value,
                onExpansionChanged: (v) => showDetails.value = v,
                children: [
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: paymentMethod.value,
                    decoration: const InputDecoration(labelText: 'Payment method'),
                    items: paymentMethods
                        .map(
                          (m) => DropdownMenuItem(value: m, child: Text(m)),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) paymentMethod.value = v;
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: isSaving.value
                    ? null
                    : () async {
                        final amount = rupeesToPaise(amountController.text);
                        final title = titleController.text.trim();
                        final categoryId = selectedCategoryId.value;

                        if (amount <= 0) {
                          _showError(context, 'Enter a valid amount');
                          return;
                        }
                        if (title.isEmpty) {
                          _showError(context, 'Enter a title');
                          return;
                        }
                        if (categoryId == null) {
                          _showError(context, 'Select a category');
                          return;
                        }

                        isSaving.value = true;
                        try {
                          final result =
                              await ref.read(expenseRepositoryProvider).addExpense(
                                    amountPaise: amount,
                                    categoryId: categoryId,
                                    title: title,
                                    paymentMethod: paymentMethod.value,
                                    tags: selectedTags.value.toList(),
                                  );
                          if (context.mounted) {
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Saved · ${result.snackbarLine}',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            _showError(context, e.toString());
                          }
                        } finally {
                          isSaving.value = false;
                        }
                      },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(isSaving.value ? 'Saving...' : 'Save expense'),
                ),
              ),
            ],
            ),
          );
        },
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
