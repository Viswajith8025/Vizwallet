import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/features/expenses/data/expense_repository.dart';
import 'package:rupee_track/features/financial_calendar/data/financial_calendar_repository.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';

Future<void> showCalendarFiltersSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.88,
    child: const _CalendarFiltersSheet(),
  );
}

class _CalendarFiltersSheet extends ConsumerStatefulWidget {
  const _CalendarFiltersSheet();

  @override
  ConsumerState<_CalendarFiltersSheet> createState() =>
      _CalendarFiltersSheetState();
}

class _CalendarFiltersSheetState extends ConsumerState<_CalendarFiltersSheet> {
  late CalendarFilters _draft;
  final _merchantController = TextEditingController();
  final _tagController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _draft = ref.read(calendarFiltersProvider);
    _merchantController.text = _draft.merchantQuery ?? '';
    _tagController.text = _draft.tagQuery ?? '';
    if (_draft.minAmountPaise != null) {
      _minController.text = '${_draft.minAmountPaise! / 100}';
    }
    if (_draft.maxAmountPaise != null) {
      _maxController.text = '${_draft.maxAmountPaise! / 100}';
    }
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _tagController.dispose();
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _apply() {
    final min = double.tryParse(_minController.text.trim());
    final max = double.tryParse(_maxController.text.trim());
    ref.read(calendarFiltersProvider.notifier).state = _draft.copyWith(
          merchantQuery: _merchantController.text.trim(),
          tagQuery: _tagController.text.trim(),
          minAmountPaise: min != null ? (min * 100).round() : null,
          clearMinAmount: min == null,
          maxAmountPaise: max != null ? (max * 100).round() : null,
          clearMaxAmount: max == null,
        );
    ref.invalidate(financialCalendarMonthProvider);
    Navigator.pop(context);
  }

  void _reset() {
    ref.read(calendarFiltersProvider.notifier).state = const CalendarFilters();
    ref.invalidate(financialCalendarMonthProvider);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesAsync = ref.watch(categoriesProvider);

    return ListView(
      padding: AppResponsive.screenPadding(context, bottom: AppSpacing.xl),
      children: [
        Text(
          'Filter timeline',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Narrow your financial calendar by type, category, merchant, tags, or amount.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Event type', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: CalendarFilterKind.values.map((kind) {
            final selected = _draft.kind == kind;
            return FilterChip(
              selected: selected,
              label: Text(_kindLabel(kind)),
              onSelected: (_) => setState(() => _draft = _draft.copyWith(kind: kind)),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Category', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        categoriesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const Text('Could not load categories'),
          data: (categories) => Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              FilterChip(
                selected: _draft.categoryId == null,
                label: const Text('All'),
                onSelected: (_) => setState(
                  () => _draft = _draft.copyWith(clearCategoryId: true),
                ),
              ),
              ...categories.map(
                (c) => FilterChip(
                  selected: _draft.categoryId == c.id,
                  label: Text(c.name),
                  onSelected: (_) => setState(
                    () => _draft = _draft.copyWith(categoryId: c.id),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _merchantController,
          decoration: const InputDecoration(
            labelText: 'Merchant / title contains',
            prefixIcon: Icon(Icons.store_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _tagController,
          decoration: const InputDecoration(
            labelText: 'Tag contains',
            prefixIcon: Icon(Icons.label_outline),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Min amount (₹)',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextField(
                controller: _maxController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Max amount (₹)',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Custom date range', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _draft.customRangeStart ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) {
                    setState(() => _draft = _draft.copyWith(customRangeStart: picked));
                  }
                },
                icon: const Icon(Icons.date_range_outlined, size: 18),
                label: Text(
                  _draft.customRangeStart == null
                      ? 'Start'
                      : '${_draft.customRangeStart!.day}/${_draft.customRangeStart!.month}/${_draft.customRangeStart!.year}',
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _draft.customRangeEnd ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) {
                    setState(() => _draft = _draft.copyWith(customRangeEnd: picked));
                  }
                },
                icon: const Icon(Icons.event_outlined, size: 18),
                label: Text(
                  _draft.customRangeEnd == null
                      ? 'End'
                      : '${_draft.customRangeEnd!.day}/${_draft.customRangeEnd!.month}/${_draft.customRangeEnd!.year}',
                ),
              ),
            ),
          ],
        ),
        if (_draft.customRangeStart != null)
          TextButton(
            onPressed: () =>
                setState(() => _draft = _draft.copyWith(clearCustomRange: true)),
            child: const Text('Clear date range'),
          ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(onPressed: _apply, child: const Text('Apply filters')),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(onPressed: _reset, child: const Text('Reset all')),
      ],
    );
  }

  String _kindLabel(CalendarFilterKind kind) => switch (kind) {
        CalendarFilterKind.all => 'All',
        CalendarFilterKind.income => 'Income',
        CalendarFilterKind.expense => 'Expense',
        CalendarFilterKind.subscriptions => 'Subscriptions',
        CalendarFilterKind.loans => 'Loans',
        CalendarFilterKind.goals => 'Goals',
        CalendarFilterKind.bills => 'Bills',
        CalendarFilterKind.savings => 'Savings',
      };
}
