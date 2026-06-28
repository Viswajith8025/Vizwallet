import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';
import 'package:rupee_track/features/financial_calendar/presentation/widgets/calendar_event_tile.dart';

class CalendarDayView extends StatelessWidget {
  const CalendarDayView({
    required this.day,
    required this.events,
    required this.onQuickAdd,
    super.key,
  });

  final DateTime day;
  final List<FinancialCalendarEvent> events;
  final VoidCallback onQuickAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final key = DateTime(day.year, day.month, day.day);
    final dayEvents = events.where((e) {
      final d = DateTime(e.day.year, e.day.month, e.day.day);
      return d == key;
    }).toList();

    final spent = dayEvents
        .where((e) => e.isDebit)
        .fold<int>(0, (s, e) => s + e.amountPaise);
    final received = dayEvents
        .where((e) => e.isCredit)
        .fold<int>(0, (s, e) => s + e.amountPaise);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMEd().format(key),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Spent ${formatPaise(spent)} · Received ${formatPaise(received)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: onQuickAdd,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add'),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (dayEvents.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                'A quiet day — no tracked money movement yet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          ...dayEvents.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: CalendarEventTile(event: e),
              )),
      ],
    );
  }
}
