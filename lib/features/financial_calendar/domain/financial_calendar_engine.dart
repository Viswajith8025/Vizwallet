import 'dart:convert';

import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/daos/expenses_dao.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';
import 'package:rupee_track/features/loans/domain/loan_direction.dart';

class FinancialCalendarRawData {
  const FinancialCalendarRawData({
    required this.expenses,
    required this.salaries,
    required this.subscriptions,
    required this.loans,
    required this.salaryDay,
    required this.budgetRemainingPaise,
    required this.subscriptionMonthlyPaise,
    required this.safeDailyPaise,
    required this.healthScore,
    required this.healthLabel,
    required this.dailyBudgetPaise,
  });

  final List<ExpenseWithCategory> expenses;
  final List<MonthlySalaryTableData> salaries;
  final List<SubscriptionsTableData> subscriptions;
  final List<LoansTableData> loans;
  final int salaryDay;
  final int budgetRemainingPaise;
  final int subscriptionMonthlyPaise;
  final int safeDailyPaise;
  final int? healthScore;
  final String? healthLabel;
  final int dailyBudgetPaise;
}

abstract final class FinancialCalendarEngine {
  static DateTime istDateOnly(DateTime utc) =>
      SalaryCycleEngine.istDateOnly(utc);

  static DateTime utcStartOfIstDay(DateTime istDay) =>
      DateTime.utc(istDay.year, istDay.month, istDay.day).subtract(istOffset);

  static DateTime utcEndOfIstDay(DateTime istDay) =>
      utcStartOfIstDay(istDay).add(const Duration(days: 1));

  static List<FinancialCalendarEvent> buildEvents(FinancialCalendarRawData raw) {
    final events = <FinancialCalendarEvent>[];

    for (final row in raw.expenses) {
      final e = row.expense;
      final day = istDateOnly(e.occurredAt);
      final tags = _parseTags(e.tags);
      final isBill = _isBillCategory(row.category);
      events.add(
        FinancialCalendarEvent(
          id: 'expense-${e.id}',
          type: isBill ? FinancialEventType.bill : FinancialEventType.expense,
          title: e.title,
          subtitle: row.category.name,
          amountPaise: e.amountPaise,
          day: day,
          colorValue: row.category.colorValue,
          categoryId: row.category.id,
          sourceId: e.id,
          tags: tags,
        ),
      );
    }

    for (final salary in raw.salaries) {
      final received = salary.receivedAt ?? DateTime.now();
      final day = istDateOnly(received);
      events.add(
        FinancialCalendarEvent(
          id: 'salary-${salary.monthKey}',
          type: FinancialEventType.salary,
          title: 'Salary received',
          subtitle: formatCycleLabelShort(
            salary.monthKey,
            salaryDay: raw.salaryDay,
          ),
          amountPaise: salary.amountPaise,
          day: day,
        ),
      );
    }

    for (final sub in raw.subscriptions) {
      for (final day in _subscriptionRenewalDays(sub)) {
        events.add(
          FinancialCalendarEvent(
            id: 'sub-${sub.id}-${day.millisecondsSinceEpoch}',
            type: FinancialEventType.subscription,
            title: sub.name,
            subtitle: '${sub.billingCycle} renewal',
            amountPaise: sub.amountPaise,
            day: day,
            sourceId: sub.id,
          ),
        );
      }
    }

    for (final loan in raw.loans) {
      if (LoanDirection.isLoan(loan.direction)) {
        if (loan.expectedReturnAt != null) {
          final dueDay = istDateOnly(loan.expectedReturnAt!);
          events.add(
            FinancialCalendarEvent(
              id: 'loan-due-${loan.id}',
              type: FinancialEventType.loan,
              title: 'Loan return due · ${loan.personName}',
              subtitle: loan.reason,
              amountPaise: loan.balancePaise,
              day: dueDay,
              sourceId: loan.id,
            ),
          );
        }
        continue;
      }

      final borrowedDay = istDateOnly(loan.borrowedAt);
      events.add(
        FinancialCalendarEvent(
          id: 'borrowed-${loan.id}',
          type: FinancialEventType.borrowedMoney,
          title: 'Borrowed from ${loan.personName}',
          subtitle: loan.reason,
          amountPaise: loan.balancePaise,
          day: borrowedDay,
          sourceId: loan.id,
        ),
      );
      if (loan.expectedReturnAt != null) {
        final dueDay = istDateOnly(loan.expectedReturnAt!);
        events.add(
          FinancialCalendarEvent(
            id: 'payback-due-${loan.id}',
            type: FinancialEventType.borrowedMoney,
            title: 'Pay-back due · ${loan.personName}',
            subtitle: loan.reason,
            amountPaise: loan.balancePaise,
            day: dueDay,
            sourceId: loan.id,
          ),
        );
      }
    }

    _addProjectedSalaryDays(events, raw.salaryDay);
    _addSavingsMarkers(events);
    _addGoalMarkers(events, raw);

    return events;
  }

  static void _addProjectedSalaryDays(
    List<FinancialCalendarEvent> events,
    int salaryDay,
  ) {
    final now = istDateOnly(DateTime.now());
    for (var i = -2; i <= 4; i++) {
      var month = now.month + i;
      var year = now.year;
      while (month < 1) {
        month += 12;
        year--;
      }
      while (month > 12) {
        month -= 12;
        year++;
      }
      final dayNum = SalaryCycleEngine.clampSalaryDay(year, month, salaryDay);
      final day = DateTime(year, month, dayNum);
      final exists = events.any(
        (e) =>
            e.type == FinancialEventType.salary &&
            e.day.year == day.year &&
            e.day.month == day.month &&
            e.day.day == day.day,
      );
      if (!exists) {
        events.add(
          FinancialCalendarEvent(
            id: 'salary-projected-$year-$month-$dayNum',
            type: FinancialEventType.salary,
            title: 'Salary day',
            subtitle: 'Expected salary cycle start',
            amountPaise: 0,
            day: day,
          ),
        );
      }
    }
  }

  static void _addSavingsMarkers(List<FinancialCalendarEvent> events) {
    final byDay = groupEventsByDay(events);
    for (final entry in byDay.entries) {
      final spent = entry.value
          .where((e) => e.isDebit && !e.isFutureReady)
          .fold<int>(0, (s, e) => s + e.amountPaise);
      final received = entry.value
          .where((e) => e.isCredit && !e.isFutureReady)
          .fold<int>(0, (s, e) => s + e.amountPaise);
      if (received > spent && spent > 0) {
        events.add(
          FinancialCalendarEvent(
            id: 'savings-${entry.key.millisecondsSinceEpoch}',
            type: FinancialEventType.savings,
            title: 'Net positive day',
            subtitle: 'Saved more than you spent',
            amountPaise: received - spent,
            day: entry.key,
          ),
        );
      }
    }
  }

  static void _addGoalMarkers(
    List<FinancialCalendarEvent> events,
    FinancialCalendarRawData raw,
  ) {
    if (raw.healthScore != null && raw.healthScore! >= 75) {
      final today = istDateOnly(DateTime.now());
      events.add(
        FinancialCalendarEvent(
          id: 'goal-health-${today.millisecondsSinceEpoch}',
          type: FinancialEventType.goalContribution,
          title: 'Strong financial health',
          subtitle: raw.healthLabel ?? 'Score ${raw.healthScore}',
          amountPaise: 0,
          day: today,
        ),
      );
    }
  }

  static List<DateTime> _subscriptionRenewalDays(SubscriptionsTableData sub) {
    if (!sub.isActive || sub.nextRenewalAt == null) return [];
    final days = <DateTime>[];
    var cursor = istDateOnly(sub.nextRenewalAt!);
    final now = istDateOnly(DateTime.now());
    final windowStart = DateTime(now.year, now.month - 2, 1);
    final windowEnd = DateTime(now.year, now.month + 4, 0);

    while (cursor.isBefore(windowStart)) {
      cursor = _advanceRenewal(cursor, sub.billingCycle);
    }
    while (!cursor.isAfter(windowEnd)) {
      days.add(cursor);
      cursor = _advanceRenewal(cursor, sub.billingCycle);
    }
    return days;
  }

  static DateTime _advanceRenewal(DateTime from, String cycle) {
    if (cycle == 'yearly') {
      return DateTime(from.year + 1, from.month, from.day);
    }
    var month = from.month + 1;
    var year = from.year;
    if (month > 12) {
      month = 1;
      year++;
    }
    final day = SalaryCycleEngine.clampSalaryDay(year, month, from.day);
    return DateTime(year, month, day);
  }

  static bool _isBillCategory(CategoriesTableData category) {
    final slug = category.slug.toLowerCase();
    final name = category.name.toLowerCase();
    return slug.contains('bill') ||
        slug.contains('utilit') ||
        name.contains('bill') ||
        name.contains('rent') ||
        name.contains('electric');
  }

  static List<String> _parseTags(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return const [];
  }

  static Map<DateTime, List<FinancialCalendarEvent>> groupEventsByDay(
    List<FinancialCalendarEvent> events,
  ) {
    final map = <DateTime, List<FinancialCalendarEvent>>{};
    for (final event in events) {
      final key = DateTime(event.day.year, event.day.month, event.day.day);
      map.putIfAbsent(key, () => []).add(event);
    }
    for (final list in map.values) {
      list.sort((a, b) => b.amountPaise.compareTo(a.amountPaise));
    }
    return map;
  }

  static List<FinancialCalendarEvent> applyFilters(
    List<FinancialCalendarEvent> events,
    CalendarFilters filters,
  ) {
    return events.where((event) {
      if (event.isFutureReady) return false;

      switch (filters.kind) {
        case CalendarFilterKind.income:
          if (!event.isCredit) return false;
        case CalendarFilterKind.expense:
          if (!event.isDebit || event.type == FinancialEventType.subscription) {
            return false;
          }
        case CalendarFilterKind.subscriptions:
          if (event.type != FinancialEventType.subscription) return false;
        case CalendarFilterKind.loans:
          if (event.type != FinancialEventType.loan &&
              event.type != FinancialEventType.borrowedMoney) {
            return false;
          }
        case CalendarFilterKind.goals:
          if (event.type != FinancialEventType.goalContribution) return false;
        case CalendarFilterKind.bills:
          if (event.type != FinancialEventType.bill) return false;
        case CalendarFilterKind.savings:
          if (event.type != FinancialEventType.savings) return false;
        case CalendarFilterKind.all:
          break;
      }

      if (filters.categoryId != null &&
          event.categoryId != filters.categoryId) {
        return false;
      }

      final merchant = filters.merchantQuery?.trim().toLowerCase();
      if (merchant != null &&
          merchant.isNotEmpty &&
          !event.title.toLowerCase().contains(merchant)) {
        return false;
      }

      final tag = filters.tagQuery?.trim().toLowerCase();
      if (tag != null &&
          tag.isNotEmpty &&
          !event.tags.any((t) => t.toLowerCase().contains(tag))) {
        return false;
      }

      if (filters.minAmountPaise != null &&
          event.amountPaise < filters.minAmountPaise!) {
        return false;
      }
      if (filters.maxAmountPaise != null &&
          event.amountPaise > filters.maxAmountPaise!) {
        return false;
      }

      if (filters.customRangeStart != null || filters.customRangeEnd != null) {
        final start = filters.customRangeStart;
        final end = filters.customRangeEnd;
        if (start != null && event.day.isBefore(_dateOnly(start))) return false;
        if (end != null && event.day.isAfter(_dateOnly(end))) return false;
      }

      return true;
    }).toList();
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static Set<CalendarIndicator> indicatorsForDay({
    required DateTime day,
    required List<FinancialCalendarEvent> events,
    required int salaryDay,
    required int dailyBudgetPaise,
  }) {
    final indicators = <CalendarIndicator>{};
    final spent = events
        .where((e) =>
            (e.type == FinancialEventType.expense ||
                e.type == FinancialEventType.bill) &&
            !e.isFutureReady)
        .fold<int>(0, (s, e) => s + e.amountPaise);

    if (day.day == salaryDay) {
      indicators.add(CalendarIndicator.salaryDay);
    }

    final cycleStart = SalaryCycleEngine.cycleStartForDate(
      utcStartOfIstDay(day),
      salaryDay: salaryDay,
    );
    if (day.year == cycleStart.year &&
        day.month == cycleStart.month &&
        day.day == cycleStart.day) {
      indicators.add(CalendarIndicator.cycleStart);
    }

    if (spent == 0 && events.any((e) => !e.isFutureReady)) {
      indicators.add(CalendarIndicator.noSpend);
    } else if (dailyBudgetPaise > 0 && spent > dailyBudgetPaise) {
      indicators.add(CalendarIndicator.overBudget);
    }

    if (events.any((e) => e.type == FinancialEventType.subscription)) {
      indicators.add(CalendarIndicator.subscriptionRenewal);
    }
    if (events.any((e) => e.type == FinancialEventType.loan)) {
      indicators.add(CalendarIndicator.loanDue);
    }
    if (events.any((e) => e.type == FinancialEventType.bill)) {
      indicators.add(CalendarIndicator.billDue);
    }
    if (events.any((e) => e.type == FinancialEventType.goalContribution)) {
      indicators.add(CalendarIndicator.goalMilestone);
    }

    return indicators;
  }

  static FinancialCalendarMonthData buildMonth({
    required int year,
    required int month,
    required List<FinancialCalendarEvent> allEvents,
    required FinancialCalendarRawData raw,
    required CalendarFilters filters,
    DateTime? selectedDay,
  }) {
    final filtered = applyFilters(allEvents, filters);
    final byDay = groupEventsByDay(filtered);

    final firstOfMonth = DateTime(year, month);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday % 7;
    final gridStart = firstOfMonth.subtract(Duration(days: startWeekday));

    final today = istDateOnly(DateTime.now());
    final selected = selectedDay != null
        ? DateTime(selectedDay.year, selectedDay.month, selectedDay.day)
        : today;

    final cells = <CalendarDayCell>[];
    for (var i = 0; i < 42; i++) {
      final day = gridStart.add(Duration(days: i));
      final key = DateTime(day.year, day.month, day.day);
      final dayEvents = byDay[key] ?? const [];
      final spent = dayEvents
          .where((e) =>
              (e.type == FinancialEventType.expense ||
                  e.type == FinancialEventType.bill ||
                  e.type == FinancialEventType.subscription) &&
              !e.isFutureReady)
          .fold<int>(0, (s, e) => s + e.amountPaise);
      final received = dayEvents
          .where((e) => e.type == FinancialEventType.salary && !e.isFutureReady)
          .fold<int>(0, (s, e) => s + e.amountPaise);

      cells.add(
        CalendarDayCell(
          day: key,
          spentPaise: spent,
          receivedPaise: received,
          events: dayEvents,
          indicators: indicatorsForDay(
            day: key,
            events: dayEvents,
            salaryDay: raw.salaryDay,
            dailyBudgetPaise: raw.dailyBudgetPaise,
          ),
          isToday: key == today,
          isSelected: key == selected,
          isInMonth: day.month == month,
          isSalaryDay: key.day == raw.salaryDay &&
              dayEvents.any((e) => e.type == FinancialEventType.salary),
        ),
      );
    }

    final monthEvents = filtered.where((e) {
      final d = e.day;
      return !d.isBefore(DateTime(year, month, 1)) &&
          !d.isAfter(DateTime(year, month, daysInMonth));
    }).toList();

    final overview = _buildOverview(
      year: year,
      month: month,
      monthEvents: monthEvents,
      byDay: byDay,
      raw: raw,
    );

    final agenda = monthEvents.toList()
      ..sort((a, b) {
        final c = a.day.compareTo(b.day);
        if (c != 0) return c;
        return b.amountPaise.compareTo(a.amountPaise);
      });

    return FinancialCalendarMonthData(
      year: year,
      month: month,
      days: cells,
      overview: overview,
      agendaEvents: agenda,
      salaryDay: raw.salaryDay,
    );
  }

  static CalendarMonthOverview _buildOverview({
    required int year,
    required int month,
    required List<FinancialCalendarEvent> monthEvents,
    required Map<DateTime, List<FinancialCalendarEvent>> byDay,
    required FinancialCalendarRawData raw,
  }) {
    final income = monthEvents
        .where((e) => e.type == FinancialEventType.salary)
        .fold<int>(0, (s, e) => s + e.amountPaise);
    final expense = monthEvents
        .where((e) =>
            e.type == FinancialEventType.expense ||
            e.type == FinancialEventType.bill)
        .fold<int>(0, (s, e) => s + e.amountPaise);

    FinancialCalendarEvent? largest;
    for (final e in monthEvents) {
      if (e.type != FinancialEventType.expense &&
          e.type != FinancialEventType.bill) {
        continue;
      }
      if (largest == null || e.amountPaise > largest.amountPaise) {
        largest = e;
      }
    }

    DateTime? highestDay;
    var highestPaise = 0;
  for (final entry in byDay.entries) {
      if (entry.key.month != month || entry.key.year != year) continue;
      final spent = entry.value
          .where((e) =>
              e.type == FinancialEventType.expense ||
              e.type == FinancialEventType.bill)
          .fold<int>(0, (s, e) => s + e.amountPaise);
      if (spent > highestPaise) {
        highestPaise = spent;
        highestDay = entry.key;
      }
    }

    var noSpend = 0;
    var overBudget = 0;
    for (var d = 1; d <= DateTime(year, month + 1, 0).day; d++) {
      final key = DateTime(year, month, d);
      final dayEvents = byDay[key] ?? const [];
      final indicators = indicatorsForDay(
        day: key,
        events: dayEvents,
        salaryDay: raw.salaryDay,
        dailyBudgetPaise: raw.dailyBudgetPaise,
      );
      if (indicators.contains(CalendarIndicator.noSpend)) noSpend++;
      if (indicators.contains(CalendarIndicator.overBudget)) overBudget++;
    }

    final cycleKey = cycleKeyFromDate(
      DateTime.utc(year, month, 15),
      salaryDay: raw.salaryDay,
    );

    return CalendarMonthOverview(
      incomePaise: income,
      expensePaise: expense,
      savingsPaise: income - expense,
      largestExpense: largest,
      highestSpendingDay: highestDay,
      highestSpendingPaise: highestPaise,
      budgetRemainingPaise: raw.budgetRemainingPaise,
      subscriptionMonthlyPaise: raw.subscriptionMonthlyPaise,
      goalContributions: monthEvents
          .where((e) => e.type == FinancialEventType.goalContribution)
          .length,
      safeDailyPaise: raw.safeDailyPaise,
      cycleKey: cycleKey,
      cycleLabel: formatCycleLabel(cycleKey, salaryDay: raw.salaryDay),
      noSpendDays: noSpend,
      overBudgetDays: overBudget,
    );
  }

  static CalendarDaySummary buildDaySummary({
    required DateTime day,
    required List<FinancialCalendarEvent> events,
    required FinancialCalendarRawData raw,
  }) {
    final key = DateTime(day.year, day.month, day.day);
    final dayEvents = events.where((e) {
      final d = DateTime(e.day.year, e.day.month, e.day.day);
      return d == key && !e.isFutureReady;
    }).toList();

    final spent = dayEvents
        .where((e) =>
            e.type == FinancialEventType.expense ||
            e.type == FinancialEventType.bill ||
            e.type == FinancialEventType.subscription)
        .fold<int>(0, (s, e) => s + e.amountPaise);
    final received = dayEvents
        .where((e) => e.type == FinancialEventType.salary)
        .fold<int>(0, (s, e) => s + e.amountPaise);

    final cycleKey = cycleKeyFromDate(
      utcStartOfIstDay(key),
      salaryDay: raw.salaryDay,
    );

    return CalendarDaySummary(
      day: key,
      spentPaise: spent,
      receivedPaise: received,
      savingsPaise: received - spent,
      transactions: dayEvents
          .where((e) =>
              e.type == FinancialEventType.expense ||
              e.type == FinancialEventType.income)
          .toList(),
      subscriptions:
          dayEvents.where((e) => e.type == FinancialEventType.subscription).toList(),
      bills: dayEvents.where((e) => e.type == FinancialEventType.bill).toList(),
      goals: dayEvents
          .where((e) => e.type == FinancialEventType.goalContribution)
          .toList(),
      healthScore: raw.healthScore,
      healthLabel: raw.healthLabel,
      cycleKey: cycleKey,
      cycleLabel: formatCycleLabel(cycleKey, salaryDay: raw.salaryDay),
      safeDailyPaise: raw.safeDailyPaise,
      indicators: indicatorsForDay(
        day: key,
        events: dayEvents,
        salaryDay: raw.salaryDay,
        dailyBudgetPaise: raw.dailyBudgetPaise,
      ),
    );
  }
}
