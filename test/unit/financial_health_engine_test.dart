import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/health_score/domain/financial_health_engine.dart';
import 'package:rupee_track/features/health_score/domain/financial_health_models.dart';

void main() {
  group('FinancialHealthEngine', () {
    FinancialHealthInput healthyInput() => const FinancialHealthInput(
          cycleKey: '2026-06-17',
          salaryPaise: 2500000,
          spentPaise: 1800000,
          carryOverPaise: 0,
          subscriptionMonthlyPaise: 100000,
          pendingBorrowedPaise: 0,
          overdueLoansCount: 0,
          impulsePurchasePaise: 50000,
          impulsePurchaseCount: 1,
          dailySpendsPaise: [50000, 52000, 48000, 51000],
          bucketsOverBudget: 0,
          bucketsOnTrack: 5,
          totalSpendingBuckets: 5,
          emergencyFundRemainingPercent: 95,
          savingsBucketTouched: false,
          previousCycleScore: 75,
          previousCycleSavingsPaise: 500000,
        );

    test('score is between 0 and 100', () {
      final report = FinancialHealthEngine.compute(input: healthyInput());
      expect(report.overallScore, inInclusiveRange(0, 100));
      expect(report.categories.length, 5);
    });

    test('no salary returns setup message', () {
      final report = FinancialHealthEngine.compute(
        input: healthyInput().copyWith(salaryPaise: 0),
      );
      expect(report.hasEnoughData, isFalse);
    });

    test('generates subscription recommendation when burden high', () {
      final report = FinancialHealthEngine.compute(
        input: healthyInput().copyWith(subscriptionMonthlyPaise: 400000),
      );
      expect(
        report.recommendations.any((r) => r.message.contains('subscription')),
        isTrue,
      );
    });

    test('motivation label is encouraging', () {
      final report = FinancialHealthEngine.compute(input: healthyInput());
      expect(report.motivationLabel, isNotEmpty);
      expect(report.motivationLabel.toLowerCase(), isNot(contains('bad')));
    });
  });
}

extension on FinancialHealthInput {
  FinancialHealthInput copyWith({
    int? salaryPaise,
    int? subscriptionMonthlyPaise,
  }) {
    return FinancialHealthInput(
      cycleKey: cycleKey,
      salaryPaise: salaryPaise ?? this.salaryPaise,
      spentPaise: spentPaise,
      carryOverPaise: carryOverPaise,
      subscriptionMonthlyPaise:
          subscriptionMonthlyPaise ?? this.subscriptionMonthlyPaise,
      pendingBorrowedPaise: pendingBorrowedPaise,
      overdueLoansCount: overdueLoansCount,
      impulsePurchasePaise: impulsePurchasePaise,
      impulsePurchaseCount: impulsePurchaseCount,
      dailySpendsPaise: dailySpendsPaise,
      bucketsOverBudget: bucketsOverBudget,
      bucketsOnTrack: bucketsOnTrack,
      totalSpendingBuckets: totalSpendingBuckets,
      emergencyFundRemainingPercent: emergencyFundRemainingPercent,
      savingsBucketTouched: savingsBucketTouched,
      previousCycleScore: previousCycleScore,
      previousCycleSavingsPaise: previousCycleSavingsPaise,
    );
  }
}
