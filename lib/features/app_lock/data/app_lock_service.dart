import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/features/app_lock/domain/pin_hasher.dart';

final appLockServiceProvider = Provider<AppLockService>((ref) {
  return AppLockService(ref);
});

class AppLockService {
  AppLockService(this._ref);

  final Ref _ref;
  final _localAuth = LocalAuthentication();

  static const _biometricPrefKey = 'app_lock_biometric_enabled';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<bool> isPinEnabled() async {
    final settings = await _ref.read(settingsDaoProvider.future);
    final row = await settings.getSettings();
    return row.pinEnabled && row.pinHash != null && row.pinHash!.isNotEmpty;
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: _biometricPrefKey);
    return value == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _biometricPrefKey,
      value: enabled ? 'true' : 'false',
    );
  }

  Future<bool> canCheckBiometrics() async {
    if (kIsWeb) return false;
    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      return supported && canCheck;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    if (!await canCheckBiometrics()) return false;
    if (!await isBiometricEnabled()) return false;

    try {
      return await _localAuth.authenticate(
        localizedReason: 'Unlock Vizwallet to view your finances',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException {
      return false;
    }
  }

  Future<void> enablePin(String pin) async {
    if (!_isValidPin(pin)) {
      throw ArgumentError('PIN must be 4–6 digits');
    }
    final hash = await PinHasher.hashPin(pin);
    final dao = await _ref.read(settingsDaoProvider.future);
    await dao.updatePin(enabled: true, pinHash: hash);
  }

  Future<void> disablePin(String pin) async {
    final dao = await _ref.read(settingsDaoProvider.future);
    final settings = await dao.getSettings();
    if (settings.pinHash == null) {
      await dao.clearPin();
      await setBiometricEnabled(false);
      return;
    }
    final ok = await PinHasher.verifyPin(pin, settings.pinHash!);
    if (!ok) throw StateError('Incorrect PIN');
    await dao.clearPin();
    await PinHasher.clearSalt();
    await setBiometricEnabled(false);
  }

  Future<bool> verifyPin(String pin) async {
    final dao = await _ref.read(settingsDaoProvider.future);
    final settings = await dao.getSettings();
    if (settings.pinHash == null) return false;
    return PinHasher.verifyPin(pin, settings.pinHash!);
  }

  bool _isValidPin(String pin) {
    final trimmed = pin.trim();
    if (trimmed.length < 4 || trimmed.length > 6) return false;
    return RegExp(r'^\d+$').hasMatch(trimmed);
  }
}
