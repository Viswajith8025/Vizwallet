import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/daos/expenses_dao.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_engine.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_report.dart';
import 'package:rupee_track/features/trends/domain/trends_comparison_mode.dart';

final spendingTrendsRepositoryProvider =
    Provider<SpendingTrendsRepository>((ref) {
  return SpendingTrendsRepository(ref);
});

class SpendingTrendsRepository {
  SpendingTrendsRepository(this._ref);

  final Ref _ref;

  Stream<SpendingTrendsReport> watchTrends({
    required TrendsComparisonMode mode,
    required String anchorCycleKey,
    required int salaryDay,
  }) async* {
    final db = await _ref.read(databaseProvider.future);

    await for (final _ in db.expensesDao.watchSpendingChanges()) {
      yield await _build(
        db: db,
        mode: mode,
        anchorCycleKey: anchorCycleKey,
        salaryDay: salaryDay,
      );
    }
  }

  Future<SpendingTrendsReport> buildForCycle({
    required String cycleKey,
    required int salaryDay,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    return _build(
      db: db,
      mode: TrendsComparisonMode.currentVsPreviousCycle,
      anchorCycleKey: cycleKey,
      salaryDay: salaryDay,
    );
  }

  Future<SpendingTrendsReport> _build({
    required AppDatabase db,
    required TrendsComparisonMode mode,
    required String anchorCycleKey,
    required int salaryDay,
  }) async {
    final settings = await db.settingsDao.getSettings();
    final salaryPaise = await db.salaryDao.getEffectiveSalaryPaise(anchorCycleKey);
    final subMonthly = await db.subscriptionsDao.monthlyTotalPaise();

    late final PeriodSnapshot current;
    PeriodSnapshot? comparison;
    late final List<PeriodSnapshot> series;

    switch (mode) {
      case TrendsComparisonMode.currentVsPreviousCycle:
        final prevKey = previousCycleKey(anchorCycleKey, salaryDay: salaryDay);
        current = await _cycleSnapshot(
          db: db,
          cycleKey: anchorCycleKey,
          salaryDay: salaryDay,
          label: formatCycleLabelShort(anchorCycleKey, salaryDay: salaryDay),
        );
        comparison = await _cycleSnapshot(
          db: db,
          cycleKey: prevKey,
          salaryDay: salaryDay,
          label: formatCycleLabelShort(prevKey, salaryDay: salaryDay),
        );
        series = [comparison, current];
      case TrendsComparisonMode.currentVsPreviousCalendarMonth:
        final ist = SalaryCycleEngine.istDateOnly(DateTime.now());
        final curBounds = SpendingTrendsEngine.calendarMonthBounds(
          ist.year,
          ist.month,
        );
        var prevYear = ist.year;
        var prevMonth = ist.month - 1;
        if (prevMonth < 1) {
          prevMonth = 12;
          prevYear--;
        }
        final prevBounds =
            SpendingTrendsEngine.calendarMonthBounds(prevYear, prevMonth);

        current = await _rangeSnapshot(
          db: db,
          startUtc: curBounds.startUtc,
          endUtc: curBounds.endUtc,
          dayCount: curBounds.dayCount,
          label: _calendarLabel(ist.year, ist.month),
        );
        comparison = await _rangeSnapshot(
          db: db,
          startUtc: prevBounds.startUtc,
          endUtc: prevBounds.endUtc,
          dayCount: prevBounds.dayCount,
          label: _calendarLabel(prevYear, prevMonth),
        );
        series = [comparison, current];
      case TrendsComparisonMode.lastSixCycles:
        final keys = recentCycleKeys(salaryDay: salaryDay, count: 6).reversed;
        series = [];
        for (final key in keys) {
          series.add(
            await _cycleSnapshot(
              db: db,
              cycleKey: key,
              salaryDay: salaryDay,
              label: formatCycleLabelShort(key, salaryDay: salaryDay),
            ),
          );
        }
        current = series.last;
        comparison = series.length > 1 ? series[series.length - 2] : null;
      case TrendsComparisonMode.lastTwelveCycles:
        final keys = recentCycleKeys(salaryDay: salaryDay, count: 12).reversed;
        series = [];
        for (final key in keys) {
          series.add(
            await _cycleSnapshot(
              db: db,
              cycleKey: key,
              salaryDay: salaryDay,
              label: formatCycleLabelShort(key, salaryDay: salaryDay),
            ),
          );
        }
        current = series.last;
        comparison = series.length > 1 ? series[series.length - 2] : null;
    }

    return SpendingTrendsEngine.build(
      mode: mode,
      current: current,
      comparison: comparison,
      series: series,
      salaryPaise: salaryPaise,
      majorThresholdPaise: settings.majorExpenseThresholdPaise,
      activeSubscriptionMonthlyPaise: subMonthly,
    );
  }

  Future<PeriodSnapshot> _cycleSnapshot({
    required AppDatabase db,
    required String cycleKey,
    required int salaryDay,
    required String label,
  }) async {
    final bounds =
        SpendingTrendsEngine.cycleBoundsUtc(cycleKey, salaryDay: salaryDay);
    final cycleBounds =
        SalaryCycleEngine.cycleBounds(cycleKey, salaryDay: salaryDay);
    return _rangeSnapshot(
      db: db,
      startUtc: bounds.startUtc,
      endUtc: bounds.endUtc,
      dayCount: cycleBounds.totalDays,
      label: label,
    );
  }

  Future<PeriodSnapshot> _rangeSnapshot({
    required AppDatabase db,
    required DateTime startUtc,
    required DateTime endUtc,
    required int dayCount,
    required String label,
  }) async {
    final rows = await db.expensesDao.listSpendingBetween(
      startUtc: startUtc,
      endUtc: endUtc,
    );
    final expenses = rows.map(_toTrendExpense).toList();
    final total = expenses.fold<int>(0, (s, e) => s + e.amountPaise);
    return PeriodSnapshot(
      label: label,
      totalSpentPaise: total,
      expenses: expenses,
      dayCount: dayCount,
    );
  }

  TrendExpense _toTrendExpense(ExpenseWithCategory row) {
    final labels = _parseLabels(row.expense.autoLabels);
    return TrendExpense(
      id: row.expense.id,
      amountPaise: row.expense.amountPaise,
      categoryId: row.category.id,
      categoryName: row.category.name,
      categorySlug: row.category.slug,
      colorValue: row.category.colorValue,
      title: row.expense.title,
      occurredAtUtc: row.expense.occurredAt,
      autoLabels: labels,
      subscriptionId: row.expense.subscriptionId,
    );
  }

  List<String> _parseLabels(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return [];
  }

  String _calendarLabel(int year, int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[month - 1]} $year';
  }
}

final trendsComparisonModeProvider =
    NotifierProvider<TrendsComparisonModeNotifier, TrendsComparisonMode>(
  TrendsComparisonModeNotifier.new,
);

class TrendsComparisonModeNotifier extends Notifier<TrendsComparisonMode> {
  @override
  TrendsComparisonMode build() => TrendsComparisonMode.currentVsPreviousCycle;

  void setMode(TrendsComparisonMode mode) => state = mode;
}

final spendingTrendsProvider = StreamProvider<SpendingTrendsReport>((ref) {
  final mode = ref.watch(trendsComparisonModeProvider);
  final cycleKey = ref.watch(selectedCycleKeyProvider);
  final salaryDay = ref.watch(salaryDayProvider);
  final repo = ref.watch(spendingTrendsRepositoryProvider);
  return repo.watchTrends(
    mode: mode,
    anchorCycleKey: cycleKey,
    salaryDay: salaryDay,
  );
});
