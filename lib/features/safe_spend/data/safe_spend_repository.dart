import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/safe_spend/domain/safe_spend_engine.dart';
import 'package:rupee_track/features/safe_spend/domain/safe_spend_snapshot.dart';

final safeSpendRepositoryProvider = Provider<SafeSpendRepository>((ref) {
  return SafeSpendRepository(ref);
});

class SafeSpendRepository {
  SafeSpendRepository(this._ref);

  final Ref _ref;

  Future<SafeSpendSnapshot> computeForCycle(String cycleKey) async {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();
    final salaryDay = settings.salaryDay;
    final salary = await db.salaryDao.getSalaryForMonth(cycleKey);
    return _compute(
      db: db,
      cycleKey: cycleKey,
      salaryDay: salaryDay,
      salaryPaise: salary?.amountPaise ?? 0,
    );
  }

  /// Recomputes after every expense or salary change in the cycle.
  Stream<SafeSpendSnapshot> watchSafeSpend(String cycleKey) async* {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();
    final salaryDay = settings.salaryDay;

    await for (final salary in db.salaryDao.watchSalaryForMonth(cycleKey)) {
      await for (final _ in db.expensesDao.watchExpensesForMonth(cycleKey)) {
        yield await _compute(
          db: db,
          cycleKey: cycleKey,
          salaryDay: salaryDay,
          salaryPaise: salary?.amountPaise ?? 0,
        );
      }
    }
  }

  Future<SafeSpendSnapshot> _compute({
    required AppDatabase db,
    required String cycleKey,
    required int salaryDay,
    required int salaryPaise,
  }) async {
    final cycleSpent = await db.expensesDao.sumSpentForMonth(cycleKey);
    final todaySpent = await db.expensesDao.sumSpentTodayInCycle(cycleKey);

    final previousKey = previousCycleKey(cycleKey, salaryDay: salaryDay);
    final prevSalary = await db.salaryDao.getSalaryForMonth(previousKey);
    final prevSpent = await db.expensesDao.sumSpentForMonth(previousKey);
    final carryOver = SalaryCycleEngine.carryOverBalance(
      previousSalaryPaise: prevSalary?.amountPaise ?? 0,
      previousSpentPaise: prevSpent,
    );

    return SafeSpendEngine.compute(
      cycleKey: cycleKey,
      salaryPaise: salaryPaise,
      carryOverPaise: carryOver,
      cycleSpentPaise: cycleSpent,
      todaySpentPaise: todaySpent,
      salaryDay: salaryDay,
    );
  }
}

final safeSpendProvider =
    StreamProvider.family<SafeSpendSnapshot, String>((ref, cycleKey) {
  final repo = ref.watch(safeSpendRepositoryProvider);
  return repo.watchSafeSpend(cycleKey);
});
