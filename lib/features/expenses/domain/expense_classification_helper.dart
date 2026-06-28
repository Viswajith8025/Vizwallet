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

List<String> mergeExpenseTags({
  required List<String> userTags,
  required List<String> classifiedTags,
  required String categoryName,
}) {
  final merged = <String>{
    categoryName,
    ...userTags,
    ...classifiedTags,
  }..removeWhere((tag) => tag.trim().isEmpty);

  return merged.toList();
}
