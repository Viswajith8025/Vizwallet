import 'package:rupee_track/features/budget/domain/allocation_mode.dart';

class BucketStatus {
  const BucketStatus({
    required this.bucketKey,
    required this.displayName,
    required this.categoryId,
    required this.bucketType,
    required this.allocatedPaise,
    required this.rolloverPaise,
    required this.spentPaise,
    required this.daysRemaining,
    required this.alertLevel,
    this.colorValue,
  });

  final String bucketKey;
  final String displayName;
  final int? categoryId;
  final BucketType bucketType;
  final int allocatedPaise;
  final int rolloverPaise;
  final int spentPaise;
  final int daysRemaining;
  final BudgetAlertLevel alertLevel;
  final int? colorValue;

  int get totalBudgetPaise => allocatedPaise + rolloverPaise;

  int get remainingPaise => totalBudgetPaise - spentPaise;

  double get percentUsed =>
      totalBudgetPaise <= 0 ? 0 : (spentPaise / totalBudgetPaise) * 100;

  int get dailyAllowancePaise {
    if (remainingPaise <= 0 || daysRemaining <= 0) return 0;
    return (remainingPaise / daysRemaining).floor();
  }

  bool get isOverBudget => spentPaise > totalBudgetPaise && totalBudgetPaise > 0;
}

class BudgetPlanStatus {
  const BudgetPlanStatus({
    required this.monthKey,
    required this.salaryPaise,
    required this.allocationMode,
    required this.rolloverEnabled,
    required this.buckets,
    required this.insights,
    this.aiNotes,
  });

  final String monthKey;
  final int salaryPaise;
  final AllocationMode allocationMode;
  final bool rolloverEnabled;
  final List<BucketStatus> buckets;
  final List<BudgetInsight> insights;
  final String? aiNotes;

  int get totalAllocatedPaise =>
      buckets.fold(0, (sum, b) => sum + b.totalBudgetPaise);

  int get totalSpentPaise => buckets.fold(0, (sum, b) => sum + b.spentPaise);

  int get unallocatedPaise => salaryPaise - totalAllocatedPaise;

  List<BucketStatus> get spendingBuckets =>
      buckets.where((b) => b.bucketType == BucketType.spending).toList();

  List<BucketStatus> get alertBuckets => buckets
      .where((b) => b.alertLevel != BudgetAlertLevel.none)
      .toList();
}

class BudgetInsight {
  const BudgetInsight({
    required this.title,
    required this.message,
    required this.severity,
  });

  final String title;
  final String message;
  final BudgetAlertLevel severity;
}
