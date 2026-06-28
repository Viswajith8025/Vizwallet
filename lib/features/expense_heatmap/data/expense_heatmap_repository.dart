import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/expense_heatmap/data/heatmap_threshold_store.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_engine.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_models.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_engine.dart';
import 'package:rupee_track/features/health_score/data/financial_health_repository.dart';
import 'package:rupee_track/features/safe_spend/data/safe_spend_repository.dart';

final expenseHeatmapRepositoryProvider =
    Provider<ExpenseHeatmapRepository>((ref) {
  return ExpenseHeatmapRepository(ref);
});

class ExpenseHeatmapRepository {
  ExpenseHeatmapRepository(this._ref);

  final Ref _ref;

  Stream<ExpenseHeatmapReport> watchReport({
    required HeatmapViewMode viewMode,
    required DateTime anchorIst,
    required HeatmapFilters filters,
    DateTime? customStart,
    DateTime? customEnd,
  }) async* {
    final db = await _ref.read(databaseProvider.future);
    final salaryDay = _ref.read(salaryDayProvider);
    final cycleKey = _ref.read(selectedCycleKeyProvider);

    await for (final _ in db.expensesDao.watchSpendingChanges()) {
      yield await _build(
        viewMode: viewMode,
        anchorIst: anchorIst,
        filters: filters,
        salaryDay: salaryDay,
        cycleKey: cycleKey,
        customStart: customStart,
        customEnd: customEnd,
      );
    }
  }

  Future<ExpenseHeatmapReport> _build({
    required HeatmapViewMode viewMode,
    required DateTime anchorIst,
    required HeatmapFilters filters,
    required int salaryDay,
    required String cycleKey,
    DateTime? customStart,
    DateTime? customEnd,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    final range = ExpenseHeatmapEngine.resolveRange(
      mode: viewMode,
      anchorIst: anchorIst,
      salaryDay: salaryDay,
      cycleKey: cycleKey,
      customStart: customStart,
      customEnd: customEnd,
    );

    final startUtc = FinancialCalendarEngine.utcStartOfIstDay(range.startIst);
    final endUtc = FinancialCalendarEngine.utcEndOfIstDay(range.endIst);

    final expenses = await db.expensesDao.listAllBetween(
      startUtc: startUtc,
      endUtc: endUtc,
    );

    final salaries = await db.salaryDao.listSalariesInRange(
      startUtc: startUtc,
      endUtc: endUtc,
    );

    final incomeByDay = <({DateTime date, int amountPaise})>[];
    for (final salary in salaries) {
      if (salary.receivedAt == null) continue;
      final day = FinancialCalendarEngine.istDateOnly(salary.receivedAt!);
      incomeByDay.add((date: day, amountPaise: salary.amountPaise));
    }

    final spendingOnly = expenses.where((e) => e.category.countsTowardSpending);
    final avgDaily = range.endIst.difference(range.startIst).inDays + 1;
    var totalSpent = 0;
    for (final row in spendingOnly) {
      totalSpent += row.expense.amountPaise;
    }
    final avg = avgDaily > 0 ? (totalSpent / avgDaily).round() : 0;

    final saved = _ref.read(heatmapThresholdsProvider);
    final thresholds = saved ?? HeatmapThresholds.fromAverageDaily(avg);

    return ExpenseHeatmapEngine.build(
      viewMode: viewMode,
      rangeStartIst: range.startIst,
      rangeEndIst: range.endIst,
      expenses: expenses,
      incomeByDay: incomeByDay,
      thresholds: thresholds,
      filters: filters,
      rangeLabel: range.label,
    );
  }

  Future<HeatmapDayDetail> loadDayDetail({
    required DateTime date,
    required ExpenseHeatmapReport report,
  }) async {
    final cycleKey = _ref.read(selectedCycleKeyProvider);
    final safeSpend = await _ref
        .read(safeSpendRepositoryProvider)
        .watchSafeSpend(cycleKey)
        .first;
    final plan =
        await _ref.read(budgetRepositoryProvider).getPlanStatus(cycleKey);
    final budgetRemaining = plan?.spendingBuckets
            .fold<int>(0, (s, b) => s + b.remainingPaise) ??
        0;

    final health = await _ref.read(financialHealthProvider(cycleKey).future);

    return ExpenseHeatmapEngine.dayDetail(
      date: date,
      report: report,
      safeDailySpendPaise: safeSpend.safeDailyLimitPaise,
      budgetRemainingPaise: budgetRemaining,
      healthScore: health.hasEnoughData ? health.overallScore : null,
      healthLabel: health.motivationLabel,
      goalContributionsPaise: 0,
    );
  }
}

final heatmapViewModeProvider =
    NotifierProvider<HeatmapViewModeNotifier, HeatmapViewMode>(
  HeatmapViewModeNotifier.new,
);

class HeatmapViewModeNotifier extends Notifier<HeatmapViewMode> {
  @override
  HeatmapViewMode build() => HeatmapViewMode.monthly;

  void setMode(HeatmapViewMode mode) => state = mode;
}

final heatmapAnchorProvider = NotifierProvider<HeatmapAnchorNotifier, DateTime>(
  HeatmapAnchorNotifier.new,
);

class HeatmapAnchorNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = FinancialCalendarEngine.istDateOnly(DateTime.now());
    return DateTime(now.year, now.month);
  }

  void setAnchor(DateTime anchor) => state = anchor;
  void previous() {
    state = DateTime(state.year, state.month - 1);
  }

  void next() {
    state = DateTime(state.year, state.month + 1);
  }
}

final heatmapCustomRangeProvider =
    StateProvider<({DateTime? start, DateTime? end})>((ref) {
  return (start: null, end: null);
});

final heatmapFiltersProvider =
    StateProvider<HeatmapFilters>((ref) => const HeatmapFilters());

final expenseHeatmapReportProvider = StreamProvider<ExpenseHeatmapReport>((ref) {
  final mode = ref.watch(heatmapViewModeProvider);
  final anchor = ref.watch(heatmapAnchorProvider);
  final filters = ref.watch(heatmapFiltersProvider);
  final custom = ref.watch(heatmapCustomRangeProvider);
  return ref.watch(expenseHeatmapRepositoryProvider).watchReport(
        viewMode: mode,
        anchorIst: anchor,
        filters: filters,
        customStart: custom.start,
        customEnd: custom.end,
      );
});
