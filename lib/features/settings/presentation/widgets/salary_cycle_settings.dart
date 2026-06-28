import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/providers/settings_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';

class SalaryCycleSettings extends ConsumerStatefulWidget {
  const SalaryCycleSettings({super.key});

  @override
  ConsumerState<SalaryCycleSettings> createState() =>
      _SalaryCycleSettingsState();
}

class _SalaryCycleSettingsState extends ConsumerState<SalaryCycleSettings> {
  int? _pendingDay;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsProvider);
    final theme = Theme.of(context);

    return settingsAsync.when(
      loading: () => const ListTile(
        title: Text('Salary cycle'),
        subtitle: Text('Loading…'),
      ),
      error: (e, _) => ListTile(
        title: const Text('Salary cycle'),
        subtitle: Text('Error: $e'),
      ),
      data: (settings) {
        final day = _pendingDay ?? settings.salaryDay;
        final previewKey = currentCycleKey(salaryDay: day);
        final previewLabel =
            formatCycleLabel(previewKey, salaryDay: day);
        final nextSalary = SalaryCycleEngine.nextSalaryDateIst(salaryDay: day);
        final daysLeft =
            SalaryCycleEngine.daysRemainingInCycle(salaryDay: day);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ListTile(
              leading: Icon(Icons.event_repeat),
              title: Text('Salary cycle'),
              subtitle: Text(
                'Your financial month runs from salary date to the day before next salary.',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('Salary date', style: theme.textTheme.titleSmall),
                  const Spacer(),
                  Text(
                    '$day${_ordinal(day)} of each month',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Slider(
              value: day.toDouble(),
              min: 1,
              max: 31,
              divisions: 30,
              label: '$day',
              onChanged: (v) => setState(() => _pendingDay = v.round()),
              onChangeEnd: (v) => _saveDay(v.round()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current cycle', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 4),
                      Text(
                        previewLabel,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Next salary: ${nextSalary.day} '
                        '${_shortMonth(nextSalary.month)} · '
                        '$daysLeft days left in cycle',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Irregular months (e.g. 31st in February) are handled automatically.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Future<void> _saveDay(int day) async {
    final dao = await ref.read(incomeSourcesDaoProvider.future);
    await dao.updateSalaryDay(day);
    ref.invalidate(appSettingsProvider);
    ref.read(selectedCycleKeyProvider.notifier).syncWithSalaryDay();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Salary date set to the $day${_ordinal(day)}')),
      );
    }
    setState(() => _pendingDay = null);
  }

  static String _ordinal(int day) {
    if (day >= 11 && day <= 13) return 'th';
    return switch (day % 10) {
      1 => 'st',
      2 => 'nd',
      3 => 'rd',
      _ => 'th',
    };
  }

  static String _shortMonth(int month) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][month - 1];
}
