import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/smart_tagging/data/tagging_repository.dart';
import 'package:rupee_track/features/smart_tagging/domain/classification_models.dart';

class ClassificationSuggestionBanner extends ConsumerWidget {
  const ClassificationSuggestionBanner({
    required this.title,
    this.onSave,
    this.canSave = false,
    super.key,
  });

  final String title;
  final VoidCallback? onSave;
  final bool canSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (title.trim().isEmpty) return const SizedBox.shrink();

    final async = ref.watch(transactionClassificationProvider(title.trim()));
    final theme = Theme.of(context);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (classification) {
        if (!classification.hasSuggestion) return const SizedBox.shrink();
        return Card(
          margin: EdgeInsets.zero,
          color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.45),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 18,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _message(classification),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                if (onSave != null && canSave) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: onSave,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _message(TransactionClassification c) {
    final parts = <String>[];
    if (c.suggestedCategoryName != null) {
      parts.add('Will save as ${c.suggestedCategoryName}');
    }
    if (c.tags.isNotEmpty) {
      parts.add('Labels: ${c.tags.join(', ')}');
    }
    if (c.primaryReason != null) {
      parts.add(c.primaryReason!);
    }
    return parts.join(' · ');
  }
}

class SpendingByTagsSection extends ConsumerWidget {
  const SpendingByTagsSection({required this.cycleKey, super.key});

  final String cycleKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(spendingByTagsProvider(cycleKey));
    final theme = Theme.of(context);

    return async.when(
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => Text(
        'Could not load spending tags.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
      ),
      data: (rows) {
        if (rows.isEmpty) {
          return const SizedBox.shrink();
        }

        final total = rows.fold<int>(0, (sum, r) => sum + r.totalPaise);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Spending by labels',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Grouped by labels for this month',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            ...rows.take(8).map((row) {
              final fraction =
                  total > 0 ? row.totalPaise / total : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            row.tag,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          formatPaise(row.totalPaise),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: fraction,
                        minHeight: 6,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${row.transactionCount} transaction${row.transactionCount == 1 ? '' : 's'}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
