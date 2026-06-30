/// Snapshot pushed to Android home screen widgets via [home_widget].
class HomeWidgetSnapshot {
  const HomeWidgetSnapshot({
    required this.moneyLeftFormatted,
    required this.todaySpentFormatted,
    required this.safeDailyFormatted,
    required this.budgetProgressPercent,
    required this.healthScore,
    required this.savingsPercent,
    required this.goalProgressPercent,
    required this.upcomingSubscriptionsCount,
    required this.upcomingSubscriptionsLabel,
    required this.overdueLoansCount,
    required this.recentTransactionTitle,
    required this.recentTransactionAmount,
    required this.cycleLabel,
    required this.themeMode,
    required this.lastUpdatedIso,
    required this.wishlistNote,
  });

  final String moneyLeftFormatted;
  final String todaySpentFormatted;
  final String safeDailyFormatted;
  final int budgetProgressPercent;
  final int healthScore;
  final double savingsPercent;
  final int goalProgressPercent;
  final int upcomingSubscriptionsCount;
  final String upcomingSubscriptionsLabel;
  final int overdueLoansCount;
  final String recentTransactionTitle;
  final String recentTransactionAmount;
  final String cycleLabel;
  final String themeMode;
  final String lastUpdatedIso;
  final String wishlistNote;

  Map<String, dynamic> toWidgetData() => {
        'money_left': moneyLeftFormatted,
        'today_spent': todaySpentFormatted,
        'safe_daily': safeDailyFormatted,
        'budget_progress': budgetProgressPercent.toString(),
        'health_score': healthScore.toString(),
        'savings_percent': savingsPercent.toStringAsFixed(1),
        'goal_progress': goalProgressPercent.toString(),
        'upcoming_subs_count': upcomingSubscriptionsCount.toString(),
        'upcoming_subs_label': upcomingSubscriptionsLabel,
        'overdue_loans_count': overdueLoansCount.toString(),
        'upcoming_bills_count': overdueLoansCount.toString(),
        'recent_tx_title': recentTransactionTitle,
        'recent_tx_amount': recentTransactionAmount,
        'cycle_label': cycleLabel,
        'theme_mode': themeMode,
        'last_updated': lastUpdatedIso,
        'wishlist_note': wishlistNote,
      };
}

/// Deep-link actions from widget taps.
abstract final class WidgetActions {
  static const scheme = 'viswallet';
  static const addExpense = 'add-expense';
  static const addIncome = 'add-income';
  static const dashboard = 'dashboard';
  static const calendar = 'calendar';
  static const budget = 'budget';
  static const health = 'health';
  static const subscriptions = 'subscriptions';
  static const markBillPaid = 'mark-bill-paid';
  static const wishlist = 'wishlist';
}
