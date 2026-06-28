import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/universal_search/domain/universal_search_engine.dart';
import 'package:rupee_track/features/universal_search/domain/universal_search_models.dart';

void main() {
  group('UniversalSearchEngine', () {
    test('parse expands food synonyms', () {
      final parsed = UniversalSearchEngine.parse('swiggy');
      expect(parsed.expandedTerms, contains('food'));
    });

    test('parse detects amount above filter', () {
      final parsed = UniversalSearchEngine.parse('amazon above ₹5000');
      expect(parsed.merchantHint, 'amazon');
      expect(parsed.minPaise, isNotNull);
      expect(parsed.minPaise! >= 450000, isTrue);
    });

    test('parse natural language subscription renew', () {
      final parsed = UniversalSearchEngine.parse(
        'What subscriptions renew next week?',
      );
      expect(parsed.isNaturalLanguage, isTrue);
      expect(parsed.suggestedRoute, isNotNull);
    });

    test('fuzzy match tolerates single typo', () {
      final score = UniversalSearchEngine.scoreMatch(
        haystack: 'Netflix subscription',
        terms: const ['netflx'],
        rawQuery: 'netflx',
      );
      expect(score, greaterThan(0));
    });

    test('groups results by kind', () {
      final groups = UniversalSearchEngine.groupResults([
        const SearchResultItem(
          id: '1',
          kind: SearchResultKind.expense,
          title: 'Coffee',
          subtitle: 'Food',
          route: '/expenses',
        ),
        const SearchResultItem(
          id: '2',
          kind: SearchResultKind.subscription,
          title: 'Netflix',
          subtitle: 'Active',
          route: '/subscriptions',
        ),
      ]);
      expect(groups.length, 2);
      expect(groups.first.label, 'Expenses');
    });

    test('suggestions merge recent and popular', () {
      final suggestions = UniversalSearchEngine.suggestionsFor(
        query: '',
        merchants: const ['Swiggy'],
        recent: const ['Food this month'],
      );
      expect(suggestions, isNotEmpty);
    });
  });
}
