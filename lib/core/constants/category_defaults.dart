class DefaultCategory {
  const DefaultCategory({
    required this.name,
    required this.slug,
    required this.iconName,
    required this.colorValue,
    this.countsTowardSpending = true,
    this.sortOrder = 0,
  });

  final String name;
  final String slug;
  final String iconName;
  final int colorValue;
  final bool countsTowardSpending;
  final int sortOrder;
}

const defaultCategories = <DefaultCategory>[
  DefaultCategory(name: 'Food', slug: 'food', iconName: 'restaurant', colorValue: 0xFFFF6B6B, sortOrder: 1),
  DefaultCategory(name: 'Recharge', slug: 'recharge', iconName: 'smartphone', colorValue: 0xFF4ECDC4, sortOrder: 2),
  DefaultCategory(name: 'Subscriptions', slug: 'subscriptions', iconName: 'subscriptions', colorValue: 0xFF9B59B6, sortOrder: 3),
  DefaultCategory(name: 'Transport', slug: 'transport', iconName: 'directions_bus', colorValue: 0xFF3498DB, sortOrder: 4),
  DefaultCategory(name: 'Shopping', slug: 'shopping', iconName: 'shopping_bag', colorValue: 0xFFE67E22, sortOrder: 5),
  DefaultCategory(name: 'Entertainment', slug: 'entertainment', iconName: 'movie', colorValue: 0xFFE91E63, sortOrder: 6),
  DefaultCategory(name: 'Bills', slug: 'bills', iconName: 'receipt_long', colorValue: 0xFF607D8B, sortOrder: 7),
  DefaultCategory(name: 'Health', slug: 'health', iconName: 'favorite', colorValue: 0xFF26A69A, sortOrder: 8),
  DefaultCategory(name: 'Rent', slug: 'rent', iconName: 'home', colorValue: 0xFF795548, sortOrder: 9),
  DefaultCategory(name: 'Education', slug: 'education', iconName: 'school', colorValue: 0xFF3F51B5, sortOrder: 10),
  DefaultCategory(name: 'Investment', slug: 'investment', iconName: 'trending_up', colorValue: 0xFF2ECC71, countsTowardSpending: false, sortOrder: 11),
  DefaultCategory(name: 'Family', slug: 'family', iconName: 'family_restroom', colorValue: 0xFFFF9800, sortOrder: 12),
  DefaultCategory(name: 'Loan', slug: 'loan', iconName: 'account_balance', colorValue: 0xFF8E44AD, sortOrder: 13),
  DefaultCategory(name: 'EMI', slug: 'emi', iconName: 'payments', colorValue: 0xFF34495E, sortOrder: 14),
  DefaultCategory(name: 'Miscellaneous', slug: 'miscellaneous', iconName: 'more_horiz', colorValue: 0xFF9E9E9E, sortOrder: 15),
];

const paymentMethods = <String>[
  'UPI',
  'Cash',
  'Card',
  'Auto Debit',
  'Net Banking',
  'Other',
];
