import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/subscriptions/data/subscription_health_repository.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_models.dart';

class SubscriptionHealthCard extends StatelessWidget {
  const SubscriptionHealthCard({
    required this.card,
    required this.onAction,
    super.key,
  });

  final SubscriptionCardViewModel card;
  final void Function(String action) onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => _showDetailSheet(context),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: card.logoColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(card.logoIcon, color: card.logoColor),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${card.categoryName} · ${card.billingCycle}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formatPaise(card.amountPaise),
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      _HealthBadge(health: card.health),
                    ],
                  ),
                  PopupMenuButton<String>(
                    onSelected: onAction,
                    itemBuilder: (context) => [
                      if (card.status == SubscriptionStatus.active)
                        const PopupMenuItem(
                          value: 'pause',
                          child: Text('Pause'),
                        ),
                      if (card.status == SubscriptionStatus.paused)
                        const PopupMenuItem(
                          value: 'resume',
                          child: Text('Resume'),
                        ),
                      if (card.status != SubscriptionStatus.cancelled)
                        const PopupMenuItem(
                          value: 'cancel',
                          child: Text('Cancel'),
                        ),
                      const PopupMenuItem(
                        value: 'usage',
                        child: Text('Set usage frequency'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  _Chip(label: _statusLabel(card.status)),
                  _Chip(label: card.paymentMethod),
                  if (card.nextRenewalAt != null)
                    _Chip(
                      label:
                          'Renews ${card.nextRenewalAt!.toLocal().toString().split(' ').first}',
                    ),
                  if (card.overlapGroup != null)
                    _Chip(
                      label: 'Overlaps',
                      color: theme.colorScheme.error.withValues(alpha: 0.12),
                      textColor: theme.colorScheme.error,
                    ),
                  _Chip(label: _usageLabel(card.usageFrequency)),
                ],
              ),
              if (card.notes != null && card.notes!.trim().isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  card.notes!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailSheet(BuildContext context) {
    showPremiumBottomSheet<void>(
      context: context,
      initialSize: 0.55,
      child: _SubscriptionDetailSheet(card: card),
    );
  }

  static String _statusLabel(SubscriptionStatus status) => switch (status) {
        SubscriptionStatus.active => 'Active',
        SubscriptionStatus.paused => 'Paused',
        SubscriptionStatus.cancelled => 'Cancelled',
      };

  static String _usageLabel(SubscriptionUsageFrequency usage) =>
      switch (usage) {
        SubscriptionUsageFrequency.daily => 'Daily use',
        SubscriptionUsageFrequency.weekly => 'Weekly use',
        SubscriptionUsageFrequency.monthly => 'Monthly use',
        SubscriptionUsageFrequency.rarely => 'Rarely used',
        SubscriptionUsageFrequency.never => 'Never used',
        SubscriptionUsageFrequency.unknown => 'Usage not tracked',
      };
}

class _HealthBadge extends StatelessWidget {
  const _HealthBadge({required this.health});

  final SubscriptionCardHealth health;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (health) {
      SubscriptionCardHealth.excellent => ('Excellent', Colors.green),
      SubscriptionCardHealth.healthy => ('Healthy', Colors.teal),
      SubscriptionCardHealth.watch => ('Watch', Colors.orange),
      SubscriptionCardHealth.atRisk => ('At risk', Colors.deepOrange),
      SubscriptionCardHealth.unused => ('Unused', Colors.red),
    };

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color.shade700,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    this.color,
    this.textColor,
  });

  final String label;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: textColor ?? theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _SubscriptionDetailSheet extends StatelessWidget {
  const _SubscriptionDetailSheet({required this.card});

  final SubscriptionCardViewModel card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(card.name, style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        _DetailRow('Monthly', formatPaise(card.monthlyEquivalentPaise)),
        _DetailRow('Yearly', formatPaise(card.yearlyEquivalentPaise)),
        _DetailRow('Billing', card.billingCycle),
        _DetailRow('Payment', card.paymentMethod),
        _DetailRow('Category', card.categoryName),
        _DetailRow('Status', SubscriptionHealthCard._statusLabel(card.status)),
        _DetailRow(
          'Usage',
          SubscriptionHealthCard._usageLabel(card.usageFrequency),
        ),
        if (card.nextRenewalAt != null)
          _DetailRow(
            'Next renewal',
            card.nextRenewalAt!.toLocal().toString().split(' ').first,
          ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

Future<void> showUsageFrequencySheet(
  BuildContext context,
  WidgetRef ref,
  int subscriptionId,
) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.45,
    child: _UsageFrequencySheet(subscriptionId: subscriptionId),
  );
}

class _UsageFrequencySheet extends ConsumerWidget {
  const _UsageFrequencySheet({required this.subscriptionId});

  final int subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const options = [
      ('daily', 'Daily'),
      ('weekly', 'Weekly'),
      ('monthly', 'Monthly'),
      ('rarely', 'Rarely'),
      ('never', 'Never'),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          'How often do you use this?',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        ...options.map(
          (opt) => ListTile(
            title: Text(opt.$2),
            onTap: () async {
              await ref
                  .read(subscriptionHealthRepositoryProvider)
                  .setUsageFrequency(subscriptionId, opt.$1);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
