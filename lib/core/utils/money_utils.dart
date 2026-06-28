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

/// Maximum supported amount: ₹10 crore in paise. Guards against overflow and
/// fat-finger input that would corrupt budgets/reports.
const int _maxAmountPaise = 100000000 * 100;

/// Converts a rupee string (e.g. "199" or "199.50") to a paise integer.
///
/// Returns 0 for empty/invalid input. Negative values are rejected (clamped to
/// 0) — amounts in this app are always non-negative. Values above
/// [_maxAmountPaise] are clamped to the cap.
int rupeesToPaise(String input) {
  final cleaned = input.replaceAll(RegExp(r'[₹,\s]'), '').trim();
  if (cleaned.isEmpty) return 0;
  final value = double.tryParse(cleaned);
  if (value == null || value.isNaN || value.isInfinite) return 0;
  if (value <= 0) return 0;
  final paise = (value * 100).round();
  return paise.clamp(0, _maxAmountPaise);
}

int rupeesDoubleToPaise(double rupees) {
  if (rupees.isNaN || rupees.isInfinite || rupees <= 0) return 0;
  return (rupees * 100).round().clamp(0, _maxAmountPaise);
}

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
