import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/daos/categories_dao.dart';
import 'package:rupee_track/core/database/daos/expenses_dao.dart';
import 'package:rupee_track/core/database/daos/loans_dao.dart';
import 'package:rupee_track/core/database/daos/salary_dao.dart';
import 'package:rupee_track/core/database/daos/settings_dao.dart';
import 'package:rupee_track/core/database/daos/income_sources_dao.dart';
import 'package:rupee_track/core/database/daos/subscriptions_dao.dart';

final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final db = AppDatabase(openConnection());
  ref.onDispose(db.close);
  return db;
});

final expensesDaoProvider = FutureProvider<ExpensesDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.expensesDao;
});

final salaryDaoProvider = FutureProvider<SalaryDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.salaryDao;
});

final categoriesDaoProvider = FutureProvider<CategoriesDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.categoriesDao;
});

final settingsDaoProvider = FutureProvider<SettingsDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.settingsDao;
});

final subscriptionsDaoProvider = FutureProvider<SubscriptionsDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.subscriptionsDao;
});

final loansDaoProvider = FutureProvider<LoansDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.loansDao;
});

final incomeSourcesDaoProvider = FutureProvider<IncomeSourcesDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.incomeSourcesDao;
});
