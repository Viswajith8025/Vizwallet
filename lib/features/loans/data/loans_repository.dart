import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/features/activity_history/data/activity_log_service.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';

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

  Future<void> addLoan({
    required String personName,
    required int amountPaise,
    String? reason,
    DateTime? expectedReturnAt,
    String direction = 'borrowed_by_me',
    String? notes,
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
          newValue: {'amountPaise': amountPaise},
        );
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
}

final activeLoansProvider = StreamProvider<List<LoansTableData>>((ref) {
  return ref.watch(loansRepositoryProvider).watchActiveLoans();
});
