import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/universal_search/domain/universal_search_models.dart';

/// Fuzzy matching, synonyms, and rule-based NL parsing — local-first.
abstract final class UniversalSearchEngine {
  static const _synonyms = {
    'food': ['restaurant', 'dining', 'swiggy', 'zomato', 'lunch', 'dinner'],
    'transport': ['uber', 'ola', 'metro', 'bus', 'fuel', 'petrol'],
    'subscription': ['subs', 'netflix', 'spotify', 'prime', 'recurring'],
    'loan': ['emi', 'borrowed', 'lent', 'debt'],
    'income': ['salary', 'pay', 'paycheck', 'wage'],
    'goal': ['savings', 'target', 'wishlist'],
    'amazon': ['amzn', 'flipkart', 'shopping'],
  };

  static ParsedSearchQuery parse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return ParsedSearchQuery(
        rawQuery: '',
        tokens: const [],
        expandedTerms: const [],
      );
    }

    final lower = trimmed.toLowerCase();
    final tokens = lower
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    final expanded = <String>{...tokens};
    for (final token in tokens) {
      for (final entry in _synonyms.entries) {
        if (entry.key == token || entry.value.contains(token)) {
          expanded.add(entry.key);
          expanded.addAll(entry.value);
        }
      }
    }

    int? minPaise;
    int? maxPaise;
    String? merchantHint;
    String? categoryHint;
    String? personHint;
    String? nlAnswer;
    String? suggestedRoute;
    var isNl = false;

  final aboveMatch = RegExp(
      r'above\s+₹?\s*([\d,]+(?:\.\d+)?)\s*(k|thousand|lakh|lakhs)?',
      caseSensitive: false,
    ).firstMatch(lower);
    if (aboveMatch != null) {
      minPaise = _parseAmountToken(
        aboveMatch.group(1)!,
        aboveMatch.group(2),
      );
    }

    final belowMatch = RegExp(
      r'below\s+₹?\s*([\d,]+(?:\.\d+)?)\s*(k|thousand|lakh|lakhs)?',
      caseSensitive: false,
    ).firstMatch(lower);
    if (belowMatch != null) {
      maxPaise = _parseAmountToken(
        belowMatch.group(1)!,
        belowMatch.group(2),
      );
    }

    if (lower.contains('amazon')) merchantHint = 'amazon';
    if (lower.contains('netflix')) merchantHint = 'netflix';
    if (lower.contains('swiggy') || lower.contains('food')) {
      categoryHint = 'food';
    }
    if (lower.contains('subscription') || lower.contains('subs')) {
      suggestedRoute = AppRoutes.subscriptions;
    }

    if (lower.contains('how much') && lower.contains('spend')) {
      isNl = true;
      if (lower.contains('food')) categoryHint = 'food';
      nlAnswer =
          'Showing matching expenses — use filters for exact totals.';
      suggestedRoute = AppRoutes.expenses;
    }

    if (lower.contains('renew') && lower.contains('subscription')) {
      isNl = true;
      nlAnswer = 'Opening subscriptions with upcoming renewals.';
      suggestedRoute = AppRoutes.subscriptions;
    }

    if (RegExp(r'₹?\s*[\d,]+').hasMatch(lower) && tokens.length <= 3) {
      final amountToken = RegExp(r'([\d,]+(?:\.\d+)?)\s*(k|thousand)?')
          .firstMatch(lower.replaceAll('₹', ''));
      if (amountToken != null && minPaise == null) {
        final parsed = _parseAmountToken(
          amountToken.group(1)!,
          amountToken.group(2),
        );
        if (parsed != null) {
          minPaise = (parsed * 0.9).round();
          maxPaise = (parsed * 1.1).round();
        }
      }
    }

    for (final token in tokens) {
      if (_looksLikePerson(token)) personHint = token;
    }

    return ParsedSearchQuery(
      rawQuery: trimmed,
      tokens: tokens,
      expandedTerms: expanded.toList(),
      merchantHint: merchantHint,
      categoryHint: categoryHint,
      minPaise: minPaise,
      maxPaise: maxPaise,
      personHint: personHint,
      nlAnswer: nlAnswer,
      suggestedRoute: suggestedRoute,
      isNaturalLanguage: isNl,
    );
  }

  static double scoreMatch({
    required String haystack,
    required List<String> terms,
    required String rawQuery,
  }) {
    if (terms.isEmpty) return 0;
    final lower = haystack.toLowerCase();
    var score = 0.0;

    if (lower == rawQuery.toLowerCase()) score += 100;
    if (lower.startsWith(rawQuery.toLowerCase())) score += 40;

    for (final term in terms) {
      if (term.isEmpty) continue;
      if (lower.contains(term)) {
        score += 30;
        if (lower.startsWith(term)) score += 15;
      } else {
        final fuzzy = _fuzzyContains(lower, term);
        if (fuzzy) score += 12;
      }
    }

    return score;
  }

  static bool _fuzzyContains(String text, String term) {
    if (term.length < 3) return false;
    if ((term.length - 1) <= 1) return text.contains(term);
    for (var i = 0; i <= text.length - term.length; i++) {
      final slice = text.substring(i, i + term.length);
      var mismatches = 0;
      for (var j = 0; j < term.length; j++) {
        if (slice[j] != term[j]) mismatches++;
        if (mismatches > 1) break;
      }
      if (mismatches <= 1) return true;
    }
    return false;
  }

  static List<SearchResultItem> rankItems(
    List<SearchResultItem> items,
    ParsedSearchQuery parsed,
  ) {
    if (parsed.rawQuery.isEmpty) return items;
    final ranked = items.map((item) {
      final haystack = '${item.title} ${item.subtitle}';
      final score = scoreMatch(
        haystack: haystack,
        terms: parsed.expandedTerms,
        rawQuery: parsed.rawQuery,
      );
      return SearchResultItem(
        id: item.id,
        kind: item.kind,
        title: item.title,
        subtitle: item.subtitle,
        amountPaise: item.amountPaise,
        occurredAt: item.occurredAt,
        route: item.route,
        routeQueryParams: item.routeQueryParams,
        icon: item.icon,
        colorValue: item.colorValue,
        score: score,
        highlights: _highlightTerms(item.title, parsed.tokens),
      );
    }).toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    return ranked.where((i) => i.score > 0 || parsed.rawQuery.length < 2).toList();
  }

  static List<SearchResultGroup> groupResults(List<SearchResultItem> items) {
    final map = <SearchResultKind, List<SearchResultItem>>{};
    for (final item in items) {
      map.putIfAbsent(item.kind, () => []).add(item);
    }

    const order = [
      SearchResultKind.nlAnswer,
      SearchResultKind.expense,
      SearchResultKind.income,
      SearchResultKind.goal,
      SearchResultKind.wishlist,
      SearchResultKind.subscription,
      SearchResultKind.loan,
      SearchResultKind.borrowedMoney,
      SearchResultKind.merchant,
      SearchResultKind.category,
      SearchResultKind.note,
      SearchResultKind.calendar,
      SearchResultKind.report,
      SearchResultKind.navigation,
    ];

    return order
        .where((k) => map[k]?.isNotEmpty == true)
        .map(
          (k) => SearchResultGroup(
            kind: k,
            label: _groupLabel(k),
            items: map[k]!,
          ),
        )
        .toList();
  }

  static List<String> suggestionsFor({
    required String query,
    required List<String> merchants,
    required List<String> recent,
  }) {
    if (query.isEmpty) {
      return [...recent.take(3), ...popularSearchQueries.take(5)];
    }
    final lower = query.toLowerCase();
    final pool = {...merchants, ...popularSearchQueries, ...recent};
    return pool
        .where((s) => s.toLowerCase().contains(lower))
        .take(6)
        .toList();
  }

  static List<String> _highlightTerms(String text, List<String> tokens) {
    return tokens.where((t) => text.toLowerCase().contains(t)).toList();
  }

  static int? _parseAmountToken(String digits, String? suffix) {
    final cleaned = digits.replaceAll(',', '');
    final base = double.tryParse(cleaned);
    if (base == null) return null;
    var rupees = base;
    final s = suffix?.toLowerCase();
    if (s == 'k' || s == 'thousand') rupees *= 1000;
    if (s == 'lakh' || s == 'lakhs') rupees *= 100000;
    return rupeesToPaise(rupees.round().toString());
  }

  static bool _looksLikePerson(String token) {
    return token.length > 2 &&
        token[0].toUpperCase() == token[0] &&
        !RegExp(r'\d').hasMatch(token);
  }

  static String _groupLabel(SearchResultKind kind) => switch (kind) {
        SearchResultKind.expense => 'Expenses',
        SearchResultKind.income => 'Income',
        SearchResultKind.goal => 'Goals',
        SearchResultKind.wishlist => 'Wishlist',
        SearchResultKind.subscription => 'Subscriptions',
        SearchResultKind.loan => 'Loans',
        SearchResultKind.borrowedMoney => 'Borrowed money',
        SearchResultKind.merchant => 'Merchants',
        SearchResultKind.category => 'Categories',
        SearchResultKind.note => 'Notes',
        SearchResultKind.calendar => 'Calendar',
        SearchResultKind.report => 'Reports',
        SearchResultKind.navigation => 'Go to',
        SearchResultKind.nlAnswer => 'Answer',
      };
}
