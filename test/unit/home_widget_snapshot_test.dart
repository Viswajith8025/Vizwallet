import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/home_widget/domain/home_widget_snapshot.dart';

void main() {
  test('HomeWidgetSnapshot serializes widget keys', () {
    const snapshot = HomeWidgetSnapshot(
      moneyLeftFormatted: '₹12,500.00',
      todaySpentFormatted: '₹450.00',
      safeDailyFormatted: '₹800.00',
      budgetProgressPercent: 75,
      healthScore: 82,
      savingsPercent: 18.5,
      goalProgressPercent: 75,
      upcomingSubscriptionsCount: 2,
      upcomingSubscriptionsLabel: 'Netflix · Jun 5',
      overdueLoansCount: 1,
      recentTransactionTitle: 'Swiggy',
      recentTransactionAmount: '₹320.00',
      cycleLabel: 'May cycle',
      themeMode: 'dark',
      lastUpdatedIso: '2026-06-01T00:00:00.000Z',
      wishlistNote: '2 wishlist items',
    );

    final data = snapshot.toWidgetData();
    expect(data['money_left'], '₹12,500.00');
    expect(data['health_score'], '82');
    expect(data['budget_progress'], '75');
    expect(data['overdue_loans_count'], '1');
  });
}
