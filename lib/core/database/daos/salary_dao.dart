import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';

part 'salary_dao.g.dart';

@DriftAccessor(tables: [MonthlySalaryTable])
class SalaryDao extends DatabaseAccessor<AppDatabase> with _$SalaryDaoMixin {
  SalaryDao(super.db);

  Stream<MonthlySalaryTableData?> watchSalaryForMonth(String monthKey) {
    return (select(monthlySalaryTable)
          ..where((t) => t.monthKey.equals(monthKey)))
        .watchSingleOrNull();
  }

  Future<MonthlySalaryTableData?> getSalaryForMonth(String monthKey) {
    return (select(monthlySalaryTable)
          ..where((t) => t.monthKey.equals(monthKey)))
        .getSingleOrNull();
  }

  Future<void> upsertSalary({
    required String monthKey,
    required int amountPaise,
    String? notes,
    DateTime? receivedAt,
  }) async {
    final existing = await getSalaryForMonth(monthKey);
    final now = DateTime.now().toUtc();

    if (existing == null) {
      await into(monthlySalaryTable).insert(
        MonthlySalaryTableCompanion.insert(
          monthKey: monthKey,
          amountPaise: amountPaise,
          notes: Value(notes),
          receivedAt: Value(receivedAt),
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    } else {
      await (update(monthlySalaryTable)
            ..where((t) => t.monthKey.equals(monthKey)))
          .write(
        MonthlySalaryTableCompanion(
          amountPaise: Value(amountPaise),
          notes: Value(notes),
          receivedAt: Value(receivedAt),
          updatedAt: Value(now),
        ),
      );
    }
  }
}
