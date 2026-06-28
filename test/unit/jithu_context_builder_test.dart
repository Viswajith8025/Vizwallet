import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/dashboard/domain/monthly_summary.dart';
import 'package:rupee_track/features/jithu/domain/jithu_context_builder.dart';
import 'package:rupee_track/features/safe_spend/domain/safe_spend_snapshot.dart';

void main() {
  test('JithuContextBuilder includes salary and safe spend numbers', () {
    const summary = CycleSummary(
      cycleKey: '2026-06',
      salaryPaise: 5000000,
      spentPaise: 1200000,
      savingsPaise: 800000,
      savingsPercent: 16,
      moneyLeftPaise: 2480000,
      carryOverPaise: 0,
      daysToSalary: 5,
      daysLeftInCycle: 5,
      safeDailyLimitPaise: 496000,
      salaryEntered: true,
      categoryBreakdown: [],
      pendingBorrowedPaise: 0,
      subscriptionMonthlyPaise: 150000,
      upcomingSubscriptionsCount: 2,
      overdueLoansCount: 0,
    );

    const safeSpend = SafeSpendSnapshot(
      cycleKey: '2026-06',
      moneyLeftPaise: 2480000,
      daysRemainingInCycle: 5,
      daysElapsedInCycle: 10,
      safeDailyLimitPaise: 496000,
      todaySpentPaise: 50000,
      remainingSafeSpendTodayPaise: 1220000,
      todayUsagePercent: 10,
      riskLevel: SafeSpendRiskLevel.onTrack,
      headline: 'On track today',
      recommendation: 'Keep optional spends light.',
      projection: SafeSpendProjection(
        averageDailySpendPaise: 120000,
        expectedEndOfCycleBalancePaise: 500000,
        dailyReductionNeededPaise: 0,
        projectedCycleSpendPaise: 1700000,
      ),
    );

    final prompt = JithuContextBuilder.systemPrompt(
      summary: summary,
      safeSpend: safeSpend,
    );

    expect(prompt, contains('Jithu'));
    expect(prompt, contains('₹24,800'));
    expect(prompt, contains('On track'));
    expect(prompt, contains('Subscriptions'));
  });
}
