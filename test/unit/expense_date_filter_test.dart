import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/expenses/domain/expense_date_filter.dart';

void main() {
  group('ExpenseDateFilter dateRange', () {
    test('boundsUtc spans inclusive IST days', () {
      final filter = ExpenseDateFilter(
        mode: ExpenseDateFilterMode.dateRange,
        rangeStart: DateTime(2026, 3, 1),
        rangeEnd: DateTime(2026, 3, 5),
      );

      final (startUtc, endUtc) = filter.boundsUtc(salaryDay: 1);
      final day1 = istDayBoundsUtc(DateTime(2026, 3, 1));
      final day5 = istDayBoundsUtc(DateTime(2026, 3, 5));

      expect(startUtc, day1.$1);
      expect(endUtc, day5.$2);
    });

    test('boundsUtc normalizes reversed dates', () {
      final filter = ExpenseDateFilter(
        mode: ExpenseDateFilterMode.dateRange,
        rangeStart: DateTime(2026, 3, 10),
        rangeEnd: DateTime(2026, 3, 3),
      );

      final (startUtc, endUtc) = filter.boundsUtc(salaryDay: 1);
      final day3 = istDayBoundsUtc(DateTime(2026, 3, 3));
      final day10 = istDayBoundsUtc(DateTime(2026, 3, 10));

      expect(startUtc, day3.$1);
      expect(endUtc, day10.$2);
    });

    test('label formats same-month range compactly', () {
      final filter = ExpenseDateFilter(
        mode: ExpenseDateFilterMode.dateRange,
        rangeStart: DateTime(2026, 6, 1),
        rangeEnd: DateTime(2026, 6, 15),
      );

      expect(filter.label(salaryDay: 1), '1–15 Jun 2026');
    });
  });
}
