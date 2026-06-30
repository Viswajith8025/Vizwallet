import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/config/groq_config.dart';
import 'package:rupee_track/features/dashboard/domain/monthly_summary.dart';
import 'package:rupee_track/features/jithu/data/groq_jithu_client.dart';
import 'package:rupee_track/features/jithu/domain/jithu_chat_message.dart';
import 'package:rupee_track/features/jithu/domain/jithu_context_builder.dart';
import 'package:rupee_track/features/jithu/domain/jithu_fallback_advisor.dart';
import 'package:rupee_track/features/safe_spend/domain/safe_spend_snapshot.dart';

class JithuRepository {
  JithuRepository(this._groq);

  final GroqJithuClient _groq;

  static const _maxHistoryTurns = 12;

  Future<String> ask({
    required String question,
    required List<JithuChatMessage> history,
    required CycleSummary summary,
    required SafeSpendSnapshot safeSpend,
  }) async {
    if (!GroqConfig.isConfigured) {
      return JithuFallbackAdvisor.reply(
        question: question,
        summary: summary,
        safeSpend: safeSpend,
      );
    }

    try {
      final systemPrompt = JithuContextBuilder.systemPrompt(
        summary: summary,
        safeSpend: safeSpend,
      );

      final apiMessages = _apiMessagesFromHistory(history, question);

      return await _groq.complete(
        systemPrompt: systemPrompt,
        messages: apiMessages,
      );
    } on GroqJithuException catch (e) {
      return '${JithuFallbackAdvisor.reply(question: question, summary: summary, safeSpend: safeSpend)}\n\n(AI is temporarily offline — error ${e.statusCode}.)';
    } catch (_) {
      return JithuFallbackAdvisor.reply(
        question: question,
        summary: summary,
        safeSpend: safeSpend,
      );
    }
  }

  List<({String role, String content})> _apiMessagesFromHistory(
    List<JithuChatMessage> history,
    String latestQuestion,
  ) {
    final prior = history
        .where((m) => m.text.trim().isNotEmpty)
        .map(
          (m) => (
            role: m.fromUser ? 'user' : 'assistant',
            content: m.text.trim(),
          ),
        )
        .toList();

    final trimmed = prior.length > _maxHistoryTurns
        ? prior.sublist(prior.length - _maxHistoryTurns)
        : prior;

    if (trimmed.isNotEmpty &&
        trimmed.last.role == 'user' &&
        trimmed.last.content == latestQuestion.trim()) {
      return trimmed;
    }

    return [
      ...trimmed,
      (role: 'user', content: latestQuestion.trim()),
    ];
  }
}

final jithuRepositoryProvider = Provider<JithuRepository>((ref) {
  return JithuRepository(ref.watch(groqJithuClientProvider));
});
