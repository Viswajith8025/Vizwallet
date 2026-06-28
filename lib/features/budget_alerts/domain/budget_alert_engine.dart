import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';
import 'package:rupee_track/features/budget/domain/bucket_status.dart';
import 'package:rupee_track/features/budget_alerts/domain/budget_alert.dart';

/// Generates informative, actionable budget alerts — never alarmist.
abstract final class BudgetAlertEngine {
  static const defaultThresholds = [50, 75, 90, 100];

  static List<BudgetAlert> generateAlerts({
    required BudgetPlanStatus plan,
    List<int> thresholds = defaultThresholds,
  }) {
    final sorted = [...thresholds]..sort();
    final alerts = <BudgetAlert>[];

    for (final bucket in plan.buckets) {
      if (bucket.bucketType != BucketType.spending) continue;
      if (bucket.totalBudgetPaise <= 0) continue;

      final crossed = _highestCrossedThreshold(
        bucket.percentUsed,
        sorted,
      );
      if (crossed == null) continue;

      alerts.add(_alertFor(
        bucket: bucket,
        cycleKey: plan.monthKey,
        threshold: crossed,
      ));
    }

    alerts.sort((a, b) => b.thresholdPercent.compareTo(a.thresholdPercent));
    return alerts;
  }

  static int? _highestCrossedThreshold(double percent, List<int> thresholds) {
    int? highest;
    for (final t in thresholds) {
      if (percent >= t) highest = t;
    }
    return highest;
  }

  static BudgetAlert _alertFor({
    required BucketStatus bucket,
    required String cycleKey,
    required int threshold,
  }) {
    final remaining = bucket.remainingPaise;
    final over = bucket.isOverBudget ? bucket.spentPaise - bucket.totalBudgetPaise : 0;
    final level = _levelForThreshold(threshold, bucket.isOverBudget);
    final name = bucket.displayName;

    final (title, message) = threshold >= 100 && over > 0
        ? (
            '$name over budget',
            '$name exceeded budget by ${formatPaise(over)}.',
          )
        : threshold >= 90
            ? (
                '$name almost exhausted',
                '$name budget is almost exhausted.',
              )
            : threshold >= 75
                ? (
                    '$name filling up',
                    'You\'ve used ${bucket.percentUsed.round()}% of your $name budget.',
                  )
                : (
                    '$name halfway',
                    '$name is halfway through its budget this cycle.',
                  );

    final remainingLine = remaining > 0 && !bucket.isOverBudget
        ? ' You have only ${formatPaise(remaining)} left for ${name.toLowerCase()}.'
        : '';

    return BudgetAlert(
      id: '${cycleKey}_${bucket.bucketKey}_$threshold',
      cycleKey: cycleKey,
      bucketKey: bucket.bucketKey,
      displayName: name,
      thresholdPercent: threshold,
      level: level,
      title: title,
      message: '$message$remainingLine',
      suggestion: _suggestion(bucket, threshold, over),
      remainingPaise: remaining,
      overspendPaise: over,
      percentUsed: bucket.percentUsed,
    );
  }

  static BudgetAlertLevel _levelForThreshold(int threshold, bool exceeded) {
    if (exceeded || threshold >= 100) return BudgetAlertLevel.exceeded;
    if (threshold >= 90) return BudgetAlertLevel.critical90;
    if (threshold >= 75) return BudgetAlertLevel.watch75;
    return BudgetAlertLevel.watch50;
  }

  static String _suggestion(BucketStatus bucket, int threshold, int over) {
    if (over > 0) {
      return 'Pause discretionary ${
          bucket.displayName.toLowerCase()
      } spends until next salary, or move funds from a flexible bucket.';
    }
    if (threshold >= 90) {
      return 'Stay near ${formatPaise(bucket.dailyAllowancePaise)}/day for the rest of this cycle.';
    }
    if (threshold >= 75) {
      return 'A lighter week in ${bucket.displayName.toLowerCase()} keeps you comfortably on track.';
    }
    return 'You\'re pacing well — no changes needed yet.';
  }

  static List<BudgetAlertGroup> groupAlerts(List<BudgetAlert> alerts) {
    if (alerts.isEmpty) return [];

    final exceeded =
        alerts.where((a) => a.isExceeded).toList();
    final critical = alerts
        .where((a) => a.level == BudgetAlertLevel.critical90 && !a.isExceeded)
        .toList();
    final watch = alerts
        .where(
          (a) =>
              !a.isExceeded &&
              a.level != BudgetAlertLevel.critical90,
        )
        .toList();

    final groups = <BudgetAlertGroup>[];

    if (exceeded.isNotEmpty) {
      groups.add(
        BudgetAlertGroup(
          key: 'exceeded',
          title: exceeded.length == 1
              ? exceeded.first.title
              : '${exceeded.length} categories over budget',
          summary: exceeded.length == 1
              ? exceeded.first.message
              : exceeded.map((a) => a.displayName).join(', '),
          alerts: exceeded,
          level: BudgetAlertLevel.exceeded,
          suggestion: exceeded.first.suggestion,
        ),
      );
    }

    if (critical.isNotEmpty) {
      groups.add(
        BudgetAlertGroup(
          key: 'critical',
          title: critical.length == 1
              ? critical.first.title
              : '${critical.length} budgets almost exhausted',
          summary: critical.length == 1
              ? critical.first.message
              : critical.map((a) => a.displayName).join(', '),
          alerts: critical,
          level: BudgetAlertLevel.critical90,
          suggestion:
              'Review these categories before your next few purchases.',
        ),
      );
    }

    if (watch.isNotEmpty) {
      groups.add(
        BudgetAlertGroup(
          key: 'watch',
          title: watch.length == 1
              ? watch.first.title
              : '${watch.length} categories to watch',
          summary: watch.length == 1
              ? watch.first.message
              : 'Halfway points reached in ${watch.map((a) => a.displayName).join(', ')}.',
          alerts: watch,
          level: BudgetAlertLevel.watch50,
          suggestion: 'No action needed yet — just stay mindful.',
        ),
      );
    }

    return groups;
  }

  static String? buildDailySummary(List<BudgetAlert> alerts) {
    if (alerts.isEmpty) return null;
    final exceeded = alerts.where((a) => a.isExceeded).length;
    final critical = alerts
        .where((a) => a.level == BudgetAlertLevel.critical90 && !a.isExceeded)
        .length;
    final watch = alerts.length - exceeded - critical;

    final parts = <String>[];
    if (exceeded > 0) {
      parts.add('$exceeded over budget');
    }
    if (critical > 0) {
      parts.add('$critical almost exhausted');
    }
    if (watch > 0) {
      parts.add('$watch to keep an eye on');
    }
    return 'Today\'s budget check: ${parts.join(', ')}.';
  }

  static String? buildWeeklySummary(List<BudgetAlert> alerts) {
    if (alerts.isEmpty) {
      return 'Your categories stayed within budget limits this week. Nice work.';
    }
    final top = alerts.take(3).map((a) => a.displayName).join(', ');
    return 'This week, focus areas: $top. ${alerts.first.suggestion}';
  }
}
