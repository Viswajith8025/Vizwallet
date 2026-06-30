import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/features/smart_tagging/domain/classification_models.dart';

bool titleLooksLikeMerchant(
  String title,
  List<CategoriesTableData> categories,
) {
  final normalized = title.trim().toLowerCase();
  if (normalized.isEmpty) return false;
  return !categories.any((c) => c.name.toLowerCase() == normalized);
}

int resolveCategoryId({
  required int selectedCategoryId,
  required TransactionClassification classification,
  required String title,
  required List<CategoriesTableData> categories,
}) {
  final suggestedId = classification.categoryId;
  if (suggestedId == null) return selectedCategoryId;

  final highConfidence = classification.confidence >= 0.6;
  final merchantTitle = titleLooksLikeMerchant(title, categories);

  if (merchantTitle && highConfidence) {
    return suggestedId;
  }

  return selectedCategoryId;
}

String _norm(String value) => value.trim().toLowerCase();

bool tagRedundantWithCategory(String tag, String categoryName) {
  final t = _norm(tag);
  final c = _norm(categoryName);
  if (t.isEmpty || c.isEmpty) return false;
  if (t == c) return true;
  if (t == '${c}s' || c == '${t}s') return true;
  final tSingular = t.replaceAll(RegExp(r's$'), '');
  final cSingular = c.replaceAll(RegExp(r's$'), '');
  return tSingular == cSingular;
}

List<String> mergeExpenseTags({
  required List<String> userTags,
  required List<String> classifiedTags,
  required String categoryName,
}) {
  final merged = <String>{
    ...userTags,
    ...classifiedTags,
  }..removeWhere(
      (tag) =>
          tag.trim().isEmpty || tagRedundantWithCategory(tag, categoryName),
    );

  return merged.toList();
}
