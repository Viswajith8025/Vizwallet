import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_snackbar.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/activity_history/data/recycle_bin_repository.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';

class RecycleBinScreen extends ConsumerWidget {
  const RecycleBinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final itemsAsync = ref.watch(recycleBinProvider);

    return Scaffold(
      appBar: PremiumAppBar(
        title: 'Recycle bin',
        subtitle: 'Restore or permanently remove items',
        actions: [
          itemsAsync.maybeWhen(
            data: (items) => items.isEmpty
                ? const SizedBox.shrink()
                : TextButton(
                    onPressed: () => _confirmRestoreAll(context, ref, items),
                    child: const Text('Restore all'),
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: 5,
          itemBuilder: (_, __) => const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: SkeletonCard(height: 64),
          ),
        ),
        error: (e, _) => ErrorState(
          message: 'Could not load recycle bin.',
          onRetry: () => ref.invalidate(recycleBinProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_sweep_outlined,
                      size: 56,
                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Recycle bin is empty',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Deleted expenses, loans, subscriptions, and goals are kept here until you restore or permanently remove them.',
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

          return ResponsiveBody(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Dismissible(
                  key: ValueKey(item.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    color: theme.colorScheme.error,
                    child: const Icon(Icons.delete_forever, color: Colors.white),
                  ),
                  confirmDismiss: (_) =>
                      _confirmPermanentDelete(context, ref, item),
                  child: PremiumMenuTile(
                    icon: activityModuleIcon(item.module),
                    title: item.title,
                    subtitle: _subtitleFor(item),
                    onTap: () => _confirmRestore(context, ref, item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  String _subtitleFor(RecycleBinItem item) {
    final deleted = item.deletedAt != null
        ? DateFormat('d MMM · h:mm a').format(item.deletedAt!.toLocal())
        : 'Recently';
    return '${activityModuleLabel(item.module)} · $deleted\n${item.subtitle}';
  }

  Future<void> _confirmRestore(
    BuildContext context,
    WidgetRef ref,
    RecycleBinItem item,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore item?'),
        content: Text('Restore "${item.title}" to your active records?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _restore(context, ref, item);
    }
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    RecycleBinItem item,
  ) async {
    await ref.read(recycleBinRepositoryProvider).restore(item);
    if (context.mounted) {
      showPremiumSnackBar(
        context,
        message: '${item.title} restored',
      );
    }
  }

  Future<bool> _confirmPermanentDelete(
    BuildContext context,
    WidgetRef ref,
    RecycleBinItem item,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete permanently?'),
        content: Text(
          '"${item.title}" will be removed forever. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete forever'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(recycleBinRepositoryProvider).permanentDelete(item);
      if (context.mounted) {
        showPremiumSnackBar(context, message: 'Permanently deleted');
      }
      return true;
    }
    return false;
  }

  Future<void> _confirmRestoreAll(
    BuildContext context,
    WidgetRef ref,
    List<RecycleBinItem> items,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore all items?'),
        content: Text('Restore ${items.length} items from the recycle bin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Restore all'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(recycleBinRepositoryProvider).restoreAll(items);
      if (context.mounted) {
        showPremiumSnackBar(context, message: 'All items restored');
      }
    }
  }
}
