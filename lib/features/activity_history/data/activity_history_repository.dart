import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/daos/activity_log_dao.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/features/activity_history/data/activity_log_service.dart';
import 'package:rupee_track/features/activity_history/domain/activity_history_engine.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';

final activityFiltersProvider = StateProvider<ActivityFilters>(
  (ref) => const ActivityFilters(),
);

final activityTimelineProvider = StreamProvider<List<ActivityTimelineGroup>>(
  (ref) async* {
    final db = await ref.watch(databaseProvider.future);
    final filters = ref.watch(activityFiltersProvider);

    await for (final rows in db.activityLogDao.watchTimeline(
      filter: ActivityLogFilter(
        query: filters.query.isEmpty ? null : filters.query,
        module: filters.module == null
            ? null
            : activityModuleKey(filters.module!),
        action: filters.action == null
            ? null
            : activityActionKey(filters.action!),
        severity: filters.severity == null
            ? null
            : activitySeverityKey(filters.severity!),
        startUtc: DateTime.now().toUtc().subtract(
              Duration(days: filters.daysBack),
            ),
        limit: 200,
      ),
    )) {
      final entries = rows.map(_mapEntry).toList();
      final filtered = ActivityHistoryEngine.applyFilters(entries, filters);
      yield ActivityHistoryEngine.groupByDate(filtered);
    }
  },
);

final activityHistoryRepositoryProvider =
    Provider<ActivityHistoryRepository>((ref) {
  return ActivityHistoryRepository(ref);
});

class ActivityHistoryRepository {
  ActivityHistoryRepository(this._ref);

  final Ref _ref;

  Future<void> undoActivity(int activityId) async {
    await _ref.read(activityLogServiceProvider).undo(activityId);
  }

  Future<void> runRetentionPurge() async {
    await _ref.read(activityLogServiceProvider).purgeExpiredRecycleBin();
  }
}

ActivityEntry _mapEntry(ActivityLogTableData row) {
  return ActivityEntry(
    id: row.id,
    action: activityActionFromKey(row.action) ?? ActivityAction.updated,
    module: activityModuleFromKey(row.module) ?? ActivityModule.expense,
    entityId: row.entityId,
    entityLabel: row.entityLabel,
    oldValueJson: row.oldValueJson,
    newValueJson: row.newValueJson,
    reason: row.reason,
    severity: activitySeverityFromKey(row.severity) ?? ActivitySeverity.info,
    performedBy: row.performedBy,
    isUndoable: row.isUndoable,
    isUndone: row.isUndone,
    occurredAt: row.occurredAt,
  );
}
