enum AllocationMode {
  manual('manual', 'Manual'),
  percentage('percentage', 'Percentage'),
  aiSuggested('ai_suggested', 'AI Suggested');

  const AllocationMode(this.storageKey, this.label);

  final String storageKey;
  final String label;

  static AllocationMode fromKey(String key) => values.firstWhere(
        (m) => m.storageKey == key,
        orElse: () => AllocationMode.percentage,
      );
}

enum BucketType {
  spending('spending'),
  reserve('reserve'),
  investment('investment');

  const BucketType(this.storageKey);
  final String storageKey;

  static BucketType fromKey(String key) => BucketType.values.firstWhere(
        (t) => t.storageKey == key,
        orElse: () => BucketType.spending,
      );
}

enum BudgetAlertLevel {
  none,
  watch50,
  watch75,
  critical90,
  exceeded,
}
