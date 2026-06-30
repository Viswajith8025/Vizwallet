/// Canonical savings calculations used across dashboard, insights, and reports.
abstract final class SavingsRateUtils {
  /// Money left this cycle (may be negative when overspent).
  static int savingsPaise({
    required int salaryPaise,
    required int spentPaise,
    required int carryOverPaise,
  }) =>
      salaryPaise + carryOverPaise - spentPaise;

  /// Display savings rate in percent (may be negative).
  static double displayPercent({
    required int salaryPaise,
    required int spentPaise,
    required int carryOverPaise,
  }) {
    if (salaryPaise <= 0) return 0;
    return (savingsPaise(
          salaryPaise: salaryPaise,
          spentPaise: spentPaise,
          carryOverPaise: carryOverPaise,
        ) /
            salaryPaise) *
        100;
  }

  /// Non-negative rate as a fraction (0..1) for health-score math.
  static double healthScoreRate({
    required int salaryPaise,
    required int spentPaise,
    required int carryOverPaise,
  }) {
    if (salaryPaise <= 0) return 0;
    final savings = savingsPaise(
      salaryPaise: salaryPaise,
      spentPaise: spentPaise,
      carryOverPaise: carryOverPaise,
    ).clamp(0, 1 << 30);
    return savings / salaryPaise;
  }

  /// True when spending exceeds salary plus carry-over.
  static bool isOverBudget({
    required int salaryPaise,
    required int spentPaise,
    required int carryOverPaise,
  }) =>
      savingsPaise(
        salaryPaise: salaryPaise,
        spentPaise: spentPaise,
        carryOverPaise: carryOverPaise,
      ) <
      0;

  /// Average goal progress across savings goals (excludes wishlist).
  static int goalsProgressPercent({
    required Iterable<({int savedPaise, int targetPaise, bool isWishlist})> goals,
  }) {
    final savingsGoals =
        goals.where((g) => !g.isWishlist && g.targetPaise > 0).toList();
    if (savingsGoals.isEmpty) return 0;
    final total = savingsGoals.fold<double>(0, (sum, g) {
      return sum + (g.savedPaise / g.targetPaise).clamp(0.0, 1.0);
    });
    return ((total / savingsGoals.length) * 100).round();
  }
}
