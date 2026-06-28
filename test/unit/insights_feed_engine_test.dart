import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/insights/domain/insights_feed_engine.dart';
import 'package:rupee_track/features/insights/domain/insights_feed_models.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_report.dart';
import 'package:rupee_track/features/trends/domain/trends_comparison_mode.dart';

SpendingTrendsReport _emptyTrends() => SpendingTrendsReport(
      mode: TrendsComparisonMode.currentVsPreviousCycle,
      current: const PeriodSnapshot(
        label: 'Current',
        totalSpentPaise: 100000,
        expenses: [],
        dayCount: 10,
      ),
      summaries: const ['Food spending is steady.'],
      highestCategory: null,
      fastestGrowingCategory: null,
      timeSeries: const [],
      categoryComparisons: const [],
      heatMap: const [],
      weekendWeekday: const WeekendWeekdaySplit(
        weekdayPaise: 60000,
        weekendPaise: 40000,
      ),
      repeatedExpenses: const [],
      impulsePurchases: const ImpulsePurchaseSummary(
        count: 0,
        totalPaise: 0,
        examples: [],
      ),
      subscriptionTrend: const SubscriptionTrendSummary(
        currentPaise: 0,
        previousPaise: 0,
        activeMonthlyPaise: 0,
        salarySharePercent: 0,
      ),
      salaryPaise: 500000,
    );

void main() {
  group('InsightsFeedEngine', () {
    test('build returns daily tip and ranked items', () {
      final report = InsightsFeedEngine.build(
        InsightsFeedInput(
          cycleKey: '2026-06',
          salaryDay: 1,
          trends: _emptyTrends(),
          savingsRatePercent: 22,
        ),
      );

      expect(report.dailyTip.kind, InsightKind.tip);
      expect(report.items, isNotEmpty);
      expect(report.items.length, lessThanOrEqualTo(14));
    });

    test('prioritizes loan overdue insights', () {
      final report = InsightsFeedEngine.build(
        InsightsFeedInput(
          cycleKey: '2026-06',
          salaryDay: 1,
          trends: _emptyTrends(),
          overdueLoans: const [
            LoanOverdueSnapshot(
              personName: 'Rahul',
              balancePaise: 500000,
              daysOverdue: 6,
              daysUntilDue: null,
              isOverdue: true,
            ),
          ],
        ),
      );

      expect(
        report.items.any((i) => i.id.startsWith('loan-overdue')),
        isTrue,
      );
      expect(report.items.first.severity, InsightSeverity.critical);
    });

    test('limits items per category', () {
      final trends = SpendingTrendsReport(
        mode: TrendsComparisonMode.currentVsPreviousCycle,
        current: const PeriodSnapshot(
          label: 'Current',
          totalSpentPaise: 200000,
          expenses: [],
          dayCount: 10,
        ),
        comparison: const PeriodSnapshot(
          label: 'Prev',
          totalSpentPaise: 300000,
          expenses: [],
          dayCount: 10,
        ),
        summaries: const ['A', 'B', 'C', 'D'],
        highestCategory: null,
        fastestGrowingCategory: null,
        timeSeries: const [],
        categoryComparisons: const [],
        heatMap: const [],
        weekendWeekday: const WeekendWeekdaySplit(
          weekdayPaise: 100000,
          weekendPaise: 100000,
        ),
        repeatedExpenses: const [],
        impulsePurchases: const ImpulsePurchaseSummary(
          count: 2,
          totalPaise: 50000,
          examples: ['Amazon'],
        ),
        subscriptionTrend: const SubscriptionTrendSummary(
          currentPaise: 0,
          previousPaise: 0,
          activeMonthlyPaise: 0,
          salarySharePercent: 0,
        ),
        salaryPaise: 500000,
      );

      final report = InsightsFeedEngine.build(
        InsightsFeedInput(
          cycleKey: '2026-06',
          salaryDay: 1,
          trends: trends,
        ),
      );

      final spendingCount = report.items
          .where((i) => i.category == InsightCategory.spending)
          .length;
      expect(spendingCount, lessThanOrEqualTo(2));
    });
  });
}
