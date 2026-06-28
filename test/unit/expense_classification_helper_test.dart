import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/features/expenses/domain/expense_classification_helper.dart';
import 'package:rupee_track/features/smart_tagging/domain/classification_models.dart';

void main() {
  final categories = [
    CategoriesTableData(
      id: 1,
      name: 'Food',
      slug: 'food',
      colorValue: 0xFF000000,
      iconName: 'restaurant',
      sortOrder: 0,
      countsTowardSpending: true,
      isSystem: true,
      isDeleted: false,
    ),
    CategoriesTableData(
      id: 2,
      name: 'Transport',
      slug: 'transport',
      colorValue: 0xFF000000,
      iconName: 'directions_car',
      sortOrder: 1,
      countsTowardSpending: true,
      isSystem: true,
      isDeleted: false,
    ),
  ];

  group('titleLooksLikeMerchant', () {
    test('treats merchant names as merchants', () {
      expect(titleLooksLikeMerchant('Swiggy', categories), isTrue);
    });

    test('treats category names as not merchants', () {
      expect(titleLooksLikeMerchant('Food', categories), isFalse);
    });
  });

  group('resolveCategoryId', () {
    test('uses suggested category for high-confidence merchant titles', () {
      final id = resolveCategoryId(
        selectedCategoryId: 2,
        classification: const TransactionClassification(
          categoryId: 1,
          categorySlug: 'food',
          suggestedCategoryName: 'Food',
          tags: ['delivery'],
          confidence: 0.9,
        ),
        title: 'Swiggy',
        categories: categories,
      );

      expect(id, 1);
    });

    test('keeps manual category when title is a category name', () {
      final id = resolveCategoryId(
        selectedCategoryId: 2,
        classification: const TransactionClassification(
          categoryId: 1,
          categorySlug: 'food',
          suggestedCategoryName: 'Food',
          tags: [],
          confidence: 0.9,
        ),
        title: 'Transport',
        categories: categories,
      );

      expect(id, 2);
    });
  });

  group('mergeExpenseTags', () {
    test('always includes category name and deduplicates', () {
      final tags = mergeExpenseTags(
        userTags: ['Food', 'lunch'],
        classifiedTags: ['delivery', 'lunch'],
        categoryName: 'Food',
      );

      expect(tags, containsAll(['Food', 'lunch', 'delivery']));
      expect(tags.length, 3);
    });
  });
}
