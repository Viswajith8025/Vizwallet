import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/expenses/domain/expense_display_utils.dart';

void main() {
  test('expenseDisplaySubtitle hides duplicate category', () {
    expect(
      expenseDisplaySubtitle(
        categoryName: 'Recharge',
        title: 'Recharge',
        meta: 'UPI · 29 Jun · 12:33 AM',
      ),
      'UPI · 29 Jun · 12:33 AM',
    );
  });

  test('expenseDisplayTags removes title and category duplicates', () {
    final tags = expenseDisplayTags(
      title: 'Recharge',
      categoryName: 'Recharge',
      amountLabels: const ['Major Expense'],
      classificationTags: const ['Recharge', 'UPI'],
    );

    expect(tags, ['Major Expense', 'UPI']);
  });
}
