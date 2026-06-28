import 'package:rupee_track/features/budget/domain/allocation_mode.dart';

/// Delivery channel for a budget alert.
enum AlertChannel {
  silent,
  inApp,
  push,
  dailySummary,
  weeklySummary,
}

/// A single proactive budget alert for one category at one threshold.
class BudgetAlert {
  const BudgetAlert({
    required this.id,
    required this.cycleKey,
    required this.bucketKey,
    required this.displayName,
    required this.thresholdPercent,
    required this.level,
    required this.title,
    required this.message,
    required this.suggestion,
    required this.remainingPaise,
    required this.overspendPaise,
    required this.percentUsed,
  });

  final String id;
  final String cycleKey;
  final String bucketKey;
  final String displayName;
  final int thresholdPercent;
  final BudgetAlertLevel level;
  final String title;
  final String message;
  final String suggestion;
  final int remainingPaise;
  final int overspendPaise;
  final double percentUsed;

  bool get isExceeded => thresholdPercent >= 100 || overspendPaise > 0;
}

/// Similar alerts grouped to avoid notification spam.
class BudgetAlertGroup {
  const BudgetAlertGroup({
    required this.key,
    required this.title,
    required this.summary,
    required this.alerts,
    required this.level,
    required this.suggestion,
  });

  final String key;
  final String title;
  final String summary;
  final List<BudgetAlert> alerts;
  final BudgetAlertLevel level;
  final String suggestion;
}

/// Active alerts + summaries for the current cycle.
class BudgetAlertsSnapshot {
  const BudgetAlertsSnapshot({
    required this.cycleKey,
    required this.groups,
    required this.allAlerts,
    required this.dailySummary,
    required this.weeklySummary,
    required this.newEscalations,
  });

  final String cycleKey;
  final List<BudgetAlertGroup> groups;
  final List<BudgetAlert> allAlerts;
  final String? dailySummary;
  final String? weeklySummary;
  final List<BudgetAlert> newEscalations;

  bool get hasAlerts => allAlerts.isNotEmpty;
  int get alertCount => allAlerts.length;
}
