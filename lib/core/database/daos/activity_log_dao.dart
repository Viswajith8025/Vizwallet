import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';

part 'activity_log_dao.g.dart';

class ActivityLogFilter {
  const ActivityLogFilter({
    this.query,
    this.module,
    this.action,
    this.severity,
    this.startUtc,
    this.endUtc,
    this.limit = 100,
    this.offset = 0,
  });

  final String? query;
  final String? module;
  final String? action;
  final String? severity;
  final DateTime? startUtc;
  final DateTime? endUtc;
  final int limit;
  final int offset;
}

@DriftAccessor(tables: [ActivityLogTable])
class ActivityLogDao extends DatabaseAccessor<AppDatabase>
    with _$ActivityLogDaoMixin {
  ActivityLogDao(super.db);

  Future<int> insertEntry(ActivityLogTableCompanion entry) {
    return into(activityLogTable).insert(entry);
  }

  Stream<List<ActivityLogTableData>> watchTimeline({
    ActivityLogFilter filter = const ActivityLogFilter(),
  }) {
    return _filteredQuery(filter).watch();
  }

  Future<List<ActivityLogTableData>> listActivities({
    ActivityLogFilter filter = const ActivityLogFilter(),
  }) {
    return _filteredQuery(filter).get();
  }

  Future<ActivityLogTableData?> getById(int id) {
    return (select(activityLogTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> markUndone(int id) {
    return (update(activityLogTable)..where((t) => t.id.equals(id))).write(
      const ActivityLogTableCompanion(isUndone: Value(true)),
    );
  }

  Future<int> countActivities({
    ActivityLogFilter filter = const ActivityLogFilter(),
  }) async {
    final count = activityLogTable.id.count();
    final query = selectOnly(activityLogTable)..addColumns([count]);

    if (filter.module != null && filter.module!.isNotEmpty) {
      query.where(activityLogTable.module.equals(filter.module!));
    }
    if (filter.action != null && filter.action!.isNotEmpty) {
      query.where(activityLogTable.action.equals(filter.action!));
    }
    if (filter.severity != null && filter.severity!.isNotEmpty) {
      query.where(activityLogTable.severity.equals(filter.severity!));
    }
    if (filter.startUtc != null) {
      query.where(
        activityLogTable.occurredAt.isBiggerOrEqualValue(filter.startUtc!),
      );
    }
    if (filter.endUtc != null) {
      query.where(
        activityLogTable.occurredAt.isSmallerThanValue(filter.endUtc!),
      );
    }
    if (filter.query != null && filter.query!.trim().isNotEmpty) {
      final pattern = '%${filter.query!.trim().toLowerCase()}%';
      query.where(
        activityLogTable.entityLabel.lower().like(pattern) |
            activityLogTable.module.lower().like(pattern) |
            activityLogTable.action.lower().like(pattern),
      );
    }

    final row = await query.getSingleOrNull();
    return row?.read(count) ?? 0;
  }

  Future<void> purgeBefore(DateTime beforeUtc) {
    return (delete(activityLogTable)
          ..where((t) => t.occurredAt.isSmallerThanValue(beforeUtc)))
        .go();
  }

  Selectable<ActivityLogTableData> _filteredQuery(ActivityLogFilter filter) {
    final query = select(activityLogTable)
      ..orderBy([(t) => OrderingTerm.desc(t.occurredAt)]);

    if (filter.module != null && filter.module!.isNotEmpty) {
      query.where((t) => t.module.equals(filter.module!));
    }
    if (filter.action != null && filter.action!.isNotEmpty) {
      query.where((t) => t.action.equals(filter.action!));
    }
    if (filter.severity != null && filter.severity!.isNotEmpty) {
      query.where((t) => t.severity.equals(filter.severity!));
    }
    if (filter.startUtc != null) {
      query.where((t) => t.occurredAt.isBiggerOrEqualValue(filter.startUtc!));
    }
    if (filter.endUtc != null) {
      query.where((t) => t.occurredAt.isSmallerThanValue(filter.endUtc!));
    }
    if (filter.query != null && filter.query!.trim().isNotEmpty) {
      final pattern = '%${filter.query!.trim().toLowerCase()}%';
      query.where(
        (t) =>
            t.entityLabel.lower().like(pattern) |
            t.module.lower().like(pattern) |
            t.action.lower().like(pattern),
      );
    }

    query.limit(filter.limit, offset: filter.offset);
    return query;
  }
}
