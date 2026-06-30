import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/widgets/empty_state.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/insights/data/insights_feed_repository.dart';
import 'package:rupee_track/features/insights/domain/insights_feed_models.dart';
import 'package:rupee_track/features/insights/presentation/widgets/insight_feed_card.dart';
import 'package:rupee_track/features/insights/presentation/widgets/insights_section_header.dart';

final dismissedInsightIdsProvider = StateProvider<Set<String>>((ref) => {});
final pinnedInsightIdsProvider = StateProvider<Set<String>>((ref) => {});

class InsightsFeedSection extends ConsumerWidget {
  const InsightsFeedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(insightsFeedProvider);
    final dismissed = ref.watch(dismissedInsightIdsProvider);
    final pinned = ref.watch(pinnedInsightIdsProvider);

    return feedAsync.when(
      loading: () => Column(
        children: List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: SkeletonCard(height: 88),
          ),
        ),
      ),
      error: (e, _) => ErrorState(
        message: 'Could not load insights.',
        onRetry: () => ref.invalidate(insightsFeedProvider),
      ),
      data: (report) {
        final visible = report.heroItems
            .where((i) => !dismissed.contains(i.id))
            .where((i) => i.kind != InsightKind.achievement)
            .toList()
          ..sort((a, b) {
            final aPin = pinned.contains(a.id);
            final bPin = pinned.contains(b.id);
            if (aPin != bPin) return aPin ? -1 : 1;
            return b.rankScore.compareTo(a.rankScore);
          });

        final priority = visible
            .where(
              (i) =>
                  i.severity == InsightSeverity.critical ||
                  i.severity == InsightSeverity.warning,
            )
            .take(3)
            .toList();
        final priorityIds = priority.map((i) => i.id).toSet();
        final regular =
            visible.where((i) => !priorityIds.contains(i.id)).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const InsightsSectionHeader(
              emoji: '💡',
              title: 'Daily insight',
              subtitle: 'One quick read to start your day',
              compactTop: true,
            ),
            DailyTipCard(tip: report.dailyTip),
            if (priority.isNotEmpty) ...[
              InsightsSectionHeader(
                emoji: '⚠️',
                title: 'Needs attention',
                subtitle: 'Alerts worth acting on now',
                count: priority.length,
                accentColor: Theme.of(context).colorScheme.error,
              ),
              ...priority.map(
                (item) => InsightFeedCard(
                  item: item,
                  featured: true,
                  isPinned: pinned.contains(item.id),
                  onPin: () => _togglePin(ref, pinned, item.id),
                  onDismiss: () => _dismiss(ref, dismissed, item.id),
                ),
              ),
            ],
            if (report.achievements.isNotEmpty) ...[
              InsightsSectionHeader(
                emoji: '🏆',
                title: 'Your wins',
                subtitle: 'Progress you have already made',
                count: report.achievements.length,
                accentColor: const Color(0xFF10B981),
              ),
              AchievementBanner(items: report.achievements),
            ],
            if (regular.isNotEmpty)
              _CollapsibleInsightList(
                items: regular,
                pinned: pinned,
                onPin: (id) => _togglePin(ref, pinned, id),
                onDismiss: (id) => _dismiss(ref, dismissed, id),
              ),
            if (priority.isEmpty &&
                regular.isEmpty &&
                report.achievements.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: EmptyState(
                  icon: Icons.auto_awesome_rounded,
                  title: 'You\'re all caught up',
                  message:
                      'New insights appear as you spend, save, and reach goals. Check back tomorrow.',
                  accentColor: Theme.of(context).colorScheme.tertiary,
                ),
              ),
          ],
        );
      },
    );
  }

  void _togglePin(WidgetRef ref, Set<String> pinned, String id) {
    final next = Set<String>.from(pinned);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    ref.read(pinnedInsightIdsProvider.notifier).state = next;
  }

  void _dismiss(WidgetRef ref, Set<String> dismissed, String id) {
    ref.read(dismissedInsightIdsProvider.notifier).state = {
      ...dismissed,
      id,
    };
  }
}

class _CollapsibleInsightList extends StatefulWidget {
  const _CollapsibleInsightList({
    required this.items,
    required this.pinned,
    required this.onPin,
    required this.onDismiss,
  });

  final List<InsightFeedItem> items;
  final Set<String> pinned;
  final ValueChanged<String> onPin;
  final ValueChanged<String> onDismiss;

  @override
  State<_CollapsibleInsightList> createState() =>
      _CollapsibleInsightListState();
}

class _CollapsibleInsightListState extends State<_CollapsibleInsightList> {
  static const _previewCount = 3;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasMore = widget.items.length > _previewCount;
    final visible = _expanded || !hasMore
        ? widget.items
        : widget.items.take(_previewCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InsightsSectionHeader(
          emoji: '✨',
          title: 'More insights',
          subtitle: 'Trends, tips, and opportunities',
          count: widget.items.length,
        ),
        ...visible.map(
          (item) => InsightFeedCard(
            item: item,
            isPinned: widget.pinned.contains(item.id),
            onPin: () => widget.onPin(item.id),
            onDismiss: () => widget.onDismiss(item.id),
          ),
        ),
        if (hasMore)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: TextButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(
                _expanded
                    ? Icons.expand_less_rounded
                    : Icons.expand_more_rounded,
              ),
              label: Text(
                _expanded
                    ? 'Show less'
                    : 'Show ${widget.items.length - _previewCount} more',
              ),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class InsightsFeedCompactSection extends ConsumerWidget {
  const InsightsFeedCompactSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(insightsFeedProvider);

    return feedAsync.when(
      loading: () => const SkeletonCard(height: 120),
      error: (e, _) => ErrorState(
        message: 'Could not load insights.',
        onRetry: () => ref.invalidate(insightsFeedProvider),
      ),
      data: (report) {
        final top = report.heroItems
            .where((i) => i.kind != InsightKind.achievement)
            .take(2)
            .toList();

        return Column(
          children: [
            InsightFeedCard(item: report.dailyTip, compact: true),
            ...top.map((item) => InsightFeedCard(item: item, compact: true)),
            if (top.isNotEmpty)
              PremiumRowTile(
                title: 'See all insights',
                leading: const Icon(Icons.insights_outlined, size: 20),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.go(AppRoutes.insights),
              ),
          ],
        );
      },
    );
  }
}
