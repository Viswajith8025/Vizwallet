import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/features/activity_history/data/activity_log_service.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';

final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>((ref) {
  return SavingsGoalsRepository(ref);
});

class SavingsGoalsRepository {
  SavingsGoalsRepository(this._ref);

  final Ref _ref;

  Stream<List<SavingsGoalsTableData>> watchActiveGoals() async* {
    final dao = await _ref.read(savingsGoalsDaoProvider.future);
    yield* dao.watchActiveGoals();
  }

  Future<void> addGoal({
    required String name,
    required int targetPaise,
    int savedPaise = 0,
    int monthlyContributionPaise = 0,
    bool isWishlist = false,
    DateTime? targetDate,
  }) async {
    final dao = await _ref.read(savingsGoalsDaoProvider.future);
    final id = await dao.insertGoal(
      SavingsGoalsTableCompanion.insert(
        name: name.trim(),
        targetPaise: targetPaise,
        savedPaise: Value(savedPaise),
        monthlyContributionPaise: Value(monthlyContributionPaise),
        isWishlist: Value(isWishlist),
        targetDate: Value(targetDate),
      ),
    );
    await _ref.read(activityLogServiceProvider).log(
          action: ActivityAction.created,
          module: isWishlist ? ActivityModule.wishlist : ActivityModule.goal,
          entityId: id,
          entityLabel: name.trim(),
          newValue: {'targetPaise': targetPaise},
        );
  }

  Future<int?> deactivateGoal(int id) async {
    final dao = await _ref.read(savingsGoalsDaoProvider.future);
    final existing = await dao.getGoalById(id);
    await dao.deactivateGoal(id);
    if (existing == null) return null;
    return _ref.read(activityLogServiceProvider).log(
          action: ActivityAction.deleted,
          module:
              existing.isWishlist ? ActivityModule.wishlist : ActivityModule.goal,
          entityId: id,
          entityLabel: existing.name,
          isUndoable: true,
          oldValue: {'name': existing.name, 'targetPaise': existing.targetPaise},
          severity: ActivitySeverity.warning,
        );
  }

  Future<void> reactivateGoal(int id) async {
    final dao = await _ref.read(savingsGoalsDaoProvider.future);
    final existing = await dao.getGoalById(id);
    await dao.reactivateGoal(id);
    if (existing != null) {
      await _ref.read(activityLogServiceProvider).log(
            action: ActivityAction.restored,
            module:
                existing.isWishlist ? ActivityModule.wishlist : ActivityModule.goal,
            entityId: id,
            entityLabel: existing.name,
          );
    }
  }
}

final activeSavingsGoalsProvider =
    StreamProvider<List<SavingsGoalsTableData>>((ref) {
  return ref.watch(savingsGoalsRepositoryProvider).watchActiveGoals();
});
