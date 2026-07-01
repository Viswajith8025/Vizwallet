import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';
import 'package:rupee_track/features/loans/domain/loan_direction.dart';

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

  Stream<List<LoansTableData>> watchActiveLentLoans() {
    return (select(loansTable)
          ..where((t) => t.isDeleted.equals(false))
          ..where((t) => t.direction.equals(LoanDirection.lentByMe))
          ..where((t) => t.status.isNotIn(['returned', 'cancelled']))
          ..orderBy([(t) => OrderingTerm.asc(t.expectedReturnAt)]))
        .watch();
  }

  Stream<List<LoansTableData>> watchActiveBorrowedPaybacks() {
    return (select(loansTable)
          ..where((t) => t.isDeleted.equals(false))
          ..where((t) => t.direction.equals(LoanDirection.borrowedByMe))
          ..where((t) => t.status.isNotIn(['returned', 'cancelled']))
          ..orderBy([(t) => OrderingTerm.asc(t.expectedReturnAt)]))
        .watch();
  }

  Future<int> pendingLentTotal() async {
    final sum = loansTable.balancePaise.sum();
    final query = selectOnly(loansTable)
      ..addColumns([sum])
      ..where(loansTable.isDeleted.equals(false))
      ..where(loansTable.direction.equals(LoanDirection.lentByMe))
      ..where(loansTable.status.isNotIn(['returned', 'cancelled']));

    final row = await query.getSingleOrNull();
    return row?.read(sum) ?? 0;
  }

  Future<List<LoansTableData>> duePaybacks({DateTime? onOrBefore}) {
    final cutoff = onOrBefore ?? DateTime.now().toUtc();
    return (select(loansTable)
          ..where((t) => t.isDeleted.equals(false))
          ..where((t) => t.direction.equals(LoanDirection.borrowedByMe))
          ..where((t) => t.status.isNotIn(['returned', 'cancelled']))
          ..where((t) => t.expectedReturnAt.isSmallerOrEqualValue(cutoff)))
        .get();
  }

  @Deprecated('Use watchActiveLentLoans')
  Stream<List<LoansTableData>> watchActiveReceivables() =>
      watchActiveLentLoans();

  @Deprecated('Use pendingLentTotal')
  Future<int> pendingReceivableTotal() => pendingLentTotal();

  @Deprecated('Use duePaybacks')
  Future<List<LoansTableData>> dueReceivables({DateTime? onOrBefore}) =>
      duePaybacks(onOrBefore: onOrBefore);

  Future<int> pendingBorrowedTotal() async {
    final sum = loansTable.balancePaise.sum();
    final query = selectOnly(loansTable)
      ..addColumns([sum])
      ..where(loansTable.isDeleted.equals(false))
      ..where(loansTable.direction.equals(LoanDirection.borrowedByMe))
      ..where(loansTable.status.isNotIn(['returned', 'cancelled']));

    final row = await query.getSingleOrNull();
    return row?.read(sum) ?? 0;
  }

  Future<List<LoansTableData>> overdueLoans() {
    final now = DateTime.now().toUtc();
    return (select(loansTable)
          ..where((t) => t.isDeleted.equals(false))
          ..where((t) => t.direction.equals(LoanDirection.borrowedByMe))
          ..where((t) => t.balancePaise.isBiggerThanValue(0))
          ..where((t) => t.status.isNotIn(['returned', 'cancelled']))
          ..where((t) => t.expectedReturnAt.isSmallerThanValue(now)))
        .get();
  }

  Future<void> recordPayment({
    required int loanId,
    required int amountPaise,
    String? notes,
  }) async {
    if (amountPaise <= 0) return;
    final loan = await getLoanById(loanId);
    if (loan == null) return;

    final paidAt = DateTime.now().toUtc();
    final applied = amountPaise.clamp(0, loan.balancePaise);
    final newBalance = loan.balancePaise - applied;
    final newStatus = newBalance <= 0 ? 'returned' : loan.status;

    await transaction(() async {
      await into(loanPaymentsTable).insert(
        LoanPaymentsTableCompanion.insert(
          loanId: loanId,
          amountPaise: applied,
          paidAt: paidAt,
          notes: Value(notes?.trim()),
        ),
      );
      await (update(loansTable)..where((t) => t.id.equals(loanId))).write(
        LoansTableCompanion(
          balancePaise: Value(newBalance),
          status: Value(newStatus),
          updatedAt: Value(paidAt),
        ),
      );
    });
  }

  Future<int> insertLoan(LoansTableCompanion loan) {
    return into(loansTable).insert(loan);
  }

  Future<void> softDeleteLoan(int id) {
    final now = DateTime.now().toUtc();
    return (update(loansTable)..where((t) => t.id.equals(id))).write(
      LoansTableCompanion(
        isDeleted: const Value(true),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> restoreSoftDeletedLoan(int id) {
    final now = DateTime.now().toUtc();
    return (update(loansTable)..where((t) => t.id.equals(id))).write(
      LoansTableCompanion(
        isDeleted: const Value(false),
        deletedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  Stream<List<LoansTableData>> watchDeletedLoans() {
    return (select(loansTable)
          ..where((t) => t.isDeleted.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)]))
        .watch();
  }

  Future<bool> permanentDeleteLoan(int id) {
    return (delete(loansTable)..where((t) => t.id.equals(id)))
        .go()
        .then((count) => count > 0);
  }

  Future<LoansTableData?> getLoanById(int id) {
    return (select(loansTable)..where((t) => t.id.equals(id))).getSingleOrNull();
  }
}
