import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/expense_heatmap/domain/expense_heatmap_models.dart';

class ContributionHeatmapGrid extends StatelessWidget {
  const ContributionHeatmapGrid({
    required this.weeks,
    required this.colors,
    required this.onDayTap,
    required this.onDayLongPress,
    this.cellSize = 14,
    this.cellGap = 3,
    super.key,
  });

  final List<HeatmapWeekColumn> weeks;
  final HeatmapColorScheme colors;
  final void Function(HeatmapDayCell cell) onDayTap;
  final void Function(HeatmapDayCell cell) onDayLongPress;
  final double cellSize;
  final double cellGap;

  static const _weekdayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: cellGap + 18),
            child: Column(
              children: List.generate(7, (i) {
                final showLabel = i.isEven;
                return SizedBox(
                  height: cellSize + cellGap,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        showLabel ? _weekdayLabels[i] : '',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16,
                child: Row(
                  children: weeks.map((week) {
                    return Padding(
                      padding: EdgeInsets.only(right: cellGap),
                      child: SizedBox(
                        width: cellSize,
                        child: Text(
                          week.label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 8,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: weeks.map((week) {
                  return Padding(
                    padding: EdgeInsets.only(right: cellGap),
                    child: Column(
                      children: List.generate(7, (row) {
                        final cell = week.cells[row];
                        if (cell == null) {
                          return SizedBox(
                            width: cellSize,
                            height: cellSize + cellGap,
                          );
                        }
                        return Padding(
                          padding: EdgeInsets.only(bottom: cellGap),
                          child: _HeatmapCell(
                            cell: cell,
                            color: colors.forLevel(
                              cell.inRange
                                  ? cell.level
                                  : HeatmapIntensityLevel.none,
                            ),
                            size: cellSize,
                            onTap: cell.inRange ? () => onDayTap(cell) : null,
                            onLongPress: cell.inRange
                                ? () => onDayLongPress(cell)
                                : null,
                          ),
                        );
                      }),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeatmapCell extends StatefulWidget {
  const _HeatmapCell({
    required this.cell,
    required this.color,
    required this.size,
    this.onTap,
    this.onLongPress,
  });

  final HeatmapDayCell cell;
  final Color color;
  final double size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<_HeatmapCell> createState() => _HeatmapCellState();
}

class _HeatmapCellState extends State<_HeatmapCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.fast,
    );
    _scale = Tween<double>(begin: 1, end: 0.88).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.standard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opacity = widget.cell.inRange ? 1.0 : 0.25;

    return GestureDetector(
      onTapDown: widget.onTap != null ? (_) => _controller.forward() : null,
      onTapUp: widget.onTap != null ? (_) => _controller.reverse() : null,
      onTapCancel: widget.onTap != null ? () => _controller.reverse() : null,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scale,
        child: Tooltip(
          message: widget.cell.inRange
              ? '${widget.cell.date.day}/${widget.cell.date.month}: '
                  '${formatPaise(widget.cell.spentPaise)}'
              : '',
          child: AnimatedContainer(
            duration: AppDurations.fast,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}

class HeatmapLegend extends StatelessWidget {
  const HeatmapLegend({
    required this.thresholds,
    required this.colors,
    super.key,
  });

  final HeatmapThresholds thresholds;
  final HeatmapColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = [
      ('No spend', HeatmapIntensityLevel.none),
      ('Low', HeatmapIntensityLevel.veryLow),
      ('Medium', HeatmapIntensityLevel.medium),
      ('High', HeatmapIntensityLevel.high),
      ('Very high', HeatmapIntensityLevel.veryHigh),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...items.map(
              (item) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: colors.forLevel(item.$2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(item.$1, style: theme.textTheme.labelSmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Thresholds: ≤${formatPaise(thresholds.veryLowMaxPaise)} · '
          '≤${formatPaise(thresholds.mediumMaxPaise)} · '
          '≤${formatPaise(thresholds.highMaxPaise)}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
