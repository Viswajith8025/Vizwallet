import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_closing_report.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_report_engine.dart';

void main() {
  test('percentChange handles zero previous', () {
    expect(MonthlyReportEngine.percentChange(100, 0), isNull);
    expect(MonthlyReportEngine.percentChange(150, 100), 50);
  });

  test('buildComparison computes deltas', () {
    final c = MonthlyReportEngine.buildComparison(
      previousCycleLabel: 'May cycle',
      incomePaise: 100000,
      expensesPaise: 60000,
      savingsPaise: 40000,
      previousIncomePaise: 100000,
      previousExpensesPaise: 50000,
      previousSavingsPaise: 50000,
    );
    expect(c.expenseChangePercent, 20);
    expect(c.savingsChangePercent, -20);
  });

  test('report json roundtrip', () {
    final report = MonthlyClosingReport(
      cycleKey: '2026-05-01',
      cycleLabel: 'May 2026',
      generatedAt: DateTime.utc(2026, 6, 1),
      incomePaise: 100000,
      expensesPaise: 70000,
      savingsPaise: 30000,
      savingsRatePercent: 30,
      carryOverPaise: 0,
      averageDailySpendPaise: 2000,
      cycleDayCount: 30,
      topCategories: const [],
      largestPurchase: null,
      majorPurchases: const [],
      subscriptions: const SubscriptionReportSection(
        cycleSpendPaise: 0,
        monthlyRecurringPaise: 0,
        salarySharePercent: 0,
        activeCount: 0,
      ),
      loans: const LoanReportSection(
        pendingBorrowedPaise: 0,
        overdueCount: 0,
        activeLoanCount: 0,
      ),
      healthScore: 72,
      healthTrendDelta: 5,
      healthMotivation: 'Good',
      trendSummaries: const [],
      goalsAchieved: const [],
      goalsMissed: const [],
      budgetBuckets: const [],
      budgetOnTrackPercent: 0,
      comparison: const CycleComparison(
        previousCycleLabel: 'Apr',
        previousIncomePaise: 0,
        previousExpensesPaise: 0,
        previousSavingsPaise: 0,
        expenseChangePercent: null,
        savingsChangePercent: null,
        incomeChangePercent: null,
      ),
    );

    final restored = MonthlyClosingReport.fromJson(report.toJson());
    expect(restored.cycleKey, report.cycleKey);
    expect(restored.savingsPaise, 30000);
  });
}
