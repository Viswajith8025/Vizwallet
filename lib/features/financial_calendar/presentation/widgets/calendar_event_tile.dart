import 'package:flutter/material.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';

class CalendarEventTile extends StatelessWidget {
  const CalendarEventTile({required this.event, super.key});

  final FinancialCalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = event.colorValue != null
        ? Color(event.colorValue!)
        : FinancialEventStyle.color(event.type, scheme);

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        dense: true,
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(
            FinancialEventStyle.icon(event.type),
            size: 18,
            color: color,
          ),
        ),
        title: Text(
          event.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          [
            FinancialEventStyle.label(event.type),
            if (event.subtitle != null) event.subtitle,
          ].join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: event.amountPaise > 0
            ? Text(
                formatPaise(event.amountPaise),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: event.isDebit ? scheme.error : scheme.primary,
                ),
              )
            : null,
      ),
    );
  }
}
