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
