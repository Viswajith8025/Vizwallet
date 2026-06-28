import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/features/budget_alerts/data/alert_preferences.dart';
import 'package:rupee_track/features/budget_alerts/data/budget_alerts_repository.dart';
import 'package:rupee_track/features/budget_alerts/domain/budget_alert_engine.dart';

class BudgetAlertSettings extends ConsumerStatefulWidget {
  const BudgetAlertSettings({super.key});

  @override
  ConsumerState<BudgetAlertSettings> createState() =>
      _BudgetAlertSettingsState();
}

class _BudgetAlertSettingsState extends ConsumerState<BudgetAlertSettings> {
  Set<int>? _thresholds;

  Set<int> get thresholds =>
      _thresholds ?? ref.read(alertPreferencesProvider).thresholds.toSet();

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(alertPreferencesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          leading: Icon(Icons.notifications_outlined),
          title: Text('Budget alerts'),
          subtitle: Text(
            'Friendly warnings when you use 50%, 75%, 90%, or 100% of a spending group.',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 8,
            children: BudgetAlertEngine.defaultThresholds.map((t) {
              final selected = thresholds.contains(t);
              return FilterChip(
                label: Text('$t%'),
                selected: selected,
                onSelected: (v) async {
                  final next = Set<int>.from(thresholds);
                  if (v) {
                    next.add(t);
                  } else if (next.length > 1) {
                    next.remove(t);
                  }
                  setState(() => _thresholds = next);
                  await _save(prefs);
                },
              );
            }).toList(),
          ),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.phone_android),
          title: const Text('In-app alerts'),
          subtitle: const Text('Show a small message inside the app'),
          value: prefs.inAppEnabled,
          onChanged: (v) => _update(prefs.copyWith(inAppEnabled: v)),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.notifications_active_outlined),
          title: const Text('Push notifications'),
          subtitle: const Text('Max 3 per day, grouped when possible'),
          value: prefs.pushEnabled,
          onChanged: (v) => _update(prefs.copyWith(pushEnabled: v)),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.volume_off_outlined),
          title: const Text('Silent alerts'),
          subtitle: const Text('Log alerts without sound or banner'),
          value: prefs.silentEnabled,
          onChanged: (v) => _update(prefs.copyWith(silentEnabled: v)),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.wb_sunny_outlined),
          title: const Text('Daily summary'),
          subtitle: const Text('Once-a-day budget check-in'),
          value: prefs.dailySummaryEnabled,
          onChanged: (v) => _update(prefs.copyWith(dailySummaryEnabled: v)),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.date_range),
          title: const Text('Weekly summary'),
          subtitle: const Text('Monday overview of focus categories'),
          value: prefs.weeklySummaryEnabled,
          onChanged: (v) => _update(prefs.copyWith(weeklySummaryEnabled: v)),
        ),
      ],
    );
  }

  Future<void> _save(AlertPreferences prefs) async {
    final sorted = thresholds.toList()..sort();
    await ref.read(alertPreferencesProvider.notifier).update(
          prefs.copyWith(thresholds: sorted),
        );
  }

  Future<void> _update(AlertPreferences prefs) async {
    await ref
        .read(alertPreferencesProvider.notifier)
        .update(prefs.copyWith(thresholds: thresholds.toList()..sort()));
  }
}

extension on AlertPreferences {
  AlertPreferences copyWith({
    List<int>? thresholds,
    bool? inAppEnabled,
    bool? pushEnabled,
    bool? silentEnabled,
    bool? dailySummaryEnabled,
    bool? weeklySummaryEnabled,
  }) {
    return AlertPreferences(
      thresholds: thresholds ?? this.thresholds,
      inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      silentEnabled: silentEnabled ?? this.silentEnabled,
      dailySummaryEnabled: dailySummaryEnabled ?? this.dailySummaryEnabled,
      weeklySummaryEnabled: weeklySummaryEnabled ?? this.weeklySummaryEnabled,
    );
  }
}
