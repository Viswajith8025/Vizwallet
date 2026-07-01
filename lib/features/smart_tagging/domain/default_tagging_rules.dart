/// Built-in merchant → category slug rules.
class MerchantRule {
  const MerchantRule({
    required this.pattern,
    required this.categorySlug,
    this.tags = const [],
    this.confidence = 0.85,
  });

  final String pattern;
  final String categorySlug;
  final List<String> tags;
  final double confidence;
}

const builtinMerchantRules = <MerchantRule>[
  MerchantRule(
    pattern: 'spotify',
    categorySlug: 'subscriptions',
    tags: ['Subscription'],
  ),
  MerchantRule(
    pattern: 'netflix',
    categorySlug: 'subscriptions',
    tags: ['Subscription'],
  ),
  MerchantRule(
    pattern: 'swiggy',
    categorySlug: 'food',
    tags: ['Food'],
  ),
  MerchantRule(
    pattern: 'zomato',
    categorySlug: 'food',
    tags: ['Food'],
  ),
  MerchantRule(
    pattern: 'amazon',
    categorySlug: 'shopping',
    tags: ['Shopping'],
  ),
  MerchantRule(
    pattern: 'flipkart',
    categorySlug: 'shopping',
    tags: ['Shopping'],
  ),
  MerchantRule(
    pattern: 'jio',
    categorySlug: 'recharge',
    tags: ['Recharge'],
  ),
  MerchantRule(
    pattern: 'airtel',
    categorySlug: 'recharge',
    tags: ['Recharge'],
  ),
  MerchantRule(
    pattern: 'vi ',
    categorySlug: 'recharge',
    tags: ['Recharge'],
  ),
  MerchantRule(
    pattern: 'petrol',
    categorySlug: 'transport',
    tags: ['Transport'],
  ),
  MerchantRule(
    pattern: 'diesel',
    categorySlug: 'transport',
    tags: ['Transport'],
  ),
  MerchantRule(
    pattern: 'uber',
    categorySlug: 'transport',
    tags: ['Transport'],
  ),
  MerchantRule(
    pattern: 'ola',
    categorySlug: 'transport',
    tags: ['Transport'],
  ),
  MerchantRule(
    pattern: 'rapido',
    categorySlug: 'transport',
    tags: ['Transport'],
  ),
  MerchantRule(
    pattern: 'hospital',
    categorySlug: 'health',
    tags: ['Medical', 'Emergency'],
  ),
  MerchantRule(
    pattern: 'pharmacy',
    categorySlug: 'health',
    tags: ['Medical'],
  ),
  MerchantRule(
    pattern: 'apollo',
    categorySlug: 'health',
    tags: ['Medical'],
  ),
  MerchantRule(
    pattern: 'jupiter',
    categorySlug: 'jupiter_savings',
    tags: ['Savings', 'Digital Gold'],
  ),
  MerchantRule(
    pattern: 'digital gold',
    categorySlug: 'jupiter_savings',
    tags: ['Savings', 'Digital Gold'],
  ),
];

/// Keyword → extra tags (and optional category hints).
class KeywordTagRule {
  const KeywordTagRule({
    required this.keyword,
    required this.tags,
    this.categorySlug,
    this.confidence = 0.65,
  });

  final String keyword;
  final List<String> tags;
  final String? categorySlug;
  final double confidence;
}

const builtinKeywordRules = <KeywordTagRule>[
  KeywordTagRule(keyword: 'family', tags: ['Family']),
  KeywordTagRule(keyword: 'travel', tags: ['Travel'], categorySlug: 'transport'),
  KeywordTagRule(keyword: 'flight', tags: ['Travel'], categorySlug: 'transport'),
  KeywordTagRule(keyword: 'hotel', tags: ['Travel'], categorySlug: 'transport'),
  KeywordTagRule(keyword: 'emergency', tags: ['Emergency'], categorySlug: 'health'),
  KeywordTagRule(keyword: 'medical', tags: ['Medical'], categorySlug: 'health'),
  KeywordTagRule(keyword: 'clinic', tags: ['Medical'], categorySlug: 'health'),
  KeywordTagRule(keyword: 'lunch', tags: ['Food'], categorySlug: 'food'),
  KeywordTagRule(keyword: 'dinner', tags: ['Food'], categorySlug: 'food'),
  KeywordTagRule(keyword: 'breakfast', tags: ['Food'], categorySlug: 'food'),
  KeywordTagRule(
    keyword: 'jupiter',
    tags: ['Savings', 'Digital Gold'],
    categorySlug: 'jupiter_savings',
  ),
  KeywordTagRule(
    keyword: 'digital gold',
    tags: ['Savings', 'Digital Gold'],
    categorySlug: 'jupiter_savings',
  ),
  KeywordTagRule(
    keyword: 'gold pot',
    tags: ['Savings'],
    categorySlug: 'jupiter_savings',
  ),
];

const suggestedSpendingTags = <String>[
  'Food',
  'Family',
  'Travel',
  'Emergency',
  'Medical',
  'Subscription',
  'Shopping',
  'Transport',
  'Recharge',
  'Savings',
  'Work',
  'Gift',
];
