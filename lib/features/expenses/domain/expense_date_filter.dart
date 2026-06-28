import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_engine.dart';

enum ExpenseDateFilterMode { today, pickDate, payCycle }

class ExpenseDateFilter {
  const ExpenseDateFilter({
    this.mode = ExpenseDateFilterMode.today,
    this.pickedDate,
  });

  final ExpenseDateFilterMode mode;
  final DateTime? pickedDate;

  ExpenseDateFilter copyWith({
    ExpenseDateFilterMode? mode,
    DateTime? pickedDate,
    bool clearPickedDate = false,
  }) {
    return ExpenseDateFilter(
      mode: mode ?? this.mode,
      pickedDate: clearPickedDate ? null : (pickedDate ?? this.pickedDate),
    );
  }

  (DateTime startUtc, DateTime endUtc) boundsUtc({required int salaryDay}) {
    switch (mode) {
      case ExpenseDateFilterMode.today:
        return istDayBoundsUtc(DateTime.now());
      case ExpenseDateFilterMode.pickDate:
        final day = pickedDate ?? DateTime.now();
        return istDayBoundsUtc(day);
      case ExpenseDateFilterMode.payCycle:
        final cycleKey = currentCycleKey(salaryDay: salaryDay);
        final bounds = SpendingTrendsEngine.cycleBoundsUtc(
          cycleKey,
          salaryDay: salaryDay,
        );
        return (bounds.startUtc, bounds.endUtc);
    }
  }

  String label({required int salaryDay}) {
    switch (mode) {
      case ExpenseDateFilterMode.today:
        final today = nowIst();
        return 'Today · ${today.day} ${_monthShort(today.month)}';
      case ExpenseDateFilterMode.pickDate:
        final day = toIst(pickedDate ?? DateTime.now());
        return '${day.day} ${_monthShort(day.month)} ${day.year}';
      case ExpenseDateFilterMode.payCycle:
        return formatCycleLabelShort(
          currentCycleKey(salaryDay: salaryDay),
          salaryDay: salaryDay,
        );
    }
  }

  static String _monthShort(int month) => const [
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
}

final expenseDateFilterProvider =
    NotifierProvider<ExpenseDateFilterNotifier, ExpenseDateFilter>(
  ExpenseDateFilterNotifier.new,
);

class ExpenseDateFilterNotifier extends Notifier<ExpenseDateFilter> {
  @override
  ExpenseDateFilter build() => const ExpenseDateFilter();

  void setToday() => state = const ExpenseDateFilter(mode: ExpenseDateFilterMode.today);

  void setPayCycle() =>
      state = const ExpenseDateFilter(mode: ExpenseDateFilterMode.payCycle);

  void setPickedDate(DateTime date) => state = ExpenseDateFilter(
        mode: ExpenseDateFilterMode.pickDate,
        pickedDate: date,
      );
}
