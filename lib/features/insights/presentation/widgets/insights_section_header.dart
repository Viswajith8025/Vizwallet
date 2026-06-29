import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';

/// Section divider for the Insights feed and analytics panels.
class InsightsSectionHeader extends StatelessWidget {
  const InsightsSectionHeader({
    required this.title,
    super.key,
    this.emoji,
    this.icon,
    this.subtitle,
    this.count,
    this.accentColor,
    this.compactTop = false,
  });

  final String title;
  final String? emoji;
  final IconData? icon;
  final String? subtitle;
  final int? count;
  final Color? accentColor;
  final bool compactTop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = accentColor ?? theme.colorScheme.primary;

    return Padding(
      padding: EdgeInsets.only(
        top: compactTop ? AppSpacing.sm : AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: emoji != null
                ? Text(emoji!, style: const TextStyle(fontSize: 18))
                : Icon(icon ?? Icons.insights_outlined, size: 18, color: color),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (count != null && count! > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          '$count',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.35,
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
