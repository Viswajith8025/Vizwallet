import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/premium_snackbar.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/loans/data/loans_repository.dart';

Future<void> showSchedulePaybackSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.78,
    child: const _SchedulePaybackSheet(),
  );
}

class _SchedulePaybackSheet extends ConsumerStatefulWidget {
  const _SchedulePaybackSheet();

  @override
  ConsumerState<_SchedulePaybackSheet> createState() =>
      _SchedulePaybackSheetState();
}

class _SchedulePaybackSheetState extends ConsumerState<_SchedulePaybackSheet> {
  final _personController = TextEditingController();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  DateTime? _returnDate;
  bool _remindMe = true;
  bool _saving = false;

  @override
  void dispose() {
    _personController.dispose();
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickReturnDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _returnDate ?? DateTime.now().add(const Duration(days: 14)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _returnDate = picked);
  }

  Future<void> _save() async {
    final person = _personController.text.trim();
    final amount = rupeesToPaise(_amountController.text);
    if (person.isEmpty) {
      _showError('Enter who you borrowed from');
      return;
    }
    if (amount <= 0) {
      _showError('Enter a valid amount');
      return;
    }
    if (_returnDate == null) {
      _showError('Pick when you will pay it back');
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(loansRepositoryProvider).schedulePayback(
            personName: person,
            amountPaise: amount,
            returnBy: _returnDate!.toUtc(),
            reason: _reasonController.text.trim().isEmpty
                ? null
                : _reasonController.text.trim(),
            scheduleReminder: _remindMe,
          );
      ref.invalidate(activeBorrowedPaybacksProvider);
      ref.invalidate(duePaybacksProvider);
      if (!mounted) return;
      Navigator.pop(context);
      showPremiumSnackBar(
        context,
        message: 'Pay-back scheduled · ${formatPaise(amount)}',
        kind: PremiumSnackBarKind.success,
      );
    } catch (_) {
      _showError('Could not save. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
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
          'Schedule a pay-back',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Money you borrowed from someone. Set when you will return it — separate from loans you give others.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _personController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Borrowed from',
            hintText: 'Friend, family, colleague…',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Amount to return',
            prefixText: '₹ ',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _reasonController,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Note (optional)',
            hintText: 'Rent advance, emergency…',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: _pickReturnDate,
          icon: const Icon(Icons.event_outlined),
          label: Text(
            _returnDate == null
                ? 'Pick pay-back date'
                : 'Pay back by ${_returnDate!.day}/${_returnDate!.month}/${_returnDate!.year}',
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Remind me on that date'),
          subtitle: const Text('Shows on Home and sends an in-app alert'),
          value: _remindMe,
          onChanged: (v) => setState(() => _remindMe = v),
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Save pay-back'),
        ),
      ],
    );
  }
}
