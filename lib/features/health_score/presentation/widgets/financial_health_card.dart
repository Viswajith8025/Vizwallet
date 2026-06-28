import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/core/widgets/theme_toggle_button.dart';
import 'package:rupee_track/features/health_score/data/financial_health_repository.dart';
import 'package:rupee_track/features/health_score/domain/financial_health_models.dart';

class FinancialHealthCard extends ConsumerWidget {
  const FinancialHealthCard({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final healthAsync = ref.watch(financialHealthProvider(cycleKey));

    return healthAsync.when(
      loading: () => const SkeletonCard(height: 100),
      error: (_, __) => const SizedBox.shrink(),
      data: (report) => compact
          ? _CompactHealthCard(report: report)
          : _FullHealthCard(report: report),
    );
  }
}

class FinancialHealthScreen extends ConsumerWidget {
  const FinancialHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final healthAsync = ref.watch(financialHealthProvider(cycleKey));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial health'),
        actions: const [ThemeToggleButton()],
      ),
      body: healthAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorState(
          message: 'We couldn\'t load your financial health score.',
          onRetry: () => ref.invalidate(financialHealthProvider(cycleKey)),
        ),
        data: (report) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(financialHealthProvider(cycleKey));
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _FullHealthCard(report: report),
              const SizedBox(height: 24),
              Text('Category breakdown', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              ...report.categories.map(
                (c) => _CategoryRow(score: c),
              ),
              if (report.history.length > 1) ...[
                const SizedBox(height: 24),
                Text('Historical scores', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                SizedBox(
                  height: 180,
                  child: _HistoryChart(history: report.history),
                ),
              ],
              const SizedBox(height: 24),
              Text('Suggestions', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ...report.recommendations.map(
                (r) => Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.lightbulb_outline,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(r.message),
                    subtitle: r.potentialGain > 0
                        ? Text('+${r.potentialGain} potential points')
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FullHealthCard extends StatelessWidget {
  const _FullHealthCard({required this.report});

  final FinancialHealthReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _scoreColor(context, report.overallScore);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withValues(alpha: 0.35)),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.14),
              theme.colorScheme.surface,
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                _ScoreRing(score: report.overallScore, color: color),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Financial health',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.motivationLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (report.trendDelta != 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              report.trendDelta > 0
                                  ? Icons.trending_up
                                  : Icons.trending_down,
                              size: 18,
                              color: report.trendDelta > 0
                                  ? BrandColors.success
                                  : theme.colorScheme.error,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${report.trendDelta > 0 ? '+' : ''}${report.trendDelta} vs last cycle',
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (!report.hasEnoughData) ...[
              const SizedBox(height: 12),
              Text(
                report.recommendations.first.message,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompactHealthCard extends StatelessWidget {
  const _CompactHealthCard({required this.report});

  final FinancialHealthReport report;

  @override
  Widget build(BuildContext context) {
    final color = _scoreColor(context, report.overallScore);
    return Card(
      child: ListTile(
        leading: _ScoreRing(score: report.overallScore, color: color, size: 52),
        title: const Text('Financial health'),
        subtitle: Text(report.motivationLabel),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(AppRoutes.financialHealth),
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({
    required this.score,
    required this.color,
    this.size = 88,
  });

  final int score;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: score / 100,
            strokeWidth: size > 60 ? 8 : 6,
            backgroundColor: color.withValues(alpha: 0.15),
            color: color,
          ),
          Text(
            '$score',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.score});

  final CategoryScore score;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _scoreColor(context, score.score);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  score.category.label,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              Text(
                '${score.score}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score.score / 100,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.summary,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryChart extends StatelessWidget {
  const _HistoryChart({required this.history});

  final List<HistoricalScorePoint> history;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final points = history.length > 6 ? history.sublist(history.length - 6) : history;

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(),
          topTitles: AxisTitles(),
          leftTitles: AxisTitles(),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: points
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value.score.toDouble()))
                .toList(),
            isCurved: true,
            color: theme.colorScheme.primary,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

Color _scoreColor(BuildContext context, int score) {
  if (score >= 80) return BrandColors.success;
  if (score >= 60) return BrandColors.warning;
  if (score >= 40) return const Color(0xFFF97316);
  return Theme.of(context).colorScheme.primary;
}
