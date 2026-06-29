/// Template for one-tap repeat of a past expense.
class RepeatExpenseTemplate {
  const RepeatExpenseTemplate({
    required this.title,
    required this.amountPaise,
    required this.categoryId,
    required this.categoryName,
    required this.colorValue,
    required this.paymentMethod,
  });

  final String title;
  final int amountPaise;
  final int categoryId;
  final String categoryName;
  final int colorValue;
  final String paymentMethod;
}

class QuickAddContext {
  const QuickAddContext({
    required this.amountSuggestionsPaise,
    required this.recentCategoryIds,
    required this.favoriteCategoryIds,
    required this.recentMerchants,
    required this.recentNotes,
    required this.repeatTemplates,
  });

  final List<int> amountSuggestionsPaise;
  final List<int> recentCategoryIds;
  final List<int> favoriteCategoryIds;
  final List<String> recentMerchants;
  final List<String> recentNotes;
  final List<RepeatExpenseTemplate> repeatTemplates;
}
