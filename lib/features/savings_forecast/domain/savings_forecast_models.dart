enum ForecastPeriod {
  days30,
  months3,
  months6,
  year1,
  years3,
  years5,
  custom,
}

enum ForecastScenarioKind {
  baseline,
  increaseSalary,
  reduceSpending,
  cancelSubscription,
  increaseSavings,
  newGoal,
  unexpectedExpense,
  loanPayment,
  bonus,
}

enum ForecastRiskKind {
  overspending,
  goalDelay,
  cashShortage,
  lowEmergencyFund,
  highSubscriptionBurden,
  budgetInstability,
}

class SavingsGoalSnapshot {
  const SavingsGoalSnapshot({
    required this.id,
    required this.name,
    required this.targetPaise,
    required this.savedPaise,
    required this.monthlyContributionPaise,
    required this.isWishlist,
    this.targetDate,
  });

  final int id;
  final String name;
  final int targetPaise;
  final int savedPaise;
  final int monthlyContributionPaise;
  final bool isWishlist;
  final DateTime? targetDate;

  int get remainingPaise => (targetPaise - savedPaise).clamp(0, targetPaise);
}

class ForecastAdjustments {
  const ForecastAdjustments({
    this.salaryDeltaPaise = 0,
    this.spendingDeltaPaise = 0,
    this.subscriptionCancelPaise = 0,
    this.extraSavingsPaise = 0,
    this.newGoalContributionPaise = 0,
    this.oneTimeExpensePaise = 0,
    this.oneTimeBonusPaise = 0,
    this.loanPaymentPaise = 0,
    this.cancelledSubscriptionName,
    this.affectedGoalName,
    this.categoryReductionName,
    this.categoryReductionPaise = 0,
  });

  final int salaryDeltaPaise;
  final int spendingDeltaPaise;
  final int subscriptionCancelPaise;
  final int extraSavingsPaise;
  final int newGoalContributionPaise;
  final int oneTimeExpensePaise;
  final int oneTimeBonusPaise;
  final int loanPaymentPaise;
  final String? cancelledSubscriptionName;
  final String? affectedGoalName;
  final String? categoryReductionName;
  final int categoryReductionPaise;

  ForecastAdjustments merge(ForecastAdjustments other) {
    return ForecastAdjustments(
      salaryDeltaPaise: salaryDeltaPaise + other.salaryDeltaPaise,
      spendingDeltaPaise: spendingDeltaPaise + other.spendingDeltaPaise,
      subscriptionCancelPaise:
          subscriptionCancelPaise + other.subscriptionCancelPaise,
      extraSavingsPaise: extraSavingsPaise + other.extraSavingsPaise,
      newGoalContributionPaise:
          newGoalContributionPaise + other.newGoalContributionPaise,
      oneTimeExpensePaise: oneTimeExpensePaise + other.oneTimeExpensePaise,
      oneTimeBonusPaise: oneTimeBonusPaise + other.oneTimeBonusPaise,
      loanPaymentPaise: loanPaymentPaise + other.loanPaymentPaise,
      cancelledSubscriptionName:
          other.cancelledSubscriptionName ?? cancelledSubscriptionName,
      affectedGoalName: other.affectedGoalName ?? affectedGoalName,
      categoryReductionName:
          other.categoryReductionName ?? categoryReductionName,
      categoryReductionPaise:
          categoryReductionPaise + other.categoryReductionPaise,
    );
  }
}

class SavingsForecastInput {
  const SavingsForecastInput({
    required this.cycleKey,
    required this.currentBalancePaise,
    required this.monthlySalaryPaise,
    required this.avgMonthlySpentPaise,
    required this.avgMonthlyNetSavingsPaise,
    required this.savingsRatePercent,
    required this.subscriptionMonthlyPaise,
    required this.loanMonthlyPaise,
    required this.goalContributionsMonthlyPaise,
    required this.budgetAdherencePercent,
    required this.healthScore,
    required this.historicalCycleSpent,
    required this.historicalSalaries,
    required this.categoryMonthlyAvg,
    required this.goals,
    required this.salaryDay,
    this.largestSubscriptionName,
    this.largestSubscriptionPaise = 0,
  });

  final String cycleKey;
  final int currentBalancePaise;
  final int monthlySalaryPaise;
  final int avgMonthlySpentPaise;
  final int avgMonthlyNetSavingsPaise;
  final double savingsRatePercent;
  final int subscriptionMonthlyPaise;
  final int loanMonthlyPaise;
  final int goalContributionsMonthlyPaise;
  final double budgetAdherencePercent;
  final int healthScore;
  final List<int> historicalCycleSpent;
  final List<int> historicalSalaries;
  final Map<String, int> categoryMonthlyAvg;
  final List<SavingsGoalSnapshot> goals;
  final int salaryDay;
  final String? largestSubscriptionName;
  final int largestSubscriptionPaise;
}

class ForecastTimelinePoint {
  const ForecastTimelinePoint({
    required this.monthIndex,
    required this.label,
    required this.balancePaise,
    required this.incomePaise,
    required this.expensePaise,
    required this.netPaise,
  });

  final int monthIndex;
  final String label;
  final int balancePaise;
  final int incomePaise;
  final int expensePaise;
  final int netPaise;
}

class GoalCompletionForecast {
  const GoalCompletionForecast({
    required this.goalId,
    required this.name,
    required this.monthsToComplete,
    required this.monthsDelayed,
    required this.onTrack,
    this.projectedCompletion,
  });

  final int goalId;
  final String name;
  final int monthsToComplete;
  final int monthsDelayed;
  final bool onTrack;
  final DateTime? projectedCompletion;
}

class ForecastPeriodSummary {
  const ForecastPeriodSummary({
    required this.period,
    required this.horizonMonths,
    required this.projectedSavingsPaise,
    required this.expectedIncomePaise,
    required this.expectedExpensesPaise,
    required this.netCashFlowPaise,
    required this.emergencyFundMonths,
    required this.investmentPotentialPaise,
  });

  final ForecastPeriod period;
  final int horizonMonths;
  final int projectedSavingsPaise;
  final int expectedIncomePaise;
  final int expectedExpensesPaise;
  final int netCashFlowPaise;
  final double emergencyFundMonths;
  final int investmentPotentialPaise;
}

class ForecastInsight {
  const ForecastInsight({
    required this.message,
    required this.severity,
  });

  final String message;
  final String severity;
}

class ForecastRisk {
  const ForecastRisk({
    required this.kind,
    required this.title,
    required this.detail,
    required this.severity,
  });

  final ForecastRiskKind kind;
  final String title;
  final String detail;
  final String severity;
}

class ForecastRecommendation {
  const ForecastRecommendation({
    required this.title,
    required this.detail,
    required this.actionKind,
  });

  final String title;
  final String detail;
  final String actionKind;
}

class ScenarioPreset {
  const ScenarioPreset({
    required this.kind,
    required this.label,
    required this.description,
    required this.adjustments,
  });

  final ForecastScenarioKind kind;
  final String label;
  final String description;
  final ForecastAdjustments adjustments;
}

class ScenarioResult {
  const ScenarioResult({
    required this.preset,
    required this.periodSummary,
    required this.deltaSavingsPaise,
    required this.headline,
  });

  final ScenarioPreset preset;
  final ForecastPeriodSummary periodSummary;
  final int deltaSavingsPaise;
  final String headline;
}

class SavingsForecastReport {
  const SavingsForecastReport({
    required this.selectedPeriod,
    required this.horizonMonths,
    required this.currentBalancePaise,
    required this.periodSummary,
    required this.allPeriodSummaries,
    required this.timeline,
    required this.savingsCurve,
    required this.incomeTrend,
    required this.expenseTrend,
    required this.goalForecasts,
    required this.insights,
    required this.risks,
    required this.recommendations,
    required this.scenarioPresets,
    required this.activeAdjustments,
    required this.generatedAt,
  });

  final ForecastPeriod selectedPeriod;
  final int horizonMonths;
  final int currentBalancePaise;
  final ForecastPeriodSummary periodSummary;
  final Map<ForecastPeriod, ForecastPeriodSummary> allPeriodSummaries;
  final List<ForecastTimelinePoint> timeline;
  final List<ForecastTimelinePoint> savingsCurve;
  final List<ForecastTimelinePoint> incomeTrend;
  final List<ForecastTimelinePoint> expenseTrend;
  final List<GoalCompletionForecast> goalForecasts;
  final List<ForecastInsight> insights;
  final List<ForecastRisk> risks;
  final List<ForecastRecommendation> recommendations;
  final List<ScenarioPreset> scenarioPresets;
  final ForecastAdjustments activeAdjustments;
  final DateTime generatedAt;
}
