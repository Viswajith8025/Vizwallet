import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/monthly_report/domain/ai_monthly_review.dart';
import 'package:rupee_track/features/monthly_report/domain/ai_monthly_review_engine.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_closing_report.dart';

void main() {
  MonthlyClosingReport sampleReport({
    int savingsPaise = 30000,
    double savingsRate = 30,
    double expenseChange = -18,
  }) {
    return MonthlyClosingReport(
      cycleKey: '2026-05-01',
      cycleLabel: 'May 2026',
      generatedAt: DateTime.utc(2026, 6, 1),
      incomePaise: 100000,
      expensesPaise: 70000,
      savingsPaise: savingsPaise,
      savingsRatePercent: savingsRate,
      carryOverPaise: 0,
      averageDailySpendPaise: 2000,
      cycleDayCount: 30,
      topCategories: const [
        CategoryReportLine(
          name: 'Food',
          totalPaise: 25000,
          sharePercent: 35,
          colorValue: 0xFFFF5722,
        ),
      ],
      largestPurchase: null,
      majorPurchases: const [],
      subscriptions: const SubscriptionReportSection(
        cycleSpendPaise: 5000,
        monthlyRecurringPaise: 5000,
        salarySharePercent: 5,
        activeCount: 2,
      ),
      loans: const LoanReportSection(
        pendingBorrowedPaise: 0,
        overdueCount: 0,
        activeLoanCount: 0,
      ),
      healthScore: 78,
      healthTrendDelta: 6,
      healthMotivation: 'Great progress',
      trendSummaries: const ['Food was your top category.'],
      goalsAchieved: const [
        GoalLine(title: 'Savings target', detail: 'Saved 30% of income'),
      ],
      goalsMissed: const [],
      budgetBuckets: const [
        BudgetBucketLine(
          name: 'Food',
          allocatedPaise: 30000,
          spentPaise: 25000,
          percentUsed: 83,
          onTrack: true,
        ),
      ],
      budgetOnTrackPercent: 100,
      comparison: CycleComparison(
        previousCycleLabel: 'Apr',
        previousIncomePaise: 100000,
        previousExpensesPaise: 85000,
        previousSavingsPaise: 15000,
        expenseChangePercent: expenseChange,
        savingsChangePercent: 100,
        incomeChangePercent: 0,
      ),
    );
  }

  test('generates motivating insights from comparison', () {
    final review = AiMonthlyReviewEngine.build(
      report: sampleReport(),
      behaviourStats: const CycleBehaviourStats(
        noSpendDays: 4,
        consecutiveBudgetDays: 12,
        expenseLogCount: 22,
      ),
    );

    expect(review.insights.any((i) => i.contains('less than last month')), isTrue);
    expect(review.achievements, isNotEmpty);
    expect(review.recommendations, isNotEmpty);
    expect(review.headline, isNotEmpty);
  });

  test('detects record savings highlight', () {
    final current = sampleReport(savingsPaise: 50000);
    final older = sampleReport(savingsPaise: 20000);
    final review = AiMonthlyReviewEngine.build(
      report: current,
      behaviourStats: const CycleBehaviourStats(
        noSpendDays: 0,
        consecutiveBudgetDays: 0,
        expenseLogCount: 10,
      ),
      historicalReports: [older],
    );
    expect(review.savingsHighlight, contains('highest'));
  });

  test('ai review json roundtrip', () {
    final review = AiMonthlyReviewEngine.buildFromReportOnly(sampleReport());
    final restored = AiMonthlyReview.fromJson(review.toJson());
    expect(restored.headline, review.headline);
    expect(restored.insights, review.insights);
  });
}
