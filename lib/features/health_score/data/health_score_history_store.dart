import 'dart:convert';

import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/features/health_score/domain/financial_health_models.dart';

class HealthScoreHistoryStore {
  static const _key = 'financial_health_history';

  List<HistoricalScorePoint> load() {
    final raw = sharedPreferences.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map(
            (e) => HistoricalScorePoint(
              cycleKey: e['cycleKey'] as String,
              score: e['score'] as int,
              recordedAt: DateTime.parse(e['recordedAt'] as String),
            ),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> record(String cycleKey, int score) async {
    final history = load();
    final idx = history.indexWhere((h) => h.cycleKey == cycleKey);
    final point = HistoricalScorePoint(
      cycleKey: cycleKey,
      score: score,
      recordedAt: DateTime.now(),
    );
    if (idx >= 0) {
      history[idx] = point;
    } else {
      history.add(point);
    }
    history.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final trimmed = history.length > 12 ? history.sublist(history.length - 12) : history;
    await sharedPreferences.setString(
      _key,
      jsonEncode(
        trimmed
            .map(
              (h) => {
                'cycleKey': h.cycleKey,
                'score': h.score,
                'recordedAt': h.recordedAt.toIso8601String(),
              },
            )
            .toList(),
      ),
    );
  }

  int? scoreForCycle(String cycleKey) {
    final match = load().where((h) => h.cycleKey == cycleKey).firstOrNull;
    return match?.score;
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
