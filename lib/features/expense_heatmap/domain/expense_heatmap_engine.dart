import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rupee_track/core/database/daos/expenses_dao.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_models.dart';

/// GitHub-style spending heatmap — pure logic, local-first.
abstract final class ExpenseHeatmapEngine {
  static ExpenseHeatmapReport build({
    required HeatmapViewMode viewMode,
    required DateTime rangeStartIst,
    required DateTime rangeEndIst,
    required List<ExpenseWithCategory> expenses,
    required List<({DateTime date, int amountPaise})> incomeByDay,
    required HeatmapThresholds thresholds,
    required HeatmapFilters filters,
    String? rangeLabel,
    DateTime? now,
  }) {
    final clock = (now ?? DateTime.now());
    final start = _dateOnly(rangeStartIst);
    final end = _dateOnly(rangeEndIst);

    final transactions = _toTransactions(expenses, incomeByDay);
    final filtered = _applyFilters(transactions, filters);

    final spentByDay = <DateTime, int>{};
    final incomeDayMap = <DateTime, int>{};
    for (final t in filtered) {
      final day = _dateOnly(toIst(t.occurredAt));
      if (t.isIncome) {
        incomeDayMap[day] = (incomeDayMap[day] ?? 0) + t.amountPaise;
      } else {
        spentByDay[day] = (spentByDay[day] ?? 0) + t.amountPaise;
      }
    }

    final gridStart = _startOfWeek(start);
    final gridEnd = _endOfWeek(end);
    final weeks = <HeatmapWeekColumn>[];
    var weekIndex = 0;
    var cursor = gridStart;

    while (!cursor.isAfter(gridEnd)) {
      final weekStart = cursor;
      final cells = <HeatmapDayCell?>[];
      var weekTotal = 0;

      for (var dow = 0; dow < 7; dow++) {
        final day = weekStart.add(Duration(days: dow));
        final inRange = !day.isBefore(start) && !day.isAfter(end);
        final spent = inRange ? (spentByDay[day] ?? 0) : 0;
        final income = inRange ? (incomeDayMap[day] ?? 0) : 0;
        if (inRange) weekTotal += spent;

        cells.add(
          HeatmapDayCell(
            date: day,
            spentPaise: spent,
            incomePaise: income,
            level: inRange
                ? thresholds.levelFor(spent)
                : HeatmapIntensityLevel.none,
            inRange: inRange,
            weekIndex: weekIndex,
            weekdayIndex: dow,
          ),
        );
      }

      weeks.add(
        HeatmapWeekColumn(
          weekIndex: weekIndex,
          label: _weekLabel(weekStart),
          totalSpentPaise: weekTotal,
          cells: cells,
        ),
      );

      weekIndex++;
      cursor = cursor.add(const Duration(days: 7));
    }

    final inRangeDays = <HeatmapDayCell>[];
    for (final week in weeks) {
      for (final cell in week.cells) {
        if (cell != null && cell.inRange) inRangeDays.add(cell);
      }
    }

    final stats = _statistics(inRangeDays, weeks, start, end);
    final insights = _insights(
      inRangeDays: inRangeDays,
      weeks: weeks,
      incomeByDay: incomeDayMap,
      start: start,
      end: end,
    );

    return ExpenseHeatmapReport(
      viewMode: viewMode,
      rangeLabel: rangeLabel ?? _defaultRangeLabel(viewMode, start, end),
      rangeStart: start,
      rangeEnd: end,
      weeks: weeks,
      thresholds: thresholds,
      statistics: stats,
      insights: insights,
      allTransactions: filtered,
      generatedAt: clock,
    );
  }

  static HeatmapDayDetail dayDetail({
    required DateTime date,
    required ExpenseHeatmapReport report,
    required int safeDailySpendPaise,
    required int budgetRemainingPaise,
    required int? healthScore,
    required String? healthLabel,
    required int goalContributionsPaise,
  }) {
    final day = _dateOnly(date);
    final dayTx = report.allTransactions.where((t) {
      final d = _dateOnly(toIst(t.occurredAt));
      return d == day;
    }).toList()
      ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));

    final spent =
        dayTx.where((t) => !t.isIncome).fold<int>(0, (s, t) => s + t.amountPaise);
    final income =
        dayTx.where((t) => t.isIncome).fold<int>(0, (s, t) => s + t.amountPaise);

    final merchantMap = <String, ({int total, int count})>{};
    for (final t in dayTx.where((t) => !t.isIncome)) {
      final key = t.title.trim().isEmpty ? t.categoryName : t.title;
      final existing = merchantMap[key];
      merchantMap[key] = (
        total: (existing?.total ?? 0) + t.amountPaise,
        count: (existing?.count ?? 0) + 1,
      );
    }

    final merchants = merchantMap.entries
        .map(
          (e) => HeatmapMerchantSlice(
            name: e.key,
            totalPaise: e.value.total,
            count: e.value.count,
          ),
        )
        .toList()
      ..sort((a, b) => b.totalPaise.compareTo(a.totalPaise));

    final cell = report.cellForDate(day);

    return HeatmapDayDetail(
      date: day,
      totalSpentPaise: spent,
      totalIncomePaise: income,
      safeDailySpendPaise: safeDailySpendPaise,
      budgetRemainingPaise: budgetRemainingPaise,
      healthScore: healthScore,
      healthLabel: healthLabel,
      goalContributionsPaise: goalContributionsPaise,
      transactions: dayTx,
      merchants: merchants,
      level: cell?.level ?? report.thresholds.levelFor(spent),
    );
  }

  static ({DateTime startIst, DateTime endIst, String label}) resolveRange({
    required HeatmapViewMode mode,
    required DateTime anchorIst,
    required int salaryDay,
    String? cycleKey,
    DateTime? customStart,
    DateTime? customEnd,
  }) {
    final anchor = _dateOnly(anchorIst);

    switch (mode) {
      case HeatmapViewMode.monthly:
        final start = DateTime(anchor.year, anchor.month, 1);
        final end = DateTime(anchor.year, anchor.month + 1, 0);
        return (
          startIst: start,
          endIst: end,
          label: _monthYearLabel(start),
        );
      case HeatmapViewMode.quarterly:
        final start = DateTime(anchor.year, anchor.month - 2, 1);
        final end = DateTime(anchor.year, anchor.month + 1, 0);
        return (
          startIst: start,
          endIst: end,
          label: '${_monthYearLabel(start)} – ${_monthYearLabel(end)}',
        );
      case HeatmapViewMode.yearly:
        final start = DateTime(anchor.year, anchor.month - 11, 1);
        final end = DateTime(anchor.year, anchor.month + 1, 0);
        return (
          startIst: start,
          endIst: end,
          label: '${_monthYearLabel(start)} – ${_monthYearLabel(end)}',
        );
      case HeatmapViewMode.salaryCycle:
        final key = cycleKey ??
            SalaryCycleEngine.cycleKeyFromDate(anchor, salaryDay: salaryDay);
        final bounds =
            SalaryCycleEngine.cycleBounds(key, salaryDay: salaryDay);
        return (
          startIst: bounds.startIst,
          endIst: bounds.endIst,
          label: SalaryCycleEngine.formatCycleLabelShort(key, salaryDay: salaryDay),
        );
      case HeatmapViewMode.custom:
        final start = _dateOnly(customStart ?? anchor);
        final end = _dateOnly(customEnd ?? anchor);
        return (
          startIst: start,
          endIst: end,
          label:
              '${start.day}/${start.month}/${start.year} – ${end.day}/${end.month}/${end.year}',
        );
    }
  }

  static List<HeatmapTransaction> _toTransactions(
    List<ExpenseWithCategory> expenses,
    List<({DateTime date, int amountPaise})> incomeByDay,
  ) {
    final list = expenses.map((row) {
      final e = row.expense;
      return HeatmapTransaction(
        id: e.id,
        title: e.title,
        amountPaise: e.amountPaise,
        categoryName: row.category.name,
        categoryId: row.category.id,
        paymentMethod: e.paymentMethod,
        occurredAt: e.occurredAt,
        isIncome: false,
        tags: _parseTags(e.tags),
      );
    }).toList();

    for (final income in incomeByDay) {
      list.add(
        HeatmapTransaction(
          id: -income.date.millisecondsSinceEpoch,
          title: 'Salary',
          amountPaise: income.amountPaise,
          categoryName: 'Income',
          paymentMethod: 'Salary',
          occurredAt: DateTime.utc(income.date.year, income.date.month,
              income.date.day),
          isIncome: true,
          tags: const ['income'],
        ),
      );
    }

    return list;
  }

  static List<HeatmapTransaction> _applyFilters(
    List<HeatmapTransaction> items,
    HeatmapFilters filters,
  ) {
    return items.where((t) {
      if (filters.categoryId != null && !t.isIncome) {
        if (t.categoryId != filters.categoryId) return false;
      }
      final merchant = filters.merchantQuery?.trim().toLowerCase();
      if (merchant != null && merchant.isNotEmpty) {
        if (!t.title.toLowerCase().contains(merchant) &&
            !t.categoryName.toLowerCase().contains(merchant)) {
          return false;
        }
      }
      final payment = filters.paymentMethod?.trim();
      if (payment != null &&
          payment.isNotEmpty &&
          t.paymentMethod != payment) {
        return false;
      }
      final tag = filters.tagQuery?.trim().toLowerCase();
      if (tag != null && tag.isNotEmpty) {
        if (!t.tags.any((x) => x.toLowerCase().contains(tag))) {
          return false;
        }
      }

      return switch (filters.kind) {
        HeatmapFilterKind.all => true,
        HeatmapFilterKind.income => t.isIncome,
        HeatmapFilterKind.expense => !t.isIncome,
        HeatmapFilterKind.subscriptions =>
          t.categoryName.toLowerCase().contains('subscription') ||
              t.tags.any((x) => x.toLowerCase().contains('subscription')),
        HeatmapFilterKind.loans =>
          t.categoryName.toLowerCase().contains('loan') ||
              t.tags.any((x) => x.toLowerCase().contains('loan')),
        HeatmapFilterKind.goals =>
          t.tags.any((x) => x.toLowerCase().contains('goal')),
        HeatmapFilterKind.wishlist =>
          t.tags.any((x) => x.toLowerCase().contains('wishlist')),
      };
    }).toList();
  }

  static HeatmapStatistics _statistics(
    List<HeatmapDayCell> inRangeDays,
    List<HeatmapWeekColumn> weeks,
    DateTime start,
    DateTime end,
  ) {
    if (inRangeDays.isEmpty) {
      return const HeatmapStatistics(
        highestSpendingDay: null,
        highestSpendingPaise: 0,
        averageDailySpendingPaise: 0,
        noSpendDays: 0,
        mostActiveWeekLabel: '—',
        mostActiveWeekPaise: 0,
        longestNoSpendStreak: 0,
        highestSpendingMonthLabel: '—',
        highestSpendingMonthPaise: 0,
        averageWeekendSpendingPaise: 0,
        averageWeekdaySpendingPaise: 0,
      );
    }

    final highest = inRangeDays.reduce(
      (a, b) => a.spentPaise >= b.spentPaise ? a : b,
    );
    final totalSpent =
        inRangeDays.fold<int>(0, (s, d) => s + d.spentPaise);
    final dayCount = end.difference(start).inDays + 1;
    final noSpend = inRangeDays.where((d) => d.spentPaise == 0).length;

    final activeWeeks = weeks.where((w) => w.totalSpentPaise > 0).toList();
    final mostActiveWeek = activeWeeks.isEmpty
        ? weeks.first
        : activeWeeks.reduce(
            (a, b) => a.totalSpentPaise >= b.totalSpentPaise ? a : b,
          );

    var longestStreak = 0;
    var current = 0;
    final sorted = [...inRangeDays]..sort((a, b) => a.date.compareTo(b.date));
    for (final day in sorted) {
      if (day.spentPaise == 0) {
        current++;
        if (current > longestStreak) longestStreak = current;
      } else {
        current = 0;
      }
    }

    final monthTotals = <String, int>{};
    for (final day in inRangeDays) {
      final key = _monthYearLabel(day.date);
      monthTotals[key] = (monthTotals[key] ?? 0) + day.spentPaise;
    }
    final topMonth = monthTotals.entries.reduce(
      (a, b) => a.value >= b.value ? a : b,
    );

    var weekendTotal = 0;
    var weekendDays = 0;
    var weekdayTotal = 0;
    var weekdayDays = 0;
    for (final day in inRangeDays) {
      final dow = day.date.weekday;
      if (dow == DateTime.saturday || dow == DateTime.sunday) {
        weekendTotal += day.spentPaise;
        weekendDays++;
      } else {
        weekdayTotal += day.spentPaise;
        weekdayDays++;
      }
    }

    return HeatmapStatistics(
      highestSpendingDay: highest.spentPaise > 0 ? highest.date : null,
      highestSpendingPaise: highest.spentPaise,
      averageDailySpendingPaise: dayCount > 0 ? (totalSpent / dayCount).round() : 0,
      noSpendDays: noSpend,
      mostActiveWeekLabel: mostActiveWeek.label,
      mostActiveWeekPaise: mostActiveWeek.totalSpentPaise,
      longestNoSpendStreak: longestStreak,
      highestSpendingMonthLabel: topMonth.key,
      highestSpendingMonthPaise: topMonth.value,
      averageWeekendSpendingPaise:
          weekendDays > 0 ? (weekendTotal / weekendDays).round() : 0,
      averageWeekdaySpendingPaise:
          weekdayDays > 0 ? (weekdayTotal / weekdayDays).round() : 0,
    );
  }

  static List<HeatmapInsight> _insights({
    required List<HeatmapDayCell> inRangeDays,
    required List<HeatmapWeekColumn> weeks,
    required Map<DateTime, int> incomeByDay,
    required DateTime start,
    required DateTime end,
  }) {
    final insights = <HeatmapInsight>[];

    if (inRangeDays.isEmpty) {
      return [
        const HeatmapInsight(
          message: 'Log expenses to see your spending heatmap.',
          icon: Icons.grid_on_outlined,
        ),
      ];
    }

    final weekdayTotals = List<int>.filled(7, 0);
    final weekdayCounts = List<int>.filled(7, 0);
    for (final day in inRangeDays) {
      final i = day.date.weekday - 1;
      weekdayTotals[i] += day.spentPaise;
      weekdayCounts[i]++;
    }
    final maxDow = weekdayTotals.indexOf(
      weekdayTotals.reduce((a, b) => a > b ? a : b),
    );
    const dayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    if (weekdayTotals[maxDow] > 0) {
      insights.add(HeatmapInsight(
        message: 'You spend most on ${dayNames[maxDow]}s.',
        icon: Icons.calendar_today_outlined,
      ));
    }

    final noSpend =
        inRangeDays.where((d) => d.spentPaise == 0 && d.inRange).length;
    if (noSpend > 0) {
      insights.add(HeatmapInsight(
        message:
            'You maintained $noSpend No Spend Day${noSpend == 1 ? '' : 's'}.',
        icon: Icons.celebration_outlined,
      ));
    }

    final inRangeWeeks =
        weeks.where((w) => w.cells.any((c) => c?.inRange == true)).toList();
    if (inRangeWeeks.length >= 3) {
      final week3 = inRangeWeeks.length >= 3 ? inRangeWeeks[2] : null;
      if (week3 != null && week3.totalSpentPaise > 0) {
        final maxWeek = inRangeWeeks.reduce(
          (a, b) => a.totalSpentPaise >= b.totalSpentPaise ? a : b,
        );
        if (maxWeek.weekIndex == 2) {
          insights.add(const HeatmapInsight(
            message: 'Week 3 had the highest spending.',
            icon: Icons.trending_up,
          ));
        }
      }
    }

    if (incomeByDay.isNotEmpty) {
      var postPayTotal = 0;
      var postPayDays = 0;
      var otherTotal = 0;
      var otherDays = 0;

      for (final day in inRangeDays) {
        final hasPayday = incomeByDay.keys.any((pay) {
          final diff = day.date.difference(pay).inDays;
          return diff >= 0 && diff <= 3;
        });
        if (hasPayday) {
          postPayTotal += day.spentPaise;
          postPayDays++;
        } else {
          otherTotal += day.spentPaise;
          otherDays++;
        }
      }

      if (postPayDays > 0 && otherDays > 0 && otherTotal > 0) {
        final postAvg = postPayTotal / postPayDays;
        final otherAvg = otherTotal / otherDays;
        if (postAvg > otherAvg * 1.1) {
          final pct = ((postAvg - otherAvg) / otherAvg * 100).round();
          insights.add(HeatmapInsight(
            message: 'You spent $pct% more in the 3 days after payday.',
            icon: Icons.payments_outlined,
          ));
        }
      }
    }

    final weekendAvg = inRangeDays
        .where((d) =>
            d.date.weekday == DateTime.saturday ||
            d.date.weekday == DateTime.sunday)
        .map((d) => d.spentPaise)
        .fold<int>(0, (s, v) => s + v);
    final weekdayAvg = inRangeDays
        .where((d) =>
            d.date.weekday != DateTime.saturday &&
            d.date.weekday != DateTime.sunday)
        .map((d) => d.spentPaise)
        .fold<int>(0, (s, v) => s + v);
    if (weekendAvg > weekdayAvg && weekdayAvg > 0) {
      insights.add(const HeatmapInsight(
        message: 'Weekend spending outpaces weekdays in this period.',
        icon: Icons.weekend_outlined,
      ));
    }

    return insights.take(6).toList();
  }

  static DateTime _dateOnly(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  static DateTime _startOfWeek(DateTime day) {
    final mondayOffset = day.weekday - DateTime.monday;
    return day.subtract(Duration(days: mondayOffset));
  }

  static DateTime _endOfWeek(DateTime day) {
    final sundayOffset = DateTime.sunday - day.weekday;
    return day.add(Duration(days: sundayOffset));
  }

  static String _weekLabel(DateTime weekStart) {
    return '${weekStart.day}/${weekStart.month}';
  }

  static String _monthYearLabel(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  static String _defaultRangeLabel(
    HeatmapViewMode mode,
    DateTime start,
    DateTime end,
  ) {
    return switch (mode) {
      HeatmapViewMode.monthly => _monthYearLabel(start),
      HeatmapViewMode.salaryCycle => 'Salary cycle',
      _ => '${_monthYearLabel(start)} – ${_monthYearLabel(end)}',
    };
  }

  static List<String> _parseTags(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}
    return [];
  }
}
