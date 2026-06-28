import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/features/insights/domain/insights_feed_models.dart';
import 'package:rupee_track/features/insights/presentation/insight_navigation.dart';

class InsightFeedCard extends StatefulWidget {
  const InsightFeedCard({
    required this.item,
    super.key,
    this.onDismiss,
    this.compact = false,
  });

  final InsightFeedItem item;
  final VoidCallback? onDismiss;
  final bool compact;

  @override
  State<InsightFeedCard> createState() => _InsightFeedCardState();
}

class _InsightFeedCardState extends State<InsightFeedCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = widget.item;
    final accent = _severityColor(item.severity, theme.colorScheme);
    final icon = item.icon ?? iconForInsightCategory(item.category);

    final card = PremiumCard(
      accentColor: accent,
      onTap: widget.compact
          ? (item.actionRoute != null
              ? () => navigateToInsightAction(context, item)
              : null)
          : () => setState(() => _expanded = !_expanded),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: accent, size: 22),
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
                        item.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (item.kind == InsightKind.achievement)
                      Icon(
                        Icons.emoji_events_rounded,
                        size: 18,
                        color: accent,
                      ),
                    if (!widget.compact && widget.onDismiss != null)
                      IconButton(
                        tooltip: 'Hide insight',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        onPressed: widget.onDismiss,
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: widget.compact || !_expanded ? 3 : null,
                  overflow:
                      widget.compact || !_expanded ? TextOverflow.ellipsis : null,
                ),
                if (!widget.compact &&
                    _expanded &&
                    item.metricValue != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${item.metricLabel ?? 'Metric'}: ${item.metricValue}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (!widget.compact &&
                    _expanded &&
                    item.actionRoute != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () => navigateToInsightAction(context, item),
                    child: Text(item.actionLabel ?? 'Learn more'),
                  ),
                ],
              ],
            ),
          ),
          if (!widget.compact)
            Icon(
              _expanded
                  ? Icons.expand_less_rounded
                  : Icons.expand_more_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: card,
    );
  }

  Color _severityColor(InsightSeverity severity, ColorScheme scheme) =>
      switch (severity) {
        InsightSeverity.critical => scheme.error,
        InsightSeverity.warning => const Color(0xFFFF9800),
        InsightSeverity.opportunity => scheme.tertiary,
        InsightSeverity.achievement => const Color(0xFF43A047),
        InsightSeverity.info => scheme.primary,
      };
}

class DailyTipCard extends StatelessWidget {
  const DailyTipCard({required this.tip, super.key});

  final InsightFeedItem tip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: PremiumCard(
        accentColor: theme.colorScheme.tertiary,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_rounded,
              color: theme.colorScheme.tertiary,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    tip.body,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AchievementBanner extends StatelessWidget {
  const AchievementBanner({required this.items, super.key});

  final List<InsightFeedItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 220,
            child: PremiumCard(
              accentColor: const Color(0xFF43A047),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFF43A047),
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          item.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.body,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
