import 'package:flutter/material.dart';

enum CalendarViewMode { month, week, day, agenda }

enum FinancialEventType {
  salary,
  expense,
  income,
  subscription,
  loan,
  borrowedMoney,
  bill,
  goalContribution,
  wishlistPurchase,
  savings,
  investment,
}

enum CalendarIndicator {
  salaryDay,
  overBudget,
  noSpend,
  subscriptionRenewal,
  goalMilestone,
  loanDue,
  billDue,
  wishlistPurchase,
  cycleStart,
}

enum CalendarFilterKind {
  all,
  income,
  expense,
  subscriptions,
  loans,
  goals,
  bills,
  savings,
}

class CalendarFilters {
  const CalendarFilters({
    this.kind = CalendarFilterKind.all,
    this.categoryId,
    this.merchantQuery,
    this.tagQuery,
    this.minAmountPaise,
    this.maxAmountPaise,
    this.customRangeStart,
    this.customRangeEnd,
  });

  final CalendarFilterKind kind;
  final int? categoryId;
  final String? merchantQuery;
  final String? tagQuery;
  final int? minAmountPaise;
  final int? maxAmountPaise;
  final DateTime? customRangeStart;
  final DateTime? customRangeEnd;

  bool get hasActiveFilters =>
      kind != CalendarFilterKind.all ||
      categoryId != null ||
      (merchantQuery?.trim().isNotEmpty ?? false) ||
      (tagQuery?.trim().isNotEmpty ?? false) ||
      minAmountPaise != null ||
      maxAmountPaise != null ||
      customRangeStart != null;

  CalendarFilters copyWith({
    CalendarFilterKind? kind,
    int? categoryId,
    bool clearCategoryId = false,
    String? merchantQuery,
    String? tagQuery,
    int? minAmountPaise,
    bool clearMinAmount = false,
    int? maxAmountPaise,
    bool clearMaxAmount = false,
    DateTime? customRangeStart,
    DateTime? customRangeEnd,
    bool clearCustomRange = false,
  }) {
    return CalendarFilters(
      kind: kind ?? this.kind,
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      merchantQuery: merchantQuery ?? this.merchantQuery,
      tagQuery: tagQuery ?? this.tagQuery,
      minAmountPaise:
          clearMinAmount ? null : (minAmountPaise ?? this.minAmountPaise),
      maxAmountPaise:
          clearMaxAmount ? null : (maxAmountPaise ?? this.maxAmountPaise),
      customRangeStart: clearCustomRange
          ? null
          : (customRangeStart ?? this.customRangeStart),
      customRangeEnd:
          clearCustomRange ? null : (customRangeEnd ?? this.customRangeEnd),
    );
  }
}

class FinancialCalendarEvent {
  const FinancialCalendarEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.amountPaise,
    required this.day,
    this.subtitle,
    this.colorValue,
    this.categoryId,
    this.sourceId,
    this.tags = const [],
    this.isFutureReady = false,
  });

  final String id;
  final FinancialEventType type;
  final String title;
  final String? subtitle;
  final int amountPaise;
  final DateTime day;
  final int? colorValue;
  final int? categoryId;
  final int? sourceId;
  final List<String> tags;
  final bool isFutureReady;

  bool get isDebit =>
      type == FinancialEventType.expense ||
      type == FinancialEventType.subscription ||
      type == FinancialEventType.bill ||
      type == FinancialEventType.borrowedMoney ||
      type == FinancialEventType.wishlistPurchase;

  bool get isCredit =>
      type == FinancialEventType.salary ||
      type == FinancialEventType.income ||
      type == FinancialEventType.savings ||
      type == FinancialEventType.goalContribution;
}

class CalendarDayCell {
  const CalendarDayCell({
    required this.day,
    required this.spentPaise,
    required this.receivedPaise,
    required this.events,
    required this.indicators,
    this.isToday = false,
    this.isSelected = false,
    this.isInMonth = true,
    this.isSalaryDay = false,
  });

  final DateTime day;
  final int spentPaise;
  final int receivedPaise;
  final List<FinancialCalendarEvent> events;
  final Set<CalendarIndicator> indicators;
  final bool isToday;
  final bool isSelected;
  final bool isInMonth;
  final bool isSalaryDay;

  int get netPaise => receivedPaise - spentPaise;

  List<FinancialCalendarEvent> get visibleEvents => events.take(4).toList();
}

class CalendarDaySummary {
  const CalendarDaySummary({
    required this.day,
    required this.spentPaise,
    required this.receivedPaise,
    required this.savingsPaise,
    required this.transactions,
    required this.subscriptions,
    required this.bills,
    required this.goals,
    required this.healthScore,
    required this.healthLabel,
    required this.cycleKey,
    required this.cycleLabel,
    required this.safeDailyPaise,
    required this.indicators,
  });

  final DateTime day;
  final int spentPaise;
  final int receivedPaise;
  final int savingsPaise;
  final List<FinancialCalendarEvent> transactions;
  final List<FinancialCalendarEvent> subscriptions;
  final List<FinancialCalendarEvent> bills;
  final List<FinancialCalendarEvent> goals;
  final int? healthScore;
  final String? healthLabel;
  final String cycleKey;
  final String cycleLabel;
  final int safeDailyPaise;
  final Set<CalendarIndicator> indicators;
}

class CalendarMonthOverview {
  const CalendarMonthOverview({
    required this.incomePaise,
    required this.expensePaise,
    required this.savingsPaise,
    required this.largestExpense,
    required this.highestSpendingDay,
    required this.highestSpendingPaise,
    required this.budgetRemainingPaise,
    required this.subscriptionMonthlyPaise,
    required this.goalContributions,
    required this.safeDailyPaise,
    required this.cycleKey,
    required this.cycleLabel,
    required this.noSpendDays,
    required this.overBudgetDays,
  });

  final int incomePaise;
  final int expensePaise;
  final int savingsPaise;
  final FinancialCalendarEvent? largestExpense;
  final DateTime? highestSpendingDay;
  final int highestSpendingPaise;
  final int budgetRemainingPaise;
  final int subscriptionMonthlyPaise;
  final int goalContributions;
  final int safeDailyPaise;
  final String cycleKey;
  final String cycleLabel;
  final int noSpendDays;
  final int overBudgetDays;
}

class FinancialCalendarMonthData {
  const FinancialCalendarMonthData({
    required this.year,
    required this.month,
    required this.days,
    required this.overview,
    required this.agendaEvents,
    required this.salaryDay,
  });

  final int year;
  final int month;
  final List<CalendarDayCell> days;
  final CalendarMonthOverview overview;
  final List<FinancialCalendarEvent> agendaEvents;
  final int salaryDay;
}

abstract final class FinancialEventStyle {
  static IconData icon(FinancialEventType type) => switch (type) {
        FinancialEventType.salary => Icons.payments_rounded,
        FinancialEventType.expense => Icons.receipt_long_rounded,
        FinancialEventType.income => Icons.trending_up_rounded,
        FinancialEventType.subscription => Icons.subscriptions_rounded,
        FinancialEventType.loan => Icons.handshake_rounded,
        FinancialEventType.borrowedMoney => Icons.account_balance_wallet_outlined,
        FinancialEventType.bill => Icons.receipt_outlined,
        FinancialEventType.goalContribution => Icons.flag_rounded,
        FinancialEventType.wishlistPurchase => Icons.favorite_border_rounded,
        FinancialEventType.savings => Icons.savings_rounded,
        FinancialEventType.investment => Icons.show_chart_rounded,
      };

  static Color color(FinancialEventType type, ColorScheme scheme) =>
      switch (type) {
        FinancialEventType.salary => scheme.primary,
        FinancialEventType.expense => scheme.error,
        FinancialEventType.income => scheme.tertiary,
        FinancialEventType.subscription => const Color(0xFF7C4DFF),
        FinancialEventType.loan => const Color(0xFFE65100),
        FinancialEventType.borrowedMoney => const Color(0xFF00897B),
        FinancialEventType.bill => const Color(0xFF5C6BC0),
        FinancialEventType.goalContribution => const Color(0xFF43A047),
        FinancialEventType.wishlistPurchase => const Color(0xFFEC407A),
        FinancialEventType.savings => const Color(0xFF26A69A),
        FinancialEventType.investment => const Color(0xFF78909C),
      };

  static String label(FinancialEventType type) => switch (type) {
        FinancialEventType.salary => 'Salary',
        FinancialEventType.expense => 'Expense',
        FinancialEventType.income => 'Income',
        FinancialEventType.subscription => 'Subscription',
        FinancialEventType.loan => 'Loan due',
        FinancialEventType.borrowedMoney => 'Borrowed',
        FinancialEventType.bill => 'Bill',
        FinancialEventType.goalContribution => 'Goal',
        FinancialEventType.wishlistPurchase => 'Wishlist',
        FinancialEventType.savings => 'Savings',
        FinancialEventType.investment => 'Investment',
      };
}
