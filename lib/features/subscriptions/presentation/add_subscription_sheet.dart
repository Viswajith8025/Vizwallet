import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/subscriptions/data/subscriptions_repository.dart';
import 'package:rupee_track/features/subscriptions/data/subscription_health_repository.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_renewal_utils.dart';

Future<void> showAddSubscriptionSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.82,
    child: const _AddSubscriptionSheet(),
  );
}

class _AddSubscriptionSheet extends ConsumerStatefulWidget {
  const _AddSubscriptionSheet();

  @override
  ConsumerState<_AddSubscriptionSheet> createState() =>
      _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends ConsumerState<_AddSubscriptionSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _billingCycle = 'monthly';
  int _billingDay = DateTime.now().day;
  DateTime? _yearlyRenewalDate;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickYearlyRenewalDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _yearlyRenewalDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _yearlyRenewalDate = picked);
  }

  DateTime? _resolveNextRenewal() {
    if (_billingCycle == 'monthly') {
      return SubscriptionRenewalUtils.nextRenewalOnDay(_billingDay);
    }
    return _yearlyRenewalDate?.toUtc();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final amount = rupeesToPaise(_amountController.text);
    if (name.isEmpty) {
      _showError('Enter a subscription name');
      return;
    }
    if (amount <= 0) {
      _showError('Enter a valid amount');
      return;
    }
    if (_billingCycle == 'yearly' && _yearlyRenewalDate == null) {
      _showError('Pick the next yearly renewal date');
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(subscriptionsRepositoryProvider).addSubscription(
            name: name,
            amountPaise: amount,
            billingCycle: _billingCycle,
            nextRenewalAt: _resolveNextRenewal(),
          );
      ref.invalidate(activeSubscriptionsProvider);
      ref.invalidate(subscriptionHealthReportProvider);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $name · ${formatPaise(amount)}')),
      );
    } catch (e) {
      _showError('Could not save this subscription. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextMonthly = SubscriptionRenewalUtils.nextRenewalOnDay(_billingDay);

    return ListView(
      padding: AppResponsive.screenPadding(context, bottom: AppSpacing.xl),
      children: [
        Text(
          'Add subscription',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Set when it charges — e.g. Spotify on the 5th every month.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'Netflix, Spotify, Jio…',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText:
                _billingCycle == 'yearly' ? 'Yearly amount' : 'Monthly amount',
            prefixText: '₹ ',
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Billing cycle', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'monthly', label: Text('Monthly')),
            ButtonSegment(value: 'yearly', label: Text('Yearly')),
          ],
          selected: {_billingCycle},
          onSelectionChanged: (value) {
            setState(() => _billingCycle = value.first);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        if (_billingCycle == 'monthly') ...[
          Text('Charges on day', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<int>(
            value: _billingDay,
            decoration: const InputDecoration(
              labelText: 'Day of month',
              hintText: 'e.g. 5 for Spotify on the 5th',
            ),
            items: List.generate(
              31,
              (i) => DropdownMenuItem(
                value: i + 1,
                child: Text('${i + 1}${_daySuffix(i + 1)} of each month'),
              ),
            ),
            onChanged: (value) {
              if (value != null) setState(() => _billingDay = value);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Next charge: ${nextMonthly.day}/${nextMonthly.month}/${nextMonthly.year}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ] else ...[
          OutlinedButton.icon(
            onPressed: _pickYearlyRenewalDate,
            icon: const Icon(Icons.event_outlined),
            label: Text(
              _yearlyRenewalDate == null
                  ? 'Next yearly renewal date'
                  : 'Renews ${_yearlyRenewalDate!.day}/${_yearlyRenewalDate!.month}/${_yearlyRenewalDate!.year}',
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Save subscription'),
        ),
      ],
    );
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    return switch (day % 10) {
      1 => 'st',
      2 => 'nd',
      3 => 'rd',
      _ => 'th',
    };
  }
}
