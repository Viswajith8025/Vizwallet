import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/activity_history/data/activity_log_service.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';
import 'package:rupee_track/features/budget_alerts/data/budget_notification_service.dart';
import 'package:rupee_track/features/loans/domain/loan_direction.dart';

final loansRepositoryProvider = Provider<LoansRepository>((ref) {
  return LoansRepository(ref);
});

class LoansRepository {
  LoansRepository(this._ref);

  final Ref _ref;

  Stream<List<LoansTableData>> watchActiveLoans() async* {
    final dao = await _ref.read(loansDaoProvider.future);
    yield* dao.watchActiveLoans();
  }

  Stream<List<LoansTableData>> watchActiveLentLoans() async* {
    final dao = await _ref.read(loansDaoProvider.future);
    yield* dao.watchActiveLentLoans();
  }

  Stream<List<LoansTableData>> watchActiveBorrowedPaybacks() async* {
    final dao = await _ref.read(loansDaoProvider.future);
    yield* dao.watchActiveBorrowedPaybacks();
  }

  /// Money you lent to someone else.
  Future<void> addLoan({
    required String personName,
    required int amountPaise,
    String? reason,
    DateTime? expectedReturnAt,
    String? notes,
  }) async {
    await _insertLoan(
      personName: personName,
      amountPaise: amountPaise,
      reason: reason,
      expectedReturnAt: expectedReturnAt,
      direction: LoanDirection.lentByMe,
      notes: notes,
    );
  }

  /// Money you borrowed — schedule when you will pay it back.
  Future<void> schedulePayback({
    required String personName,
    required int amountPaise,
    required DateTime returnBy,
    String? reason,
    String? notes,
    bool scheduleReminder = true,
  }) async {
    await _insertLoan(
      personName: personName,
      amountPaise: amountPaise,
      reason: reason,
      expectedReturnAt: returnBy,
      direction: LoanDirection.borrowedByMe,
      notes: notes,
      scheduleReminder: scheduleReminder,
    );
  }

  Future<void> _insertLoan({
    required String personName,
    required int amountPaise,
    String? reason,
    DateTime? expectedReturnAt,
    required String direction,
    String? notes,
    bool scheduleReminder = false,
  }) async {
    final dao = await _ref.read(loansDaoProvider.future);
    final now = DateTime.now().toUtc();

    final id = await dao.insertLoan(
      LoansTableCompanion.insert(
        personName: personName.trim(),
        direction: Value(direction),
        principalPaise: amountPaise,
        balancePaise: amountPaise,
        reason: Value(reason?.trim()),
        borrowedAt: now,
        expectedReturnAt: Value(expectedReturnAt),
        notes: Value(notes?.trim()),
      ),
    );
    await _ref.read(activityLogServiceProvider).log(
          action: ActivityAction.created,
          module: ActivityModule.loan,
          entityId: id,
          entityLabel: personName.trim(),
          newValue: {
            'amountPaise': amountPaise,
            'direction': direction,
          },
        );

    if (scheduleReminder && expectedReturnAt != null) {
      final title = LoanDirection.isPayback(direction)
          ? 'Pay-back reminder'
          : 'Loan return reminder';
      final body = LoanDirection.isPayback(direction)
          ? 'Pay ${personName.trim()} by ${expectedReturnAt.toLocal().toString().split(' ').first}'
          : '${personName.trim()} should return money by ${expectedReturnAt.toLocal().toString().split(' ').first}';
      await BudgetNotificationService.instance.show(title: title, body: body);
    }
  }

  Future<int?> removeLoan(int id) async {
    final dao = await _ref.read(loansDaoProvider.future);
    final existing = await dao.getLoanById(id);
    await dao.softDeleteLoan(id);
    if (existing == null) return null;
    return _ref.read(activityLogServiceProvider).log(
          action: ActivityAction.deleted,
          module: ActivityModule.loan,
          entityId: id,
          entityLabel: existing.personName,
          isUndoable: true,
          oldValue: {
            'personName': existing.personName,
            'balancePaise': existing.balancePaise,
          },
          severity: ActivitySeverity.warning,
        );
  }

  Future<void> restoreLoan(int id) async {
    final dao = await _ref.read(loansDaoProvider.future);
    final existing = await dao.getLoanById(id);
    await dao.restoreSoftDeletedLoan(id);
    if (existing != null) {
      await _ref.read(activityLogServiceProvider).log(
            action: ActivityAction.restored,
            module: ActivityModule.loan,
            entityId: id,
            entityLabel: existing.personName,
          );
    }
  }

  Future<void> recordPayment({
    required int loanId,
    required int amountPaise,
    String? notes,
  }) async {
    final dao = await _ref.read(loansDaoProvider.future);
    final existing = await dao.getLoanById(loanId);
    if (existing == null) return;

    await dao.recordPayment(
      loanId: loanId,
      amountPaise: amountPaise,
      notes: notes,
    );
    await _ref.read(activityLogServiceProvider).log(
          action: ActivityAction.updated,
          module: ActivityModule.loan,
          entityId: loanId,
          entityLabel: existing.personName,
          newValue: {'paymentPaise': amountPaise, 'notes': notes},
        );
  }

  /// They paid you back on a loan you gave.
  Future<void> markLoanReturned({
    required int loanId,
    bool creditToSalary = true,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    final loan = await db.loansDao.getLoanById(loanId);
    if (loan == null || !LoanDirection.isLoan(loan.direction)) return;

    final amount = loan.balancePaise;
    if (amount <= 0) return;

    await db.loansDao.recordPayment(
      loanId: loanId,
      amountPaise: amount,
      notes: 'Loan returned',
    );

    if (creditToSalary) {
      await _adjustSalary(amountPaise: amount, add: true);
    }

    await _logLoanUpdate(loan, 'returnedPaise', amount, creditToSalary);
  }

  /// You paid back money you borrowed.
  Future<void> markPaybackComplete({
    required int loanId,
    bool debitFromSalary = true,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    final loan = await db.loansDao.getLoanById(loanId);
    if (loan == null || !LoanDirection.isPayback(loan.direction)) return;

    final amount = loan.balancePaise;
    if (amount <= 0) return;

    await db.loansDao.recordPayment(
      loanId: loanId,
      amountPaise: amount,
      notes: 'Paid back',
    );

    if (debitFromSalary) {
      await _adjustSalary(amountPaise: amount, add: false);
    }

    await _logLoanUpdate(loan, 'paidBackPaise', amount, debitFromSalary);
  }

  Future<void> _adjustSalary({
    required int amountPaise,
    required bool add,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();
    final cycleKey = currentCycleKey(salaryDay: settings.salaryDay);
    final salary = await db.salaryDao.getSalaryForMonth(cycleKey);
    final current = salary?.amountPaise ?? 0;
    final next = add
        ? current + amountPaise
        : (current - amountPaise).clamp(0, 1 << 62);
    await db.salaryDao.upsertSalary(
      monthKey: cycleKey,
      amountPaise: next,
      notes: salary?.notes,
      receivedAt: salary?.receivedAt,
    );
  }

  Future<void> _logLoanUpdate(
    LoansTableData loan,
    String amountKey,
    int amount,
    bool salaryAdjusted,
  ) async {
    await _ref.read(activityLogServiceProvider).log(
          action: ActivityAction.updated,
          module: ActivityModule.loan,
          entityId: loan.id,
          entityLabel: loan.personName,
          newValue: {
            amountKey: amount,
            'salaryAdjusted': salaryAdjusted,
          },
        );
  }
}

final activeLoansProvider = StreamProvider<List<LoansTableData>>((ref) {
  return ref.watch(loansRepositoryProvider).watchActiveLoans();
});

final activeLentLoansProvider = StreamProvider<List<LoansTableData>>((ref) {
  return ref.watch(loansRepositoryProvider).watchActiveLentLoans();
});

final activeBorrowedPaybacksProvider =
    StreamProvider<List<LoansTableData>>((ref) {
  return ref.watch(loansRepositoryProvider).watchActiveBorrowedPaybacks();
});

final duePaybacksProvider = FutureProvider<List<LoansTableData>>((ref) async {
  final dao = await ref.watch(loansDaoProvider.future);
  return dao.duePaybacks();
});
