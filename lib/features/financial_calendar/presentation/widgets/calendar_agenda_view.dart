import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';
import 'package:rupee_track/features/financial_calendar/presentation/widgets/calendar_event_tile.dart';

class CalendarAgendaView extends StatelessWidget {
  const CalendarAgendaView({
    required this.events,
    required this.onDayTap,
    super.key,
  });

  final List<FinancialCalendarEvent> events;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (events.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Text(
            'No events match your filters this month.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final grouped = <DateTime, List<FinancialCalendarEvent>>{};
    for (final event in events) {
      final key = DateTime(event.day.year, event.day.month, event.day.day);
      grouped.putIfAbsent(key, () => []).add(event);
    }

    final days = grouped.keys.toList()..sort();

    return Card(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: days.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final day = days[index];
          final dayEvents = grouped[day]!;
          return InkWell(
            onTap: () => onDayTap(day),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat.yMMMEd().format(day),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ...dayEvents
                      .take(5)
                      .map((e) => CalendarEventTile(event: e)),
                  if (dayEvents.length > 5)
                    Text(
                      '+${dayEvents.length - 5} more',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
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
