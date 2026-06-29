import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/insights/data/insights_feed_repository.dart';
import 'package:rupee_track/features/insights/domain/insights_feed_models.dart';
import 'package:rupee_track/features/insights/presentation/widgets/insight_feed_card.dart';

final dismissedInsightIdsProvider = StateProvider<Set<String>>((ref) => {});
final pinnedInsightIdsProvider = StateProvider<Set<String>>((ref) => {});

class InsightsFeedSection extends ConsumerWidget {
  const InsightsFeedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(insightsFeedProvider);
    final dismissed = ref.watch(dismissedInsightIdsProvider);
    final pinned = ref.watch(pinnedInsightIdsProvider);
    final theme = Theme.of(context);

    return feedAsync.when(
      loading: () => Column(
        children: List.generate(
          3,
          (_) => const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
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
            .toList()
          ..sort((a, b) {
            final aPin = pinned.contains(a.id);
            final bPin = pinned.contains(b.id);
            if (aPin != bPin) return aPin ? -1 : 1;
            return b.rankScore.compareTo(a.rankScore);
          });

        final topAlert = visible.isNotEmpty ? visible.first : null;
        final rest = topAlert == null ? <InsightFeedItem>[] : visible.skip(1).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Text(
                'Today',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            DailyTipCard(tip: report.dailyTip),
            if (topAlert != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'Most important',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              InsightFeedCard(
                item: topAlert,
                featured: true,
                isPinned: pinned.contains(topAlert.id),
                onPin: () {
                  final next = Set<String>.from(pinned);
                  if (next.contains(topAlert.id)) {
                    next.remove(topAlert.id);
                  } else {
                    next.add(topAlert.id);
                  }
                  ref.read(pinnedInsightIdsProvider.notifier).state = next;
                },
                onDismiss: () {
                  ref.read(dismissedInsightIdsProvider.notifier).state = {
                    ...dismissed,
                    topAlert.id,
                  };
                },
              ),
            ],
            if (report.achievements.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'Wins',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.tertiary,
                  ),
                ),
              ),
              AchievementBanner(items: report.achievements),
            ],
            if (rest.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'For you',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              ...rest.map(
                (item) => InsightFeedCard(
                  item: item,
                  isPinned: pinned.contains(item.id),
                  onPin: () {
                    final next = Set<String>.from(pinned);
                    if (next.contains(item.id)) {
                      next.remove(item.id);
                    } else {
                      next.add(item.id);
                    }
                    ref.read(pinnedInsightIdsProvider.notifier).state = next;
                  },
                  onDismiss: () {
                    ref.read(dismissedInsightIdsProvider.notifier).state = {
                      ...dismissed,
                      item.id,
                    };
                  },
                ),
              ),
            ],
            if (visible.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Text(
                  'You\'re all caught up. New insights appear as you spend and save.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
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
        final top = report.heroItems.take(2).toList();

        return Column(
          children: [
            InsightFeedCard(item: report.dailyTip, compact: true),
            ...top.map((item) => InsightFeedCard(item: item, compact: true)),
            if (top.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: PremiumRowTile(
                  title: 'See all insights',
                  leading: const Icon(Icons.insights_outlined, size: 20),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.go(AppRoutes.insights),
                ),
              ),
          ],
        );
      },
    );
  }
}
