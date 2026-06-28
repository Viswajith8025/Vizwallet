import 'package:flutter/material.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';

class CalendarIndicatorDots extends StatelessWidget {
  const CalendarIndicatorDots({required this.indicators, super.key});

  final Set<CalendarIndicator> indicators;

  @override
  Widget build(BuildContext context) {
    if (indicators.isEmpty) return const SizedBox(height: 6);

    final colors = indicators.take(3).map(_color).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors
          .map(
            (c) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(color: c, shape: BoxShape.circle),
              ),
            ),
          )
          .toList(),
    );
  }

  Color _color(CalendarIndicator indicator) => switch (indicator) {
        CalendarIndicator.salaryDay => Colors.green,
        CalendarIndicator.overBudget => Colors.red,
        CalendarIndicator.noSpend => Colors.teal,
        CalendarIndicator.subscriptionRenewal => Colors.deepPurple,
        CalendarIndicator.goalMilestone => Colors.lightGreen,
        CalendarIndicator.loanDue => Colors.orange,
        CalendarIndicator.billDue => Colors.indigo,
        CalendarIndicator.wishlistPurchase => Colors.pink,
        CalendarIndicator.cycleStart => Colors.blue,
      };
}
