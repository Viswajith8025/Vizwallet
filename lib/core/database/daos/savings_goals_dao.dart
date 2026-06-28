import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';

part 'savings_goals_dao.g.dart';

@DriftAccessor(tables: [SavingsGoalsTable])
class SavingsGoalsDao extends DatabaseAccessor<AppDatabase>
    with _$SavingsGoalsDaoMixin {
  SavingsGoalsDao(super.db);

  Stream<List<SavingsGoalsTableData>> watchActiveGoals() {
    return (select(savingsGoalsTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.targetDate)]))
        .watch();
  }

  Future<List<SavingsGoalsTableData>> listActiveGoals() {
    return (select(savingsGoalsTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.targetDate)]))
        .get();
  }

  Future<int> insertGoal(SavingsGoalsTableCompanion goal) {
    return into(savingsGoalsTable).insert(goal);
  }

  Future<void> updateGoal(int id, SavingsGoalsTableCompanion goal) {
    return (update(savingsGoalsTable)..where((t) => t.id.equals(id))).write(
      goal.copyWith(updatedAt: Value(DateTime.now().toUtc())),
    );
  }

  Future<void> deactivateGoal(int id) {
    return (update(savingsGoalsTable)..where((t) => t.id.equals(id))).write(
      SavingsGoalsTableCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> reactivateGoal(int id) {
    return (update(savingsGoalsTable)..where((t) => t.id.equals(id))).write(
      SavingsGoalsTableCompanion(
        isActive: const Value(true),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Stream<List<SavingsGoalsTableData>> watchInactiveGoals() {
    return (select(savingsGoalsTable)
          ..where((t) => t.isActive.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Future<SavingsGoalsTableData?> getGoalById(int id) {
    return (select(savingsGoalsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<bool> permanentDeleteGoal(int id) {
    return (delete(savingsGoalsTable)..where((t) => t.id.equals(id)))
        .go()
        .then((count) => count > 0);
  }
}
