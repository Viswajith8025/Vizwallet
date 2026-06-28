import 'package:flutter/foundation.dart';

/// Local notification delivery — logs on desktop/web; ready for mobile plugin.
class BudgetNotificationService {
  BudgetNotificationService._();
  static final instance = BudgetNotificationService._();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    if (kDebugMode) {
      debugPrint('BudgetNotificationService: ready (in-app mode)');
    }
  }

  Future<void> show({
    required String title,
    required String body,
    bool silent = false,
  }) async {
    if (silent) {
      if (kDebugMode) {
        debugPrint('[Silent alert] $title — $body');
      }
      return;
    }
    if (kDebugMode) {
      debugPrint('[Push alert] $title — $body');
    }
    // flutter_local_notifications can be wired here for Android/iOS.
  }

  Future<void> showGrouped({
    required String title,
    required String body,
    bool silent = false,
  }) =>
      show(title: title, body: body, silent: silent);
}
