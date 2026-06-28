import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_engine.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_report.dart';
import 'package:rupee_track/features/trends/domain/trends_comparison_mode.dart';

void main() {
  group('SpendingTrendsEngine', () {
    final food = TrendExpense(
      id: 1,
      amountPaise: 180000,
      categoryId: 1,
      categoryName: 'Food',
      categorySlug: 'food',
      colorValue: 0xFFFF0000,
      title: 'Lunch',
      occurredAtUtc: DateTime.utc(2026, 6, 20),
      autoLabels: [],
    );
    final shopping = TrendExpense(
      id: 2,
      amountPaise: 50000,
      categoryId: 2,
      categoryName: 'Shopping',
      categorySlug: 'shopping',
      colorValue: 0xFF00FF00,
      title: 'Shirt',
      occurredAtUtc: DateTime.utc(2026, 6, 21),
      autoLabels: ['Major Expense'],
    );

    test('identifies highest category', () {
      final current = PeriodSnapshot(
        label: 'Current',
        totalSpentPaise: 230000,
        expenses: [food, shopping],
        dayCount: 10,
      );
      final report = SpendingTrendsEngine.build(
        mode: TrendsComparisonMode.currentVsPreviousCycle,
        current: current,
        series: [current],
        salaryPaise: 2500000,
        majorThresholdPaise: 10000,
        activeSubscriptionMonthlyPaise: 20000,
      );
      expect(report.highestCategory?.categoryName, 'Food');
    });

    test('generates natural language summaries', () {
      final prevFood = TrendExpense(
        id: 3,
        amountPaise: 150000,
        categoryId: 1,
        categoryName: 'Food',
        categorySlug: 'food',
        colorValue: 0xFFFF0000,
        title: 'Dinner',
        occurredAtUtc: DateTime.utc(2026, 5, 20),
        autoLabels: [],
      );
      final current = PeriodSnapshot(
        label: 'Jun',
        totalSpentPaise: 180000,
        expenses: [food],
        dayCount: 15,
      );
      final comparison = PeriodSnapshot(
        label: 'May',
        totalSpentPaise: 150000,
        expenses: [prevFood],
        dayCount: 15,
      );
      final report = SpendingTrendsEngine.build(
        mode: TrendsComparisonMode.currentVsPreviousCycle,
        current: current,
        comparison: comparison,
        series: [comparison, current],
        salaryPaise: 2500000,
        majorThresholdPaise: 10000,
        activeSubscriptionMonthlyPaise: 200000,
      );
      expect(
        report.summaries.any((s) => s.contains('Food')),
        isTrue,
      );
      expect(
        report.summaries.any((s) => s.contains('Subscriptions')),
        isTrue,
      );
    });

    test('detects repeated expenses', () {
      final dup = TrendExpense(
        id: 4,
        amountPaise: 5000,
        categoryId: 1,
        categoryName: 'Food',
        categorySlug: 'food',
        colorValue: 0xFFFF0000,
        title: 'Coffee',
        occurredAtUtc: DateTime.utc(2026, 6, 22),
        autoLabels: [],
      );
      final current = PeriodSnapshot(
        label: 'Current',
        totalSpentPaise: 10000,
        expenses: [dup, dup],
        dayCount: 5,
      );
      final report = SpendingTrendsEngine.build(
        mode: TrendsComparisonMode.currentVsPreviousCycle,
        current: current,
        series: [current],
        salaryPaise: 2500000,
        majorThresholdPaise: 10000,
        activeSubscriptionMonthlyPaise: 0,
      );
      expect(report.repeatedExpenses, isNotEmpty);
      expect(report.repeatedExpenses.first.title, 'Coffee');
    });

    test('cycleBoundsUtc returns timezone-independent UTC instants', () {
      // Cycle 2026-06-17 (salary day 17) spans 17 Jun – 16 Jul IST.
      // 17 Jun 00:00 IST == 16 Jun 18:30 UTC; the exclusive end is
      // 17 Jul 00:00 IST == 16 Jul 18:30 UTC. These must be exact regardless
      // of the device timezone (regression test for the double-offset bug).
      final bounds = SpendingTrendsEngine.cycleBoundsUtc(
        '2026-06-17',
        salaryDay: 17,
      );
      expect(bounds.startUtc.isUtc, isTrue);
      expect(bounds.endUtc.isUtc, isTrue);
      expect(bounds.startUtc, DateTime.utc(2026, 6, 16, 18, 30));
      expect(bounds.endUtc, DateTime.utc(2026, 7, 16, 18, 30));
    });
  });
}
