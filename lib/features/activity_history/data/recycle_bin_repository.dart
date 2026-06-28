import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/activity_history/data/activity_log_service.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';
import 'package:rupee_track/features/home_widget/data/home_widget_sync_service.dart';

final recycleBinProvider = StreamProvider<List<RecycleBinItem>>((ref) async* {
  final db = await ref.watch(databaseProvider.future);

  Future<List<RecycleBinItem>> loadItems() async {
    final items = <RecycleBinItem>[];

    final deletedExpenses = await db.expensesDao.watchDeletedExpenses().first;
    for (final row in deletedExpenses) {
      items.add(
        RecycleBinItem(
          id: 'expense-${row.expense.id}',
          module: ActivityModule.expense,
          title: row.expense.title,
          subtitle:
              '${row.category.name} · ${formatPaise(row.expense.amountPaise)}',
          deletedAt: row.expense.deletedAt,
          amountPaise: row.expense.amountPaise,
          colorValue: row.category.colorValue,
        ),
      );
    }

    final deletedLoans = await db.loansDao.watchDeletedLoans().first;
    for (final loan in deletedLoans) {
      items.add(
        RecycleBinItem(
          id: 'loan-${loan.id}',
          module: ActivityModule.loan,
          title: loan.personName,
          subtitle: '${loan.direction} · ${formatPaise(loan.balancePaise)}',
          deletedAt: loan.deletedAt,
          amountPaise: loan.balancePaise,
        ),
      );
    }

    final cancelledSubs =
        await db.subscriptionsDao.watchCancelledSubscriptions().first;
    for (final sub in cancelledSubs) {
      items.add(
        RecycleBinItem(
          id: 'subscription-${sub.id}',
          module: ActivityModule.subscription,
          title: sub.name,
          subtitle: 'Cancelled · ${formatPaise(sub.amountPaise)}/mo',
          deletedAt: sub.updatedAt,
          amountPaise: sub.amountPaise,
        ),
      );
    }

    final inactiveGoals = await db.savingsGoalsDao.watchInactiveGoals().first;
    for (final goal in inactiveGoals) {
      items.add(
        RecycleBinItem(
          id: 'goal-${goal.id}',
          module:
              goal.isWishlist ? ActivityModule.wishlist : ActivityModule.goal,
          title: goal.name,
          subtitle:
              '${formatPaise(goal.savedPaise)} / ${formatPaise(goal.targetPaise)}',
          deletedAt: goal.updatedAt,
          amountPaise: goal.targetPaise,
        ),
      );
    }

    items.sort((a, b) {
      final aTime = a.deletedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bTime = b.deletedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bTime.compareTo(aTime);
    });

    return items;
  }

  yield await loadItems();

  final controller = StreamController<void>();
  void ping([_]) {
    if (!controller.isClosed) controller.add(null);
  }

  final subs = <StreamSubscription<dynamic>>[
    db.expensesDao.watchSpendingChanges().listen(ping),
    db.expensesDao.watchDeletedExpenses().listen(ping),
    db.loansDao.watchDeletedLoans().listen(ping),
    db.subscriptionsDao.watchCancelledSubscriptions().listen(ping),
    db.savingsGoalsDao.watchInactiveGoals().listen(ping),
  ];

  try {
    await for (final _ in controller.stream) {
      yield await loadItems();
    }
  } finally {
    for (final sub in subs) {
      await sub.cancel();
    }
    await controller.close();
  }
});

final recycleBinRepositoryProvider = Provider<RecycleBinRepository>((ref) {
  return RecycleBinRepository(ref);
});

class RecycleBinRepository {
  RecycleBinRepository(this._ref);

  final Ref _ref;

  Future<void> restore(RecycleBinItem item) async {
    final db = await _ref.read(databaseProvider.future);
    final log = _ref.read(activityLogServiceProvider);
    final parts = item.id.split('-');
    if (parts.length < 2) return;
    final entityId = int.tryParse(parts[1]);
    if (entityId == null) return;

    switch (item.module) {
      case ActivityModule.expense:
        await db.expensesDao.restoreSoftDeletedExpense(entityId);
        await log.log(
          action: ActivityAction.restored,
          module: ActivityModule.expense,
          entityId: entityId,
          entityLabel: item.title,
        );
        await _ref.read(homeWidgetSyncServiceProvider).sync();
      case ActivityModule.loan:
        await db.loansDao.restoreSoftDeletedLoan(entityId);
        await log.log(
          action: ActivityAction.restored,
          module: ActivityModule.loan,
          entityId: entityId,
          entityLabel: item.title,
        );
      case ActivityModule.subscription:
        await db.subscriptionsDao.resumeSubscription(entityId);
        await log.log(
          action: ActivityAction.restored,
          module: ActivityModule.subscription,
          entityId: entityId,
          entityLabel: item.title,
        );
      case ActivityModule.goal:
      case ActivityModule.wishlist:
        await db.savingsGoalsDao.reactivateGoal(entityId);
        await log.log(
          action: ActivityAction.restored,
          module: item.module,
          entityId: entityId,
          entityLabel: item.title,
        );
      default:
        break;
    }

    _ref.invalidate(recycleBinProvider);
  }

  Future<void> permanentDelete(RecycleBinItem item) async {
    final db = await _ref.read(databaseProvider.future);
    final log = _ref.read(activityLogServiceProvider);
    final parts = item.id.split('-');
    if (parts.length < 2) return;
    final entityId = int.tryParse(parts[1]);
    if (entityId == null) return;

    switch (item.module) {
      case ActivityModule.expense:
        await db.expensesDao.permanentDeleteExpense(entityId);
      case ActivityModule.loan:
        await db.loansDao.permanentDeleteLoan(entityId);
      case ActivityModule.subscription:
        await db.subscriptionsDao.permanentDeleteSubscription(entityId);
      case ActivityModule.goal:
      case ActivityModule.wishlist:
        await db.savingsGoalsDao.permanentDeleteGoal(entityId);
      default:
        return;
    }

    await log.log(
      action: ActivityAction.deleted,
      module: item.module,
      entityId: entityId,
      entityLabel: item.title,
      reason: 'Permanently deleted from recycle bin',
      severity: ActivitySeverity.critical,
    );

    _ref.invalidate(recycleBinProvider);
  }

  Future<void> restoreAll(List<RecycleBinItem> items) async {
    for (final item in items) {
      await restore(item);
    }
  }
}
