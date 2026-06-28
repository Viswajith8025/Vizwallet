import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/dashboard/data/dashboard_repository.dart';
import 'package:rupee_track/features/dashboard/domain/monthly_summary.dart';
import 'package:rupee_track/features/safe_spend/data/safe_spend_repository.dart';
import 'package:rupee_track/features/safe_spend/domain/safe_spend_snapshot.dart';

class JithuScreen extends ConsumerStatefulWidget {
  const JithuScreen({super.key});

  @override
  ConsumerState<JithuScreen> createState() => _JithuScreenState();
}

class _JithuScreenState extends ConsumerState<JithuScreen> {
  final _controller = TextEditingController();
  final _messages = <_JithuMessage>[
    const _JithuMessage(
      fromUser: false,
      text:
          'Hi, I am Jithu. Ask me how much you can spend today, where your money is going, or how to save more.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ask(String text, CycleSummary summary, SafeSpendSnapshot safeSpend) {
    final question = text.trim();
    if (question.isEmpty) return;

    setState(() {
      _messages
        ..add(_JithuMessage(fromUser: true, text: question))
        ..add(
          _JithuMessage(
            fromUser: false,
            text: _JithuAdvisor.reply(
              question: question,
              summary: summary,
              safeSpend: safeSpend,
            ),
          ),
        );
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final salaryDay = ref.watch(salaryDayProvider);
    final cycleKey = currentCycleKey(salaryDay: salaryDay);
    final summaryAsync = ref.watch(monthlySummaryProvider(cycleKey));
    final safeSpendAsync = ref.watch(safeSpendProvider(cycleKey));

    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Jithu',
        subtitle: 'Simple money help',
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: 'Jithu couldn\'t read your financial summary.',
          onRetry: () {
            ref.invalidate(monthlySummaryProvider(cycleKey));
            ref.invalidate(safeSpendProvider(cycleKey));
          },
        ),
        data: (summary) => safeSpendAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ErrorState(
          message: 'Jithu couldn\'t read today\'s spending limit.',
            onRetry: () => ref.invalidate(safeSpendProvider(cycleKey)),
          ),
          data: (safeSpend) => _JithuBody(
            controller: _controller,
            messages: _messages,
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
    required this.messages,
    required this.summary,
    required this.safeSpend,
    required this.onAsk,
  });

  final TextEditingController controller;
  final List<_JithuMessage> messages;
  final CycleSummary summary;
  final SafeSpendSnapshot safeSpend;
  final ValueChanged<String> onAsk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = _JithuAdvisor.suggestions(summary);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.sm,
              AppSpacing.screenHorizontal,
              AppSpacing.lg,
            ),
            children: [
              _JithuSummaryCard(summary: summary, safeSpend: safeSpend),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: suggestions
                    .map(
                      (s) => ActionChip(
                        label: Text(s),
                        avatar: const Icon(Icons.auto_awesome_rounded, size: 16),
                        onPressed: () => onAsk(s),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: AppSpacing.lg),
              ...messages.map((m) => _MessageBubble(message: m)),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.send,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                    hintText: 'Ask Jithu a money question...',
                    ),
                    onSubmitted: onAsk,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: () => onAsk(controller.text),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(52, 52),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
      accentColor: theme.colorScheme.secondary,
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
                      'Jithu\'s quick read',
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

  final _JithuMessage message;

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

class _JithuMessage {
  const _JithuMessage({
    required this.fromUser,
    required this.text,
  });

  final bool fromUser;
  final String text;
}

abstract final class _JithuAdvisor {
  static List<String> suggestions(CycleSummary summary) {
    if (!summary.salaryEntered) {
      return const [
        'What should I set up first?',
        'How do budgets work?',
        'How can I start tracking?',
      ];
    }

    return const [
      'How am I doing?',
        'How much can I spend today?',
      'Where is my money going?',
      'Give me one saving tip',
    ];
  }

  static String reply({
    required String question,
    required CycleSummary summary,
    required SafeSpendSnapshot safeSpend,
  }) {
    final q = question.toLowerCase();

    if (!summary.salaryEntered) {
      return 'Start by setting your monthly salary. After that I can calculate safe daily spending, savings pace, and category advice for you.';
    }

    if (q.contains('today') ||
        q.contains('spend') ||
        q.contains('safe') ||
        q.contains('can i')) {
      final left = safeSpend.remainingSafeSpendTodayPaise;
      if (left <= 0) {
        return 'For today, you have already used the safe guide. Best move: avoid non-essential spending and shift purchases to tomorrow.';
      }
      return 'You can spend about ${formatPaise(left)} more today and stay within today\'s suggested limit. Current status: ${safeSpend.riskLevel.label}.';
    }

    if (q.contains('where') ||
        q.contains('category') ||
        q.contains('money going') ||
        q.contains('top')) {
      if (summary.categoryBreakdown.isEmpty) {
        return 'No spending pattern yet this month. Add a few expenses and I will show your biggest category.';
      }
      final top = summary.categoryBreakdown.first;
        return 'Your biggest spending area this month is ${top.categoryName} at ${formatPaise(top.totalPaise)}. If you want quick control, try reducing this by 10-15%.';
    }

    if (q.contains('save') ||
        q.contains('saving') ||
        q.contains('advice') ||
        q.contains('tip')) {
      if (summary.savingsPercent < 0) {
        return 'You are over your available money by ${formatPaise(summary.moneyLeftPaise.abs())}. Pause optional spending first, then check your biggest spending area.';
      }
      if (summary.savingsPercent < 10) {
        return 'Your savings cushion is small right now. Try this: keep one day\'s spending limit untouched for the next 3 days.';
      }
      return 'You have a decent cushion. To improve it, save ${formatPaise((summary.safeDailyLimitPaise * 0.2).round())} from your daily limit each day.';
    }

    if (q.contains('how') ||
        q.contains('doing') ||
        q.contains('update') ||
        q.contains('summary')) {
      return 'This month you spent ${formatPaise(summary.spentPaise)} and have ${formatPaise(summary.moneyLeftPaise)} left. Your suggested daily limit is ${formatPaise(summary.safeDailyLimitPaise)} for the remaining ${summary.daysLeftInCycle} day(s).';
    }

    return 'Here is my quick view: money left is ${formatPaise(summary.moneyLeftPaise)}, today\'s remaining limit is ${formatPaise(safeSpend.remainingSafeSpendTodayPaise)}, and your current status is ${safeSpend.riskLevel.label}.';
  }
}
