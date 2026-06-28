import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/features/activity_history/domain/activity_history_engine.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';

class ActivityTimelineTile extends StatefulWidget {
  const ActivityTimelineTile({
    required this.entry,
    super.key,
    this.onUndo,
  });

  final ActivityEntry entry;
  final VoidCallback? onUndo;

  @override
  State<ActivityTimelineTile> createState() => _ActivityTimelineTileState();
}

class _ActivityTimelineTileState extends State<ActivityTimelineTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;
    final accent = activitySeverityColor(entry.severity, theme.colorScheme);
    final time = DateFormat('h:mm a').format(entry.occurredAt.toLocal());
    final changes = ActivityHistoryEngine.diffLines(
      oldValueJson: entry.oldValueJson,
      newValueJson: entry.newValueJson,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: PremiumCard(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(
                    activityModuleIcon(entry.module),
                    color: accent,
                    size: 20,
                  ),
                ),
                if (_expanded)
                  Container(
                    width: 2,
                    height: 24,
                    margin: const EdgeInsets.only(top: AppSpacing.xs),
                    color: theme.dividerColor,
                  ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.entityLabel,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${entry.actionLabel} · ${entry.moduleLabel}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (entry.isUndone)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        'Undone',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                    ),
                  if (_expanded) ...[
                    const SizedBox(height: AppSpacing.sm),
                    if (entry.reason != null && entry.reason!.isNotEmpty)
                      Text(
                        'Reason: ${entry.reason}',
                        style: theme.textTheme.bodySmall,
                      ),
                    Text(
                      'By ${entry.performedBy}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    ...changes.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              line.label,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              line.value,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontFamily: 'monospace',
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.onUndo != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      TextButton.icon(
                        onPressed: widget.onUndo,
                        icon: const Icon(Icons.undo_rounded, size: 18),
                        label: const Text('Undo'),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            Icon(
              _expanded
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
