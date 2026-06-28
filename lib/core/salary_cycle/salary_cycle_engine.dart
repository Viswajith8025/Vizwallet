import 'package:rupee_track/core/salary_cycle/salary_cycle_bounds.dart';
import 'package:rupee_track/core/utils/date_utils.dart';

/// Salary-cycle accounting — pure logic, no Flutter or database.
///
/// Financial periods are anchored to the user's salary date, e.g. salary on the
/// 17th → cycle `2026-06-17` runs 17 Jun – 16 Jul (IST).
abstract final class SalaryCycleEngine {
  static int clampSalaryDay(int year, int month, int salaryDay) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return salaryDay.clamp(1, daysInMonth);
  }

  static DateTime istDateOnly(DateTime utc) {
    final ist = toIst(utc);
    return DateTime(ist.year, ist.month, ist.day);
  }

  static String formatCycleKey(DateTime startIst) =>
      '${startIst.year}-'
      '${startIst.month.toString().padLeft(2, '0')}-'
      '${startIst.day.toString().padLeft(2, '0')}';

  static bool isLegacyMonthKey(String key) {
    final parts = key.split('-');
    return parts.length == 2 && parts[0].length == 4 && parts[1].length == 2;
  }

  static bool isCycleKey(String key) {
    final parts = key.split('-');
    return parts.length == 3 && parts[0].length == 4;
  }

  /// Maps old calendar `YYYY-MM` keys to a cycle anchor in that month.
  static String migrateLegacyMonthKey(
    String legacyKey, {
    required int salaryDay,
  }) {
    final parts = legacyKey.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final anchor = clampSalaryDay(year, month, salaryDay);
    return formatCycleKey(DateTime(year, month, anchor));
  }

  static DateTime parseCycleKey(String cycleKey, {required int salaryDay}) {
    final parts = cycleKey.split('-');
    if (parts.length == 3) {
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }
    return DateTime.parse(migrateLegacyMonthKey(cycleKey, salaryDay: salaryDay));
  }

  static DateTime cycleStartForDate(DateTime utc, {required int salaryDay}) {
    final today = istDateOnly(utc);
    final anchorThisMonth =
        clampSalaryDay(today.year, today.month, salaryDay);

    if (today.day >= anchorThisMonth) {
      return DateTime(today.year, today.month, anchorThisMonth);
    }

    var prevMonth = today.month - 1;
    var prevYear = today.year;
    if (prevMonth < 1) {
      prevMonth = 12;
      prevYear--;
    }
    final prevAnchor = clampSalaryDay(prevYear, prevMonth, salaryDay);
    return DateTime(prevYear, prevMonth, prevAnchor);
  }

  static DateTime nextCycleStartAfter(
    DateTime cycleStartIst, {
    required int salaryDay,
  }) {
    var year = cycleStartIst.year;
    var month = cycleStartIst.month + 1;
    if (month > 12) {
      month = 1;
      year++;
    }
    final anchor = clampSalaryDay(year, month, salaryDay);
    return DateTime(year, month, anchor);
  }

  static DateTime cycleEndForStart(
    DateTime cycleStartIst, {
    required int salaryDay,
  }) {
    final nextStart = nextCycleStartAfter(cycleStartIst, salaryDay: salaryDay);
    return nextStart.subtract(const Duration(days: 1));
  }

  static String cycleKeyFromDate(
    DateTime utc, {
    required int salaryDay,
  }) =>
      formatCycleKey(cycleStartForDate(utc, salaryDay: salaryDay));

  static String currentCycleKey({
    required int salaryDay,
    DateTime? from,
  }) =>
      cycleKeyFromDate(from ?? DateTime.now(), salaryDay: salaryDay);

  static SalaryCycleBounds cycleBounds(
    String cycleKey, {
    required int salaryDay,
  }) {
    final start = parseCycleKey(cycleKey, salaryDay: salaryDay);
    final end = cycleEndForStart(start, salaryDay: salaryDay);
    final key = formatCycleKey(start);
    return SalaryCycleBounds(
      cycleKey: key,
      startIst: start,
      endIst: end,
      salaryDay: salaryDay,
    );
  }

  static SalaryCycleBounds currentCycle({
    required int salaryDay,
    DateTime? from,
  }) =>
      cycleBounds(
        currentCycleKey(salaryDay: salaryDay, from: from),
        salaryDay: salaryDay,
      );

  static DateTime nextSalaryDateIst({
    required int salaryDay,
    DateTime? from,
  }) {
    final today = istDateOnly(from ?? DateTime.now());
    final anchorThisMonth =
        clampSalaryDay(today.year, today.month, salaryDay);
    final thisMonthSalary = DateTime(today.year, today.month, anchorThisMonth);

    if (today.isBefore(thisMonthSalary)) {
      return thisMonthSalary;
    }

    var nextMonth = today.month + 1;
    var nextYear = today.year;
    if (nextMonth > 12) {
      nextMonth = 1;
      nextYear++;
    }
    final nextAnchor = clampSalaryDay(nextYear, nextMonth, salaryDay);
    return DateTime(nextYear, nextMonth, nextAnchor);
  }

  /// Days until the next salary credit (0 on salary day → next month's date).
  static int daysUntilNextSalary({
    required int salaryDay,
    DateTime? from,
  }) {
    final today = istDateOnly(from ?? DateTime.now());
    final next = nextSalaryDateIst(salaryDay: salaryDay, from: from);
    return next.difference(today).inDays;
  }

  /// Days left in the current salary cycle, including today.
  static int daysRemainingInCycle({
    required int salaryDay,
    DateTime? from,
  }) {
    final bounds = currentCycle(salaryDay: salaryDay, from: from);
    final today = istDateOnly(from ?? DateTime.now());
    return bounds.endIst.difference(today).inDays + 1;
  }

  static String previousCycleKey(
    String cycleKey, {
    required int salaryDay,
  }) {
    final start = parseCycleKey(cycleKey, salaryDay: salaryDay);
    var year = start.year;
    var month = start.month - 1;
    if (month < 1) {
      month = 12;
      year--;
    }
    final anchor = clampSalaryDay(year, month, salaryDay);
    return formatCycleKey(DateTime(year, month, anchor));
  }

  static List<String> recentCycleKeys({
    required int salaryDay,
    int count = 12,
    DateTime? from,
  }) {
    final keys = <String>[];
    var key = currentCycleKey(salaryDay: salaryDay, from: from);
    for (var i = 0; i < count; i++) {
      keys.add(key);
      key = previousCycleKey(key, salaryDay: salaryDay);
    }
    return keys;
  }

  static String _shortMonth(int month) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ][month - 1];

  static String formatCycleLabel(
    String cycleKey, {
    required int salaryDay,
  }) {
    final bounds = cycleBounds(cycleKey, salaryDay: salaryDay);
    final start = bounds.startIst;
    final end = bounds.endIst;
    final startLabel =
        '${start.day} ${_shortMonth(start.month)}';
    final endLabel = '${end.day} ${_shortMonth(end.month)}';
    if (start.year == end.year) {
      return '$startLabel – $endLabel ${start.year}';
    }
    return '$startLabel ${start.year} – $endLabel ${end.year}';
  }

  static String formatCycleLabelShort(
    String cycleKey, {
    required int salaryDay,
  }) {
    final bounds = cycleBounds(cycleKey, salaryDay: salaryDay);
    final start = bounds.startIst;
    final end = bounds.endIst;
    return '${_shortMonth(start.month)} ${start.day}–'
        '${_shortMonth(end.month)} ${end.day}';
  }

  static int dailySpendingAllowance({
    required int moneyLeftPaise,
    required int daysRemaining,
  }) {
    if (daysRemaining <= 0) return moneyLeftPaise;
    return (moneyLeftPaise / daysRemaining).floor();
  }

  /// Unused salary from the previous cycle (positive carry-over only).
  static int carryOverBalance({
    required int previousSalaryPaise,
    required int previousSpentPaise,
  }) {
    final remaining = previousSalaryPaise - previousSpentPaise;
    return remaining > 0 ? remaining : 0;
  }

  static int effectiveMoneyLeft({
    required int salaryPaise,
    required int spentPaise,
    required int carryOverPaise,
  }) =>
      salaryPaise + carryOverPaise - spentPaise;
}
