import 'dart:ui';

import 'package:rupee_track/bootstrap.dart';

/// Persists the user's dragged Quick Add FAB offset from the default corner.
abstract final class FabPositionStore {
  static const _keyX = 'quick_add_fab_offset_x';
  static const _keyY = 'quick_add_fab_offset_y';

  static Offset load() {
    if (!sharedPreferences.containsKey(_keyX)) return Offset.zero;
    return Offset(
      sharedPreferences.getDouble(_keyX) ?? 0,
      sharedPreferences.getDouble(_keyY) ?? 0,
    );
  }

  static Future<void> save(Offset offset) async {
    await sharedPreferences.setDouble(_keyX, offset.dx);
    await sharedPreferences.setDouble(_keyY, offset.dy);
  }
}
