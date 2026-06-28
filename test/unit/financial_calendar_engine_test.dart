import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_engine.dart';
import 'package:rupee_track/features/financial_calendar/domain/financial_calendar_models.dart';

void main() {
  final sampleEvents = [
    FinancialCalendarEvent(
      id: '1',
      type: FinancialEventType.expense,
      title: 'Swiggy lunch',
      amountPaise: 45000,
      day: DateTime(2026, 6, 10),
      tags: const ['food'],
    ),
    FinancialCalendarEvent(
      id: '2',
      type: FinancialEventType.subscription,
      title: 'Netflix',
      amountPaise: 64900,
      day: DateTime(2026, 6, 10),
    ),
    FinancialCalendarEvent(
      id: '3',
      type: FinancialEventType.salary,
      title: 'Salary received',
      amountPaise: 8500000,
      day: DateTime(2026, 6, 1),
    ),
    FinancialCalendarEvent(
      id: '4',
      type: FinancialEventType.bill,
      title: 'Electricity',
      amountPaise: 220000,
      day: DateTime(2026, 6, 15),
    ),
  ];

  group('FinancialCalendarEngine.applyFilters', () {
    test('filters spending (expenses and bills, not subscriptions)', () {
      final filtered = FinancialCalendarEngine.applyFilters(
        sampleEvents,
        const CalendarFilters(kind: CalendarFilterKind.expense),
      );
      expect(filtered.length, 2);
      expect(
        filtered.map((e) => e.type).toSet(),
        {FinancialEventType.expense, FinancialEventType.bill},
      );
    });

    test('filters by merchant query', () {
      final filtered = FinancialCalendarEngine.applyFilters(
        sampleEvents,
        const CalendarFilters(merchantQuery: 'netflix'),
      );
      expect(filtered.length, 1);
      expect(filtered.first.type, FinancialEventType.subscription);
    });

    test('filters by tag query', () {
      final filtered = FinancialCalendarEngine.applyFilters(
        sampleEvents,
        const CalendarFilters(tagQuery: 'food'),
      );
      expect(filtered.length, 1);
      expect(filtered.first.title, 'Swiggy lunch');
    });

    test('filters by amount range', () {
      final filtered = FinancialCalendarEngine.applyFilters(
        sampleEvents,
        const CalendarFilters(minAmountPaise: 100000),
      );
      expect(filtered.map((e) => e.id).toList(), ['3', '4']);
    });
  });

  group('FinancialCalendarEngine.groupEventsByDay', () {
    test('groups and sorts by amount descending', () {
      final grouped = FinancialCalendarEngine.groupEventsByDay(sampleEvents);
      expect(grouped.length, 3);
      final june10 = grouped[DateTime(2026, 6, 10)]!;
      expect(june10.first.type, FinancialEventType.subscription);
      expect(june10.last.type, FinancialEventType.expense);
    });
  });

  group('FinancialCalendarEngine.indicatorsForDay', () {
    test('marks salary day and subscription renewal', () {
      final day = DateTime(2026, 6, 1);
      final indicators = FinancialCalendarEngine.indicatorsForDay(
        day: day,
        events: sampleEvents.where((e) => e.day == day).toList(),
        salaryDay: 1,
        dailyBudgetPaise: 500000,
      );
      expect(indicators, contains(CalendarIndicator.salaryDay));
      expect(indicators, contains(CalendarIndicator.cycleStart));
    });

    test('marks over-budget day', () {
      final day = DateTime(2026, 6, 15);
      final indicators = FinancialCalendarEngine.indicatorsForDay(
        day: day,
        events: sampleEvents.where((e) => e.day == day).toList(),
        salaryDay: 1,
        dailyBudgetPaise: 100000,
      );
      expect(indicators, contains(CalendarIndicator.overBudget));
      expect(indicators, contains(CalendarIndicator.billDue));
    });
  });
}
