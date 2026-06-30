import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/premium_snackbar.dart';
import 'package:rupee_track/core/design_system/premium_chip.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/activity_history/data/activity_history_repository.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';
import 'package:rupee_track/features/activity_history/presentation/widgets/activity_timeline_tile.dart';

class ActivityTimelineScreen extends ConsumerStatefulWidget {
  const ActivityTimelineScreen({super.key});

  @override
  ConsumerState<ActivityTimelineScreen> createState() =>
      _ActivityTimelineScreenState();
}

class _ActivityTimelineScreenState extends ConsumerState<ActivityTimelineScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activityHistoryRepositoryProvider).runRetentionPurge();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filters = ref.watch(activityFiltersProvider);
    final timelineAsync = ref.watch(activityTimelineProvider);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Activity history',
        subtitle: 'Every change, undo-ready',
        actions: [
          IconButton(
            tooltip: 'Filter',
            onPressed: () => _showFilters(context),
            icon: Badge(
              isLabelVisible: filters.hasActiveFilters,
              child: const Icon(Icons.filter_list_rounded),
            ),
          ),
        ],
      ),
      body: timelineAsync.when(
        loading: () => ResponsiveBody(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            itemCount: 6,
            itemBuilder: (_, __) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: SkeletonCard(height: 72),
            ),
          ),
        ),
        error: (e, _) => ResponsiveBody(
          child: ErrorState(
            message: 'Could not load activity history.',
            onRetry: () => ref.invalidate(activityTimelineProvider),
          ),
        ),
        data: (groups) {
          if (groups.isEmpty) {
            return _EmptyTimeline(theme: theme);
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(activityTimelineProvider);
            },
            child: ResponsiveBody(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppSpacing.md,
                          bottom: AppSpacing.sm,
                        ),
                        child: Text(
                          group.dateLabel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      ...group.entries.map(
                        (entry) => ActivityTimelineTile(
                          entry: entry,
                          onUndo: entry.canUndo
                              ? () => _undo(entry)
                              : null,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _undo(ActivityEntry entry) async {
    await ref.read(activityHistoryRepositoryProvider).undoActivity(entry.id);
    if (mounted) {
      showPremiumSnackBar(
        context,
        message: 'Undid ${entry.actionLabel.toLowerCase()}',
      );
    }
  }

  void _showFilters(BuildContext context) {
    showPremiumBottomSheet(
      context: context,
      initialSize: 0.55,
      child: const _ActivityFiltersSheet(),
    );
  }
}

class _EmptyTimeline extends StatelessWidget {
  const _EmptyTimeline({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 56,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No activity yet',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Every expense, goal, and setting change will appear here with full audit details.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityFiltersSheet extends ConsumerWidget {
  const _ActivityFiltersSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(activityFiltersProvider);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text('Filter activity', style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Search',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          onChanged: (q) {
            ref.read(activityFiltersProvider.notifier).state =
                filters.copyWith(query: q);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Module', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: ActivityModule.values.map((module) {
            return PremiumFilterChip(
              label: activityModuleLabel(module),
              selected: filters.module == module,
              onSelected: (_) {
                ref.read(activityFiltersProvider.notifier).state =
                    filters.copyWith(
                  module: filters.module == module ? null : module,
                  clearModule: filters.module == module,
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Action', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: ActivityAction.values.take(6).map((action) {
            return PremiumFilterChip(
              label: activityActionLabel(action),
              selected: filters.action == action,
              onSelected: (_) {
                ref.read(activityFiltersProvider.notifier).state =
                    filters.copyWith(
                  action: filters.action == action ? null : action,
                  clearAction: filters.action == action,
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: () {
            ref.read(activityFiltersProvider.notifier).state =
                const ActivityFilters();
            Navigator.pop(context);
          },
          child: const Text('Clear filters'),
        ),
      ],
    );
  }
}
