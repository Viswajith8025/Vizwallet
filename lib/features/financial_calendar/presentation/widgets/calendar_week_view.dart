import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';
import 'package:rupee_track/features/financial_calendar/presentation/widgets/calendar_event_tile.dart';
import 'package:rupee_track/features/financial_calendar/presentation/widgets/calendar_indicator_dots.dart';

class CalendarWeekView extends StatelessWidget {
  const CalendarWeekView({
    required this.cells,
    required this.selectedDay,
    required this.onDayTap,
    super.key,
  });

  final List<CalendarDayCell> cells;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final selected = DateTime(
      selectedDay.year,
      selectedDay.month,
      selectedDay.day,
    );
    final weekStart = selected.subtract(Duration(days: selected.weekday % 7));
    final weekDays = List.generate(
      7,
      (i) => weekStart.add(Duration(days: i)),
    );

    final weekCells = weekDays.map((d) {
      return cells.firstWhere(
        (c) =>
            c.day.year == d.year &&
            c.day.month == d.month &&
            c.day.day == d.day,
        orElse: () => CalendarDayCell(
          day: d,
          spentPaise: 0,
          receivedPaise: 0,
          events: const [],
          indicators: const {},
        ),
      );
    }).toList();

    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 72,
              child: Row(
                children: weekCells.map((cell) {
                  final isSelected = cell.day == selected;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onDayTap(cell.day),
                      child: AnimatedContainer(
                        duration: AppDurations.fast,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                                  .withValues(alpha: 0.14)
                              : null,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.E().format(cell.day),
                              style: theme.textTheme.labelSmall,
                            ),
                            Text(
                              '${cell.day.day}',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            CalendarIndicatorDots(indicators: cell.indicators),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            Text(
              DateFormat.yMMMEd().format(selected),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Builder(
              builder: (context) {
                final dayCell = weekCells.firstWhere((c) => c.day == selected);
                if (dayCell.events.isEmpty) {
                  return Text(
                    'No financial events this day',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                }
                return Column(
                  children: dayCell.events
                      .take(6)
                      .map((e) => CalendarEventTile(event: e))
                      .toList(),
                );
              },
            ),
            if (weekCells.any((c) => c.spentPaise > 0)) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Week spending: ${formatPaise(weekCells.fold(0, (s, c) => s + c.spentPaise))}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
