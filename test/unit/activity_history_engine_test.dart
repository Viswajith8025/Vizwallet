import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/activity_history/domain/activity_history_engine.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';

void main() {
  group('ActivityHistoryEngine', () {
    test('groups entries by date with Today label', () {
      final localToday = DateTime.now();
      final occurred = DateTime(
        localToday.year,
        localToday.month,
        localToday.day,
        10,
      );

      final groups = ActivityHistoryEngine.groupByDate([
        ActivityEntry(
          id: 1,
          action: ActivityAction.created,
          module: ActivityModule.expense,
          entityLabel: 'Coffee',
          occurredAt: occurred,
        ),
      ]);
      expect(groups.length, 1);
      expect(groups.first.dateLabel, 'Today');
      expect(groups.first.entries.length, 1);
    });

    test('filters by module and query', () {
      final now = DateTime.now();
      final entries = [
        ActivityEntry(
          id: 1,
          action: ActivityAction.deleted,
          module: ActivityModule.expense,
          entityLabel: 'Swiggy lunch',
          occurredAt: now,
        ),
        ActivityEntry(
          id: 2,
          action: ActivityAction.created,
          module: ActivityModule.subscription,
          entityLabel: 'Netflix',
          occurredAt: now,
        ),
      ];

      final filtered = ActivityHistoryEngine.applyFilters(
        entries,
        const ActivityFilters(query: 'swiggy', module: ActivityModule.expense),
      );

      expect(filtered.length, 1);
      expect(filtered.first.entityLabel, 'Swiggy lunch');
    });

    test('diffLines returns previous and current values', () {
      final lines = ActivityHistoryEngine.diffLines(
        oldValueJson: '{"amount":100}',
        newValueJson: '{"amount":200}',
      );
      expect(lines.length, 2);
      expect(lines.first.label, 'Previous');
      expect(lines.last.label, 'Current');
    });
  });
}
