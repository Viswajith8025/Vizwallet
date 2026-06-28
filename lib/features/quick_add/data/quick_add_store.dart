import 'dart:convert';

import 'package:rupee_track/bootstrap.dart';

class QuickAddStore {
  static const _favoritesKey = 'quick_add_favorite_categories';
  static const _merchantFreqKey = 'quick_add_merchant_freq';

  List<int> get favoriteCategoryIds {
    final raw = sharedPreferences.getStringList(_favoritesKey);
    if (raw == null) return [];
    return raw.map(int.parse).toList();
  }

  Future<void> toggleFavorite(int categoryId) async {
    final favs = favoriteCategoryIds.toList();
    if (favs.contains(categoryId)) {
      favs.remove(categoryId);
    } else {
      favs.insert(0, categoryId);
      if (favs.length > 6) favs.removeLast();
    }
    await sharedPreferences.setStringList(
      _favoritesKey,
      favs.map((e) => e.toString()).toList(),
    );
  }

  Future<void> recordMerchant(String title) async {
    if (title.trim().isEmpty) return;
    final key = title.trim().toLowerCase();
    final raw = sharedPreferences.getString(_merchantFreqKey);
    final map = <String, int>{};
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        for (final e in decoded.entries) {
          map[e.key] = e.value as int;
        }
      } catch (_) {}
    }
    map[key] = (map[key] ?? 0) + 1;
    await sharedPreferences.setString(_merchantFreqKey, jsonEncode(map));
  }

  List<String> topMerchants({int limit = 8}) {
    final raw = sharedPreferences.getString(_merchantFreqKey);
    if (raw == null) return [];
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final entries = decoded.entries.toList()
        ..sort((a, b) => (b.value as int).compareTo(a.value as int));
      return entries.take(limit).map((e) => _titleCase(e.key)).toList();
    } catch (_) {
      return [];
    }
  }

  String _titleCase(String key) {
    if (key.isEmpty) return key;
    return key[0].toUpperCase() + key.substring(1);
  }
}
