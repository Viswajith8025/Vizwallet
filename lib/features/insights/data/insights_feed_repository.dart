import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/savings_rate_utils.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/health_score/data/financial_health_repository.dart';
import 'package:rupee_track/features/insights/domain/insights_feed_engine.dart';
import 'package:rupee_track/features/insights/domain/insights_feed_models.dart';
import 'package:rupee_track/features/safe_spend/data/safe_spend_repository.dart';
import 'package:rupee_track/features/savings_forecast/data/savings_forecast_repository.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_models.dart';
import 'package:rupee_track/features/subscriptions/data/subscription_health_repository.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_models.dart';
import 'package:rupee_track/features/trends/data/spending_trends_repository.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_report.dart';

final insightsFeedRepositoryProvider = Provider<InsightsFeedRepository>((ref) {
  return InsightsFeedRepository(ref);
});

final insightsFeedProvider = StreamProvider<InsightsFeedReport>((ref) async* {
  final cycleKey = ref.watch(selectedCycleKeyProvider);
  final salaryDay = ref.watch(salaryDayProvider);
  final repo = ref.watch(insightsFeedRepositoryProvider);

  yield* repo.watchFeed(cycleKey: cycleKey, salaryDay: salaryDay);
});

class InsightsFeedRepository {
  InsightsFeedRepository(this._ref);

  final Ref _ref;

  Stream<InsightsFeedReport> watchFeed({
    required String cycleKey,
    required int salaryDay,
  }) async* {
    final db = await _ref.read(databaseProvider.future);

    yield await _build(cycleKey: cycleKey, salaryDay: salaryDay);

    final controller = StreamController<void>();
    void ping([_]) {
      if (!controller.isClosed) controller.add(null);
    }

    final subs = <StreamSubscription<dynamic>>[
      db.expensesDao.watchSpendingChanges().listen(ping),
      db.salaryDao.watchSalaryForMonth(cycleKey).listen(ping),
      db.subscriptionsDao.watchAllSubscriptions().listen(ping),
      db.savingsGoalsDao.watchActiveGoals().listen(ping),
      db.loansDao.watchActiveLoans().listen(ping),
      db.expensesDao.watchDeletedExpenses().listen(ping),
      db.loansDao.watchDeletedLoans().listen(ping),
      db.subscriptionsDao.watchCancelledSubscriptions().listen(ping),
      db.savingsGoalsDao.watchInactiveGoals().listen(ping),
    ];

    try {
      await for (final _ in controller.stream) {
        yield await _build(cycleKey: cycleKey, salaryDay: salaryDay);
      }
    } finally {
      for (final sub in subs) {
        await sub.cancel();
      }
      await controller.close();
    }
  }

  Future<InsightsFeedReport> _build({
    required String cycleKey,
    required int salaryDay,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    final trendsRepo = _ref.read(spendingTrendsRepositoryProvider);
    final healthRepo = _ref.read(financialHealthRepositoryProvider);
    final safeSpendRepo = _ref.read(safeSpendRepositoryProvider);
    final subHealthRepo = _ref.read(subscriptionHealthRepositoryProvider);
    final budgetRepo = _ref.read(budgetRepositoryProvider);

    final trends = await trendsRepo.buildForCycle(
      cycleKey: cycleKey,
      salaryDay: salaryDay,
    );

    final health = await healthRepo.buildHealthReport(cycleKey);
    final safeSpend = await safeSpendRepo.computeForCycle(cycleKey);

    SavingsForecastReport? forecast;
    try {
      forecast = await _ref.read(savingsForecastReportProvider.future);
    } catch (_) {
      forecast = null;
    }

    SubscriptionHealthReport? subscriptions;
    try {
      subscriptions = await subHealthRepo.buildHealthReport();
    } catch (_) {
      subscriptions = null;
    }

    final budget = await budgetRepo.getPlanStatus(cycleKey);
    final goals = await db.savingsGoalsDao.listActiveGoals();
    final goalSnapshots = goals
        .map(
          (g) => SavingsGoalSnapshot(
            id: g.id,
            name: g.name,
            targetPaise: g.targetPaise,
            savedPaise: g.savedPaise,
            monthlyContributionPaise: g.monthlyContributionPaise,
            isWishlist: g.isWishlist,
            targetDate: g.targetDate,
          ),
        )
        .toList();

    final loans = await db.loansDao.watchActiveLoans().first;
    final now = DateTime.now().toUtc();
    final overdueSnapshots = loans.map((loan) {
      final expected = loan.expectedReturnAt;
      if (expected == null) {
        return LoanOverdueSnapshot(
          personName: loan.personName,
          balancePaise: loan.balancePaise,
          daysOverdue: 0,
          daysUntilDue: null,
          isOverdue: false,
        );
      }
      final diff = expected.difference(now).inDays;
      return LoanOverdueSnapshot(
        personName: loan.personName,
        balancePaise: loan.balancePaise,
        daysOverdue: diff < 0 ? -diff : 0,
        daysUntilDue: diff >= 0 ? diff : null,
        isOverdue: diff < 0,
      );
    }).toList();

    final merchantTotals = <String, int>{};
    for (final e in trends.current.expenses) {
      final title = e.title.trim();
      if (title.isEmpty) continue;
      merchantTotals[title] = (merchantTotals[title] ?? 0) + e.amountPaise;
    }
    String? topMerchant;
    var topMerchantPaise = 0;
    for (final entry in merchantTotals.entries) {
      if (entry.value > topMerchantPaise) {
        topMerchant = entry.key;
        topMerchantPaise = entry.value;
      }
    }

    final categoryLastSpend = <String, DateTime>{};
    for (final e in trends.current.expenses) {
      final name = e.categoryName;
      final at = e.occurredAtUtc;
      final prev = categoryLastSpend[name];
      if (prev == null || at.isAfter(prev)) {
        categoryLastSpend[name] = at;
      }
    }
    final today = DateTime.now().toUtc();
    final categoryNoSpendDays = <String, int>{};
    for (final cat in trends.categoryComparisons) {
      final last = categoryLastSpend[cat.categoryName];
      if (last == null && cat.currentPaise == 0) {
        categoryNoSpendDays[cat.categoryName] = trends.current.dayCount;
      } else if (last != null) {
        final days = today.difference(last).inDays;
        if (cat.currentPaise == 0 || days >= 7) {
          categoryNoSpendDays[cat.categoryName] = days;
        }
      }
    }

    final trackingStreak = _expenseTrackingStreak(trends.current.expenses);

    final salary = await db.salaryDao.getSalaryForMonth(cycleKey);
    final spent = await db.expensesDao.sumSpentForMonth(cycleKey);
    final salaryPaise = salary?.amountPaise ?? trends.salaryPaise;

    final previousKey = previousCycleKey(cycleKey, salaryDay: salaryDay);
    final prevSalary = await db.salaryDao.getSalaryForMonth(previousKey);
    final prevSpent = await db.expensesDao.sumSpentForMonth(previousKey);
    final carryOver = SalaryCycleEngine.carryOverBalance(
      previousSalaryPaise: prevSalary?.amountPaise ?? 0,
      previousSpentPaise: prevSpent,
    );
    final savingsRate = SavingsRateUtils.displayPercent(
      salaryPaise: salaryPaise,
      spentPaise: spent,
      carryOverPaise: carryOver,
    );

    final daysUntilSalary = SalaryCycleEngine.daysUntilNextSalary(
      salaryDay: salaryDay,
    );

    return InsightsFeedEngine.build(
      InsightsFeedInput(
        cycleKey: cycleKey,
        salaryDay: salaryDay,
        trends: trends,
        health: health,
        safeSpend: safeSpend,
        subscriptions: subscriptions,
        budget: budget,
        forecast: forecast,
        goals: goalSnapshots,
        overdueLoans: overdueSnapshots,
        daysUntilSalary: daysUntilSalary,
        topMerchant: topMerchant,
        topMerchantPaise: topMerchantPaise,
        categoryNoSpendDays: categoryNoSpendDays,
        expenseTrackingStreakDays: trackingStreak,
        savingsRatePercent: savingsRate,
      ),
    );
  }

  int _expenseTrackingStreak(List<TrendExpense> expenses) {
    if (expenses.isEmpty) return 0;

    final days = <String>{};
    for (final e in expenses) {
      final ist = SalaryCycleEngine.istDateOnly(e.occurredAtUtc);
      days.add('${ist.year}-${ist.month}-${ist.day}');
    }

    var streak = 0;
    var cursor = SalaryCycleEngine.istDateOnly(DateTime.now());
    while (true) {
      final key = '${cursor.year}-${cursor.month}-${cursor.day}';
      if (!days.contains(key)) break;
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
      if (streak > 60) break;
    }
    return streak;
  }
}
