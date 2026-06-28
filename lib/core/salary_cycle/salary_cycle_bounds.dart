/// Inclusive IST calendar boundaries for one salary cycle.
class SalaryCycleBounds {
  const SalaryCycleBounds({
    required this.cycleKey,
    required this.startIst,
    required this.endIst,
    required this.salaryDay,
  });

  /// Anchor key `YYYY-MM-DD` — the salary date that opens this cycle.
  final String cycleKey;

  /// First day of the cycle (IST, date-only).
  final DateTime startIst;

  /// Last day of the cycle (IST, date-only).
  final DateTime endIst;

  /// Configured salary day (may be clamped per month inside the engine).
  final int salaryDay;

  int get totalDays => endIst.difference(startIst).inDays + 1;

  bool containsIstDate(DateTime istDateOnly) {
    final d = DateTime(istDateOnly.year, istDateOnly.month, istDateOnly.day);
    return !d.isBefore(startIst) && !d.isAfter(endIst);
  }
}
