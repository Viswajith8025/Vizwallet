/// How an income source defines its pay cycle.
///
/// v1 implements [monthlyDay] only. [weekly] and [irregular] are reserved for
/// freelance / multi-income support without schema changes.
enum SalaryCycleType {
  monthlyDay('monthly_day'),
  weekly('weekly'),
  irregular('irregular');

  const SalaryCycleType(this.storageKey);

  final String storageKey;

  static SalaryCycleType fromKey(String key) => values.firstWhere(
        (t) => t.storageKey == key,
        orElse: () => monthlyDay,
      );
}
