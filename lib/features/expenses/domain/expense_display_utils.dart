import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/utils/auto_label_utils.dart';
import 'package:rupee_track/features/expenses/domain/expense_classification_helper.dart';

String _norm(String value) => value.trim().toLowerCase();

/// Subtitle line for expense tiles — skips category when it matches the title.
String expenseDisplaySubtitle({
  required String categoryName,
  required String title,
  required String meta,
}) {
  if (_norm(categoryName) == _norm(title)) return meta;
  return '$categoryName · $meta';
}

/// Tags shown on expense tiles — no duplicates of title or category.
List<String> expenseDisplayTags({
  required String title,
  required String categoryName,
  required List<String> amountLabels,
  required List<String> classificationTags,
}) {
  final skip = {_norm(title), _norm(categoryName)};
  final seen = <String>{};
  final out = <String>[];

  for (final tag in [...amountLabels, ...classificationTags]) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty) continue;
    final key = _norm(trimmed);
    if (skip.contains(key) ||
        seen.contains(key) ||
        tagRedundantWithCategory(trimmed, categoryName)) {
      continue;
    }
    seen.add(key);
    out.add(trimmed);
  }

  return out.take(3).toList();
}

/// Recomputes amount-based labels from current settings (not stale DB JSON).
List<String> expenseAmountLabels({
  required AppSettingsTableData settings,
  required int amountPaise,
}) {
  return computeAutoLabels(
    amountPaise: amountPaise,
    majorThresholdPaise: settings.majorExpenseThresholdPaise,
    largeThresholdPaise: settings.largeExpenseThresholdPaise,
    veryLargeThresholdPaise: settings.veryLargeExpenseThresholdPaise,
  );
}
