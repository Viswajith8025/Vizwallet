import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/subscriptions/data/subscriptions_repository.dart';
import 'package:rupee_track/features/subscriptions/data/subscription_health_repository.dart';

Future<void> showAddSubscriptionSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.78,
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
  DateTime? _renewalDate;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickRenewalDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _renewalDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _renewalDate = picked);
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

    setState(() => _saving = true);
    try {
      await ref.read(subscriptionsRepositoryProvider).addSubscription(
            name: name,
            amountPaise: amount,
            billingCycle: _billingCycle,
            nextRenewalAt: _renewalDate?.toUtc(),
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

    return ListView(
      padding: AppResponsive.screenPadding(context, bottom: AppSpacing.xl),
      children: [
        Text(
          'Add subscription',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Track recurring payments like streaming, mobile, or gym memberships.',
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
            labelText: _billingCycle == 'yearly' ? 'Yearly amount' : 'Monthly amount',
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
        OutlinedButton.icon(
          onPressed: _pickRenewalDate,
          icon: const Icon(Icons.event_outlined),
          label: Text(
            _renewalDate == null
                ? 'Next renewal date (optional)'
                : 'Renews ${_renewalDate!.day}/${_renewalDate!.month}/${_renewalDate!.year}',
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? 'Saving…' : 'Save subscription'),
        ),
      ],
    );
  }
}
