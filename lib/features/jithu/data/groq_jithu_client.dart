import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rupee_track/core/config/groq_config.dart';

class GroqJithuException implements Exception {
  GroqJithuException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'Groq API error ($statusCode)';
}

class GroqJithuClient {
  GroqJithuClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String> complete({
    required String systemPrompt,
    required List<({String role, String content})> messages,
  }) async {
    if (!GroqConfig.isConfigured) {
      throw StateError('Groq API key is not configured');
    }

    final payload = {
      'model': GroqConfig.model,
      'messages': [
        {'role': 'system', 'content': systemPrompt},
        ...messages.map(
          (m) => {'role': m.role, 'content': m.content},
        ),
      ],
      'temperature': 0.75,
      'max_completion_tokens': 2048,
      'top_p': 0.9,
    };

    final response = await _client.post(
      Uri.parse('${GroqConfig.baseUrl}/chat/completions'),
      headers: {
        'Authorization': 'Bearer ${GroqConfig.apiKey}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw GroqJithuException(response.statusCode, response.body);
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = decoded['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw StateError('Groq returned no choices');
    }

    final message = choices.first['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw StateError('Groq returned empty content');
    }

    return content.trim();
  }
}

final groqJithuClientProvider = Provider<GroqJithuClient>((ref) {
  return GroqJithuClient();
});
