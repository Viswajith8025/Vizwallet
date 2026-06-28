import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_models.dart';

class SubscriptionCategoryChart extends StatelessWidget {
  const SubscriptionCategoryChart({
    required this.slices,
    super.key,
  });

  final List<CategoryCostSlice> slices;

  @override
  Widget build(BuildContext context) {
    if (slices.isEmpty) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text('No category data yet')),
      );
    }

    final total = slices.fold<int>(0, (sum, s) => sum + s.monthlyPaise);

    return SizedBox(
      height: 180,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 28,
                sections: slices.map((slice) {
                  final pct =
                      total > 0 ? (slice.monthlyPaise / total) * 100 : 0.0;
                  return PieChartSectionData(
                    value: slice.monthlyPaise.toDouble(),
                    color: Color(slice.colorValue),
                    title: pct >= 8 ? '${pct.round()}%' : '',
                    radius: 52,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: slices.take(4).map((slice) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color(slice.colorValue),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          slice.categoryName,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        formatPaise(slice.monthlyPaise),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionCostTrendChart extends StatelessWidget {
  const SubscriptionCostTrendChart({
    required this.points,
    super.key,
  });

  final List<SubscriptionCostTrendPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final maxY = points
            .map((p) => p.totalPaise)
            .reduce((a, b) => a > b ? a : b)
            .toDouble() *
        1.15;

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY,
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  final key = points[index].monthKey;
                  final parts = key.split('-');
                  if (parts.length < 2) return const SizedBox.shrink();
                  return Text(
                    parts[1],
                    style: theme.textTheme.labelSmall,
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i].totalPaise.toDouble()),
              ],
              isCurved: true,
              color: theme.colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
