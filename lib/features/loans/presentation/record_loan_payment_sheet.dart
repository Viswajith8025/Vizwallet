import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/premium_snackbar.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/loans/data/loans_repository.dart';

Future<void> showRecordLoanPaymentSheet(
  BuildContext context,
  WidgetRef ref,
  LoansTableData loan,
) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.45,
    child: _RecordLoanPaymentSheet(loan: loan),
  );
}

class _RecordLoanPaymentSheet extends ConsumerStatefulWidget {
  const _RecordLoanPaymentSheet({required this.loan});

  final LoansTableData loan;

  @override
  ConsumerState<_RecordLoanPaymentSheet> createState() =>
      _RecordLoanPaymentSheetState();
}

class _RecordLoanPaymentSheetState extends ConsumerState<_RecordLoanPaymentSheet> {
  final _amountController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final rupees = double.tryParse(_amountController.text.trim());
    if (rupees == null || rupees <= 0) {
      showPremiumSnackBar(
        context,
        message: 'Enter a valid amount',
        kind: PremiumSnackBarKind.error,
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(loansRepositoryProvider).recordPayment(
            loanId: widget.loan.id,
            amountPaise: (rupees * 100).round(),
          );
      if (!mounted) return;
      Navigator.pop(context);
      showPremiumSnackBar(
        context,
        message: 'Repayment recorded',
        kind: PremiumSnackBarKind.success,
      );
    } catch (_) {
      if (!mounted) return;
      showPremiumSnackBar(
        context,
        message: 'Could not save repayment',
        kind: PremiumSnackBarKind.error,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Record repayment',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.loan.personName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Balance: ${formatPaise(widget.loan.balancePaise)}',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount (₹)',
              prefixText: '₹ ',
            ),
            enabled: !_saving,
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving…' : 'Save repayment'),
          ),
        ],
      ),
    );
  }
}
