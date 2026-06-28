import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/providers/settings_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_bounds.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';

/// Primary income salary day (synced with settings + income source table).
final salaryDayProvider = Provider<int>((ref) {
  final settings = ref.watch(appSettingsProvider).value;
  return settings?.salaryDay ?? AppConstants.defaultSalaryDay;
});

final selectedCycleKeyProvider =
    NotifierProvider<SelectedCycleKeyNotifier, String>(
  SelectedCycleKeyNotifier.new,
);

/// Backward-compatible alias — `monthKey` columns now store cycle keys.
final selectedMonthKeyProvider = selectedCycleKeyProvider;

class SelectedCycleKeyNotifier extends Notifier<String> {
  @override
  String build() {
    final salaryDay = ref.watch(salaryDayProvider);
    return _resolveStoredKey(salaryDay);
  }

  String _resolveStoredKey(int salaryDay) {
    final stored = sharedPreferences.getString(AppConstants.selectedCycleKeyPref) ??
        sharedPreferences.getString(AppConstants.selectedMonthKeyPref);

    if (stored != null) {
      if (SalaryCycleEngine.isLegacyMonthKey(stored)) {
        return SalaryCycleEngine.migrateLegacyMonthKey(
          stored,
          salaryDay: salaryDay,
        );
      }
      return stored;
    }
    return currentCycleKey(salaryDay: salaryDay);
  }

  void setCycle(String cycleKey) {
    state = cycleKey;
    sharedPreferences.setString(AppConstants.selectedCycleKeyPref, cycleKey);
  }

  /// Call after the user changes their salary date.
  void syncWithSalaryDay() {
    state = currentCycleKey(salaryDay: ref.read(salaryDayProvider));
    sharedPreferences.setString(AppConstants.selectedCycleKeyPref, state);
  }
}

/// Bounds for the cycle currently selected in the UI.
final activeSalaryCycleProvider = Provider<SalaryCycleBounds>((ref) {
  final salaryDay = ref.watch(salaryDayProvider);
  final cycleKey = ref.watch(selectedCycleKeyProvider);
  return SalaryCycleEngine.cycleBounds(cycleKey, salaryDay: salaryDay);
});

/// Whether the selected cycle is the live financial month (today falls inside it).
final isCurrentSalaryCycleProvider = Provider<bool>((ref) {
  final bounds = ref.watch(activeSalaryCycleProvider);
  final today = SalaryCycleEngine.istDateOnly(DateTime.now());
  return bounds.containsIstDate(today);
});
