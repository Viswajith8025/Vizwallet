import 'package:rupee_track/core/database/daos/expenses_dao.dart';

class CycleSummary {
  const CycleSummary({
    required this.cycleKey,
    required this.salaryPaise,
    required this.spentPaise,
    required this.savingsPaise,
    required this.savingsPercent,
    required this.moneyLeftPaise,
    required this.carryOverPaise,
    required this.daysToSalary,
    required this.daysLeftInCycle,
    required this.safeDailyLimitPaise,
    required this.salaryEntered,
    required this.categoryBreakdown,
    required this.pendingBorrowedPaise,
    required this.subscriptionMonthlyPaise,
    required this.upcomingSubscriptionsCount,
    required this.overdueLoansCount,
  });

  final String cycleKey;
  final int salaryPaise;
  final int spentPaise;
  final int savingsPaise;
  final double savingsPercent;
  final int moneyLeftPaise;
  final int carryOverPaise;
  final int daysToSalary;
  final int daysLeftInCycle;
  final int safeDailyLimitPaise;
  final bool salaryEntered;
  final List<CategorySpendRow> categoryBreakdown;
  final int pendingBorrowedPaise;
  final int subscriptionMonthlyPaise;
  final int upcomingSubscriptionsCount;
  final int overdueLoansCount;

  /// Backward-compatible alias.
  String get monthKey => cycleKey;
  int get daysLeftInMonth => daysLeftInCycle;
}

/// @deprecated Use [CycleSummary].
typedef MonthlySummary = CycleSummary;
