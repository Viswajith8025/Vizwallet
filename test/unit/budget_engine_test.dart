import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';
import 'package:rupee_track/features/budget/domain/budget_engine.dart';
import 'package:rupee_track/features/budget/domain/budget_templates.dart';

void main() {
  group('BudgetEngine', () {
    const salary = 2500000; // ₹25,000

    test('percentage template sums to salary', () {
      final allocations = BudgetEngine.fromPercentageTemplate(
        salaryPaise: salary,
        categorySlugToId: {'food': 1, 'transport': 2},
      );
      final total =
          allocations.fold<int>(0, (s, b) => s + b.allocatedPaise);
      expect(total, salary);
      expect(allocations.length, defaultBudgetTemplates.length);
    });

    test('alert levels at thresholds', () {
      expect(
        BudgetEngine.alertLevelForPercent(49),
        BudgetAlertLevel.none,
      );
      expect(
        BudgetEngine.alertLevelForPercent(50),
        BudgetAlertLevel.watch50,
      );
      expect(
        BudgetEngine.alertLevelForPercent(76),
        BudgetAlertLevel.watch75,
      );
      expect(
        BudgetEngine.alertLevelForPercent(95),
        BudgetAlertLevel.critical90,
      );
      expect(
        BudgetEngine.alertLevelForPercent(100),
        BudgetAlertLevel.exceeded,
      );
    });

    test('computeBucketStatuses calculates remaining and daily allowance', () {
      final statuses = BudgetEngine.computeBucketStatuses(
        allocations: [
          const BucketAllocationInput(
            bucketKey: 'food',
            displayName: 'Food',
            categoryId: 1,
            bucketType: BucketType.spending,
            allocatedPaise: 100000,
            rolloverPaise: 0,
          ),
        ],
        spentByCategoryId: {1: 40000},
        daysRemaining: 10,
      );

      expect(statuses.single.remainingPaise, 60000);
      expect(statuses.single.dailyAllowancePaise, 6000);
      expect(statuses.single.percentUsed, 40);
    });

    test('rollover adds to bucket budget', () {
      final rolled = BudgetEngine.applyRollover(
        allocations: [
          const BucketAllocationInput(
            bucketKey: 'food',
            displayName: 'Food',
            categoryId: 1,
            bucketType: BucketType.spending,
            allocatedPaise: 100000,
          ),
        ],
        previousRemainingByBucketKey: {'food': 5000},
      );
      expect(rolled.single.rolloverPaise, 5000);
    });
  });
}
