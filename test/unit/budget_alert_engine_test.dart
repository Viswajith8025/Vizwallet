import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';
import 'package:rupee_track/features/budget/domain/bucket_status.dart';
import 'package:rupee_track/features/budget_alerts/domain/budget_alert_engine.dart';

void main() {
  group('BudgetAlertEngine', () {
    BudgetPlanStatus plan({
      required int foodSpent,
      required int foodBudget,
      int shopSpent = 0,
      int shopBudget = 100000,
    }) {
      return BudgetPlanStatus(
        monthKey: '2026-06-17',
        salaryPaise: 2500000,
        allocationMode: AllocationMode.percentage,
        rolloverEnabled: true,
        buckets: [
          BucketStatus(
            bucketKey: 'food',
            displayName: 'Food',
            categoryId: 1,
            bucketType: BucketType.spending,
            allocatedPaise: foodBudget,
            rolloverPaise: 0,
            spentPaise: foodSpent,
            daysRemaining: 10,
            alertLevel: BudgetAlertLevel.none,
          ),
          BucketStatus(
            bucketKey: 'shopping',
            displayName: 'Shopping',
            categoryId: 2,
            bucketType: BucketType.spending,
            allocatedPaise: shopBudget,
            rolloverPaise: 0,
            spentPaise: shopSpent,
            daysRemaining: 10,
            alertLevel: BudgetAlertLevel.none,
          ),
        ],
        insights: const [],
      );
    }

    test('generates almost exhausted message at 90%', () {
      final alerts = BudgetAlertEngine.generateAlerts(
        plan: plan(foodSpent: 92000, foodBudget: 100000),
      );
      expect(
        alerts.any((a) => a.message.contains('almost exhausted')),
        isTrue,
      );
    });

    test('generates over budget message', () {
      final alerts = BudgetAlertEngine.generateAlerts(
        plan: plan(foodSpent: 0, foodBudget: 100000, shopSpent: 109200, shopBudget: 100000),
      );
      final shop = alerts.where((a) => a.bucketKey == 'shopping').first;
      expect(shop.message, contains('exceeded budget'));
    });

    test('groups similar alerts', () {
      final alerts = BudgetAlertEngine.generateAlerts(
        plan: plan(foodSpent: 55000, foodBudget: 100000, shopSpent: 60000),
      );
      final groups = BudgetAlertEngine.groupAlerts(alerts);
      expect(groups, isNotEmpty);
    });

    test('builds daily summary', () {
      final alerts = BudgetAlertEngine.generateAlerts(
        plan: plan(foodSpent: 95000, foodBudget: 100000),
      );
      final summary = BudgetAlertEngine.buildDailySummary(alerts);
      expect(summary, contains('budget check'));
    });
  });
}
