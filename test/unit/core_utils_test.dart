import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/core/utils/auto_label_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';

void main() {
  group('money_utils', () {
    test('rupeesToPaise converts correctly', () {
      expect(rupeesToPaise('199'), 19900);
      expect(rupeesToPaise('199.50'), 19950);
      expect(rupeesToPaise('₹ 1,250'), 125000);
    });

    test('rupeesToPaise rejects negative, invalid, and empty input', () {
      expect(rupeesToPaise('-50'), 0);
      expect(rupeesToPaise('abc'), 0);
      expect(rupeesToPaise(''), 0);
      expect(rupeesToPaise('   '), 0);
    });

    test('rupeesToPaise clamps absurdly large amounts', () {
      expect(rupeesToPaise('99999999999'), 100000000 * 100);
    });

    test('rupeesDoubleToPaise rejects negative and non-finite', () {
      expect(rupeesDoubleToPaise(-1), 0);
      expect(rupeesDoubleToPaise(double.nan), 0);
      expect(rupeesDoubleToPaise(double.infinity), 0);
      expect(rupeesDoubleToPaise(12.5), 1250);
    });

    test('formatPaise formats INR', () {
      expect(formatPaise(2500000), contains('25'));
    });
  });

  group('auto_label_utils', () {
    test('assigns major expense above threshold', () {
      final labels = computeAutoLabels(
        amountPaise: 15000,
        majorThresholdPaise: 10000,
        largeThresholdPaise: 50000,
        veryLargeThresholdPaise: 100000,
      );
      expect(labels, contains('Major Expense'));
    });

    test('assigns very large expense', () {
      final labels = computeAutoLabels(
        amountPaise: 150000,
        majorThresholdPaise: 10000,
        largeThresholdPaise: 50000,
        veryLargeThresholdPaise: 100000,
      );
      expect(labels, contains('Very Large Expense'));
    });
  });
}
