import 'package:intl/intl.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';

class ActivityHistoryEngine {
  static List<ActivityTimelineGroup> groupByDate(List<ActivityEntry> entries) {
    if (entries.isEmpty) return const [];

    final map = <String, List<ActivityEntry>>{};
    final today = DateTime.now();
    final todayKey = _dateKey(today);
    final yesterdayKey = _dateKey(today.subtract(const Duration(days: 1)));

    for (final entry in entries) {
      final local = entry.occurredAt.toLocal();
      final key = _dateKey(local);
      map.putIfAbsent(key, () => []).add(entry);
    }

    final keys = map.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return keys.map((key) {
      final label = key == todayKey
          ? 'Today'
          : key == yesterdayKey
              ? 'Yesterday'
              : DateFormat('EEE, d MMM yyyy').format(DateTime.parse(key));
      return ActivityTimelineGroup(
        dateLabel: label,
        entries: map[key]!,
      );
    }).toList();
  }

  static List<ActivityEntry> applyFilters(
    List<ActivityEntry> entries,
    ActivityFilters filters,
  ) {
    final cutoff = DateTime.now().toUtc().subtract(
          Duration(days: filters.daysBack),
        );

    return entries.where((entry) {
      if (entry.occurredAt.isBefore(cutoff)) return false;
      if (filters.module != null && entry.module != filters.module) {
        return false;
      }
      if (filters.action != null && entry.action != filters.action) {
        return false;
      }
      if (filters.severity != null && entry.severity != filters.severity) {
        return false;
      }
      if (filters.query.trim().isNotEmpty) {
        final q = filters.query.trim().toLowerCase();
        final haystack =
            '${entry.entityLabel} ${entry.moduleLabel} ${entry.actionLabel}'
                .toLowerCase();
        if (!haystack.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  static List<ActivityChangeLine> diffLines({
    String? oldValueJson,
    String? newValueJson,
  }) {
    final lines = <ActivityChangeLine>[];
    if (oldValueJson != null && oldValueJson.isNotEmpty) {
      lines.add(ActivityChangeLine(label: 'Previous', value: oldValueJson));
    }
    if (newValueJson != null && newValueJson.isNotEmpty) {
      lines.add(ActivityChangeLine(label: 'Current', value: newValueJson));
    }
    return lines;
  }

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

class ActivityChangeLine {
  const ActivityChangeLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}
