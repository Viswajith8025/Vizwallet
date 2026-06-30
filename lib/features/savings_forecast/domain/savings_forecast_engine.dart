import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_models.dart';

/// Rule-based savings projection — local-first financial GPS.
abstract final class SavingsForecastEngine {
  static const _periodMonths = {
    ForecastPeriod.days30: 1,
    ForecastPeriod.months3: 3,
    ForecastPeriod.months6: 6,
    ForecastPeriod.year1: 12,
    ForecastPeriod.years3: 36,
    ForecastPeriod.years5: 60,
  };

  static SavingsForecastReport build({
    required SavingsForecastInput input,
    ForecastPeriod selectedPeriod = ForecastPeriod.year1,
    int customHorizonMonths = 12,
    ForecastAdjustments adjustments = const ForecastAdjustments(),
    DateTime? now,
  }) {
    final clock = (now ?? DateTime.now()).toLocal();
    final horizonMonths = selectedPeriod == ForecastPeriod.custom
        ? customHorizonMonths.clamp(1, 120)
        : _periodMonths[selectedPeriod] ?? 12;

    final simulation = _simulate(
      input: input,
      adjustments: adjustments,
      horizonMonths: horizonMonths,
      clock: clock,
    );

    final allSummaries = <ForecastPeriod, ForecastPeriodSummary>{};
    for (final entry in _periodMonths.entries) {
      final sim = entry.key == selectedPeriod
          ? simulation
          : _simulate(
              input: input,
              adjustments: adjustments,
              horizonMonths: entry.value,
              clock: clock,
            );
      allSummaries[entry.key] = _summaryFromSimulation(
        period: entry.key,
        horizonMonths: entry.value,
        simulation: sim,
        input: input,
      );
    }

    final periodSummary = allSummaries[selectedPeriod]!;
    final goalForecasts = _goalForecasts(
      goals: input.goals,
      monthlyNetSavings:
          simulation.netMonthlyPaise + adjustments.extraSavingsPaise,
      clock: clock,
    );

    final insights = _insights(
      input: input,
      periodSummary: periodSummary,
      goalForecasts: goalForecasts,
      adjustments: adjustments,
      horizonMonths: horizonMonths,
    );

    final risks = _risks(input: input, periodSummary: periodSummary);
    final recommendations = _recommendations(
      input: input,
      risks: risks,
      periodSummary: periodSummary,
    );

    final presets = _scenarioPresets(input);

    return SavingsForecastReport(
      selectedPeriod: selectedPeriod,
      horizonMonths: horizonMonths,
      currentBalancePaise: input.currentBalancePaise,
      periodSummary: periodSummary,
      allPeriodSummaries: allSummaries,
      timeline: simulation.timeline,
      savingsCurve: simulation.timeline,
      incomeTrend: simulation.timeline
          .map(
            (p) => ForecastTimelinePoint(
              monthIndex: p.monthIndex,
              label: p.label,
              balancePaise: p.incomePaise,
              incomePaise: p.incomePaise,
              expensePaise: 0,
              netPaise: p.incomePaise,
            ),
          )
          .toList(),
      expenseTrend: simulation.timeline
          .map(
            (p) => ForecastTimelinePoint(
              monthIndex: p.monthIndex,
              label: p.label,
              balancePaise: p.expensePaise,
              incomePaise: 0,
              expensePaise: p.expensePaise,
              netPaise: -p.expensePaise,
            ),
          )
          .toList(),
      goalForecasts: goalForecasts,
      insights: insights,
      risks: risks,
      recommendations: recommendations,
      scenarioPresets: presets,
      activeAdjustments: adjustments,
      generatedAt: clock,
    );
  }

  static ScenarioResult simulatePreset({
    required SavingsForecastInput input,
    required ScenarioPreset preset,
    ForecastPeriod period = ForecastPeriod.year1,
    DateTime? now,
  }) {
    final baseline = build(input: input, selectedPeriod: period, now: now);
    final adjusted = build(
      input: input,
      selectedPeriod: period,
      adjustments: preset.adjustments,
      now: now,
    );
    return ScenarioResult(
      preset: preset,
      periodSummary: adjusted.periodSummary,
      deltaSavingsPaise: adjusted.periodSummary.projectedSavingsPaise -
          baseline.periodSummary.projectedSavingsPaise,
      headline: _scenarioHeadline(preset, adjusted.periodSummary),
    );
  }

  static _SimulationResult _simulate({
    required SavingsForecastInput input,
    required ForecastAdjustments adjustments,
    required int horizonMonths,
    required DateTime clock,
  }) {
    var balance = input.currentBalancePaise;
    final timeline = <ForecastTimelinePoint>[];
    var totalIncome = 0;
    var totalExpenses = 0;

    final monthlyIncome = (input.monthlySalaryPaise + adjustments.salaryDeltaPaise)
        .clamp(0, 99999999999);
    final baseVariableSpend = (input.avgMonthlySpentPaise -
            input.subscriptionMonthlyPaise -
            input.goalContributionsMonthlyPaise)
        .clamp(0, 99999999999);
    final variableSpend = (baseVariableSpend +
            adjustments.spendingDeltaPaise +
            adjustments.categoryReductionPaise)
        .clamp(0, 99999999999);
    final subscriptionSpend = (input.subscriptionMonthlyPaise -
            adjustments.subscriptionCancelPaise)
        .clamp(0, 99999999999);
    final goalContrib = input.goalContributionsMonthlyPaise +
        adjustments.newGoalContributionPaise +
        adjustments.extraSavingsPaise;
    final loanPay = input.loanMonthlyPaise + adjustments.loanPaymentPaise;

    var netMonthlySum = 0;

    for (var m = 1; m <= horizonMonths; m++) {
      final monthDate = DateTime(clock.year, clock.month + m, 1);
      final seasonal = _seasonalFactor(monthDate.month);
      var income = monthlyIncome;
      var expenses = ((subscriptionSpend + goalContrib + loanPay + variableSpend) *
              seasonal)
          .round();

      if (m == 1) {
        income += adjustments.oneTimeBonusPaise;
        expenses += adjustments.oneTimeExpensePaise;
      }

      final net = income - expenses;
      balance += net;
      totalIncome += income;
      totalExpenses += expenses;
      netMonthlySum += net;

      timeline.add(
        ForecastTimelinePoint(
          monthIndex: m,
          label: _monthLabel(monthDate),
          balancePaise: balance,
          incomePaise: income,
          expensePaise: expenses,
          netPaise: net,
        ),
      );
    }

    return _SimulationResult(
      timeline: timeline,
      endingBalance: balance,
      totalIncome: totalIncome,
      totalExpenses: totalExpenses,
      netMonthlyPaise: horizonMonths > 0
          ? (netMonthlySum / horizonMonths).round()
          : input.avgMonthlyNetSavingsPaise,
    );
  }

  static ForecastPeriodSummary _summaryFromSimulation({
    required ForecastPeriod period,
    required int horizonMonths,
    required _SimulationResult simulation,
    required SavingsForecastInput input,
  }) {
    final monthlyExpenses = horizonMonths > 0
        ? (simulation.totalExpenses / horizonMonths).round()
        : input.avgMonthlySpentPaise;
    final emergencyMonths = monthlyExpenses > 0
        ? simulation.endingBalance / monthlyExpenses
        : 0.0;

    return ForecastPeriodSummary(
      period: period,
      horizonMonths: horizonMonths,
      projectedSavingsPaise: simulation.endingBalance,
      expectedIncomePaise: simulation.totalIncome,
      expectedExpensesPaise: simulation.totalExpenses,
      netCashFlowPaise: simulation.totalIncome - simulation.totalExpenses,
      emergencyFundMonths: emergencyMonths,
      investmentPotentialPaise:
          (simulation.endingBalance * 1.08).round().clamp(0, 99999999999),
    );
  }

  static List<GoalCompletionForecast> _goalForecasts({
    required List<SavingsGoalSnapshot> goals,
    required int monthlyNetSavings,
    required DateTime clock,
  }) {
    return goals.map((goal) {
      final contrib = goal.monthlyContributionPaise > 0
          ? goal.monthlyContributionPaise
          : (monthlyNetSavings * 0.15).round().clamp(10000, monthlyNetSavings);
      final effectiveContrib = contrib > 0 ? contrib : 1;
      final months =
          (goal.remainingPaise / effectiveContrib).ceil().clamp(0, 600);
      final projected = months > 0
          ? DateTime(clock.year, clock.month + months, clock.day)
          : clock;

      var monthsDelayed = 0;
      if (goal.targetDate != null && projected.isAfter(goal.targetDate!)) {
        monthsDelayed = ((projected.difference(goal.targetDate!).inDays) / 30)
            .ceil()
            .clamp(0, 120);
      }

      return GoalCompletionForecast(
        goalId: goal.id,
        name: goal.name,
        monthsToComplete: months,
        monthsDelayed: monthsDelayed,
        onTrack: monthsDelayed == 0,
        projectedCompletion: months > 0 ? projected : null,
      );
    }).toList();
  }

  static List<ForecastInsight> _insights({
    required SavingsForecastInput input,
    required ForecastPeriodSummary periodSummary,
    required List<GoalCompletionForecast> goalForecasts,
    required ForecastAdjustments adjustments,
    required int horizonMonths,
  }) {
    final insights = <ForecastInsight>[];

    if (adjustments.categoryReductionPaise < 0 &&
        adjustments.categoryReductionName != null) {
      final monthly = -adjustments.categoryReductionPaise;
      insights.add(ForecastInsight(
        message:
            'Reducing ${adjustments.categoryReductionName} spending by ${formatPaise(monthly)}/month saves ${formatPaise(monthly * 12)} annually.',
        severity: 'info',
      ));
    }

    if (adjustments.subscriptionCancelPaise > 0 &&
        adjustments.affectedGoalName != null) {
      final monthsSaved = adjustments.subscriptionCancelPaise > 0
          ? (adjustments.subscriptionCancelPaise / 50000).ceil().clamp(1, 12)
          : 2;
      insights.add(ForecastInsight(
        message:
            'Cancelling ${adjustments.cancelledSubscriptionName ?? 'a subscription'} allows your ${adjustments.affectedGoalName} goal to finish ~$monthsSaved month${monthsSaved == 1 ? '' : 's'} earlier.',
        severity: 'info',
      ));
    }

    if (horizonMonths >= 12) {
      insights.add(ForecastInsight(
        message:
            'You are projected to save ${formatPaiseCompact(periodSummary.projectedSavingsPaise)} this year.',
        severity: 'info',
      ));
    }

    for (final goal in goalForecasts) {
      if (goal.monthsDelayed > 0) {
        insights.add(ForecastInsight(
          message:
              'Current spending habits will delay your ${goal.name} goal by ${goal.monthsDelayed} month${goal.monthsDelayed == 1 ? '' : 's'}.',
          severity: 'warning',
        ));
      }
    }

    if (input.savingsRatePercent >= 20) {
      insights.add(ForecastInsight(
        message:
            'You save ${input.savingsRatePercent.toStringAsFixed(0)}% of income — strong momentum.',
        severity: 'info',
      ));
    } else if (input.savingsRatePercent < 5 && input.monthlySalaryPaise > 0) {
      insights.add(ForecastInsight(
        message:
            'At current habits, savings grow slowly — small cuts compound quickly.',
        severity: 'warning',
      ));
    }

    if (periodSummary.netCashFlowPaise > 0) {
      insights.add(ForecastInsight(
        message:
            'Net cash flow over this period: ${formatPaise(periodSummary.netCashFlowPaise)}.',
        severity: 'info',
      ));
    }

    return insights.take(6).toList();
  }

  static List<ForecastRisk> _risks({
    required SavingsForecastInput input,
    required ForecastPeriodSummary periodSummary,
  }) {
    final risks = <ForecastRisk>[];

    if (input.avgMonthlyNetSavingsPaise < 0) {
      risks.add(ForecastRisk(
        kind: ForecastRiskKind.overspending,
        title: 'Overspending risk',
        detail:
            'Recent cycles spend more than you earn on average.',
        severity: 'critical',
      ));
    }

    if (periodSummary.projectedSavingsPaise < input.currentBalancePaise) {
      risks.add(ForecastRisk(
        kind: ForecastRiskKind.cashShortage,
        title: 'Cash shortage projected',
        detail: 'Balance may shrink at current spending pace.',
        severity: 'warning',
      ));
    }

    if (periodSummary.emergencyFundMonths < 3 &&
        input.avgMonthlySpentPaise > 0) {
      risks.add(ForecastRisk(
        kind: ForecastRiskKind.lowEmergencyFund,
        title: 'Low emergency fund',
        detail:
            'Projected buffer is ${periodSummary.emergencyFundMonths.toStringAsFixed(1)} months of expenses — aim for 3+.',
        severity: 'warning',
      ));
    }

    if (input.monthlySalaryPaise > 0 &&
        input.subscriptionMonthlyPaise / input.monthlySalaryPaise > 0.12) {
      risks.add(ForecastRisk(
        kind: ForecastRiskKind.highSubscriptionBurden,
        title: 'High subscription burden',
        detail:
            'Subscriptions are ${(input.subscriptionMonthlyPaise / input.monthlySalaryPaise * 100).toStringAsFixed(0)}% of income.',
        severity: 'warning',
      ));
    }

    if (input.budgetAdherencePercent < 60 &&
        input.budgetAdherencePercent > 0) {
      risks.add(ForecastRisk(
        kind: ForecastRiskKind.budgetInstability,
        title: 'Budget instability',
        detail:
            'Only ${input.budgetAdherencePercent.toStringAsFixed(0)}% of spending groups stayed on track.',
        severity: 'info',
      ));
    }

    final delayedGoals = input.goals.where((g) {
      if (g.targetDate == null) return false;
      return g.targetDate!.isBefore(
        DateTime.now().add(const Duration(days: 180)),
      );
    });
    if (delayedGoals.isNotEmpty) {
      risks.add(ForecastRisk(
        kind: ForecastRiskKind.goalDelay,
        title: 'Goal deadline pressure',
        detail:
            '${delayedGoals.length} goal${delayedGoals.length == 1 ? '' : 's'} due within 6 months need faster contributions.',
        severity: 'warning',
      ));
    }

    return risks;
  }

  static List<ForecastRecommendation> _recommendations({
    required SavingsForecastInput input,
    required List<ForecastRisk> risks,
    required ForecastPeriodSummary periodSummary,
  }) {
    final recs = <ForecastRecommendation>[];

    if (risks.any((r) => r.kind == ForecastRiskKind.lowEmergencyFund)) {
      recs.add(const ForecastRecommendation(
        title: 'Build emergency fund',
        detail: 'Aim for 3 months of expenses before discretionary goals.',
        actionKind: 'emergency_fund',
      ));
    }

    if (risks.any((r) => r.kind == ForecastRiskKind.highSubscriptionBurden)) {
      recs.add(const ForecastRecommendation(
        title: 'Optimize subscriptions',
        detail: 'Review recurring services in Subscription Health.',
        actionKind: 'subscriptions',
      ));
    }

    if (input.savingsRatePercent < 15 && input.monthlySalaryPaise > 0) {
      recs.add(const ForecastRecommendation(
        title: 'Increase savings',
        detail: 'Try auto-transferring 10% of salary on payday.',
        actionKind: 'increase_savings',
      ));
    }

    final topCategory = input.categoryMonthlyAvg.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (topCategory.isNotEmpty) {
      recs.add(ForecastRecommendation(
        title: 'Reduce ${topCategory.first.key}',
        detail:
            'Your highest variable category averages ${formatPaise(topCategory.first.value)}/month.',
        actionKind: 'reduce_category',
      ));
    }

    if (periodSummary.emergencyFundMonths >= 3) {
      recs.add(const ForecastRecommendation(
        title: 'Investment potential',
        detail:
            'With a solid buffer, consider setting aside more in your savings goals.',
        actionKind: 'invest',
      ));
    }

    if (input.healthScore < 70) {
      recs.add(const ForecastRecommendation(
        title: 'Improve financial health score',
        detail: 'Small wins in budget and debt improve your overall score.',
        actionKind: 'health_score',
      ));
    }

    return recs.take(5).toList();
  }

  static List<ScenarioPreset> _scenarioPresets(SavingsForecastInput input) {
    final foodAvg = input.categoryMonthlyAvg['Food'] ?? 50000;
    final subPaise = input.largestSubscriptionPaise > 0
        ? input.largestSubscriptionPaise
        : input.subscriptionMonthlyPaise > 0
            ? (input.subscriptionMonthlyPaise / 2).round()
            : 49900;
    final firstGoal = input.goals.isNotEmpty ? input.goals.first : null;

    return [
      ScenarioPreset(
        kind: ForecastScenarioKind.increaseSalary,
        label: 'Increase salary',
        description: '+10% income boost',
        adjustments: ForecastAdjustments(
          salaryDeltaPaise: (input.monthlySalaryPaise * 0.1).round(),
        ),
      ),
      ScenarioPreset(
        kind: ForecastScenarioKind.reduceSpending,
        label: 'Reduce spending',
        description: 'Cut variable spend by 10%',
        adjustments: ForecastAdjustments(
          spendingDeltaPaise: -(input.avgMonthlySpentPaise * 0.1).round(),
        ),
      ),
      ScenarioPreset(
        kind: ForecastScenarioKind.cancelSubscription,
        label: 'Cancel subscription',
        description: input.largestSubscriptionName ?? 'Drop one recurring bill',
        adjustments: ForecastAdjustments(
          subscriptionCancelPaise: subPaise,
          cancelledSubscriptionName: input.largestSubscriptionName ?? 'Netflix',
          affectedGoalName: firstGoal?.name ?? 'your next goal',
        ),
      ),
      ScenarioPreset(
        kind: ForecastScenarioKind.increaseSavings,
        label: 'Increase savings',
        description: '+₹2,000/month to savings',
        adjustments: const ForecastAdjustments(extraSavingsPaise: 200000),
      ),
      ScenarioPreset(
        kind: ForecastScenarioKind.newGoal,
        label: 'New goal',
        description: 'Add ₹1,500/month goal contribution',
        adjustments: const ForecastAdjustments(
          newGoalContributionPaise: 150000,
        ),
      ),
      ScenarioPreset(
        kind: ForecastScenarioKind.unexpectedExpense,
        label: 'Unexpected expense',
        description: 'One-time ₹15,000 hit',
        adjustments: const ForecastAdjustments(oneTimeExpensePaise: 1500000),
      ),
      ScenarioPreset(
        kind: ForecastScenarioKind.loanPayment,
        label: 'New loan EMI',
        description: '+₹5,000/month repayment',
        adjustments: const ForecastAdjustments(loanPaymentPaise: 500000),
      ),
      ScenarioPreset(
        kind: ForecastScenarioKind.bonus,
        label: 'Bonus',
        description: 'One-time ₹25,000 bonus',
        adjustments: const ForecastAdjustments(oneTimeBonusPaise: 2500000),
      ),
      if (foodAvg > 0)
        ScenarioPreset(
          kind: ForecastScenarioKind.reduceSpending,
          label: 'Cut food spend',
          description: 'Reduce food by ₹500/month',
          adjustments: ForecastAdjustments(
            categoryReductionPaise: -50000,
            categoryReductionName: 'Food',
          ),
        ),
    ];
  }

  static String _scenarioHeadline(
    ScenarioPreset preset,
    ForecastPeriodSummary summary,
  ) {
    return switch (preset.kind) {
      ForecastScenarioKind.increaseSalary =>
        'Higher income → ${formatPaise(summary.projectedSavingsPaise)} saved',
      ForecastScenarioKind.reduceSpending ||
      ForecastScenarioKind.cancelSubscription =>
        'Spending cut → ${formatPaise(summary.projectedSavingsPaise)} projected',
      ForecastScenarioKind.increaseSavings ||
      ForecastScenarioKind.newGoal =>
        'More saved → ${formatPaise(summary.projectedSavingsPaise)} balance',
      ForecastScenarioKind.unexpectedExpense ||
      ForecastScenarioKind.loanPayment =>
        'Tighter path → ${formatPaise(summary.projectedSavingsPaise)} remaining',
      ForecastScenarioKind.bonus =>
        'Bonus boost → ${formatPaise(summary.projectedSavingsPaise)} projected',
      _ => 'Projected savings: ${formatPaise(summary.projectedSavingsPaise)}',
    };
  }

  static double _seasonalFactor(int month) {
    return switch (month) {
      11 || 12 => 1.08,
      3 || 4 || 10 => 1.05,
      _ => 1.0,
    };
  }

  static String _monthLabel(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.year % 100}';
  }

  static String formatPaiseCompact(int paise) {
    final rupees = paise / 100;
    if (rupees >= 100000) {
      final lakhs = rupees / 100000;
      return '₹${lakhs.toStringAsFixed(1)} Lakhs';
    }
    return formatPaise(paise);
  }
}

class _SimulationResult {
  const _SimulationResult({
    required this.timeline,
    required this.endingBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netMonthlyPaise,
  });

  final List<ForecastTimelinePoint> timeline;
  final int endingBalance;
  final int totalIncome;
  final int totalExpenses;
  final int netMonthlyPaise;
}
