import 'package:flutter/material.dart';

enum SearchResultKind {
  expense,
  income,
  goal,
  wishlist,
  subscription,
  loan,
  borrowedMoney,
  category,
  merchant,
  calendar,
  report,
  note,
  navigation,
  nlAnswer,
}

enum SearchSort {
  relevance,
  newest,
  oldest,
  highestAmount,
  lowestAmount,
  alphabetical,
}

enum SearchTransactionType {
  all,
  expense,
  income,
}

class SearchFilters {
  const SearchFilters({
    this.startUtc,
    this.endUtc,
    this.cycleKey,
    this.minPaise,
    this.maxPaise,
    this.categoryId,
    this.paymentMethod,
    this.tagQuery,
    this.subscriptionStatus,
    this.goalStatus,
    this.transactionType = SearchTransactionType.all,
    this.sort = SearchSort.relevance,
  });

  final DateTime? startUtc;
  final DateTime? endUtc;
  final String? cycleKey;
  final int? minPaise;
  final int? maxPaise;
  final int? categoryId;
  final String? paymentMethod;
  final String? tagQuery;
  final String? subscriptionStatus;
  final String? goalStatus;
  final SearchTransactionType transactionType;
  final SearchSort sort;

  bool get hasActiveFilters =>
      startUtc != null ||
      endUtc != null ||
      cycleKey != null ||
      minPaise != null ||
      maxPaise != null ||
      categoryId != null ||
      (paymentMethod?.isNotEmpty ?? false) ||
      (tagQuery?.isNotEmpty ?? false) ||
      subscriptionStatus != null ||
      goalStatus != null ||
      transactionType != SearchTransactionType.all;

  SearchFilters copyWith({
    DateTime? startUtc,
    DateTime? endUtc,
    String? cycleKey,
    int? minPaise,
    int? maxPaise,
    int? categoryId,
    String? paymentMethod,
    String? tagQuery,
    String? subscriptionStatus,
    String? goalStatus,
    SearchTransactionType? transactionType,
    SearchSort? sort,
    bool clearDates = false,
    bool clearAmounts = false,
    bool clearCategory = false,
  }) {
    return SearchFilters(
      startUtc: clearDates ? null : (startUtc ?? this.startUtc),
      endUtc: clearDates ? null : (endUtc ?? this.endUtc),
      cycleKey: cycleKey ?? this.cycleKey,
      minPaise: clearAmounts ? null : (minPaise ?? this.minPaise),
      maxPaise: clearAmounts ? null : (maxPaise ?? this.maxPaise),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tagQuery: tagQuery ?? this.tagQuery,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      goalStatus: goalStatus ?? this.goalStatus,
      transactionType: transactionType ?? this.transactionType,
      sort: sort ?? this.sort,
    );
  }
}

class ParsedSearchQuery {
  const ParsedSearchQuery({
    required this.rawQuery,
    required this.tokens,
    required this.expandedTerms,
    this.merchantHint,
    this.categoryHint,
    this.minPaise,
    this.maxPaise,
    this.personHint,
    this.nlAnswer,
    this.suggestedRoute,
    this.isNaturalLanguage = false,
  });

  final String rawQuery;
  final List<String> tokens;
  final List<String> expandedTerms;
  final String? merchantHint;
  final String? categoryHint;
  final int? minPaise;
  final int? maxPaise;
  final String? personHint;
  final String? nlAnswer;
  final String? suggestedRoute;
  final bool isNaturalLanguage;
}

class SearchResultItem {
  const SearchResultItem({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    this.amountPaise,
    this.occurredAt,
    required this.route,
    this.routeQueryParams = const {},
    this.icon,
    this.colorValue,
    this.score = 0,
    this.highlights = const [],
  });

  final String id;
  final SearchResultKind kind;
  final String title;
  final String subtitle;
  final int? amountPaise;
  final DateTime? occurredAt;
  final String route;
  final Map<String, String> routeQueryParams;
  final IconData? icon;
  final int? colorValue;
  final double score;
  final List<String> highlights;
}

class SearchResultGroup {
  const SearchResultGroup({
    required this.kind,
    required this.label,
    required this.items,
  });

  final SearchResultKind kind;
  final String label;
  final List<SearchResultItem> items;
}

class UniversalSearchReport {
  const UniversalSearchReport({
    required this.query,
    required this.parsed,
    required this.groups,
    required this.suggestions,
    required this.totalCount,
    required this.hasMore,
    this.nlAnswerItem,
  });

  final String query;
  final ParsedSearchQuery parsed;
  final List<SearchResultGroup> groups;
  final List<String> suggestions;
  final int totalCount;
  final bool hasMore;
  final SearchResultItem? nlAnswerItem;
}

const popularSearchQueries = [
  'Food this month',
  'Subscriptions',
  'Netflix',
  'Salary',
  'Loans',
  'No spend days',
  'Amazon',
  'Budget',
];
