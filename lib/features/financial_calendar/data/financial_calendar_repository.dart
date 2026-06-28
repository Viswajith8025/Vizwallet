import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_engine.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';
import 'package:rupee_track/features/health_score/data/financial_health_repository.dart';
import 'package:rupee_track/features/safe_spend/data/safe_spend_repository.dart';

final calendarViewModeProvider =
    StateProvider<CalendarViewMode>((ref) => CalendarViewMode.month);

final calendarFiltersProvider =
    StateProvider<CalendarFilters>((ref) => const CalendarFilters());

final calendarFocusedMonthProvider = StateProvider<DateTime>((ref) {
  final now = FinancialCalendarEngine.istDateOnly(DateTime.now());
  return DateTime(now.year, now.month);
});

final calendarSelectedDayProvider = StateProvider<DateTime>((ref) {
  return FinancialCalendarEngine.istDateOnly(DateTime.now());
});

typedef CalendarMonthQuery = ({int year, int month});

final financialCalendarRepositoryProvider =
    Provider<FinancialCalendarRepository>((ref) {
  return FinancialCalendarRepository(ref);
});

class FinancialCalendarRepository {
  FinancialCalendarRepository(this._ref);

  final Ref _ref;

  Future<FinancialCalendarRawData> _loadRaw(String cycleKey) async {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();
    final salaryDay = settings.salaryDay;

    final bounds = SalaryCycleEngine.cycleBounds(cycleKey, salaryDay: salaryDay);
    final windowStart = bounds.startIst.subtract(const Duration(days: 45));
    final windowEnd = bounds.endIst.add(const Duration(days: 45));

    final startUtc = FinancialCalendarEngine.utcStartOfIstDay(
      DateTime(windowStart.year, windowStart.month, windowStart.day),
    );
    final endUtc = FinancialCalendarEngine.utcEndOfIstDay(
      DateTime(windowEnd.year, windowEnd.month, windowEnd.day),
    );

    final expenses = await db.expensesDao.listAllBetween(
      startUtc: startUtc,
      endUtc: endUtc,
    );

    final salaries = await db.salaryDao.listSalariesInRange(
      startUtc: startUtc,
      endUtc: endUtc,
    );

    final subscriptions = await db.subscriptionsDao.watchActiveSubscriptions().first;
    final loans = await db.loansDao.watchActiveLoans().first;

    final plan =
        await _ref.read(budgetRepositoryProvider).getPlanStatus(cycleKey);
    final budgetRemaining = plan?.spendingBuckets
            .fold<int>(0, (s, b) => s + b.remainingPaise) ??
        0;

    final subMonthly = await db.subscriptionsDao.monthlyTotalPaise();

    final safeSpend = await _ref
        .read(safeSpendRepositoryProvider)
        .watchSafeSpend(cycleKey)
        .first;

    final health = await _ref
        .read(financialHealthRepositoryProvider)
        .watchHealth(cycleKey)
        .first;

    final daysInCycle =
        bounds.endIst.difference(bounds.startIst).inDays + 1;
    final totalSpendingBudget = plan?.spendingBuckets
            .fold<int>(0, (s, b) => s + b.totalBudgetPaise) ??
        0;
    final dailyBudget =
        daysInCycle > 0 ? (totalSpendingBudget / daysInCycle).round() : 0;

    return FinancialCalendarRawData(
      expenses: expenses,
      salaries: salaries,
      subscriptions: subscriptions,
      loans: loans,
      salaryDay: salaryDay,
      budgetRemainingPaise: budgetRemaining,
      subscriptionMonthlyPaise: subMonthly,
      safeDailyPaise: safeSpend.safeDailyLimitPaise,
      healthScore: health.hasEnoughData ? health.overallScore : null,
      healthLabel: health.motivationLabel,
      dailyBudgetPaise: dailyBudget,
    );
  }

  Future<FinancialCalendarMonthData> loadMonth({
    required int year,
    required int month,
    required CalendarFilters filters,
    DateTime? selectedDay,
  }) async {
    final salaryDay = _ref.read(salaryDayProvider);
    final cycleKey = cycleKeyFromDate(
      DateTime.utc(year, month, 15),
      salaryDay: salaryDay,
    );
    final raw = await _loadRaw(cycleKey);
    final events = FinancialCalendarEngine.buildEvents(raw);
    return FinancialCalendarEngine.buildMonth(
      year: year,
      month: month,
      allEvents: events,
      raw: raw,
      filters: filters,
      selectedDay: selectedDay,
    );
  }

  Future<CalendarDaySummary> loadDaySummary(DateTime day) async {
    final salaryDay = _ref.read(salaryDayProvider);
    final cycleKey = cycleKeyFromDate(
      FinancialCalendarEngine.utcStartOfIstDay(day),
      salaryDay: salaryDay,
    );
    final raw = await _loadRaw(cycleKey);
    final events = FinancialCalendarEngine.buildEvents(raw);
    return FinancialCalendarEngine.buildDaySummary(
      day: day,
      events: events,
      raw: raw,
    );
  }
}

final financialCalendarMonthProvider =
    FutureProvider.family<FinancialCalendarMonthData, CalendarMonthQuery>(
  (ref, query) async {
    final filters = ref.watch(calendarFiltersProvider);
    final selected = ref.watch(calendarSelectedDayProvider);
    ref.watch(calendarFiltersProvider);
    return ref.read(financialCalendarRepositoryProvider).loadMonth(
          year: query.year,
          month: query.month,
          filters: filters,
          selectedDay: selected,
        );
  },
);

final calendarDaySummaryProvider =
    FutureProvider.family<CalendarDaySummary, DateTime>((ref, day) {
  return ref.read(financialCalendarRepositoryProvider).loadDaySummary(day);
});
