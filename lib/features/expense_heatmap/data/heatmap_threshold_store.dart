import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_models.dart';

const _thresholdsKey = 'expense_heatmap_thresholds';

final heatmapThresholdStoreProvider = Provider<HeatmapThresholdStore>((ref) {
  return HeatmapThresholdStore();
});

class HeatmapThresholdStore {
  HeatmapThresholds? loadSaved() {
    final raw = sharedPreferences.getString(_thresholdsKey);
    if (raw == null) return null;
    try {
      return HeatmapThresholds.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> save(HeatmapThresholds thresholds) async {
    await sharedPreferences.setString(
      _thresholdsKey,
      jsonEncode(thresholds.toJson()),
    );
  }

  Future<void> clear() async {
    await sharedPreferences.remove(_thresholdsKey);
  }
}

final heatmapThresholdsProvider =
    NotifierProvider<HeatmapThresholdsNotifier, HeatmapThresholds?>(
  HeatmapThresholdsNotifier.new,
);

class HeatmapThresholdsNotifier extends Notifier<HeatmapThresholds?> {
  @override
  HeatmapThresholds? build() {
    return ref.read(heatmapThresholdStoreProvider).loadSaved();
  }

  void setThresholds(HeatmapThresholds thresholds) {
    state = thresholds;
    ref.read(heatmapThresholdStoreProvider).save(thresholds);
  }

  void reset() {
    state = null;
    ref.read(heatmapThresholdStoreProvider).clear();
  }
}
