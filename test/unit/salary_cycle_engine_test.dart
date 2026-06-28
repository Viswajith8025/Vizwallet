import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';

void main() {
  group('SalaryCycleEngine', () {
    final june20 = DateTime.utc(2026, 6, 20, 6, 30); // noon IST Jun 20
    final june10 = DateTime.utc(2026, 6, 10, 6, 30);

    test('cycle key for salary day 17', () {
      expect(
        SalaryCycleEngine.cycleKeyFromDate(june20, salaryDay: 17),
        '2026-06-17',
      );
      expect(
        SalaryCycleEngine.cycleKeyFromDate(june10, salaryDay: 17),
        '2026-05-17',
      );
    });

    test('cycle bounds 17 Jun – 16 Jul', () {
      final bounds = SalaryCycleEngine.cycleBounds('2026-06-17', salaryDay: 17);
      expect(bounds.startIst, DateTime(2026, 6, 17));
      expect(bounds.endIst, DateTime(2026, 7, 16));
      expect(bounds.totalDays, 30);
    });

    test('salary on 31st clamps in short months', () {
      final feb15 = DateTime.utc(2025, 2, 15, 6, 30);
      expect(
        SalaryCycleEngine.cycleKeyFromDate(feb15, salaryDay: 31),
        '2025-01-31',
      );

      final bounds = SalaryCycleEngine.cycleBounds('2025-01-31', salaryDay: 31);
      expect(bounds.endIst, DateTime(2025, 2, 27));
    });

    test('leap year February for salary day 29', () {
      final mar1 = DateTime.utc(2024, 3, 1, 6, 30);
      expect(
        SalaryCycleEngine.cycleKeyFromDate(mar1, salaryDay: 29),
        '2024-02-29',
      );
      final bounds = SalaryCycleEngine.cycleBounds('2024-02-29', salaryDay: 29);
      expect(bounds.endIst, DateTime(2024, 3, 28));
    });

    test('days remaining in cycle on start day', () {
      final onStart = DateTime.utc(2026, 6, 17, 6, 30);
      expect(
        SalaryCycleEngine.daysRemainingInCycle(salaryDay: 17, from: onStart),
        30,
      );
    });

    test('days until next salary on pay day points to next month', () {
      final onPayDay = DateTime.utc(2026, 6, 17, 6, 30);
      expect(
        SalaryCycleEngine.daysUntilNextSalary(salaryDay: 17, from: onPayDay),
        30,
      );
    });

    test('previous cycle key across year boundary', () {
      expect(
        SalaryCycleEngine.previousCycleKey('2026-01-17', salaryDay: 17),
        '2025-12-17',
      );
    });

    test('carry-over balance only when positive', () {
      expect(
        SalaryCycleEngine.carryOverBalance(
          previousSalaryPaise: 2500000,
          previousSpentPaise: 2000000,
        ),
        500000,
      );
      expect(
        SalaryCycleEngine.carryOverBalance(
          previousSalaryPaise: 2500000,
          previousSpentPaise: 2600000,
        ),
        0,
      );
    });

    test('migrates legacy calendar month keys', () {
      expect(
        SalaryCycleEngine.migrateLegacyMonthKey('2026-06', salaryDay: 17),
        '2026-06-17',
      );
      expect(SalaryCycleEngine.isLegacyMonthKey('2026-06'), isTrue);
      expect(SalaryCycleEngine.isCycleKey('2026-06-17'), isTrue);
    });

    test('daily spending allowance', () {
      expect(
        SalaryCycleEngine.dailySpendingAllowance(
          moneyLeftPaise: 300000,
          daysRemaining: 10,
        ),
        30000,
      );
    });

    test('daily spending allowance is 0 when no days remain', () {
      expect(
        SalaryCycleEngine.dailySpendingAllowance(
          moneyLeftPaise: 300000,
          daysRemaining: 0,
        ),
        0,
      );
      expect(
        SalaryCycleEngine.dailySpendingAllowance(
          moneyLeftPaise: 300000,
          daysRemaining: -3,
        ),
        0,
      );
    });

    test('daily spending allowance is 0 when overspent', () {
      expect(
        SalaryCycleEngine.dailySpendingAllowance(
          moneyLeftPaise: -5000,
          daysRemaining: 10,
        ),
        0,
      );
    });
  });
}
