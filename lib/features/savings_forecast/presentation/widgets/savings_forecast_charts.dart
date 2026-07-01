import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_models.dart';

class SavingsForecastCurveChart extends StatelessWidget {
  const SavingsForecastCurveChart({
    required this.points,
    super.key,
  });

  final List<ForecastTimelinePoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return const SizedBox(
        height: 160,
        child: Center(child: Text('Add salary & expenses for a forecast')),
      );
    }

    final theme = Theme.of(context);
    final display = points.length > 12
        ? [points.first, ...points.sublist(points.length - 11)]
        : points;
    final balances = display.map((p) => p.balancePaise).toList();
    final minBalance = balances.reduce((a, b) => a < b ? a : b).toDouble();
    final maxBalance = balances.reduce((a, b) => a > b ? a : b).toDouble();
    final minY = minBalance < 0 ? minBalance * 1.1 : 0.0;
    final maxY = maxBalance > 0 ? maxBalance * 1.1 : 1.0;

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY.clamp(minY + 1, double.infinity),
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: const AxisTitles(),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: (display.length / 4).ceilToDouble().clamp(1, 12),
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= display.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    display[i].label,
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
                for (var i = 0; i < display.length; i++)
                  FlSpot(i.toDouble(), display[i].balancePaise.toDouble()),
              ],
              isCurved: true,
              color: theme.colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForecastTrendChart extends StatelessWidget {
  const ForecastTrendChart({
    required this.income,
    required this.expenses,
    super.key,
  });

  final List<ForecastTimelinePoint> income;
  final List<ForecastTimelinePoint> expenses;

  @override
  Widget build(BuildContext context) {
    if (income.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final len = income.length.clamp(0, 12);
    final maxY = [
      ...income.take(len).map((p) => p.incomePaise),
      ...expenses.take(len).map((p) => p.expensePaise),
    ].fold<int>(0, (a, b) => a > b ? a : b).toDouble() * 1.15;

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: maxY.clamp(1, double.infinity),
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(
            topTitles: AxisTitles(),
            rightTitles: AxisTitles(),
            leftTitles: AxisTitles(),
            bottomTitles: AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < len; i++)
                  FlSpot(i.toDouble(), income[i].incomePaise.toDouble()),
              ],
              color: Colors.teal,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
            LineChartBarData(
              spots: [
                for (var i = 0; i < len; i++)
                  FlSpot(i.toDouble(), expenses[i].expensePaise.toDouble()),
              ],
              color: theme.colorScheme.error,
              barWidth: 2,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalProjectionBar extends StatelessWidget {
  const GoalProjectionBar({
    required this.goals,
    super.key,
  });

  final List<GoalCompletionForecast> goals;

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Text(
        'Add a savings goal to see completion projections.',
        style: Theme.of(context).textTheme.bodySmall,
      );
    }

    final theme = Theme.of(context);
    final maxMonths = goals
        .map((g) => g.monthsToComplete)
        .fold<int>(0, (a, b) => a > b ? a : b)
        .clamp(1, 60);

    return Column(
      children: goals.take(4).map((goal) {
        final pct = (goal.monthsToComplete / maxMonths).clamp(0.0, 1.0);
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(goal.name, style: theme.textTheme.titleSmall),
                  Text(
                    goal.monthsToComplete > 0
                        ? '${goal.monthsToComplete} mo'
                        : 'Done',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: 1 - pct,
                minHeight: 6,
                borderRadius: BorderRadius.circular(999),
                color: goal.onTrack
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

String formatForecastAmount(int paise) => formatPaise(paise);
