import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/daos/expenses_dao.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_engine.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_models.dart';

ExpenseWithCategory _expense({
  required int id,
  required int amount,
  required DateTime occurredAt,
  String title = 'Coffee',
}) {
  final now = DateTime.utc(2026, 6, 1);
  return ExpenseWithCategory(
    expense: ExpensesTableData(
      id: id,
      amountPaise: amount,
      categoryId: 1,
      title: title,
      description: null,
      occurredAt: occurredAt,
      monthKey: '2026-06-17',
      paymentMethod: 'UPI',
      tags: '[]',
      notes: null,
      autoLabels: '[]',
      isDeleted: false,
      subscriptionId: null,
      createdAt: now,
      updatedAt: now,
    ),
    category: CategoriesTableData(
      id: 1,
      name: 'Food',
      slug: 'food',
      iconName: 'restaurant',
      colorValue: 0xFFFF6B6B,
      isSystem: true,
      countsTowardSpending: true,
      sortOrder: 1,
      isDeleted: false,
    ),
  );
}

void main() {
  group('ExpenseHeatmapEngine', () {
    test('builds grid with no-spend and spending days', () {
      final start = DateTime(2026, 6, 1);
      final end = DateTime(2026, 6, 7);
      final report = ExpenseHeatmapEngine.build(
        viewMode: HeatmapViewMode.monthly,
        rangeStartIst: start,
        rangeEndIst: end,
        expenses: [
          _expense(
            id: 1,
            amount: 50000,
            occurredAt: DateTime.utc(2026, 6, 2).subtract(
              const Duration(hours: 5, minutes: 30),
            ),
          ),
        ],
        incomeByDay: const [],
        thresholds: const HeatmapThresholds(
          veryLowMaxPaise: 30000,
          mediumMaxPaise: 80000,
          highMaxPaise: 150000,
        ),
        filters: const HeatmapFilters(),
        now: DateTime(2026, 6, 15),
      );

      expect(report.statistics.noSpendDays, greaterThan(0));
      expect(report.weeks, isNotEmpty);
      expect(report.statistics.highestSpendingPaise, 50000);
    });

    test('resolveRange monthly bounds', () {
      final range = ExpenseHeatmapEngine.resolveRange(
        mode: HeatmapViewMode.monthly,
        anchorIst: DateTime(2026, 6, 15),
        salaryDay: 17,
      );
      expect(range.startIst, DateTime(2026, 6, 1));
      expect(range.endIst, DateTime(2026, 6, 30));
    });

    test('threshold levels map correctly', () {
      const thresholds = HeatmapThresholds(
        veryLowMaxPaise: 10000,
        mediumMaxPaise: 50000,
        highMaxPaise: 100000,
      );
      expect(thresholds.levelFor(0), HeatmapIntensityLevel.none);
      expect(thresholds.levelFor(5000), HeatmapIntensityLevel.veryLow);
      expect(thresholds.levelFor(40000), HeatmapIntensityLevel.medium);
      expect(thresholds.levelFor(90000), HeatmapIntensityLevel.high);
      expect(thresholds.levelFor(200000), HeatmapIntensityLevel.veryHigh);
    });

    test('generates weekend spending insight', () {
      final start = DateTime(2026, 6, 1);
      final end = DateTime(2026, 6, 14);
      final expenses = <ExpenseWithCategory>[];
      for (var d = 1; d <= 14; d++) {
        final date = DateTime(2026, 6, d);
        final isWeekend =
            date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
        expenses.add(
          _expense(
            id: d,
            amount: isWeekend ? 80000 : 10000,
            occurredAt: DateTime.utc(2026, 6, d).subtract(
              const Duration(hours: 5, minutes: 30),
            ),
          ),
        );
      }

      final report = ExpenseHeatmapEngine.build(
        viewMode: HeatmapViewMode.monthly,
        rangeStartIst: start,
        rangeEndIst: end,
        expenses: expenses,
        incomeByDay: const [],
        thresholds: HeatmapThresholds.fromAverageDaily(40000),
        filters: const HeatmapFilters(),
        now: DateTime(2026, 6, 15),
      );

      expect(
        report.insights.any((i) => i.message.toLowerCase().contains('weekend')),
        isTrue,
      );
    });

    test('tracks longest no spend streak', () {
      final report = ExpenseHeatmapEngine.build(
        viewMode: HeatmapViewMode.monthly,
        rangeStartIst: DateTime(2026, 6, 1),
        rangeEndIst: DateTime(2026, 6, 10),
        expenses: [
          _expense(
            id: 1,
            amount: 10000,
            occurredAt: DateTime.utc(2026, 6, 10).subtract(
              const Duration(hours: 5, minutes: 30),
            ),
          ),
        ],
        incomeByDay: const [],
        thresholds: HeatmapThresholds.fromAverageDaily(50000),
        filters: const HeatmapFilters(),
        now: DateTime(2026, 6, 15),
      );

      expect(report.statistics.longestNoSpendStreak, greaterThanOrEqualTo(8));
    });
  });
}
