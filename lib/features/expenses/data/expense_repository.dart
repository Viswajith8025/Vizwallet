import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/daos/expenses_dao.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/utils/auto_label_utils.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/smart_tagging/data/tagging_repository.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(ref);
});

class ExpenseRepository {
  ExpenseRepository(this._ref);

  final Ref _ref;

  Stream<List<ExpenseWithCategory>> watchForMonth(String monthKey) async* {
    final dao = await _ref.read(expensesDaoProvider.future);
    yield* dao.watchExpensesForMonth(monthKey);
  }

  Future<void> addExpense({
    required int amountPaise,
    required int categoryId,
    required String title,
    String? description,
    DateTime? occurredAt,
    String paymentMethod = 'UPI',
    List<String> tags = const [],
    String? notes,
    bool autoClassifyTags = true,
  }) async {
    final dao = await _ref.read(expensesDaoProvider.future);
    final settingsDao = await _ref.read(settingsDaoProvider.future);
    final settings = await settingsDao.getSettings();

    var resolvedTags = tags;
    if (autoClassifyTags && resolvedTags.isEmpty) {
      final categories = await _ref.read(categoriesProvider.future);
      final classification = await _ref.read(taggingRepositoryProvider).classify(
            title: title,
            description: description,
            notes: notes,
            categories: categories,
          );
      resolvedTags = _ref
          .read(taggingRepositoryProvider)
          .autoTagsForSave(classification);
      if (resolvedTags.isEmpty && classification.tags.isNotEmpty) {
        resolvedTags = classification.tags;
      }
    }

    final when = (occurredAt ?? DateTime.now()).toUtc();
    final salaryDay = settings.salaryDay;
    final labels = computeAutoLabels(
      amountPaise: amountPaise,
      majorThresholdPaise: settings.majorExpenseThresholdPaise,
      largeThresholdPaise: settings.largeExpenseThresholdPaise,
      veryLargeThresholdPaise: settings.veryLargeExpenseThresholdPaise,
    );

    await dao.insertExpense(
      ExpensesTableCompanion.insert(
        amountPaise: amountPaise,
        categoryId: categoryId,
        title: title,
        description: Value(description),
        occurredAt: when,
        monthKey: cycleKeyFromDate(when, salaryDay: salaryDay),
        paymentMethod: Value(paymentMethod),
        tags: Value(jsonEncode(resolvedTags)),
        notes: Value(notes),
        autoLabels: Value(jsonEncode(labels)),
      ),
    );
    _ref.invalidate(spendingByTagsProvider(cycleKeyFromDate(when, salaryDay: salaryDay)));
  }

  Future<void> updateExpenseClassification({
    required int expenseId,
    required int categoryId,
    required String title,
    required List<String> tags,
    String? notes,
    required String monthKey,
  }) async {
    final dao = await _ref.read(expensesDaoProvider.future);
    final categories = await _ref.read(categoriesProvider.future);
    final category = categories.firstWhere((c) => c.id == categoryId);

    await dao.updateExpense(
      id: expenseId,
      categoryId: categoryId,
      title: title,
      tagsJson: jsonEncode(tags),
      notes: notes,
    );

    await _ref.read(taggingRepositoryProvider).recordCorrection(
          title: title,
          categorySlug: category.slug,
          tags: tags,
        );
    _ref.invalidate(spendingByTagsProvider(monthKey));
  }

  Future<void> deleteExpense(int id) async {
    final dao = await _ref.read(expensesDaoProvider.future);
    await dao.softDeleteExpense(id);
  }

  Future<void> restoreExpense(ExpenseWithCategory item) async {
    final dao = await _ref.read(expensesDaoProvider.future);
    await dao.restoreSoftDeletedExpense(item.expense.id);
    _ref.invalidate(spendingByTagsProvider(item.expense.monthKey));
  }
}

final expensesForMonthProvider =
    StreamProvider.family<List<ExpenseWithCategory>, String>((ref, monthKey) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.watchForMonth(monthKey);
});

final categoriesProvider = StreamProvider<List<CategoriesTableData>>((ref) async* {
  final dao = await ref.watch(categoriesDaoProvider.future);
  yield* dao.watchActiveCategories();
});
