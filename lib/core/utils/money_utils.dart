import 'package:intl/intl.dart';
import 'package:rupee_track/core/constants/app_constants.dart';

final _inrFormat = NumberFormat.currency(
  locale: 'en_IN',
  symbol: AppConstants.currencySymbol,
  decimalDigits: 0,
);

final _inrFormatWithPaise = NumberFormat.currency(
  locale: 'en_IN',
  symbol: AppConstants.currencySymbol,
  decimalDigits: 2,
);

/// Converts rupee string (e.g. "199" or "199.50") to paise integer.
int rupeesToPaise(String input) {
  final cleaned = input.replaceAll(RegExp(r'[₹,\s]'), '').trim();
  if (cleaned.isEmpty) return 0;
  final value = double.tryParse(cleaned);
  if (value == null) return 0;
  return (value * 100).round();
}

int rupeesDoubleToPaise(double rupees) => (rupees * 100).round();

double paiseToRupees(int paise) => paise / 100;

String formatPaise(int paise, {bool showPaise = false}) {
  if (showPaise || paise % 100 != 0) {
    return _inrFormatWithPaise.format(paiseToRupees(paise));
  }
  return _inrFormat.format(paiseToRupees(paise).round());
}

String formatPercent(double value) {
  return '${value.toStringAsFixed(1)}%';
}
