import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final stored = sharedPreferences.getString('theme_mode') ?? 'system';
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await sharedPreferences.setString('theme_mode', value);
    final dao = await ref.read(settingsDaoProvider.future);
    await dao.updateThemeMode(value);
  }
}

final appSettingsProvider = StreamProvider<AppSettingsTableData>((ref) async* {
  final dao = await ref.watch(settingsDaoProvider.future);
  yield* dao.watchSettings();
});

/// When true, swipe-to-delete on the Expenses list is disabled.
final expenseSwipeDeleteLockedProvider =
    NotifierProvider<ExpenseSwipeDeleteLockedNotifier, bool>(
  ExpenseSwipeDeleteLockedNotifier.new,
);

class ExpenseSwipeDeleteLockedNotifier extends Notifier<bool> {
  static const _key = 'expense_swipe_delete_locked';

  @override
  bool build() {
    return sharedPreferences.getBool(_key) ?? false;
  }

  Future<void> setLocked(bool locked) async {
    state = locked;
    await sharedPreferences.setBool(_key, locked);
  }

  Future<void> toggle() => setLocked(!state);
}
