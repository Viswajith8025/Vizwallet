import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';

/// India Standard Time offset — no DST.
const istOffset = Duration(hours: 5, minutes: 30);

DateTime toIst(DateTime utc) => utc.toUtc().add(istOffset);

DateTime nowIst() => toIst(DateTime.now());

// ---------------------------------------------------------------------------
// Salary-cycle keys (stored in `monthKey` columns for backward compatibility)
// ---------------------------------------------------------------------------

/// Returns cycle anchor key like `2026-06-17` for the salary cycle containing [date].
String cycleKeyFromDate(DateTime date, {required int salaryDay}) =>
    SalaryCycleEngine.cycleKeyFromDate(date, salaryDay: salaryDay);

String currentCycleKey({required int salaryDay}) =>
    SalaryCycleEngine.currentCycleKey(salaryDay: salaryDay);

List<String> recentCycleKeys({required int salaryDay, int count = 12}) =>
    SalaryCycleEngine.recentCycleKeys(salaryDay: salaryDay, count: count);

String formatCycleLabel(String cycleKey, {required int salaryDay}) =>
    SalaryCycleEngine.formatCycleLabel(cycleKey, salaryDay: salaryDay);

String formatCycleLabelShort(String cycleKey, {required int salaryDay}) =>
    SalaryCycleEngine.formatCycleLabelShort(cycleKey, salaryDay: salaryDay);

String previousCycleKey(String cycleKey, {required int salaryDay}) =>
    SalaryCycleEngine.previousCycleKey(cycleKey, salaryDay: salaryDay);

int daysUntilNextSalary({required int salaryDay, DateTime? from}) =>
    SalaryCycleEngine.daysUntilNextSalary(salaryDay: salaryDay, from: from);

int daysRemainingInCycle({required int salaryDay, DateTime? from}) =>
    SalaryCycleEngine.daysRemainingInCycle(salaryDay: salaryDay, from: from);

// ---------------------------------------------------------------------------
// Legacy calendar-month helpers (deprecated — use cycle APIs above)
// ---------------------------------------------------------------------------

@Deprecated('Use cycleKeyFromDate with salaryDay')
String monthKeyFromDate(DateTime date) {
  final ist = toIst(date);
  final month = ist.month.toString().padLeft(2, '0');
  return '${ist.year}-$month';
}

@Deprecated('Use currentCycleKey with salaryDay')
String currentMonthKey() => monthKeyFromDate(DateTime.now());

@Deprecated('Use SalaryCycleEngine.cycleBounds')
DateTime startOfMonthIst(String monthKey) {
  final parts = monthKey.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  return DateTime.utc(year, month, 1).subtract(istOffset);
}

@Deprecated('Use SalaryCycleEngine.cycleBounds')
DateTime endOfMonthIst(String monthKey) {
  final parts = monthKey.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final nextMonth = month == 12
      ? DateTime.utc(year + 1, 1, 1)
      : DateTime.utc(year, month + 1, 1);
  return nextMonth.subtract(istOffset).subtract(const Duration(milliseconds: 1));
}

@Deprecated('Use daysUntilNextSalary')
int daysUntilSalaryDay({required int salaryDay, DateTime? from}) =>
    daysUntilNextSalary(salaryDay: salaryDay, from: from);

@Deprecated('Use daysRemainingInCycle')
int daysRemainingInMonth({DateTime? from, int salaryDay = 1}) =>
    daysRemainingInCycle(salaryDay: salaryDay, from: from);

@Deprecated('Use formatCycleLabel')
String formatMonthLabel(String monthKey) {
  if (SalaryCycleEngine.isCycleKey(monthKey)) {
    final parts = monthKey.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[month - 1]} $year';
  }
  final parts = monthKey.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return '${months[month - 1]} $year';
}

@Deprecated('Use recentCycleKeys')
List<String> recentMonthKeys({int count = 12}) {
  final keys = <String>[];
  var date = DateTime.now();
  for (var i = 0; i < count; i++) {
    keys.add(monthKeyFromDate(date));
    date = DateTime(date.year, date.month - 1, date.day);
  }
  return keys;
}
