import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/features/budget_alerts/domain/budget_alert_engine.dart';

class AlertPreferences {
  const AlertPreferences({
    required this.thresholds,
    required this.inAppEnabled,
    required this.pushEnabled,
    required this.silentEnabled,
    required this.dailySummaryEnabled,
    required this.weeklySummaryEnabled,
  });

  final List<int> thresholds;
  final bool inAppEnabled;
  final bool pushEnabled;
  final bool silentEnabled;
  final bool dailySummaryEnabled;
  final bool weeklySummaryEnabled;

  static const defaults = AlertPreferences(
    thresholds: BudgetAlertEngine.defaultThresholds,
    inAppEnabled: true,
    pushEnabled: false,
    silentEnabled: true,
    dailySummaryEnabled: true,
    weeklySummaryEnabled: false,
  );

  static AlertPreferences load() {
    final prefs = sharedPreferences;
    final raw = prefs.getString('budget_alert_thresholds');
    final thresholds = raw != null
        ? raw
            .split(',')
            .map((s) => int.tryParse(s.trim()))
            .whereType<int>()
            .toList()
        : BudgetAlertEngine.defaultThresholds;

    return AlertPreferences(
      thresholds: thresholds.isEmpty
          ? BudgetAlertEngine.defaultThresholds
          : thresholds,
      inAppEnabled: prefs.getBool('budget_alert_in_app') ?? true,
      pushEnabled: prefs.getBool('budget_alert_push') ?? false,
      silentEnabled: prefs.getBool('budget_alert_silent') ?? true,
      dailySummaryEnabled: prefs.getBool('budget_alert_daily') ?? true,
      weeklySummaryEnabled: prefs.getBool('budget_alert_weekly') ?? false,
    );
  }

  Future<void> save() async {
    final prefs = sharedPreferences;
    await prefs.setString(
      'budget_alert_thresholds',
      thresholds.join(','),
    );
    await prefs.setBool('budget_alert_in_app', inAppEnabled);
    await prefs.setBool('budget_alert_push', pushEnabled);
    await prefs.setBool('budget_alert_silent', silentEnabled);
    await prefs.setBool('budget_alert_daily', dailySummaryEnabled);
    await prefs.setBool('budget_alert_weekly', weeklySummaryEnabled);
  }
}

/// Prevents re-notifying the same threshold; allows escalation only.
class AlertThrottleStore {
  static const _maxPushPerDay = 3;

  String _key(String cycleKey, String bucketKey) =>
      'alert_notified_${cycleKey}_$bucketKey';

  int getLastNotifiedThreshold(String cycleKey, String bucketKey) {
    return sharedPreferences.getInt(_key(cycleKey, bucketKey)) ?? 0;
  }

  Future<void> markNotified(
    String cycleKey,
    String bucketKey,
    int threshold,
  ) async {
    await sharedPreferences.setInt(
      _key(cycleKey, bucketKey),
      threshold,
    );
  }

  /// Returns alerts that crossed a NEW higher threshold since last notify.
  List<T> filterNewEscalations<T>({
    required String cycleKey,
    required List<({T item, String bucketKey, int threshold})> candidates,
  }) {
    final fresh = <T>[];
    for (final c in candidates) {
      final last = getLastNotifiedThreshold(cycleKey, c.bucketKey);
      if (c.threshold > last) fresh.add(c.item);
    }
    return fresh;
  }

  int get pushCountToday {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return sharedPreferences.getInt('alert_push_count_$today') ?? 0;
  }

  Future<bool> canSendPush() async {
    return pushCountToday < _maxPushPerDay;
  }

  Future<void> recordPush() async {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final count = pushCountToday + 1;
    await sharedPreferences.setInt('alert_push_count_$today', count);
  }

  DateTime? get lastDailySummary {
    final raw = sharedPreferences.getString('alert_last_daily');
    return raw != null ? DateTime.tryParse(raw) : null;
  }

  Future<void> markDailySummarySent() async {
    await sharedPreferences.setString(
      'alert_last_daily',
      DateTime.now().toIso8601String(),
    );
  }

  bool shouldShowDailySummary({required bool enabled}) {
    if (!enabled) return false;
    final last = lastDailySummary;
    if (last == null) return true;
    return DateTime.now().difference(last).inHours >= 20;
  }

  DateTime? get lastWeeklySummary {
    final raw = sharedPreferences.getString('alert_last_weekly');
    return raw != null ? DateTime.tryParse(raw) : null;
  }

  Future<void> markWeeklySummarySent() async {
    await sharedPreferences.setString(
      'alert_last_weekly',
      DateTime.now().toIso8601String(),
    );
  }

  bool shouldShowWeeklySummary({required bool enabled}) {
    if (!enabled) return false;
    final last = lastWeeklySummary;
    if (last == null) return DateTime.now().weekday == DateTime.monday;
    return DateTime.now().difference(last).inDays >= 7;
  }
}
