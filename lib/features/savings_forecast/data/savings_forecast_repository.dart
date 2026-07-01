import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/daos/subscriptions_dao.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/savings_rate_utils.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/dashboard/data/dashboard_repository.dart';
import 'package:rupee_track/features/health_score/data/financial_health_repository.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_report_engine.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_engine.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_models.dart';

final savingsForecastRepositoryProvider =
    Provider<SavingsForecastRepository>((ref) {
  return SavingsForecastRepository(ref);
});

class SavingsForecastRepository {
  SavingsForecastRepository(this._ref);

  final Ref _ref;

  Stream<SavingsForecastReport> watchReport({
    ForecastPeriod period = ForecastPeriod.year1,
    ForecastAdjustments adjustments = const ForecastAdjustments(),
    int customHorizonMonths = 12,
  }) async* {
    final db = await _ref.read(databaseProvider.future);
    final cycleKey = _ref.read(selectedCycleKeyProvider);
    final salaryDay = _ref.read(salaryDayProvider);

    Future<SavingsForecastReport> buildReport() async {
      final input = await _buildInput(cycleKey: cycleKey, salaryDay: salaryDay);
      return SavingsForecastEngine.build(
        input: input,
        selectedPeriod: period,
        customHorizonMonths: customHorizonMonths,
        adjustments: adjustments,
      );
    }

    yield await buildReport();

    final controller = StreamController<void>();
    void ping([_]) {
      if (!controller.isClosed) controller.add(null);
    }

    final subs = <StreamSubscription<dynamic>>[
      db.expensesDao.watchSpendingChanges().listen(ping),
      db.salaryDao.watchSalaryForMonth(cycleKey).listen(ping),
      db.salaryDao.watchDeductionsForMonth(cycleKey).listen(ping),
      db.salaryDao.watchExtraIncomeForMonth(cycleKey).listen(ping),
      db.subscriptionsDao.watchAllSubscriptions().listen(ping),
      db.savingsGoalsDao.watchActiveGoals().listen(ping),
      db.loansDao.watchActiveLoans().listen(ping),
      db.budgetDao.watchPlanForMonth(cycleKey).listen(ping),
    ];

    try {
      await for (final _ in controller.stream) {
        yield await buildReport();
      }
    } finally {
      for (final sub in subs) {
        await sub.cancel();
      }
      await controller.close();
    }
  }

  Future<SavingsForecastInput> _buildInput({
    required String cycleKey,
    required int salaryDay,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();

    final summary = await _ref
        .read(dashboardRepositoryProvider)
        .watchCycleSummary(cycleKey)
        .first;

    final keys = recentCycleKeys(salaryDay: salaryDay, count: 6);
    final historicalSpent = <int>[];
    final historicalSalaries = <int>[];
    final categoryTotals = <String, int>{};

    for (final key in keys) {
      historicalSpent.add(await db.expensesDao.sumSpentForMonth(key));
      final sal = await db.salaryDao.getTotalCycleInflowPaise(key);
      historicalSalaries.add(sal);

      final breakdown = await db.expensesDao.categoryBreakdown(key);
      for (final row in breakdown) {
        categoryTotals[row.categoryName] =
            (categoryTotals[row.categoryName] ?? 0) + row.totalPaise;
      }
    }

    final cycleCount = keys.isEmpty ? 1 : keys.length;
    final avgSpent = historicalSpent.isEmpty
        ? summary.spentPaise
        : (historicalSpent.fold<int>(0, (a, b) => a + b) / cycleCount).round();
    final avgSalary = historicalSalaries.isEmpty
        ? summary.salaryPaise
        : (historicalSalaries.fold<int>(0, (a, b) => a + b) / cycleCount)
            .round();

    final categoryMonthlyAvg = categoryTotals.map(
      (name, total) => MapEntry(name, (total / cycleCount).round()),
    );

    final subMonthly = await db.subscriptionsDao.monthlyTotalPaise();
    final activeSubs = await db.subscriptionsDao.watchActiveSubscriptions().first;
    var largestSubName = '';
    var largestSubPaise = 0;
    for (final sub in activeSubs) {
      final monthly = SubscriptionsDao.monthlyEquivalentPaise(sub);
      if (monthly > largestSubPaise) {
        largestSubPaise = monthly;
        largestSubName = sub.name;
      }
    }

    final loans = await db.loansDao.watchActiveLoans().first;
    final now = DateTime.now().toUtc();
    var loanMonthly = 0;
    for (final loan in loans) {
      if (loan.direction != 'borrowed_by_me') continue;
      if (loan.expectedReturnAt == null) {
        loanMonthly += (loan.balancePaise / 12).round();
        continue;
      }
      final months = loan.expectedReturnAt!.difference(now).inDays ~/ 30;
      if (months > 0) {
        loanMonthly += (loan.balancePaise / months).round();
      }
    }

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
    final goalContrib = goals.fold<int>(
      0,
      (sum, g) => sum + g.monthlyContributionPaise,
    );

    final budgetRepo = _ref.read(budgetRepositoryProvider);
    final plan = await budgetRepo.getPlanStatus(cycleKey);
    final budgetAdherence = MonthlyReportEngine.budgetOnTrackPercent(plan);

    final previousKey = previousCycleKey(cycleKey, salaryDay: salaryDay);
    final prevInflow =
        await db.salaryDao.getTotalCycleInflowPaise(previousKey);
    final prevSpent = await db.expensesDao.sumSpentForMonth(previousKey);
    final carryOver = SalaryCycleEngine.carryOverBalance(
      previousSalaryPaise: prevInflow,
      previousSpentPaise: prevSpent,
    );

    final salary = summary.salaryPaise > 0 ? summary.salaryPaise : avgSalary;
    final monthlyInflow = summary.salaryPaise + summary.extraIncomePaise;
    final forecastIncomePaise =
        monthlyInflow > 0 ? monthlyInflow : avgSalary;
    final netSavings = forecastIncomePaise - avgSpent;
    final inflowForRate =
        monthlyInflow > 0 ? monthlyInflow : forecastIncomePaise;
    final savingsRate = inflowForRate > 0
        ? (summary.moneyLeftPaise / inflowForRate) * 100
        : SavingsRateUtils.displayPercent(
            salaryPaise: salary,
            spentPaise: summary.spentPaise,
            carryOverPaise: carryOver,
          );
    final currentBalance = SalaryCycleEngine.effectiveMoneyLeft(
      salaryPaise: summary.salaryPaise,
      spentPaise: summary.spentPaise,
      carryOverPaise: carryOver,
      extraIncomePaise: summary.extraIncomePaise,
    );

    final healthReport =
        await _ref.read(financialHealthRepositoryProvider).buildHealthReport(
              cycleKey,
            );
    final healthScore = healthReport.hasEnoughData
        ? healthReport.overallScore
        : _fallbackHealthScore(
            savingsRate: savingsRate,
            budgetAdherence: budgetAdherence,
            subShare: forecastIncomePaise > 0 ? subMonthly / forecastIncomePaise : 0,
          );

    return SavingsForecastInput(
      cycleKey: cycleKey,
      currentBalancePaise: currentBalance.clamp(-99999999999, 99999999999),
      monthlySalaryPaise: forecastIncomePaise,
      avgMonthlySpentPaise: avgSpent,
      avgMonthlyNetSavingsPaise: netSavings,
      savingsRatePercent: savingsRate,
      subscriptionMonthlyPaise: subMonthly,
      loanMonthlyPaise: loanMonthly,
      goalContributionsMonthlyPaise: goalContrib,
      budgetAdherencePercent: budgetAdherence,
      healthScore: healthScore,
      historicalCycleSpent: historicalSpent,
      historicalSalaries: historicalSalaries,
      categoryMonthlyAvg: categoryMonthlyAvg,
      goals: goalSnapshots,
      salaryDay: settings.salaryDay,
      largestSubscriptionName: largestSubName.isEmpty ? null : largestSubName,
      largestSubscriptionPaise: largestSubPaise,
    );
  }

  int _fallbackHealthScore({
    required double savingsRate,
    required double budgetAdherence,
    required double subShare,
  }) {
    var score = 50.0;
    score += (savingsRate * 1.5).clamp(0, 30);
    score += (budgetAdherence * 0.2).clamp(0, 20);
    score -= (subShare * 100).clamp(0, 15);
    return score.round().clamp(0, 100);
  }

  Future<ScenarioResult> simulate({
    required ScenarioPreset preset,
    ForecastPeriod period = ForecastPeriod.year1,
  }) async {
    final cycleKey = _ref.read(selectedCycleKeyProvider);
    final salaryDay = _ref.read(salaryDayProvider);
    final input = await _buildInput(cycleKey: cycleKey, salaryDay: salaryDay);
    return SavingsForecastEngine.simulatePreset(
      input: input,
      preset: preset,
      period: period,
    );
  }
}

final selectedForecastPeriodProvider =
    NotifierProvider<SelectedForecastPeriodNotifier, ForecastPeriod>(
  SelectedForecastPeriodNotifier.new,
);

class SelectedForecastPeriodNotifier extends Notifier<ForecastPeriod> {
  @override
  ForecastPeriod build() => ForecastPeriod.year1;

  void setPeriod(ForecastPeriod period) => state = period;
}

final activeForecastAdjustmentsProvider =
    NotifierProvider<ActiveForecastAdjustmentsNotifier, ForecastAdjustments>(
  ActiveForecastAdjustmentsNotifier.new,
);

class ActiveForecastAdjustmentsNotifier extends Notifier<ForecastAdjustments> {
  @override
  ForecastAdjustments build() => const ForecastAdjustments();

  void apply(ScenarioPreset preset) {
    state = state.merge(preset.adjustments);
  }

  void reset() => state = const ForecastAdjustments();
}

final savingsForecastReportProvider = StreamProvider<SavingsForecastReport>((ref) {
  final period = ref.watch(selectedForecastPeriodProvider);
  final adjustments = ref.watch(activeForecastAdjustmentsProvider);
  ref.watch(selectedCycleKeyProvider);
  return ref.watch(savingsForecastRepositoryProvider).watchReport(
        period: period,
        adjustments: adjustments,
      );
});
