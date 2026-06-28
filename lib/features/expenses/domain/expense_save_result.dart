/// Summary returned after an expense is saved with auto labels applied.
class ExpenseSaveResult {
  const ExpenseSaveResult({
    required this.title,
    required this.amountPaise,
    required this.categoryId,
    required this.categoryName,
    required this.tags,
    required this.labels,
  });

  final String title;
  final int amountPaise;
  final int categoryId;
  final String categoryName;
  final List<String> tags;
  final List<String> labels;

  List<String> get allLabels => [...labels, ...tags];

  String get snackbarLine {
    final parts = <String>[categoryName];
    if (allLabels.isNotEmpty) {
      parts.add(allLabels.take(3).join(', '));
    }
    return parts.join(' · ');
  }
}
