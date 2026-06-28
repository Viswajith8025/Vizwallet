import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';
import 'package:rupee_track/features/budget/domain/bucket_status.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_closing_report.dart';

abstract final class MonthlyReportEngine {
  static double? percentChange(int current, int previous) {
    if (previous == 0) return null;
    return ((current - previous) / previous) * 100;
  }

  static CycleComparison buildComparison({
    required String previousCycleLabel,
    required int incomePaise,
    required int expensesPaise,
    required int savingsPaise,
    required int previousIncomePaise,
    required int previousExpensesPaise,
    required int previousSavingsPaise,
  }) {
    return CycleComparison(
      previousCycleLabel: previousCycleLabel,
      previousIncomePaise: previousIncomePaise,
      previousExpensesPaise: previousExpensesPaise,
      previousSavingsPaise: previousSavingsPaise,
      expenseChangePercent: percentChange(expensesPaise, previousExpensesPaise),
      savingsChangePercent: percentChange(savingsPaise, previousSavingsPaise),
      incomeChangePercent: percentChange(incomePaise, previousIncomePaise),
    );
  }

  static List<GoalLine> goalsAchieved({
    required BudgetPlanStatus? plan,
    required double savingsRatePercent,
    required int incomePaise,
  }) {
    final goals = <GoalLine>[];

    if (savingsRatePercent >= 20 && incomePaise > 0) {
      goals.add(
        GoalLine(
          title: 'Savings target',
          detail:
              'Saved ${savingsRatePercent.toStringAsFixed(0)}% of income this cycle',
        ),
      );
    }

    if (plan != null) {
      for (final b in plan.buckets) {
        if (b.bucketType != BucketType.spending) continue;
        if (!b.isOverBudget && b.totalBudgetPaise > 0) {
          goals.add(
            GoalLine(
              title: b.displayName,
              detail:
                  'Under budget · ${formatPaise(b.remainingPaise)} remaining',
            ),
          );
        }
      }
    }

    return goals;
  }

  static List<GoalLine> goalsMissed({
    required BudgetPlanStatus? plan,
    required double savingsRatePercent,
    required int incomePaise,
  }) {
    final goals = <GoalLine>[];

    if (incomePaise > 0 && savingsRatePercent < 10) {
      goals.add(
        GoalLine(
          title: 'Savings target',
          detail:
              'Only ${savingsRatePercent.toStringAsFixed(0)}% saved — aim for 20%',
        ),
      );
    }

    if (plan != null) {
      for (final b in plan.buckets) {
        if (b.isOverBudget) {
          goals.add(
            GoalLine(
              title: b.displayName,
              detail:
                  'Over budget by ${formatPaise(b.spentPaise - b.totalBudgetPaise)}',
            ),
          );
        }
        if (b.bucketKey == 'savings' && b.spentPaise > 0) {
          goals.add(
            const GoalLine(
              title: 'Savings bucket',
              detail: 'Savings allocation was used during the cycle',
            ),
          );
        }
      }
    }

    return goals;
  }

  static List<BudgetBucketLine> bucketLines(BudgetPlanStatus? plan) {
    if (plan == null) return [];
    return plan.buckets
        .map(
          (b) => BudgetBucketLine(
            name: b.displayName,
            allocatedPaise: b.totalBudgetPaise,
            spentPaise: b.spentPaise,
            percentUsed: b.percentUsed,
            onTrack: !b.isOverBudget,
          ),
        )
        .toList();
  }

  static double budgetOnTrackPercent(BudgetPlanStatus? plan) {
    if (plan == null) return 0;
    final spending = plan.spendingBuckets;
    if (spending.isEmpty) return 0;
    final onTrack = spending.where((b) => !b.isOverBudget).length;
    return (onTrack / spending.length) * 100;
  }
}
