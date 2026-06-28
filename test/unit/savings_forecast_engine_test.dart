import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_engine.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_models.dart';

SavingsForecastInput _input({
  int salary = 5000000,
  int spent = 3500000,
  int balance = 1500000,
  int subs = 100000,
  List<SavingsGoalSnapshot> goals = const [],
}) {
  return SavingsForecastInput(
    cycleKey: '2026-06-17',
    currentBalancePaise: balance,
    monthlySalaryPaise: salary,
    avgMonthlySpentPaise: spent,
    avgMonthlyNetSavingsPaise: salary - spent,
    savingsRatePercent: ((salary - spent) / salary) * 100,
    subscriptionMonthlyPaise: subs,
    loanMonthlyPaise: 0,
    goalContributionsMonthlyPaise: 0,
    budgetAdherencePercent: 75,
    healthScore: 72,
    historicalCycleSpent: [spent, spent, spent],
    historicalSalaries: [salary, salary, salary],
    categoryMonthlyAvg: const {'Food': 800000},
    goals: goals,
    salaryDay: 17,
    largestSubscriptionName: 'Netflix',
    largestSubscriptionPaise: subs,
  );
}

void main() {
  group('SavingsForecastEngine', () {
    test('projects positive savings over 12 months', () {
      final report = SavingsForecastEngine.build(
        input: _input(),
        selectedPeriod: ForecastPeriod.year1,
        now: DateTime(2026, 6, 15),
      );

      expect(report.periodSummary.horizonMonths, 12);
      expect(
        report.periodSummary.projectedSavingsPaise,
        greaterThan(report.currentBalancePaise),
      );
      expect(report.savingsCurve.length, 12);
    });

    test('reduce spending scenario increases projected savings', () {
      final baseline = SavingsForecastEngine.build(
        input: _input(),
        selectedPeriod: ForecastPeriod.year1,
        now: DateTime(2026, 6, 15),
      );
      final reduced = SavingsForecastEngine.build(
        input: _input(),
        selectedPeriod: ForecastPeriod.year1,
        adjustments: const ForecastAdjustments(spendingDeltaPaise: -500000),
        now: DateTime(2026, 6, 15),
      );

      expect(
        reduced.periodSummary.projectedSavingsPaise,
        greaterThan(baseline.periodSummary.projectedSavingsPaise),
      );
    });

    test('cancel subscription insight references goal', () {
      final report = SavingsForecastEngine.build(
        input: _input(
          goals: const [
            SavingsGoalSnapshot(
              id: 1,
              name: 'Laptop',
              targetPaise: 6000000,
              savedPaise: 1000000,
              monthlyContributionPaise: 200000,
              isWishlist: false,
            ),
          ],
        ),
        selectedPeriod: ForecastPeriod.year1,
        adjustments: const ForecastAdjustments(
          subscriptionCancelPaise: 64900,
          cancelledSubscriptionName: 'Netflix',
          affectedGoalName: 'Laptop',
        ),
        now: DateTime(2026, 6, 15),
      );

      expect(
        report.insights.any((i) => i.message.contains('Laptop')),
        isTrue,
      );
    });

    test('flags overspending risk when net savings negative', () {
      final report = SavingsForecastEngine.build(
        input: _input(salary: 3000000, spent: 4000000, balance: 500000),
        selectedPeriod: ForecastPeriod.months6,
        now: DateTime(2026, 6, 15),
      );

      expect(
        report.risks.any((r) => r.kind == ForecastRiskKind.overspending),
        isTrue,
      );
    });

    test('goal forecast estimates months to complete', () {
      final report = SavingsForecastEngine.build(
        input: _input(
          goals: const [
            SavingsGoalSnapshot(
              id: 1,
              name: 'Bike',
              targetPaise: 10000000,
              savedPaise: 2000000,
              monthlyContributionPaise: 500000,
              isWishlist: true,
            ),
          ],
        ),
        selectedPeriod: ForecastPeriod.year1,
        now: DateTime(2026, 6, 15),
      );

      expect(report.goalForecasts.single.monthsToComplete, 16);
    });

    test('simulatePreset returns delta vs baseline', () {
      final input = _input();
      final preset = SavingsForecastEngine.build(input: input).scenarioPresets
          .firstWhere((p) => p.kind == ForecastScenarioKind.bonus);
      final result = SavingsForecastEngine.simulatePreset(
        input: input,
        preset: preset,
        now: DateTime(2026, 6, 15),
      );

      expect(result.deltaSavingsPaise, greaterThan(0));
    });
  });
}
