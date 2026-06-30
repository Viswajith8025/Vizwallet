import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/core/utils/savings_rate_utils.dart';

void main() {
  group('SavingsRateUtils', () {
    test('displayPercent includes carry-over', () {
      expect(
        SavingsRateUtils.displayPercent(
          salaryPaise: 100000,
          spentPaise: 80000,
          carryOverPaise: 10000,
        ),
        30.0,
      );
    });

    test('displayPercent can be negative when overspent', () {
      expect(
        SavingsRateUtils.displayPercent(
          salaryPaise: 100000,
          spentPaise: 120000,
          carryOverPaise: 0,
        ),
        -20.0,
      );
    });

    test('healthScoreRate clamps negative savings to zero', () {
      expect(
        SavingsRateUtils.healthScoreRate(
          salaryPaise: 100000,
          spentPaise: 120000,
          carryOverPaise: 0,
        ),
        0.0,
      );
    });

    test('isOverBudget respects carry-over', () {
      expect(
        SavingsRateUtils.isOverBudget(
          salaryPaise: 100000,
          spentPaise: 105000,
          carryOverPaise: 10000,
        ),
        false,
      );
      expect(
        SavingsRateUtils.isOverBudget(
          salaryPaise: 100000,
          spentPaise: 115000,
          carryOverPaise: 10000,
        ),
        true,
      );
    });

    test('goalsProgressPercent averages non-wishlist goals', () {
      expect(
        SavingsRateUtils.goalsProgressPercent(
          goals: [
            (savedPaise: 5000, targetPaise: 10000, isWishlist: false),
            (savedPaise: 10000, targetPaise: 10000, isWishlist: false),
            (savedPaise: 0, targetPaise: 5000, isWishlist: true),
          ],
        ),
        75,
      );
    });
  });
}
