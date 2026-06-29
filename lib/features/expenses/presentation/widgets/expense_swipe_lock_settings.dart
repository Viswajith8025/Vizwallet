import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/providers/settings_provider.dart';

class ExpenseSwipeLockSettings extends ConsumerWidget {
  const ExpenseSwipeLockSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final locked = ref.watch(expenseSwipeDeleteLockedProvider);

    return PremiumCard(
      variant: PremiumCardVariant.elevated,
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Icon(
          locked ? Icons.lock_rounded : Icons.swipe_left_rounded,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          'Swipe delete lock',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          locked
              ? 'Swipe is off — tap an expense to edit or delete safely.'
              : 'Swipe left on an expense to delete it quickly.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        value: locked,
        onChanged: (value) => ref
            .read(expenseSwipeDeleteLockedProvider.notifier)
            .setLocked(value),
      ),
    );
  }
}
