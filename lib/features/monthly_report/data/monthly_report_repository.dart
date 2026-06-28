import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/auto_label_utils.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/health_score/data/financial_health_repository.dart';
import 'package:rupee_track/features/health_score/domain/financial_health_models.dart';
import 'package:rupee_track/features/monthly_report/data/monthly_report_store.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_closing_report.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_report_engine.dart';
import 'package:rupee_track/features/trends/data/spending_trends_repository.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_report.dart';

final monthlyReportStoreProvider =
    Provider<MonthlyReportStore>((ref) => MonthlyReportStore());

final monthlyReportRepositoryProvider = Provider<MonthlyReportRepository>((ref) {
  return MonthlyReportRepository(ref);
});

class MonthlyReportRepository {
  MonthlyReportRepository(this._ref);

  final Ref _ref;

  Future<void> ensureAutoReports({required int salaryDay}) async {
    final store = _ref.read(monthlyReportStoreProvider);
    final current = currentCycleKey(salaryDay: salaryDay);
    final candidates = recentCycleKeys(salaryDay: salaryDay, count: 12)
        .where((k) => k != current)
        .toList();

    for (final cycleKey in candidates) {
      if (!await _cycleHasEnded(cycleKey, salaryDay)) continue;
      if (await store.hasReport(cycleKey)) continue;
      final report = await buildReport(cycleKey, salaryDay: salaryDay);
      if (report.incomePaise > 0 || report.expensesPaise > 0) {
        await store.saveReport(report);
      }
    }
  }

  Future<bool> _cycleHasEnded(String cycleKey, int salaryDay) async {
    final bounds = SalaryCycleEngine.cycleBounds(cycleKey, salaryDay: salaryDay);
    final today = SalaryCycleEngine.istDateOnly(DateTime.now());
    return today.isAfter(bounds.endIst);
  }

  Future<MonthlyClosingReport> buildReport(
    String cycleKey, {
    required int salaryDay,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();
    final bounds = SalaryCycleEngine.cycleBounds(cycleKey, salaryDay: salaryDay);
    final dateFormat = DateFormat('d MMM yyyy');

    final salary = await db.salaryDao.getSalaryForMonth(cycleKey);
    final incomePaise = salary?.amountPaise ?? 0;
    final expensesPaise = await db.expensesDao.sumSpentForMonth(cycleKey);
    final breakdown = await db.expensesDao.categoryBreakdown(cycleKey);

    final previousKey = previousCycleKey(cycleKey, salaryDay: salaryDay);
    final prevSalary = await db.salaryDao.getSalaryForMonth(previousKey);
    final prevSpent = await db.expensesDao.sumSpentForMonth(previousKey);
    final prevIncome = prevSalary?.amountPaise ?? 0;

    final prevPrevKey = previousCycleKey(previousKey, salaryDay: salaryDay);
    final prevPrevSalary = await db.salaryDao.getSalaryForMonth(prevPrevKey);
    final prevPrevSpent = await db.expensesDao.sumSpentForMonth(prevPrevKey);
    final prevCarryIntoPrevious = SalaryCycleEngine.carryOverBalance(
      previousSalaryPaise: prevPrevSalary?.amountPaise ?? 0,
      previousSpentPaise: prevPrevSpent,
    );

    final carryOver = SalaryCycleEngine.carryOverBalance(
      previousSalaryPaise: prevIncome,
      previousSpentPaise: prevSpent,
    );

    final savingsPaise = SalaryCycleEngine.effectiveMoneyLeft(
      salaryPaise: incomePaise,
      spentPaise: expensesPaise,
      carryOverPaise: carryOver,
    );
    final savingsRate =
        incomePaise > 0 ? (savingsPaise / incomePaise) * 100 : 0.0;
    final prevSavings =
        (prevIncome + prevCarryIntoPrevious - prevSpent).clamp(0, 1 << 30);

    final cycleDayCount = bounds.totalDays;
    final avgDaily = cycleDayCount > 0
        ? (expensesPaise / cycleDayCount).round()
        : 0;

    final topCategories = breakdown
        .map(
          (c) => CategoryReportLine(
            name: c.categoryName,
            totalPaise: c.totalPaise,
            sharePercent: expensesPaise > 0
                ? (c.totalPaise / expensesPaise) * 100
                : 0,
            colorValue: c.colorValue,
          ),
        )
        .take(6)
        .toList();

    final startUtc = DateTime.utc(
      bounds.startIst.year,
      bounds.startIst.month,
      bounds.startIst.day,
    ).subtract(istOffset);
    final endUtc = DateTime.utc(
      bounds.endIst.year,
      bounds.endIst.month,
      bounds.endIst.day,
    ).add(const Duration(days: 1)).subtract(istOffset);

    final expenses = await db.expensesDao.listSpendingBetween(
      startUtc: startUtc,
      endUtc: endUtc,
    );

    PurchaseHighlight? largest;
    final majorPurchases = <PurchaseHighlight>[];
    for (final row in expenses) {
      final e = row.expense;
      final highlight = PurchaseHighlight(
        title: e.title,
        categoryName: row.category.name,
        amountPaise: e.amountPaise,
        dateLabel: dateFormat.format(e.occurredAt.toLocal()),
      );
      if (largest == null || e.amountPaise > largest.amountPaise) {
        largest = highlight;
      }
      if (isMajorPurchase(
        amountPaise: e.amountPaise,
        majorPurchaseThresholdPaise: settings.majorPurchaseThresholdPaise,
      )) {
        majorPurchases.add(highlight);
      }
    }
    majorPurchases.sort((a, b) => b.amountPaise.compareTo(a.amountPaise));

    final subMonthly = await db.subscriptionsDao.monthlyTotalPaise();
    final activeSubs = await db.subscriptionsDao.watchActiveSubscriptions().first;
    final subCycleSpend = expenses
        .where((r) => r.expense.subscriptionId != null)
        .fold<int>(0, (s, r) => s + r.expense.amountPaise);

    final borrowed = await db.loansDao.pendingBorrowedTotal();
    final overdue = await db.loansDao.overdueLoans();
    final activeLoans = await db.loansDao.watchActiveLoans().first;

    final plan =
        await _ref.read(budgetRepositoryProvider).getPlanStatus(cycleKey);

    FinancialHealthReport? health;
    try {
      health = await _ref
          .read(financialHealthRepositoryProvider)
          .buildForCycle(cycleKey);
    } catch (_) {}

    SpendingTrendsReport? trends;
    try {
      trends = await _ref.read(spendingTrendsRepositoryProvider).buildForCycle(
            cycleKey: cycleKey,
            salaryDay: salaryDay,
          );
    } catch (_) {}

    final comparison = MonthlyReportEngine.buildComparison(
      previousCycleLabel: formatCycleLabel(previousKey, salaryDay: salaryDay),
      incomePaise: incomePaise,
      expensesPaise: expensesPaise,
      savingsPaise: savingsPaise,
      previousIncomePaise: prevIncome,
      previousExpensesPaise: prevSpent,
      previousSavingsPaise: prevSavings,
    );

    return MonthlyClosingReport(
      cycleKey: cycleKey,
      cycleLabel: formatCycleLabel(cycleKey, salaryDay: salaryDay),
      generatedAt: DateTime.now().toUtc(),
      incomePaise: incomePaise,
      expensesPaise: expensesPaise,
      savingsPaise: savingsPaise,
      savingsRatePercent: savingsRate,
      carryOverPaise: carryOver,
      averageDailySpendPaise: avgDaily,
      cycleDayCount: cycleDayCount,
      topCategories: topCategories,
      largestPurchase: largest,
      majorPurchases: majorPurchases.take(8).toList(),
      subscriptions: SubscriptionReportSection(
        cycleSpendPaise: subCycleSpend,
        monthlyRecurringPaise: subMonthly,
        salarySharePercent:
            incomePaise > 0 ? (subMonthly / incomePaise) * 100 : 0,
        activeCount: activeSubs.length,
      ),
      loans: LoanReportSection(
        pendingBorrowedPaise: borrowed,
        overdueCount: overdue.length,
        activeLoanCount: activeLoans.length,
      ),
      healthScore: health?.hasEnoughData == true ? health!.overallScore : null,
      healthTrendDelta: health?.trendDelta ?? 0,
      healthMotivation: health?.motivationLabel ?? '',
      trendSummaries: trends?.summaries.take(4).toList() ?? const [],
      goalsAchieved: MonthlyReportEngine.goalsAchieved(
        plan: plan,
        savingsRatePercent: savingsRate,
        incomePaise: incomePaise,
      ),
      goalsMissed: MonthlyReportEngine.goalsMissed(
        plan: plan,
        savingsRatePercent: savingsRate,
        incomePaise: incomePaise,
      ),
      budgetBuckets: MonthlyReportEngine.bucketLines(plan),
      budgetOnTrackPercent: MonthlyReportEngine.budgetOnTrackPercent(plan),
      comparison: comparison,
    );
  }

  Future<MonthlyClosingReport?> getStoredOrBuild(
    String cycleKey, {
    required int salaryDay,
  }) async {
    final store = _ref.read(monthlyReportStoreProvider);
    final cached = await store.loadReport(cycleKey);
    if (cached != null) return cached;
    if (!await _cycleHasEnded(cycleKey, salaryDay)) return null;
    final report = await buildReport(cycleKey, salaryDay: salaryDay);
    await store.saveReport(report);
    return report;
  }
}

final monthlyClosingReportProvider =
    FutureProvider.family<MonthlyClosingReport?, String>((ref, cycleKey) async {
  final salaryDay = ref.watch(salaryDayProvider);
  return ref.read(monthlyReportRepositoryProvider).getStoredOrBuild(
        cycleKey,
        salaryDay: salaryDay,
      );
});

final previousCycleClosingReportProvider =
    FutureProvider<MonthlyClosingReport?>((ref) async {
  final salaryDay = ref.watch(salaryDayProvider);
  final current = ref.watch(selectedCycleKeyProvider);
  final previous = previousCycleKey(current, salaryDay: salaryDay);
  return ref.read(monthlyReportRepositoryProvider).getStoredOrBuild(
        previous,
        salaryDay: salaryDay,
      );
});
