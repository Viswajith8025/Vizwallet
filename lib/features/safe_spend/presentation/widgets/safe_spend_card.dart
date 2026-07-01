import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/design_system/compact_label.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/design_system/progress_ring.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/features/safe_spend/domain/safe_spend_snapshot.dart';

class SafeSpendCard extends StatelessWidget {
  const SafeSpendCard({
    required this.snapshot,
    super.key,
    this.compact = false,
    this.expanded = false,
  });

  final SafeSpendSnapshot snapshot;
  final bool compact;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskColor = _riskColor(context, snapshot.riskLevel);
    final usage = snapshot.todayUsagePercent.clamp(0, 200) / 100;

    return PremiumCard(
      variant: PremiumCardVariant.tinted,
      tintColor: riskColor,
      accentColor: riskColor,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shield_outlined, color: riskColor, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: SingleLineLabel(
                    'How much can I spend today?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                _RiskChip(level: snapshot.riskLevel, color: riskColor),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Safe to spend today',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatPaise(snapshot.safeDailyLimitPaise),
                        style: (compact
                                ? theme.textTheme.titleLarge
                                : theme.textTheme.headlineMedium)
                            ?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                ProgressRing(
                  progress: usage > 1 ? 1 : usage,
                  size: compact ? 56 : 72,
                  strokeWidth: compact ? 6 : 7,
                  color: riskColor,
                  child: Text(
                    '${snapshot.todayUsagePercent.round()}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? 12 : 16),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Spent today',
                    value: formatPaise(snapshot.todaySpentPaise),
                    highlight: snapshot.isOverTodayGuide,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricTile(
                    label: 'Left for today',
                    value: formatPaise(
                      snapshot.remainingSafeSpendTodayPaise.clamp(
                        0,
                        1 << 30,
                      ),
                    ),
                    subtitle: snapshot.remainingSafeSpendTodayPaise < 0
                        ? '${formatPaise(-snapshot.remainingSafeSpendTodayPaise)} over'
                        : null,
                  ),
                ),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(expanded ? 16 : 14),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.headline,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (snapshot.recommendation != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        snapshot.recommendation!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            if (!compact && snapshot.riskLevel != SafeSpendRiskLevel.noData) ...[
              SizedBox(height: expanded ? 20 : 16),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Text(
                'If you keep this pace',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              _ProjectionRow(
                icon: Icons.trending_flat,
                label: 'Average per day',
                value: formatPaise(
                  snapshot.projection.averageDailySpendPaise,
                ),
              ),
              if (snapshot.projection.moneyLastsUntilIst != null)
                _ProjectionRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Money lasts until',
                  value: _formatDate(snapshot.projection.moneyLastsUntilIst!),
                ),
              _ProjectionRow(
                icon: snapshot.projection.expectsShortage
                    ? Icons.info_outline
                    : Icons.savings_outlined,
                label: snapshot.projection.expectsShortage
                    ? 'Expected gap at cycle end'
                    : 'Expected savings',
                value: formatPaise(
                  snapshot.projection.expectedEndOfCycleBalancePaise.abs(),
                ),
                valueColor: snapshot.projection.expectsShortage
                    ? theme.colorScheme.error
                    : BrandColors.success,
              ),
            ],
          ],
        ),
    );
  }

  static Color _riskColor(BuildContext context, SafeSpendRiskLevel level) =>
      switch (level) {
        SafeSpendRiskLevel.onTrack => BrandColors.success,
        SafeSpendRiskLevel.comfortable => BrandColors.accent,
        SafeSpendRiskLevel.watch => BrandColors.warning,
        SafeSpendRiskLevel.elevated => const Color(0xFFF97316),
        SafeSpendRiskLevel.critical => Theme.of(context).colorScheme.error,
        SafeSpendRiskLevel.noData =>
          Theme.of(context).colorScheme.onSurfaceVariant,
      };

  static String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

class _RiskChip extends StatelessWidget {
  const _RiskChip({required this.level, required this.color});

  final SafeSpendRiskLevel level;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    this.subtitle,
    this.highlight = false,
  });

  final String label;
  final String value;
  final String? subtitle;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittingLabel(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          FittingLabel(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: highlight ? theme.colorScheme.error : null,
            ),
          ),
          if (subtitle != null)
            FittingLabel(
              subtitle!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProjectionRow extends StatelessWidget {
  const _ProjectionRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: SingleLineLabel(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SingleLineLabel(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
