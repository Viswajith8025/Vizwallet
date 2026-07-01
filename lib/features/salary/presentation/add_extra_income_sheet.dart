import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/premium_snackbar.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/dashboard/data/dashboard_repository.dart';
import 'package:rupee_track/features/salary/data/salary_repository.dart';

Future<void> showAddExtraIncomeSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.62,
    child: const _AddExtraIncomeSheet(),
  );
}

class _AddExtraIncomeSheet extends ConsumerStatefulWidget {
  const _AddExtraIncomeSheet();

  @override
  ConsumerState<_AddExtraIncomeSheet> createState() =>
      _AddExtraIncomeSheetState();
}

class _AddExtraIncomeSheetState extends ConsumerState<_AddExtraIncomeSheet> {
  final _labelController = TextEditingController();
  final _amountController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _labelController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final label = _labelController.text.trim();
    final amount = rupeesToPaise(_amountController.text);
    if (label.isEmpty) {
      _error('Say where it came from (e.g. family, gift)');
      return;
    }
    if (amount <= 0) {
      _error('Enter a valid amount');
      return;
    }

    setState(() => _saving = true);
    try {
      final cycleKey = ref.read(selectedCycleKeyProvider);
      final dao = await ref.read(salaryDaoProvider.future);
      await dao.addExtraIncome(
        monthKey: cycleKey,
        label: label,
        amountPaise: amount,
      );
      ref.invalidate(salaryBreakdownProvider(cycleKey));
      ref.invalidate(monthlySummaryProvider(cycleKey));
      if (!mounted) return;
      Navigator.pop(context);
      showPremiumSnackBar(
        context,
        message: 'Added ${formatPaise(amount)} to this cycle',
        kind: PremiumSnackBarKind.success,
      );
    } catch (_) {
      _error('Could not save');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _error(String message) {
    showPremiumSnackBar(
      context,
      message: message,
      kind: PremiumSnackBarKind.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: AppResponsive.screenPadding(context, bottom: AppSpacing.xl),
      children: [
        Text(
          'Extra money this cycle',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Cash from family, gifts, or anything outside your salary. '
          'It adds to money left for this cycle only.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _labelController,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'From',
            hintText: 'Family, friend, bonus…',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹ ',
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Add to cycle'),
        ),
      ],
    );
  }
}
