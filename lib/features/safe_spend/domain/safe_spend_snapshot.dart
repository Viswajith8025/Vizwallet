/// How today's spending compares to the safe daily guide.
enum SafeSpendRiskLevel {
  onTrack,
  comfortable,
  watch,
  elevated,
  critical,
  noData,
}

extension SafeSpendRiskLevelX on SafeSpendRiskLevel {
  String get label => switch (this) {
        SafeSpendRiskLevel.onTrack => 'On track',
        SafeSpendRiskLevel.comfortable => 'Comfortable',
        SafeSpendRiskLevel.watch => 'Pace gently',
        SafeSpendRiskLevel.elevated => 'Above guide',
        SafeSpendRiskLevel.critical => 'Needs attention',
        SafeSpendRiskLevel.noData => 'Set salary',
      };
}

/// Forward-looking view based on spending pace this cycle.
class SafeSpendProjection {
  const SafeSpendProjection({
    required this.averageDailySpendPaise,
    this.moneyLastsUntilIst,
    required this.expectedEndOfCycleBalancePaise,
    required this.dailyReductionNeededPaise,
    required this.projectedCycleSpendPaise,
  });

  final int averageDailySpendPaise;
  final DateTime? moneyLastsUntilIst;
  final int expectedEndOfCycleBalancePaise;
  final int dailyReductionNeededPaise;
  final int projectedCycleSpendPaise;

  bool get expectsShortage => expectedEndOfCycleBalancePaise < 0;
  bool get expectsSavings => expectedEndOfCycleBalancePaise > 0;
}

/// Live safe-spend snapshot — recalculated whenever cycle money or expenses change.
class SafeSpendSnapshot {
  const SafeSpendSnapshot({
    required this.cycleKey,
    required this.moneyLeftPaise,
    required this.daysRemainingInCycle,
    required this.daysElapsedInCycle,
    required this.safeDailyLimitPaise,
    required this.todaySpentPaise,
    required this.remainingSafeSpendTodayPaise,
    required this.todayUsagePercent,
    required this.riskLevel,
    required this.headline,
    required this.recommendation,
    required this.projection,
  });

  final String cycleKey;
  final int moneyLeftPaise;
  final int daysRemainingInCycle;
  final int daysElapsedInCycle;
  final int safeDailyLimitPaise;
  final int todaySpentPaise;
  final int remainingSafeSpendTodayPaise;
  final double todayUsagePercent;
  final SafeSpendRiskLevel riskLevel;
  final String headline;
  final String? recommendation;
  final SafeSpendProjection projection;

  bool get isOverTodayGuide => todaySpentPaise > safeDailyLimitPaise;
}
