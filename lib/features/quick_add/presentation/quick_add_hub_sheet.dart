import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/category_icon_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/expenses/data/expense_repository.dart';
import 'package:rupee_track/features/quick_add/data/quick_add_repository.dart';
import 'package:rupee_track/features/quick_add/domain/quick_add_models.dart';
import 'package:rupee_track/features/quick_add/presentation/widgets/quick_add_calculator_pad.dart';
import 'package:rupee_track/features/quick_add/presentation/widgets/quick_add_voice_input.dart';
import 'package:rupee_track/features/smart_tagging/data/tagging_repository.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/features/smart_tagging/presentation/widgets/smart_tagging_widgets.dart';

Future<void> showQuickAddSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    child: const QuickAddHubSheet(),
  );
}

class QuickAddHubSheet extends ConsumerStatefulWidget {
  const QuickAddHubSheet({super.key});

  @override
  ConsumerState<QuickAddHubSheet> createState() => _QuickAddHubSheetState();
}

class _QuickAddHubSheetState extends ConsumerState<QuickAddHubSheet> {
  String _amountDigits = '';
  String? _merchant;
  String? _note;
  bool _showCalculator = false;
  bool _saving = false;

  int get _amountPaise {
    if (_amountDigits.isEmpty) return 0;
    return int.parse(_amountDigits) * 100;
  }

  void _appendDigit(String digit) {
    if (_amountDigits.length >= 7) return;
    setState(() => _amountDigits += digit);
  }

  void _backspace() {
    if (_amountDigits.isEmpty) return;
    setState(() => _amountDigits = _amountDigits.substring(0, _amountDigits.length - 1));
  }

  void _clearAmount() => setState(() => _amountDigits = '');

  void _setAmountPaise(int paise) {
    final rupees = (paise / 100).round();
    setState(() => _amountDigits = rupees > 0 ? '$rupees' : '');
  }

  Future<void> _saveExpense(CategoriesTableData category) async {
    if (_amountPaise <= 0 || _saving) return;
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();

    final repo = ref.read(quickAddRepositoryProvider);
    final title = repo.titleForCategory(
      category.name,
      merchant: _merchant,
    );

    try {
      await repo.quickSaveExpense(
        amountPaise: _amountPaise,
        categoryId: category.id,
        title: title,
        notes: _note,
      );
      ref.invalidate(quickAddContextProvider);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('${formatPaise(_amountPaise)} · $title'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _repeat(RepeatExpenseTemplate template) async {
    if (_saving) return;
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();
    try {
      await ref.read(quickAddRepositoryProvider).repeatExpense(template);
      ref.invalidate(quickAddContextProvider);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Repeated ${formatPaise(template.amountPaise)} · ${template.title}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _handleAction(QuickAddAction action) {
    switch (action) {
      case QuickAddAction.expense:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pick amount and category above'),
            duration: Duration(seconds: 1),
          ),
        );
        return;
      case QuickAddAction.borrow:
        Navigator.pop(context);
        context.push(AppRoutes.loans);
      case QuickAddAction.receive:
        Navigator.pop(context);
        context.push(AppRoutes.loans);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Log received money as a loan repayment'),
          ),
        );
      case QuickAddAction.subscription:
        Navigator.pop(context);
        context.push(AppRoutes.subscriptions);
      case QuickAddAction.income:
        Navigator.pop(context);
        context.push(AppRoutes.salary);
      case QuickAddAction.transfer:
        return;
    }
  }

  void _showSupport() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quick Add tips'),
        content: const Text(
          'Fastest path: tap an amount, then a category — saved instantly.\n\n'
          '• Long-press a category to favorite it\n'
          '• Tap a repeat chip for one-tap logging\n'
          '• Use the mic for hands-free entry\n'
          '• Merchants & notes are optional shortcuts',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  List<CategoriesTableData> _orderedCategories(
    List<CategoriesTableData> all,
    QuickAddContext ctx, {
    int? suggestedCategoryId,
  }) {
    final byId = {for (final c in all) c.id: c};
    final ordered = <CategoriesTableData>[];
    final seen = <int>{};

    if (suggestedCategoryId != null) {
      final cat = byId[suggestedCategoryId];
      if (cat != null && seen.add(suggestedCategoryId)) ordered.add(cat);
    }

    for (final id in ctx.favoriteCategoryIds) {
      final cat = byId[id];
      if (cat != null && seen.add(id)) ordered.add(cat);
    }
    for (final id in ctx.recentCategoryIds) {
      final cat = byId[id];
      if (cat != null && seen.add(id)) ordered.add(cat);
    }
    for (final cat in all) {
      if (seen.add(cat.id)) ordered.add(cat);
    }
    return ordered;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contextAsync = ref.watch(quickAddContextProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Quick Add',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Full form',
                      icon: const Icon(Icons.open_in_full, size: 20),
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(AppRoutes.expenseAdd);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _AmountHeader(
                  amountDigits: _amountDigits,
                  merchant: _merchant,
                  onToggleCalculator: () =>
                      setState(() => _showCalculator = !_showCalculator),
                  showCalculator: _showCalculator,
                ),
                const SizedBox(height: 12),
                contextAsync.when(
                  loading: () => const SizedBox(
                    height: 36,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (ctx) => _AmountSuggestions(
                    suggestions: ctx.amountSuggestionsPaise,
                    selectedPaise: _amountPaise,
                    onTap: _setAmountPaise,
                  ),
                ),
                if (_showCalculator) ...[
                  const SizedBox(height: 12),
                  QuickAddCalculatorPad(
                    onDigit: _appendDigit,
                    onBackspace: _backspace,
                    onClear: _clearAmount,
                  ),
                ],
                const SizedBox(height: 16),
                contextAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (ctx) {
                    if (ctx.repeatTemplates.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('One-tap repeat'),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: ctx.repeatTemplates.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, i) {
                              final t = ctx.repeatTemplates[i];
                              return ActionChip(
                                avatar: CircleAvatar(
                                  radius: 10,
                                  backgroundColor:
                                      Color(t.colorValue).withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.replay,
                                    size: 12,
                                    color: Color(t.colorValue),
                                  ),
                                ),
                                label: Text(
                                  '${t.title} · ${formatPaise(t.amountPaise)}',
                                ),
                                onPressed: _saving ? null : () => _repeat(t),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                contextAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (ctx) {
                    if (ctx.recentMerchants.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('Recent merchants'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ctx.recentMerchants.map((m) {
                            final selected = _merchant == m;
                            return FilterChip(
                              label: Text(m),
                              selected: selected,
                              onSelected: (_) => setState(
                                () => _merchant = selected ? null : m,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                if (_merchant != null && _merchant!.trim().isNotEmpty) ...[
                  ClassificationSuggestionBanner(title: _merchant!),
                  const SizedBox(height: 12),
                ],
                categoriesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                  data: (categories) {
                    final ctx = contextAsync.valueOrNull;
                    final classifyTitle = _merchant?.trim() ?? '';
                    final classificationAsync = classifyTitle.isNotEmpty
                        ? ref.watch(
                            transactionClassificationProvider(classifyTitle),
                          )
                        : null;
                    final suggestedId =
                        classificationAsync?.valueOrNull?.categoryId;

                    final ordered = ctx != null
                        ? _orderedCategories(
                            categories,
                            ctx,
                            suggestedCategoryId: suggestedId,
                          )
                        : categories;

                    final favorites = ctx?.favoriteCategoryIds.toSet() ?? {};

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('Categories · tap to save'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: ordered.map((cat) {
                            final isFavorite = favorites.contains(cat.id);
                            final isSuggested = suggestedId == cat.id;
                            final canSave = _amountPaise > 0 && !_saving;
                            return _CategoryTile(
                              category: cat,
                              isFavorite: isFavorite,
                              isSuggested: isSuggested,
                              enabled: canSave || _amountPaise > 0,
                              onTap: canSave
                                  ? () => _saveExpense(cat)
                                  : () {
                                      HapticFeedback.lightImpact();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Enter an amount first'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                              onLongPress: () async {
                                await ref
                                    .read(quickAddStoreProvider)
                                    .toggleFavorite(cat.id);
                                ref.invalidate(quickAddContextProvider);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isFavorite
                                          ? 'Removed ${cat.name} from favorites'
                                          : 'Favorited ${cat.name}',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                contextAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (ctx) {
                    if (ctx.recentNotes.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel('Recent notes'),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ctx.recentNotes.map((n) {
                            final selected = _note == n;
                            return FilterChip(
                              label: Text(n),
                              selected: selected,
                              onSelected: (_) =>
                                  setState(() => _note = selected ? null : n),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    QuickAddVoiceButton(
                      onResult: (amountPaise, merchant) {
                        setState(() {
                          if (amountPaise > 0) {
                            _amountDigits = '${(amountPaise / 100).round()}';
                          }
                          if (merchant != null && merchant.isNotEmpty) {
                            _merchant = merchant;
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: _showSupport,
                      icon: const Icon(Icons.help_outline, size: 18),
                      label: const Text('Support'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _SectionLabel('More actions'),
                const SizedBox(height: 10),
                _ActionGrid(onAction: _handleAction),
        ],
      ),
    );
  }
}

class _AmountHeader extends StatelessWidget {
  const _AmountHeader({
    required this.amountDigits,
    required this.merchant,
    required this.onToggleCalculator,
    required this.showCalculator,
  });

  final String amountDigits;
  final String? merchant;
  final VoidCallback onToggleCalculator;
  final bool showCalculator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final paise = amountDigits.isEmpty ? 0 : int.parse(amountDigits) * 100;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatPaise(paise),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              if (merchant != null)
                Text(
                  merchant!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: showCalculator ? 'Hide calculator' : 'Calculator',
          onPressed: onToggleCalculator,
          icon: Icon(showCalculator ? Icons.keyboard_hide : Icons.calculate),
        ),
      ],
    );
  }
}

class _AmountSuggestions extends StatelessWidget {
  const _AmountSuggestions({
    required this.suggestions,
    required this.selectedPaise,
    required this.onTap,
  });

  final List<int> suggestions;
  final int selectedPaise;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final paise = suggestions[i];
          final selected = paise == selectedPaise;
          return ChoiceChip(
            label: Text(formatPaise(paise)),
            selected: selected,
            onSelected: (_) {
              HapticFeedback.selectionClick();
              onTap(paise);
            },
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isFavorite,
    required this.isSuggested,
    required this.enabled,
    required this.onTap,
    required this.onLongPress,
  });

  final CategoriesTableData category;
  final bool isFavorite;
  final bool isSuggested;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);
    return Material(
      color: color.withValues(alpha: enabled ? 0.14 : 0.06),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          width: 96,
          height: 88,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      categoryIconFromName(category.iconName),
                      color: color,
                      size: 26,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              if (isFavorite)
                const Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(Icons.star, size: 14, color: Colors.amber),
                ),
              if (isSuggested)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.onAction});

  final ValueChanged<QuickAddAction> onAction;

  @override
  Widget build(BuildContext context) {
    final actions = <(QuickAddAction, IconData, String)>[
      (QuickAddAction.expense, Icons.remove_circle_outline, 'Expense'),
      (QuickAddAction.borrow, Icons.arrow_downward, 'Borrow'),
      (QuickAddAction.receive, Icons.arrow_upward, 'Receive'),
      (QuickAddAction.subscription, Icons.subscriptions_outlined, 'Subscription'),
      (QuickAddAction.income, Icons.payments_outlined, 'Income'),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.35,
      children: actions.map((a) {
        return Material(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onAction(a.$1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(a.$2, size: 22),
                const SizedBox(height: 6),
                Text(
                  a.$3,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
