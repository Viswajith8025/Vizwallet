/// Strips sensitive fields from exported backup payloads.
abstract final class BackupSanitizer {
  static const _settingsSecretKeys = {
    'pinHash',
    'pin_hash',
    'biometricEnabled',
    'biometric_enabled',
  };

  static Map<String, dynamic> sanitizeSettings(Map<String, dynamic> settings) {
    return Map<String, dynamic>.from(settings)
      ..removeWhere((key, _) => _settingsSecretKeys.contains(key));
  }

  static Map<String, dynamic> sanitizeBackup(Map<String, dynamic> backup) {
    final sanitized = Map<String, dynamic>.from(backup);
    final settings = sanitized['settings'];
    if (settings is Map<String, dynamic>) {
      sanitized['settings'] = sanitizeSettings(settings);
    }
    return sanitized;
  }
}
