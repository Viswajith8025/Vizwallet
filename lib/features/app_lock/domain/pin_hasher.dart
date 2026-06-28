import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// PIN hashing with per-device salt in secure storage.
abstract final class PinHasher {
  static const _saltKey = 'app_lock_pin_salt';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static Future<String> hashPin(String pin) async {
    final salt = await _saltOrCreate();
    final digest = sha256.convert(utf8.encode('$salt:$pin'));
    return digest.toString();
  }

  static Future<bool> verifyPin(String pin, String storedHash) async {
    if (storedHash.isEmpty) return false;
    final computed = await hashPin(pin);
    return computed == storedHash;
  }

  static Future<void> clearSalt() async {
    await _storage.delete(key: _saltKey);
  }

  static Future<String> _saltOrCreate() async {
    final existing = await _storage.read(key: _saltKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final salt = base64Url.encode(
      List<int>.generate(32, (i) => (i * 17 + 91) % 256),
    );
    await _storage.write(key: _saltKey, value: salt);
    return salt;
  }
}
