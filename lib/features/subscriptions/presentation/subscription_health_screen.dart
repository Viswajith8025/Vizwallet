import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/empty_state.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/subscriptions/data/subscription_health_repository.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_models.dart';
import 'package:rupee_track/features/subscriptions/presentation/add_subscription_sheet.dart';
import 'package:rupee_track/features/subscriptions/presentation/widgets/subscription_health_card.dart';
import 'package:rupee_track/features/subscriptions/presentation/widgets/subscription_health_charts.dart';

class SubscriptionHealthScreen extends ConsumerWidget {
  const SubscriptionHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(subscriptionHealthReportProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Subscription Health',
        subtitle: 'Optimize recurring spend',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddSubscriptionSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: ResponsiveBody(
        child: reportAsync.when(
          loading: () => ListView(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xxl,
            ),
            children: const [
              SkeletonCard(height: 120),
              SizedBox(height: AppSpacing.sm),
              SkeletonCard(height: 200),
            ],
          ),
          error: (_, __) => ErrorState(
            message: 'We couldn\'t load your subscription health dashboard.',
            onRetry: () => ref.invalidate(subscriptionHealthReportProvider),
          ),
          data: (report) {
            if (report.cards.isEmpty) {
              return EmptyStates.subscriptions(
                onAdd: () => showAddSubscriptionSheet(context, ref),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(subscriptionHealthReportProvider);
              },
              child: ListView(
                padding: const EdgeInsets.only(
                  top: AppSpacing.md,
                  bottom: AppSpacing.xxl,
                ),
                children: [
                  _HealthScoreCard(score: report.healthScore),
                  const SizedBox(height: AppSpacing.sm),
                  _OverviewGrid(overview: report.overview, report: report),
                  if (report.alerts.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _SectionTitle('Notifications'),
                    ...report.alerts.map(
                      (a) => _AlertTile(alert: a),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  _SectionTitle('AI insights'),
                  ...report.insights.map((i) => _InsightTile(insight: i)),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionTitle('Renewal timeline'),
                  _RenewalTimeline(entries: report.renewalTimeline),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionTitle('Analytics'),
                  PremiumCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category breakdown',
                            style: theme.textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.sm),
                        SubscriptionCategoryChart(
                          slices: report.categoryBreakdown,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text('Cost trend',
                            style: theme.textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.sm),
                        SubscriptionCostTrendChart(points: report.costTrend),
                      ],
                    ),
                  ),
                  if (report.suggestions.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.lg),
                    _SectionTitle('Smart suggestions'),
                    ...report.suggestions.map(
                      (s) => _SuggestionTile(suggestion: s),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  _SectionTitle('Your subscriptions'),
                  ...report.cards.map(
                    (card) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: SubscriptionHealthCard(
                        card: card,
                        onAction: (action) => _handleAction(
                          context,
                          ref,
                          card.id,
                          action,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    int id,
    String action,
  ) async {
    final repo = ref.read(subscriptionHealthRepositoryProvider);
    switch (action) {
      case 'pause':
        await repo.pauseSubscription(id);
      case 'resume':
        await repo.resumeSubscription(id);
      case 'cancel':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Cancel subscription?'),
            content: const Text(
              'This marks the subscription as cancelled. You can add it again later.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Keep'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Cancel subscription'),
              ),
            ],
          ),
        );
        if (confirm == true) await repo.cancelSubscription(id);
      case 'usage':
        if (context.mounted) {
          await showUsageFrequencySheet(context, ref, id);
        }
    }
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _HealthScoreCard extends StatelessWidget {
  const _HealthScoreCard({required this.score});

  final SubscriptionHealthScore score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (score.score) {
      >= 85 => Colors.green,
      >= 70 => Colors.teal,
      >= 50 => Colors.orange,
      >= 30 => Colors.deepOrange,
      _ => Colors.red,
    };

    return PremiumCard(
      accentColor: color,
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: score.score / 100,
                  strokeWidth: 6,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.15),
                ),
                Center(
                  child: Text(
                    '${score.score}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subscription Health Score',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  score.label,
                  style: theme.textTheme.bodyMedium?.copyWith(color: color),
                ),
                if (score.factors.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    score.factors.first.detail,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({
    required this.overview,
    required this.report,
  });

  final SubscriptionHealthOverview overview;
  final SubscriptionHealthReport report;

  @override
  Widget build(BuildContext context) {
    final largest = report.cards
        .where((c) => c.id == overview.largestSubscriptionId)
        .map((c) => c.name)
        .firstOrNull;
    final longest = report.cards
        .where((c) => c.id == overview.longestRunningSubscriptionId)
        .map((c) => c.name)
        .firstOrNull;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Monthly',
                value: formatPaise(overview.monthlyTotalPaise),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _MetricTile(
                label: 'Yearly',
                value: formatPaise(overview.yearlyTotalPaise),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Active',
                value: '${overview.activeCount}',
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _MetricTile(
                label: 'Paused',
                value: '${overview.pausedCount}',
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _MetricTile(
                label: 'Cancelled',
                value: '${overview.cancelledCount}',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: 'Upcoming renewals',
                value: '${overview.upcomingRenewalCount}',
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: _MetricTile(
                label: 'Avg monthly',
                value: formatPaise(overview.averageMonthlyCostPaise),
              ),
            ),
          ],
        ),
        if (largest != null || longest != null) ...[
          const SizedBox(height: AppSpacing.xs),
          if (largest != null)
            _MetricTile(label: 'Largest', value: largest, fullWidth: true),
          if (longest != null) ...[
            const SizedBox(height: AppSpacing.xs),
            _MetricTile(label: 'Longest running', value: longest, fullWidth: true),
          ],
        ],
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    this.fullWidth = false,
  });

  final String label;
  final String value;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
    return fullWidth ? child : child;
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.insight});

  final SubscriptionInsight insight;

  @override
  Widget build(BuildContext context) {
    final icon = switch (insight.severity) {
      'critical' => Icons.warning_amber_rounded,
      'warning' => Icons.info_outline,
      _ => Icons.auto_awesome_outlined,
    };
    final color = switch (insight.severity) {
      'critical' => Colors.red,
      'warning' => Colors.orange,
      _ => Theme.of(context).colorScheme.primary,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(insight.message),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});

  final SubscriptionNotificationAlert alert;

  @override
  Widget build(BuildContext context) {
    final icon = switch (alert.kind) {
      'renew_tomorrow' => Icons.event_rounded,
      'trial_ending' => Icons.hourglass_bottom_rounded,
      'unused' => Icons.visibility_off_outlined,
      _ => Icons.notifications_outlined,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.tertiary),
        title: Text(alert.title),
        subtitle: Text(alert.message),
      ),
    );
  }
}

class _RenewalTimeline extends StatelessWidget {
  const _RenewalTimeline({required this.entries});

  final List<RenewalTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const PremiumCard(
        child: Text('No upcoming renewals with dates set.'),
      );
    }

    final grouped = <RenewalTimelineBucket, List<RenewalTimelineEntry>>{};
    for (final entry in entries) {
      grouped.putIfAbsent(entry.bucket, () => []).add(entry);
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: RenewalTimelineBucket.values.map((bucket) {
          final items = grouped[bucket];
          if (items == null || items.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _bucketLabel(bucket),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                ...items.map(
                  (e) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(e.name),
                    subtitle: Text(
                      e.renewalAt.toLocal().toString().split(' ').first,
                    ),
                    trailing: Text(formatPaise(e.amountPaise)),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  static String _bucketLabel(RenewalTimelineBucket bucket) =>
      switch (bucket) {
        RenewalTimelineBucket.today => 'Today',
        RenewalTimelineBucket.thisWeek => 'This week',
        RenewalTimelineBucket.nextWeek => 'Next week',
        RenewalTimelineBucket.thisMonth => 'This month',
        RenewalTimelineBucket.upcomingQuarter => 'Upcoming quarter',
      };
}

class _SuggestionTile extends StatelessWidget {
  const _SuggestionTile({required this.suggestion});

  final SubscriptionSuggestion suggestion;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: const Icon(Icons.lightbulb_outline),
        title: Text(suggestion.title),
        subtitle: Text(suggestion.detail),
        trailing: suggestion.annualSavingsPaise != null
            ? Text(
                'Save ${formatPaise(suggestion.annualSavingsPaise!)}/yr',
                style: Theme.of(context).textTheme.labelSmall,
              )
            : null,
      ),
    );
  }
}

