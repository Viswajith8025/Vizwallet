import 'dart:convert';

enum ClassificationSource {
  userLearned,
  history,
  merchant,
  keyword,
  ai,
}

class ClassificationSignal {
  const ClassificationSignal({
    required this.source,
    required this.confidence,
    this.categorySlug,
    this.tags = const [],
    this.reason,
  });

  final ClassificationSource source;
  final double confidence;
  final String? categorySlug;
  final List<String> tags;
  final String? reason;
}

class ClassificationRequest {
  const ClassificationRequest({
    required this.title,
    this.description,
    this.notes,
    this.categorySlugsById = const {},
    this.historyCategorySlug,
    this.historyTags = const [],
  });

  final String title;
  final String? description;
  final String? notes;
  final Map<int, String> categorySlugsById;
  final String? historyCategorySlug;
  final List<String> historyTags;

  String get combinedText {
    return [title, description, notes]
        .where((s) => s != null && s.trim().isNotEmpty)
        .join(' ')
        .toLowerCase();
  }
}

class TransactionClassification {
  const TransactionClassification({
    this.categorySlug,
    this.categoryId,
    this.tags = const [],
    this.confidence = 0,
    this.signals = const [],
    this.suggestedCategoryName,
  });

  final String? categorySlug;
  final int? categoryId;
  final List<String> tags;
  final double confidence;
  final List<ClassificationSignal> signals;
  final String? suggestedCategoryName;

  bool get hasSuggestion => categorySlug != null || tags.isNotEmpty;

  String? get primaryReason =>
      signals.isNotEmpty ? signals.first.reason : null;
}

String normalizeTaggingPattern(String input) {
  return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
}

List<String> parseTagsJson(String raw) {
  try {
    final decoded = (jsonDecode(raw) as List).cast<String>();
    return decoded.where((t) => t.trim().isNotEmpty).toList();
  } catch (_) {
    return [];
  }
}

class TagSpendRow {
  const TagSpendRow({
    required this.tag,
    required this.totalPaise,
    required this.transactionCount,
  });

  final String tag;
  final int totalPaise;
  final int transactionCount;
}
