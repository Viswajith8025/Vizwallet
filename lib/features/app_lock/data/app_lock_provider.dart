import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/settings_provider.dart';
import 'package:rupee_track/features/app_lock/data/app_lock_service.dart';

final appLockProvider =
    NotifierProvider<AppLockNotifier, AppLockState>(AppLockNotifier.new);

class AppLockState {
  const AppLockState({
    required this.pinEnabled,
    required this.unlocked,
    required this.biometricAvailable,
    required this.biometricEnabled,
  });

  final bool pinEnabled;
  final bool unlocked;
  final bool biometricAvailable;
  final bool biometricEnabled;

  bool get shouldShowLock => pinEnabled && !unlocked;

  AppLockState copyWith({
    bool? pinEnabled,
    bool? unlocked,
    bool? biometricAvailable,
    bool? biometricEnabled,
  }) {
    return AppLockState(
      pinEnabled: pinEnabled ?? this.pinEnabled,
      unlocked: unlocked ?? this.unlocked,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    );
  }
}

class AppLockNotifier extends Notifier<AppLockState> {
  @override
  AppLockState build() {
    ref.listen(appSettingsProvider, (prev, next) {
      final pinOn = next.valueOrNull?.pinEnabled ?? false;
      if (!pinOn) {
        state = state.copyWith(pinEnabled: false, unlocked: true);
      } else if (!state.pinEnabled) {
        state = state.copyWith(pinEnabled: true, unlocked: false);
      }
    });

    _bootstrap();
    return const AppLockState(
      pinEnabled: false,
      unlocked: true,
      biometricAvailable: false,
      biometricEnabled: false,
    );
  }

  Future<void> _bootstrap() async {
    final service = ref.read(appLockServiceProvider);
    final pinOn = await service.isPinEnabled();
    final bioAvail = await service.canCheckBiometrics();
    final bioOn = await service.isBiometricEnabled();
    state = AppLockState(
      pinEnabled: pinOn,
      unlocked: !pinOn,
      biometricAvailable: bioAvail,
      biometricEnabled: bioOn,
    );
  }

  void lock() {
    if (!state.pinEnabled) return;
    state = state.copyWith(unlocked: false);
  }

  void unlock() {
    state = state.copyWith(unlocked: true);
  }

  Future<void> refreshFlags() async {
    final service = ref.read(appLockServiceProvider);
    state = state.copyWith(
      pinEnabled: await service.isPinEnabled(),
      biometricAvailable: await service.canCheckBiometrics(),
      biometricEnabled: await service.isBiometricEnabled(),
    );
  }
}
