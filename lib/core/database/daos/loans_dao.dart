import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';

part 'loans_dao.g.dart';

@DriftAccessor(tables: [LoansTable, LoanPaymentsTable])
class LoansDao extends DatabaseAccessor<AppDatabase> with _$LoansDaoMixin {
  LoansDao(super.db);

  Stream<List<LoansTableData>> watchActiveLoans() {
    return (select(loansTable)
          ..where((t) => t.isDeleted.equals(false))
          ..where((t) => t.status.isNotIn(['returned', 'cancelled']))
          ..orderBy([(t) => OrderingTerm.asc(t.expectedReturnAt)]))
        .watch();
  }

  Future<int> pendingBorrowedTotal() async {
    final sum = loansTable.balancePaise.sum();
    final query = selectOnly(loansTable)
      ..addColumns([sum])
      ..where(loansTable.isDeleted.equals(false))
      ..where(loansTable.direction.equals('borrowed_by_me'))
      ..where(loansTable.status.isNotIn(['returned', 'cancelled']));

    final row = await query.getSingleOrNull();
    return row?.read(sum) ?? 0;
  }

  Future<List<LoansTableData>> overdueLoans() {
    final now = DateTime.now().toUtc();
    return (select(loansTable)
          ..where((t) => t.isDeleted.equals(false))
          ..where((t) => t.status.isNotIn(['returned', 'cancelled']))
          ..where((t) => t.expectedReturnAt.isSmallerThanValue(now)))
        .get();
  }
}
