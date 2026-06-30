import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';

/// Pay-cycle range — looks like plain text until tapped to change month.
class DashboardCycleHeader extends ConsumerWidget {
  const DashboardCycleHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final salaryDay = ref.watch(salaryDayProvider);
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final bounds = ref.watch(activeSalaryCycleProvider);
    final isCurrent = ref.watch(isCurrentSalaryCycleProvider);

    final start = bounds.startIst;
    final end = bounds.endIst;
    final monthLabel = DateFormat('MMMM').format(start);
    final rangeLabel = start.year == end.year
        ? '$monthLabel ${start.day} – ${end.day}, ${start.year}'
        : '${DateFormat('d MMM yyyy').format(start)} – '
            '${DateFormat('d MMM yyyy').format(end)}';

    return Semantics(
      button: true,
      label: 'Pay cycle $rangeLabel. Tap to change.',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _pickCycle(context, ref, salaryDay, cycleKey),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.xs,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCurrent ? 'This month' : 'Pay cycle',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rangeLabel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.unfold_more_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.45),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickCycle(
    BuildContext context,
    WidgetRef ref,
    int salaryDay,
    String selected,
  ) async {
    final cycles = recentCycleKeys(salaryDay: salaryDay, count: 12);
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.lg,
            ),
            children: [
              Text(
                'Choose pay cycle',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...cycles.map((key) {
                final label = SalaryCycleEngine.formatCycleLabel(
                  key,
                  salaryDay: salaryDay,
                );
                return ListTile(
                  title: Text(label),
                  trailing: key == selected
                      ? Icon(
                          Icons.check_rounded,
                          color: Theme.of(ctx).colorScheme.primary,
                        )
                      : null,
                  onTap: () => Navigator.pop(ctx, key),
                );
              }),
            ],
          ),
        );
      },
    );

    if (picked != null && picked != selected) {
      ref.read(selectedCycleKeyProvider.notifier).setCycle(picked);
    }
  }
}
