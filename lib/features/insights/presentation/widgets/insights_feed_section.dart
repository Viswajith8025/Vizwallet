import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/insights/data/insights_feed_repository.dart';
import 'package:rupee_track/features/insights/presentation/widgets/insight_feed_card.dart';

final dismissedInsightIdsProvider = StateProvider<Set<String>>((ref) => {});

class InsightsFeedSection extends ConsumerWidget {
  const InsightsFeedSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(insightsFeedProvider);
    final dismissed = ref.watch(dismissedInsightIdsProvider);
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
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DailyTipCard(tip: report.dailyTip),
            if (report.achievements.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: Text(
                  'Achievements',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              AchievementBanner(items: report.achievements),
              const SizedBox(height: AppSpacing.md),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'For you',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            if (visible.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'You\'re all caught up. Check back after your next transaction.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ...visible.map(
                (item) => InsightFeedCard(
                  item: item,
                  onDismiss: () {
                    ref.read(dismissedInsightIdsProvider.notifier).state = {
                      ...dismissed,
                      item.id,
                    };
                  },
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
        final top = report.heroItems.take(3).toList();
        if (top.isEmpty) {
          return InsightFeedCard(item: report.dailyTip, compact: true);
        }

        return Column(
          children: [
            InsightFeedCard(item: report.dailyTip, compact: true),
            ...top.map((item) => InsightFeedCard(item: item, compact: true)),
            if (top.length >= 3)
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
