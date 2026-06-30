import 'package:rupee_track/core/config/groq_local.example.dart'
    if (dart.library.io) 'package:rupee_track/core/config/groq_local.dart';

/// Groq API configuration for Jithu (cloud AI assistant).
///
/// Priority: `--dart-define=GROQ_API_KEY` → `groq_local.dart` (copy from example).
abstract final class GroqConfig {
  static const _fromEnv = String.fromEnvironment('GROQ_API_KEY');

  static String get apiKey {
    if (_fromEnv.isNotEmpty) return _fromEnv;
    return GroqLocal.apiKey;
  }

  static bool get isConfigured => apiKey.isNotEmpty;

  static const model = String.fromEnvironment(
    'GROQ_MODEL',
    defaultValue: 'llama-3.3-70b-versatile',
  );

  static const baseUrl = 'https://api.groq.com/openai/v1';
}
