import 'package:rupee_track/features/budget/domain/allocation_mode.dart';

/// Default percentage template for new budget plans.
class BudgetTemplate {
  const BudgetTemplate({
    required this.bucketKey,
    required this.displayName,
    required this.categorySlug,
    required this.bucketType,
    required this.defaultPercent,
  });

  final String bucketKey;
  final String displayName;
  final String? categorySlug;
  final BucketType bucketType;
  final double defaultPercent;
}

const defaultBudgetTemplates = <BudgetTemplate>[
  BudgetTemplate(
    bucketKey: 'savings',
    displayName: 'Savings',
    categorySlug: null,
    bucketType: BucketType.reserve,
    defaultPercent: 20,
  ),
  BudgetTemplate(
    bucketKey: 'food',
    displayName: 'Food',
    categorySlug: 'food',
    bucketType: BucketType.spending,
    defaultPercent: 15,
  ),
  BudgetTemplate(
    bucketKey: 'transport',
    displayName: 'Transport',
    categorySlug: 'transport',
    bucketType: BucketType.spending,
    defaultPercent: 10,
  ),
  BudgetTemplate(
    bucketKey: 'subscriptions',
    displayName: 'Subscriptions',
    categorySlug: 'subscriptions',
    bucketType: BucketType.spending,
    defaultPercent: 5,
  ),
  BudgetTemplate(
    bucketKey: 'entertainment',
    displayName: 'Entertainment',
    categorySlug: 'entertainment',
    bucketType: BucketType.spending,
    defaultPercent: 10,
  ),
  BudgetTemplate(
    bucketKey: 'shopping',
    displayName: 'Shopping',
    categorySlug: 'shopping',
    bucketType: BucketType.spending,
    defaultPercent: 15,
  ),
  BudgetTemplate(
    bucketKey: 'emergency_fund',
    displayName: 'Emergency Fund',
    categorySlug: null,
    bucketType: BucketType.reserve,
    defaultPercent: 10,
  ),
  BudgetTemplate(
    bucketKey: 'investments',
    displayName: 'Investments',
    categorySlug: 'investment',
    bucketType: BucketType.investment,
    defaultPercent: 10,
  ),
  BudgetTemplate(
    bucketKey: 'miscellaneous',
    displayName: 'Miscellaneous',
    categorySlug: 'miscellaneous',
    bucketType: BucketType.spending,
    defaultPercent: 5,
  ),
];

class BucketAllocationInput {
  const BucketAllocationInput({
    required this.bucketKey,
    required this.displayName,
    required this.categoryId,
    required this.bucketType,
    required this.allocatedPaise,
    this.allocatedPercent,
    this.rolloverPaise = 0,
    this.sortOrder = 0,
  });

  final String bucketKey;
  final String displayName;
  final int? categoryId;
  final BucketType bucketType;
  final int allocatedPaise;
  final double? allocatedPercent;
  final int rolloverPaise;
  final int sortOrder;
}

/// Minimal category info for building per-category budget lines.
class CategoryBudgetSeed {
  const CategoryBudgetSeed({
    required this.id,
    required this.slug,
    required this.name,
    required this.sortOrder,
    required this.countsTowardSpending,
  });

  final int id;
  final String slug;
  final String name;
  final int sortOrder;
  final bool countsTowardSpending;
}
