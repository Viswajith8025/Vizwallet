import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [BudgetPlansTable, BudgetBucketsTable])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Stream<BudgetPlansTableData?> watchPlanForMonth(String monthKey) {
    return (select(budgetPlansTable)
          ..where((t) => t.monthKey.equals(monthKey)))
        .watchSingleOrNull();
  }

  Future<BudgetPlansTableData?> getPlanForMonth(String monthKey) {
    return (select(budgetPlansTable)
          ..where((t) => t.monthKey.equals(monthKey)))
        .getSingleOrNull();
  }

  Future<List<BudgetBucketsTableData>> getBucketsForPlan(int planId) {
    return (select(budgetBucketsTable)
          ..where((t) => t.planId.equals(planId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
  }

  Stream<List<BudgetBucketsTableData>> watchBucketsForMonth(String monthKey) async* {
    await for (final plan in watchPlanForMonth(monthKey)) {
      if (plan == null) {
        yield [];
      } else {
        yield await getBucketsForPlan(plan.id);
      }
    }
  }

  Future<int> upsertPlan({
    required String monthKey,
    required int salaryPaise,
    required String allocationMode,
    required bool rolloverEnabled,
    String? aiNotes,
  }) async {
    final existing = await getPlanForMonth(monthKey);
    final now = DateTime.now().toUtc();

    if (existing == null) {
      return into(budgetPlansTable).insert(
        BudgetPlansTableCompanion.insert(
          monthKey: monthKey,
          salaryPaise: salaryPaise,
          allocationMode: Value(allocationMode),
          rolloverEnabled: Value(rolloverEnabled),
          aiNotes: Value(aiNotes),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    }

    await (update(budgetPlansTable)
          ..where((t) => t.monthKey.equals(monthKey)))
        .write(
      BudgetPlansTableCompanion(
        salaryPaise: Value(salaryPaise),
        allocationMode: Value(allocationMode),
        rolloverEnabled: Value(rolloverEnabled),
        aiNotes: Value(aiNotes),
        updatedAt: Value(now),
      ),
    );
    return existing.id;
  }

  Future<void> replaceBuckets({
    required int planId,
    required List<BudgetBucketsTableCompanion> buckets,
  }) async {
    // Atomic: a crash between delete and insert must not leave a plan with
    // zero buckets.
    await transaction(() async {
      await (delete(budgetBucketsTable)..where((t) => t.planId.equals(planId)))
          .go();
      await batch((b) {
        b.insertAll(budgetBucketsTable, buckets);
      });
    });
  }

  Future<void> deletePlanForMonth(String monthKey) async {
    final plan = await getPlanForMonth(monthKey);
    if (plan == null) return;
    await transaction(() async {
      await (delete(budgetBucketsTable)..where((t) => t.planId.equals(plan.id)))
          .go();
      await (delete(budgetPlansTable)..where((t) => t.monthKey.equals(monthKey)))
          .go();
    });
  }
}
