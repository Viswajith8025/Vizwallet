import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_report.dart';
import 'package:rupee_track/features/trends/domain/trends_comparison_mode.dart';

/// Financial analytics — pure logic for spending trends & NL summaries.
abstract final class SpendingTrendsEngine {
  static const _impulseSlugs = {
    'entertainment',
    'shopping',
    'food',
    'miscellaneous',
  };

  static SpendingTrendsReport build({
    required TrendsComparisonMode mode,
    required PeriodSnapshot current,
    PeriodSnapshot? comparison,
    required List<PeriodSnapshot> series,
    required int salaryPaise,
    required int majorThresholdPaise,
    required int activeSubscriptionMonthlyPaise,
  }) {
    final comparisons = _categoryComparisons(current, comparison);
    final highest = comparisons.isEmpty
        ? null
        : comparisons.reduce(
            (a, b) => a.currentPaise >= b.currentPaise ? a : b,
          );
    final fastest = _fastestGrowing(comparisons);
    final weekendWeekday = _weekendWeekdaySplit(current.expenses);
    final heatMap = _weekdayHeatMap(current.expenses);
    final repeated = _repeatedExpenses(current.expenses);
    final impulse = _impulsePurchases(
      current.expenses,
      majorThresholdPaise: majorThresholdPaise,
    );
    final subTrend = _subscriptionTrend(
      current: current,
      comparison: comparison,
      salaryPaise: salaryPaise,
      activeMonthlyPaise: activeSubscriptionMonthlyPaise,
    );

    final summaries = _summaries(
      current: current,
      comparison: comparison,
      highest: highest,
      fastest: fastest,
      weekendWeekday: weekendWeekday,
      impulse: impulse,
      subTrend: subTrend,
      salaryPaise: salaryPaise,
    );

    return SpendingTrendsReport(
      mode: mode,
      current: current,
      comparison: comparison,
      summaries: summaries,
      highestCategory: highest,
      fastestGrowingCategory: fastest,
      timeSeries: series
          .map((s) => TimeSeriesPoint(label: s.label, spentPaise: s.totalSpentPaise))
          .toList(),
      categoryComparisons: comparisons,
      weekendWeekday: weekendWeekday,
      heatMap: heatMap,
      repeatedExpenses: repeated,
      impulsePurchases: impulse,
      subscriptionTrend: subTrend,
      salaryPaise: salaryPaise,
    );
  }

  static List<CategoryTrendPoint> _categoryComparisons(
    PeriodSnapshot current,
    PeriodSnapshot? comparison,
  ) {
    final prevByCategory = <int, int>{};
    if (comparison != null) {
      for (final e in comparison.expenses) {
        prevByCategory[e.categoryId] =
            (prevByCategory[e.categoryId] ?? 0) + e.amountPaise;
      }
    }

    final currentByCategory = <int, ({String name, int color, int total})>{};
    for (final e in current.expenses) {
      final existing = currentByCategory[e.categoryId];
      currentByCategory[e.categoryId] = (
        name: e.categoryName,
        color: e.colorValue,
        total: (existing?.total ?? 0) + e.amountPaise,
      );
    }

    return currentByCategory.entries
        .map(
          (entry) => CategoryTrendPoint(
            categoryId: entry.key,
            categoryName: entry.value.name,
            colorValue: entry.value.color,
            currentPaise: entry.value.total,
            previousPaise: prevByCategory[entry.key] ?? 0,
          ),
        )
        .toList()
      ..sort((a, b) => b.currentPaise.compareTo(a.currentPaise));
  }

  static CategoryTrendPoint? _fastestGrowing(List<CategoryTrendPoint> rows) {
    CategoryTrendPoint? best;
    double? bestRate;
    for (final row in rows) {
      final rate = row.changePercent;
      if (rate == null || rate <= 0) continue;
      if (bestRate == null || rate > bestRate) {
        bestRate = rate;
        best = row;
      }
    }
    return best;
  }

  static WeekendWeekdaySplit _weekendWeekdaySplit(List<TrendExpense> expenses) {
    var weekday = 0;
    var weekend = 0;
    for (final e in expenses) {
      final ist = toIst(e.occurredAtUtc);
      final dow = ist.weekday;
      if (dow == DateTime.saturday || dow == DateTime.sunday) {
        weekend += e.amountPaise;
      } else {
        weekday += e.amountPaise;
      }
    }
    return WeekendWeekdaySplit(weekdayPaise: weekday, weekendPaise: weekend);
  }

  static List<HeatMapCell> _weekdayHeatMap(List<TrendExpense> expenses) {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final totals = List<int>.filled(7, 0);
    for (final e in expenses) {
      final dow = toIst(e.occurredAtUtc).weekday;
      totals[dow - 1] += e.amountPaise;
    }
    final max = totals.reduce((a, b) => a > b ? a : b);
    return List.generate(7, (i) {
      final spent = totals[i];
      return HeatMapCell(
        weekday: i + 1,
        label: labels[i],
        spentPaise: spent,
        intensity: max > 0 ? spent / max : 0,
      );
    });
  }

  static List<RepeatedExpensePattern> _repeatedExpenses(
    List<TrendExpense> expenses,
  ) {
    final groups = <String, List<TrendExpense>>{};
    for (final e in expenses) {
      final key = '${e.categoryId}:${e.title.trim().toLowerCase()}';
      groups.putIfAbsent(key, () => []).add(e);
    }

    return groups.entries
        .where((e) => e.value.length >= 2)
        .map(
          (entry) {
            final list = entry.value;
            return RepeatedExpensePattern(
              title: list.first.title,
              categoryName: list.first.categoryName,
              count: list.length,
              totalPaise: list.fold(0, (s, e) => s + e.amountPaise),
            );
          },
        )
        .toList()
      ..sort((a, b) => b.totalPaise.compareTo(a.totalPaise));
  }

  static ImpulsePurchaseSummary _impulsePurchases(
    List<TrendExpense> expenses, {
    required int majorThresholdPaise,
  }) {
    final impulses = expenses.where((e) {
      if (e.subscriptionId != null) return false;
      final isLarge = e.amountPaise >= majorThresholdPaise ||
          e.autoLabels.isNotEmpty;
      final isDiscretionary = _impulseSlugs.contains(e.categorySlug);
      return isLarge && isDiscretionary;
    }).toList();

    return ImpulsePurchaseSummary(
      count: impulses.length,
      totalPaise: impulses.fold(0, (s, e) => s + e.amountPaise),
      examples: impulses.take(3).map((e) => e.title).toList(),
    );
  }

  static SubscriptionTrendSummary _subscriptionTrend({
    required PeriodSnapshot current,
    required PeriodSnapshot? comparison,
    required int salaryPaise,
    required int activeMonthlyPaise,
  }) {
    int subSpend(List<TrendExpense> list) => list
        .where((e) => e.categorySlug == 'subscriptions')
        .fold(0, (s, e) => s + e.amountPaise);

    final currentSub = subSpend(current.expenses);
    final prevSub =
        comparison != null ? subSpend(comparison.expenses) : 0;
    final share = salaryPaise > 0
        ? (activeMonthlyPaise / salaryPaise) * 100
        : 0.0;

    return SubscriptionTrendSummary(
      currentPaise: currentSub,
      previousPaise: prevSub,
      activeMonthlyPaise: activeMonthlyPaise,
      salarySharePercent: share,
    );
  }

  static List<String> _summaries({
    required PeriodSnapshot current,
    required PeriodSnapshot? comparison,
    required CategoryTrendPoint? highest,
    required CategoryTrendPoint? fastest,
    required WeekendWeekdaySplit weekendWeekday,
    required ImpulsePurchaseSummary impulse,
    required SubscriptionTrendSummary subTrend,
    required int salaryPaise,
  }) {
    final lines = <String>[];

    if (current.expenses.isEmpty) {
      lines.add('No spending recorded for this period yet.');
      return lines;
    }

    if (highest != null) {
      lines.add(
        '${highest.categoryName} is your highest spending category at ${formatPaise(highest.currentPaise)}.',
      );
    }

    if (fastest != null && fastest.changePercent != null) {
      lines.add(
        '${fastest.categoryName} spending increased by ${fastest.changePercent!.round()}%.',
      );
    }

    if (comparison != null) {
      final delta = current.totalSpentPaise - comparison.totalSpentPaise;
      if (delta.abs() >= 10000) {
        if (delta > 0) {
          lines.add(
            'You spent ${formatPaise(delta)} more than ${comparison.label}.',
          );
        } else {
          lines.add(
            'You spent ${formatPaise(-delta)} less than ${comparison.label}.',
          );
        }
      }

      for (final cat in _categoryComparisons(current, comparison)) {
        if (cat.deltaPaise.abs() < 10000) continue;
        if (cat.deltaPaise > 0 && cat.changePercent != null) {
          lines.add(
            '${cat.categoryName} spending increased by ${cat.changePercent!.round()}%.',
          );
        } else if (cat.deltaPaise < 0) {
          lines.add(
            'You spent ${formatPaise(-cat.deltaPaise)} less on ${cat.categoryName.toLowerCase()}.',
          );
        }
      }
    }

    lines.add(
      'Average daily spending is ${formatPaise(current.avgDailyPaise)} '
      '(~${formatPaise(current.avgWeeklyPaise)}/week).',
    );

    if (weekendWeekday.total > 0) {
      lines.add(
        'Weekend spending is ${weekendWeekday.weekendSharePercent.round()}% of your total.',
      );
    }

    if (subTrend.salarySharePercent > 0) {
      lines.add(
        'Subscriptions now consume ${subTrend.salarySharePercent.round()}% of your salary.',
      );
    }

    if (impulse.count > 0) {
      lines.add(
        '${impulse.count} impulse-style purchase${impulse.count == 1 ? '' : 's'} totalling ${formatPaise(impulse.totalPaise)}.',
      );
    }

    return lines.take(8).toList();
  }

  /// Calendar month boundaries in UTC for expense queries.
  static ({DateTime startUtc, DateTime endUtc, int dayCount}) calendarMonthBounds(
    int year,
    int month,
  ) {
    final startUtc =
        DateTime.utc(year, month, 1).subtract(istOffset);
    final nextMonth = month == 12
        ? DateTime.utc(year + 1, 1, 1)
        : DateTime.utc(year, month + 1, 1);
    final endUtc = nextMonth.subtract(istOffset);
    final dayCount = DateTime(year, month + 1, 0).day;
    return (startUtc: startUtc, endUtc: endUtc, dayCount: dayCount);
  }

  static ({DateTime startUtc, DateTime endUtc}) cycleBoundsUtc(
    String cycleKey, {
    required int salaryDay,
  }) {
    final bounds = SalaryCycleEngine.cycleBounds(cycleKey, salaryDay: salaryDay);
    final startUtc = bounds.startIst.subtract(istOffset);
    final endUtc =
        bounds.endIst.add(const Duration(days: 1)).subtract(istOffset);
    return (startUtc: startUtc, endUtc: endUtc);
  }
}
