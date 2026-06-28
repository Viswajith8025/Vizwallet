List<String> computeAutoLabels({
  required int amountPaise,
  required int majorThresholdPaise,
  required int largeThresholdPaise,
  required int veryLargeThresholdPaise,
}) {
  final labels = <String>[];

  if (amountPaise > veryLargeThresholdPaise) {
    labels.add('Very Large Expense');
  } else if (amountPaise > largeThresholdPaise) {
    labels.add('Large Expense');
  } else if (amountPaise > majorThresholdPaise) {
    labels.add('Major Expense');
  }

  return labels;
}

bool isMajorPurchase({
  required int amountPaise,
  required int majorPurchaseThresholdPaise,
}) {
  return amountPaise >= majorPurchaseThresholdPaise;
}
