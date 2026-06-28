import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';

final activityLogServiceProvider = Provider<ActivityLogService>((ref) {
  return ActivityLogService(ref);
});

class ActivityLogService {
  ActivityLogService(this._ref);

  final Ref _ref;

  Future<int> log({
    required ActivityAction action,
    required ActivityModule module,
    required String entityLabel,
    int? entityId,
    Map<String, dynamic>? oldValue,
    Map<String, dynamic>? newValue,
    String? reason,
    ActivitySeverity severity = ActivitySeverity.info,
    bool isUndoable = false,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    return db.activityLogDao.insertEntry(
      ActivityLogTableCompanion.insert(
        action: activityActionKey(action),
        module: activityModuleKey(module),
        entityId: Value(entityId),
        entityLabel: Value(entityLabel),
        oldValueJson: Value(
          oldValue == null ? null : jsonEncode(oldValue),
        ),
        newValueJson: Value(
          newValue == null ? null : jsonEncode(newValue),
        ),
        reason: Value(reason),
        severity: Value(activitySeverityKey(severity)),
        isUndoable: Value(isUndoable),
      ),
    );
  }

  Future<bool> undo(int activityId) async {
    final db = await _ref.read(databaseProvider.future);
    final dao = db.activityLogDao;
    final entry = await dao.getById(activityId);
    if (entry == null || entry.isUndone || !entry.isUndoable) return false;

    final action = activityActionFromKey(entry.action);
    final module = activityModuleFromKey(entry.module);
    if (action == null || module == null) return false;

    final ok = await _performUndo(db, entry, action, module);
    if (ok) {
      await dao.markUndone(activityId);
      await log(
        action: ActivityAction.restored,
        module: module,
        entityId: entry.entityId,
        entityLabel: entry.entityLabel,
        reason: 'Undo',
        severity: ActivitySeverity.info,
      );
    }
    return ok;
  }

  Future<bool> _performUndo(
    AppDatabase db,
    ActivityLogTableData entry,
    ActivityAction action,
    ActivityModule module,
  ) async {
    switch (module) {
      case ActivityModule.expense:
        if (entry.entityId == null) return false;
        if (action == ActivityAction.deleted) {
          await db.expensesDao.restoreSoftDeletedExpense(entry.entityId!);
          return true;
        }
        if (action == ActivityAction.updated && entry.oldValueJson != null) {
          final old = jsonDecode(entry.oldValueJson!) as Map<String, dynamic>;
          await db.expensesDao.updateExpense(
            id: entry.entityId!,
            categoryId: old['categoryId'] as int,
            title: old['title'] as String,
            tagsJson: old['tags'] as String? ?? '[]',
            notes: old['notes'] as String?,
          );
          return true;
        }
        return false;
      case ActivityModule.loan:
        if (entry.entityId == null) return false;
        if (action == ActivityAction.deleted) {
          await db.loansDao.restoreSoftDeletedLoan(entry.entityId!);
          return true;
        }
        return false;
      case ActivityModule.subscription:
        if (entry.entityId == null) return false;
        if (action == ActivityAction.cancelled) {
          await db.subscriptionsDao.resumeSubscription(entry.entityId!);
          return true;
        }
        return false;
      case ActivityModule.goal:
      case ActivityModule.wishlist:
        if (entry.entityId == null) return false;
        if (action == ActivityAction.deleted) {
          await db.savingsGoalsDao.reactivateGoal(entry.entityId!);
          return true;
        }
        return false;
      default:
        return false;
    }
  }

  Future<void> purgeExpiredRecycleBin() async {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();
    final retentionDays = settings.recycleBinRetentionDays;
    if (retentionDays <= 0) return;

    final cutoff =
        DateTime.now().toUtc().subtract(Duration(days: retentionDays));

    final expiredExpenses =
        await db.expensesDao.listExpiredDeletedExpenses(cutoff);
    for (final expense in expiredExpenses) {
      await db.expensesDao.permanentDeleteExpense(expense.id);
      await log(
        action: ActivityAction.deleted,
        module: ActivityModule.expense,
        entityId: expense.id,
        entityLabel: expense.title,
        reason: 'Auto-purged after $retentionDays days',
        severity: ActivitySeverity.warning,
      );
    }

    final deletedLoans = await db.loansDao.watchDeletedLoans().first;
    for (final loan in deletedLoans) {
      final deletedAt = loan.deletedAt;
      if (deletedAt == null || !deletedAt.isBefore(cutoff)) continue;
      await db.loansDao.permanentDeleteLoan(loan.id);
      await log(
        action: ActivityAction.deleted,
        module: ActivityModule.loan,
        entityId: loan.id,
        entityLabel: loan.personName,
        reason: 'Auto-purged after $retentionDays days',
        severity: ActivitySeverity.warning,
      );
    }

    final cancelledSubs =
        await db.subscriptionsDao.watchCancelledSubscriptions().first;
    for (final sub in cancelledSubs) {
      if (!sub.updatedAt.isBefore(cutoff)) continue;
      await db.subscriptionsDao.permanentDeleteSubscription(sub.id);
      await log(
        action: ActivityAction.deleted,
        module: ActivityModule.subscription,
        entityId: sub.id,
        entityLabel: sub.name,
        reason: 'Auto-purged after $retentionDays days',
        severity: ActivitySeverity.warning,
      );
    }

    final inactiveGoals = await db.savingsGoalsDao.watchInactiveGoals().first;
    for (final goal in inactiveGoals) {
      if (!goal.updatedAt.isBefore(cutoff)) continue;
      await db.savingsGoalsDao.permanentDeleteGoal(goal.id);
      await log(
        action: ActivityAction.deleted,
        module:
            goal.isWishlist ? ActivityModule.wishlist : ActivityModule.goal,
        entityId: goal.id,
        entityLabel: goal.name,
        reason: 'Auto-purged after $retentionDays days',
        severity: ActivitySeverity.warning,
      );
    }
  }
}
