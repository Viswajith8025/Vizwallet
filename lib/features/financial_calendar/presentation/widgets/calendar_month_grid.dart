import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';
import 'package:rupee_track/features/financial_calendar/presentation/widgets/calendar_indicator_dots.dart';

class CalendarMonthGrid extends StatelessWidget {
  const CalendarMonthGrid({
    required this.cells,
    required this.onDayTap,
    super.key,
  });

  final List<CalendarDayCell> cells;
  final ValueChanged<DateTime> onDayTap;

  static const _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          children: [
            Row(
              children: _weekdays
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.xs),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
                childAspectRatio: 0.82,
              ),
              itemCount: cells.length,
              itemBuilder: (context, index) {
                final cell = cells[index];
                return _DayCell(
                  cell: cell,
                  onTap: () => onDayTap(cell.day),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.cell, required this.onTap});

  final CalendarDayCell cell;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bg = cell.isSelected
        ? scheme.primary.withValues(alpha: 0.16)
        : cell.isToday
            ? scheme.secondaryContainer.withValues(alpha: 0.45)
            : Colors.transparent;
    final border = cell.isSelected
        ? Border.all(color: scheme.primary, width: 1.5)
        : null;

    return AnimatedContainer(
      duration: AppDurations.fast,
      curve: AppCurves.standard,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: border,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${cell.day.day}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cell.isInMonth
                        ? scheme.onSurface
                        : scheme.onSurfaceVariant.withValues(alpha: 0.45),
                  ),
                ),
                if (cell.spentPaise > 0) ...[
                  const SizedBox(height: 2),
                  Text(
                    _compactMoney(cell.spentPaise),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.error,
                      fontWeight: FontWeight.w600,
                      fontSize: 9,
                    ),
                  ),
                ],
                const Spacer(),
                CalendarIndicatorDots(indicators: cell.indicators),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _compactMoney(int paise) {
    final rupees = paise / 100;
    if (rupees >= 1000) return '₹${(rupees / 1000).toStringAsFixed(1)}k';
    return formatPaise(paise).replaceAll('.00', '');
  }
}
