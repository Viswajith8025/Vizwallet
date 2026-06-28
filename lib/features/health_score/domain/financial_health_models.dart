/// Raw metrics gathered for one salary cycle.
class FinancialHealthInput {
  const FinancialHealthInput({
    required this.cycleKey,
    required this.salaryPaise,
    required this.spentPaise,
    required this.carryOverPaise,
    required this.subscriptionMonthlyPaise,
    required this.pendingBorrowedPaise,
    required this.overdueLoansCount,
    required this.impulsePurchasePaise,
    required this.impulsePurchaseCount,
    required this.dailySpendsPaise,
    required this.bucketsOverBudget,
    required this.bucketsOnTrack,
    required this.totalSpendingBuckets,
    required this.emergencyFundRemainingPercent,
    required this.savingsBucketTouched,
    required this.previousCycleScore,
    required this.previousCycleSavingsPaise,
  });

  final String cycleKey;
  final int salaryPaise;
  final int spentPaise;
  final int carryOverPaise;
  final int subscriptionMonthlyPaise;
  final int pendingBorrowedPaise;
  final int overdueLoansCount;
  final int impulsePurchasePaise;
  final int impulsePurchaseCount;
  final List<int> dailySpendsPaise;
  final int bucketsOverBudget;
  final int bucketsOnTrack;
  final int totalSpendingBuckets;
  final double emergencyFundRemainingPercent;
  final bool savingsBucketTouched;
  final int? previousCycleScore;
  final int previousCycleSavingsPaise;

  bool get hasSalary => salaryPaise > 0;

  int get savingsPaise =>
      (salaryPaise + carryOverPaise - spentPaise).clamp(0, 1 << 30);

  double get savingsRate =>
      salaryPaise > 0 ? savingsPaise / salaryPaise : 0;

  double get subscriptionBurden =>
      salaryPaise > 0 ? subscriptionMonthlyPaise / salaryPaise : 0;

  double get debtRatio =>
      salaryPaise > 0 ? pendingBorrowedPaise / salaryPaise : 0;

  double get budgetDiscipline => totalSpendingBuckets > 0
      ? bucketsOnTrack / totalSpendingBuckets
      : 1.0;
}

enum HealthCategory {
  saving('Saving', 'How much money you keep each month'),
  budgeting('Budgeting', 'Staying within your spending plan'),
  debt('Debt', 'Borrowed money and repayments'),
  subscriptions('Subscriptions', 'Monthly bills like Netflix or recharge'),
  stability('Stability', 'How steady your spending feels');

  const HealthCategory(this.label, this.description);

  final String label;
  final String description;
}

class CategoryScore {
  const CategoryScore({
    required this.category,
    required this.score,
    required this.summary,
  });

  final HealthCategory category;
  final int score;
  final String summary;
}

class HealthRecommendation {
  const HealthRecommendation({
    required this.message,
    required this.potentialGain,
    required this.category,
  });

  final String message;
  final int potentialGain;
  final HealthCategory category;
}

class HistoricalScorePoint {
  const HistoricalScorePoint({
    required this.cycleKey,
    required this.score,
    required this.recordedAt,
  });

  final String cycleKey;
  final int score;
  final DateTime recordedAt;
}

class FinancialHealthReport {
  const FinancialHealthReport({
    required this.cycleKey,
    required this.overallScore,
    required this.trendDelta,
    required this.motivationLabel,
    required this.categories,
    required this.recommendations,
    required this.history,
    required this.hasEnoughData,
  });

  final String cycleKey;
  final int overallScore;
  final int trendDelta;
  final String motivationLabel;
  final List<CategoryScore> categories;
  final List<HealthRecommendation> recommendations;
  final List<HistoricalScorePoint> history;
  final bool hasEnoughData;
}
