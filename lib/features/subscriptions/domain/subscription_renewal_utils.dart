/// Helpers for subscription renewal scheduling.
abstract final class SubscriptionRenewalUtils {
  /// Next billing date on [dayOfMonth] (1–31), on or after today.
  static DateTime nextRenewalOnDay(int dayOfMonth, {DateTime? from}) {
    final anchor = from ?? DateTime.now();
    final day = dayOfMonth.clamp(1, 31);

    DateTime onMonth(int year, int month) {
      final lastDay = DateTime(year, month + 1, 0).day;
      return DateTime(year, month, day.clamp(1, lastDay));
    }

    var candidate = onMonth(anchor.year, anchor.month);
    if (!candidate.isAfter(anchor)) {
      var month = anchor.month + 1;
      var year = anchor.year;
      if (month > 12) {
        month = 1;
        year++;
      }
      candidate = onMonth(year, month);
    }
    return candidate;
  }

  static int dayOfMonthFromRenewal(DateTime? renewal) {
    if (renewal == null) return DateTime.now().day;
    return renewal.toLocal().day;
  }
}
