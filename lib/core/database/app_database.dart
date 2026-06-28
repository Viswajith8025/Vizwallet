import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/constants/category_defaults.dart';
import 'package:rupee_track/core/database/daos/budget_dao.dart';
import 'package:rupee_track/core/database/daos/categories_dao.dart';
import 'package:rupee_track/core/database/daos/expenses_dao.dart';
import 'package:rupee_track/core/database/daos/loans_dao.dart';
import 'package:rupee_track/core/database/daos/salary_dao.dart';
import 'package:rupee_track/core/database/daos/settings_dao.dart';
import 'package:rupee_track/core/database/daos/subscriptions_dao.dart';
import 'package:rupee_track/core/database/tables.dart';
import 'package:rupee_track/core/database/daos/income_sources_dao.dart';
import 'package:rupee_track/core/database/daos/tagging_rules_dao.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/smart_tagging/domain/default_tagging_rules.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    AppSettingsTable,
    MonthlySalaryTable,
    CategoriesTable,
    ExpensesTable,
    SubscriptionsTable,
    SubscriptionPaymentsTable,
    LoansTable,
    LoanPaymentsTable,
    BudgetPlansTable,
    BudgetBucketsTable,
    IncomeSourcesTable,
    TaggingRulesTable,
  ],
  daos: [
    ExpensesDao,
    SalaryDao,
    CategoriesDao,
    SettingsDao,
    SubscriptionsDao,
    LoansDao,
    BudgetDao,
    IncomeSourcesDao,
    TaggingRulesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedDefaults();
          await _seedTaggingRules();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(budgetPlansTable);
            await m.createTable(budgetBucketsTable);
          }
          if (from < 3) {
            await m.createTable(incomeSourcesTable);
            final settings = await select(appSettingsTable).getSingleOrNull();
            final salaryDay = settings?.salaryDay ?? AppConstants.defaultSalaryDay;
            await into(incomeSourcesTable).insert(
              IncomeSourcesTableCompanion.insert(
                dayOfMonth: Value(salaryDay),
              ),
            );
            await _migrateToSalaryCycleKeys(salaryDay);
          }
          if (from < 4) {
            await m.createTable(taggingRulesTable);
            await _seedTaggingRules();
          }
        },
      );

  Future<void> _migrateToSalaryCycleKeys(int salaryDay) async {
    final expenses = await select(expensesTable).get();
    for (final expense in expenses) {
      final newKey = SalaryCycleEngine.cycleKeyFromDate(
        expense.occurredAt,
        salaryDay: salaryDay,
      );
      if (newKey != expense.monthKey) {
        await (update(expensesTable)..where((t) => t.id.equals(expense.id)))
            .write(ExpensesTableCompanion(monthKey: Value(newKey)));
      }
    }

    final salaries = await select(monthlySalaryTable).get();
    for (final salary in salaries) {
      final anchor = salary.receivedAt ??
          SalaryCycleEngine.parseCycleKey(
            SalaryCycleEngine.isLegacyMonthKey(salary.monthKey)
                ? SalaryCycleEngine.migrateLegacyMonthKey(
                    salary.monthKey,
                    salaryDay: salaryDay,
                  )
                : salary.monthKey,
            salaryDay: salaryDay,
          );
      final newKey = SalaryCycleEngine.cycleKeyFromDate(
        anchor,
        salaryDay: salaryDay,
      );
      if (newKey != salary.monthKey) {
        await (update(monthlySalaryTable)
              ..where((t) => t.id.equals(salary.id)))
            .write(MonthlySalaryTableCompanion(monthKey: Value(newKey)));
      }
    }

    final plans = await select(budgetPlansTable).get();
    for (final plan in plans) {
      final newKey = SalaryCycleEngine.isLegacyMonthKey(plan.monthKey)
          ? SalaryCycleEngine.migrateLegacyMonthKey(
              plan.monthKey,
              salaryDay: salaryDay,
            )
          : plan.monthKey;
      if (newKey != plan.monthKey) {
        await (update(budgetPlansTable)..where((t) => t.id.equals(plan.id)))
            .write(BudgetPlansTableCompanion(monthKey: Value(newKey)));
      }
    }

    final payments = await select(subscriptionPaymentsTable).get();
    for (final payment in payments) {
      final newKey = SalaryCycleEngine.cycleKeyFromDate(
        payment.paidAt,
        salaryDay: salaryDay,
      );
      if (newKey != payment.monthKey) {
        await (update(subscriptionPaymentsTable)
              ..where((t) => t.id.equals(payment.id)))
            .write(
          SubscriptionPaymentsTableCompanion(monthKey: Value(newKey)),
        );
      }
    }
  }

  Future<void> _seedDefaults() async {
    await into(appSettingsTable).insert(
      AppSettingsTableCompanion.insert(
        majorExpenseThresholdPaise: Value(
          rupeesDoubleToPaise(
            AppConstants.defaultMajorExpenseThresholdRupees.toDouble(),
          ),
        ),
        largeExpenseThresholdPaise: Value(
          rupeesDoubleToPaise(
            AppConstants.defaultLargeExpenseThresholdRupees.toDouble(),
          ),
        ),
        veryLargeExpenseThresholdPaise: Value(
          rupeesDoubleToPaise(
            AppConstants.defaultVeryLargeExpenseThresholdRupees.toDouble(),
          ),
        ),
        majorPurchaseThresholdPaise: Value(
          rupeesDoubleToPaise(
            AppConstants.defaultMajorPurchaseThresholdRupees.toDouble(),
          ),
        ),
        salaryDay: const Value(AppConstants.defaultSalaryDay),
      ),
    );

    await into(incomeSourcesTable).insert(
      IncomeSourcesTableCompanion.insert(
        dayOfMonth: const Value(AppConstants.defaultSalaryDay),
      ),
    );

    for (final category in defaultCategories) {
      await into(categoriesTable).insert(
        CategoriesTableCompanion.insert(
          name: category.name,
          slug: category.slug,
          iconName: Value(category.iconName),
          colorValue: Value(category.colorValue),
          isSystem: const Value(true),
          countsTowardSpending: Value(category.countsTowardSpending),
          sortOrder: Value(category.sortOrder),
        ),
      );
    }
  }

  Future<void> _seedTaggingRules() async {
    for (final rule in builtinMerchantRules) {
      await into(taggingRulesTable).insert(
        TaggingRulesTableCompanion.insert(
          pattern: rule.pattern,
          categorySlug: Value(rule.categorySlug),
          tags: Value(jsonEncode(rule.tags)),
          source: 'builtin',
          confidence: Value(rule.confidence),
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'vis_wallet.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
