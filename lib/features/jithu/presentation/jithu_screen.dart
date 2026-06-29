import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/dashboard/data/dashboard_repository.dart';
import 'package:rupee_track/features/dashboard/domain/monthly_summary.dart';
import 'package:rupee_track/features/jithu/data/jithu_repository.dart';
import 'package:rupee_track/features/jithu/domain/jithu_branding.dart';
import 'package:rupee_track/features/jithu/domain/jithu_chat_message.dart';
import 'package:rupee_track/features/jithu/domain/jithu_fallback_advisor.dart';
import 'package:rupee_track/features/safe_spend/data/safe_spend_repository.dart';
import 'package:rupee_track/features/safe_spend/domain/safe_spend_snapshot.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/shell_bottom_inset.dart';

class JithuScreen extends ConsumerStatefulWidget {
  const JithuScreen({super.key});

  @override
  ConsumerState<JithuScreen> createState() => _JithuScreenState();
}

class _JithuScreenState extends ConsumerState<JithuScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <JithuChatMessage>[
    const JithuChatMessage(
      fromUser: false,
      text:
          'Ask me how much you can spend today, where your money is going, or how to save more.',
    ),
  ];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _ask(
    String text,
    CycleSummary summary,
    SafeSpendSnapshot safeSpend,
  ) async {
    final question = text.trim();
    if (question.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(JithuChatMessage(fromUser: true, text: question));
      _isLoading = true;
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final reply = await ref.read(jithuRepositoryProvider).ask(
            question: question,
            history: _messages,
            summary: summary,
            safeSpend: safeSpend,
          );

      if (!mounted) return;
      setState(() {
        _messages.add(JithuChatMessage(fromUser: false, text: reply));
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          JithuChatMessage(
            fromUser: false,
            text: JithuFallbackAdvisor.reply(
              question: question,
              summary: summary,
              safeSpend: safeSpend,
            ),
          ),
        );
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final salaryDay = ref.watch(salaryDayProvider);
    final cycleKey = currentCycleKey(salaryDay: salaryDay);
    final summaryAsync = ref.watch(monthlySummaryProvider(cycleKey));
    final safeSpendAsync = ref.watch(safeSpendProvider(cycleKey));

    return Scaffold(
      appBar: const PremiumAppBar(
        title: JithuBranding.displayName,
        subtitle: 'Ask anything about your money',
      ),
      body: summaryAsync.when(
        loading: () => const ResponsiveBody(child: DashboardSkeleton()),
        error: (e, _) => ResponsiveBody(
          child: ErrorState(
            message:
                '${JithuBranding.displayName} couldn\'t read your financial summary.',
            onRetry: () {
              ref.invalidate(monthlySummaryProvider(cycleKey));
              ref.invalidate(safeSpendProvider(cycleKey));
            },
          ),
        ),
        data: (summary) => safeSpendAsync.when(
          loading: () => const ResponsiveBody(child: DashboardSkeleton()),
          error: (e, _) => ResponsiveBody(
            child: ErrorState(
              message:
                  '${JithuBranding.displayName} couldn\'t read today\'s spending limit.',
              onRetry: () => ref.invalidate(safeSpendProvider(cycleKey)),
            ),
          ),
          data: (safeSpend) => _JithuBody(
            controller: _controller,
            scrollController: _scrollController,
            messages: _messages,
            isLoading: _isLoading,
            summary: summary,
            safeSpend: safeSpend,
            onAsk: (text) => _ask(text, summary, safeSpend),
          ),
        ),
      ),
    );
  }
}

class _JithuBody extends StatelessWidget {
  const _JithuBody({
    required this.controller,
    required this.scrollController,
    required this.messages,
    required this.isLoading,
    required this.summary,
    required this.safeSpend,
    required this.onAsk,
  });

  final TextEditingController controller;
  final ScrollController scrollController;
  final List<JithuChatMessage> messages;
  final bool isLoading;
  final CycleSummary summary;
  final SafeSpendSnapshot safeSpend;
  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = JithuFallbackAdvisor.suggestions(summary);

    return ResponsiveBody(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: AppSpacing.md,
              ),
            children: [
              _JithuSummaryCard(summary: summary, safeSpend: safeSpend),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Try asking',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...suggestions.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Tooltip(
                      message: s,
                      child: ActionChip(
                        label: Text(s),
                        avatar:
                            const Icon(Icons.auto_awesome_rounded, size: 16),
                        onPressed: isLoading ? null : () => onAsk(s),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...messages.map((m) => _MessageBubble(message: m)),
              if (isLoading) const _TypingBubble(),
            ],
          ),
        ),
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.sm,
                bottom: ShellBottomInset.of(context) + AppSpacing.xs,
              ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    enabled: !isLoading,
                    textInputAction: TextInputAction.send,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Ask a money question...',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                    ),
                    onSubmitted: isLoading ? null : onAsk,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Semantics(
                  button: true,
                  label: 'Send message',
                  child: SizedBox(
                    height: 48,
                    width: 48,
                    child: FilledButton(
                      onPressed: isLoading ? null : () => onAsk(controller.text),
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: theme.colorScheme.onPrimary,
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              color: theme.colorScheme.onPrimary,
                            ),
                    ),
                  ),
                ),
              ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _JithuSummaryCard extends StatelessWidget {
  const _JithuSummaryCard({
    required this.summary,
    required this.safeSpend,
  });

  final CycleSummary summary;
  final SafeSpendSnapshot safeSpend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topCategory = summary.categoryBreakdown.isEmpty
        ? null
        : summary.categoryBreakdown.first;

    return PremiumCard(
      variant: PremiumCardVariant.tinted,
      tintColor: theme.colorScheme.primary,
      accentColor: theme.colorScheme.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your snapshot',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      summary.salaryEntered
                          ? '${safeSpend.riskLevel.label} today'
                          : 'Add salary to unlock advice',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _MetricLine(
            label: 'Money left',
            value: formatPaise(summary.moneyLeftPaise),
          ),
          _MetricLine(
            label: 'Safe today',
            value: formatPaise(safeSpend.remainingSafeSpendTodayPaise),
          ),
          _MetricLine(
            label: 'Top spend',
            value: topCategory == null
                ? 'No spending yet'
                : '${topCategory.categoryName} · ${formatPaise(topCategory.totalPaise)}',
          ),
        ],
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final JithuChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.fromUser;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.lg),
            topRight: const Radius.circular(AppRadius.lg),
            bottomLeft: Radius.circular(isUser ? AppRadius.lg : AppRadius.xs),
            bottomRight: Radius.circular(isUser ? AppRadius.xs : AppRadius.lg),
          ),
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isUser
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Thinking...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
