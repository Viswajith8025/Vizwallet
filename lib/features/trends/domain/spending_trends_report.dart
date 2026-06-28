/// Lightweight expense row for analytics (no Flutter / DB).
import 'trends_comparison_mode.dart';

class TrendExpense {
  const TrendExpense({
    required this.id,
    required this.amountPaise,
    required this.categoryId,
    required this.categoryName,
    required this.categorySlug,
    required this.colorValue,
    required this.title,
    required this.occurredAtUtc,
    required this.autoLabels,
    this.subscriptionId,
  });

  final int id;
  final int amountPaise;
  final int categoryId;
  final String categoryName;
  final String categorySlug;
  final int colorValue;
  final String title;
  final DateTime occurredAtUtc;
  final List<String> autoLabels;
  final int? subscriptionId;
}

class PeriodSnapshot {
  const PeriodSnapshot({
    required this.label,
    required this.totalSpentPaise,
    required this.expenses,
    required this.dayCount,
  });

  final String label;
  final int totalSpentPaise;
  final List<TrendExpense> expenses;
  final int dayCount;

  int get avgDailyPaise =>
      dayCount > 0 ? (totalSpentPaise / dayCount).round() : 0;

  int get avgWeeklyPaise => (avgDailyPaise * 7).round();
}

class CategoryTrendPoint {
  const CategoryTrendPoint({
    required this.categoryId,
    required this.categoryName,
    required this.colorValue,
    required this.currentPaise,
    required this.previousPaise,
  });

  final int categoryId;
  final String categoryName;
  final int colorValue;
  final int currentPaise;
  final int previousPaise;

  int get deltaPaise => currentPaise - previousPaise;

  double? get changePercent =>
      previousPaise > 0 ? (deltaPaise / previousPaise) * 100 : null;
}

class TimeSeriesPoint {
  const TimeSeriesPoint({
    required this.label,
    required this.spentPaise,
  });

  final String label;
  final int spentPaise;
}

class WeekendWeekdaySplit {
  const WeekendWeekdaySplit({
    required this.weekdayPaise,
    required this.weekendPaise,
  });

  final int weekdayPaise;
  final int weekendPaise;

  int get total => weekdayPaise + weekendPaise;

  double get weekendSharePercent =>
      total > 0 ? (weekendPaise / total) * 100 : 0;
}

class HeatMapCell {
  const HeatMapCell({
    required this.weekday,
    required this.label,
    required this.spentPaise,
    required this.intensity,
  });

  final int weekday;
  final String label;
  final int spentPaise;
  final double intensity;
}

class RepeatedExpensePattern {
  const RepeatedExpensePattern({
    required this.title,
    required this.categoryName,
    required this.count,
    required this.totalPaise,
  });

  final String title;
  final String categoryName;
  final int count;
  final int totalPaise;
}

class ImpulsePurchaseSummary {
  const ImpulsePurchaseSummary({
    required this.count,
    required this.totalPaise,
    required this.examples,
  });

  final int count;
  final int totalPaise;
  final List<String> examples;
}

class SubscriptionTrendSummary {
  const SubscriptionTrendSummary({
    required this.currentPaise,
    required this.previousPaise,
    required this.activeMonthlyPaise,
    required this.salarySharePercent,
  });

  final int currentPaise;
  final int previousPaise;
  final int activeMonthlyPaise;
  final double salarySharePercent;

  double? get growthPercent => previousPaise > 0
      ? ((currentPaise - previousPaise) / previousPaise) * 100
      : null;
}

class SpendingTrendsReport {
  const SpendingTrendsReport({
    required this.mode,
    required this.current,
    this.comparison,
    required this.summaries,
    required this.highestCategory,
    this.fastestGrowingCategory,
    required this.timeSeries,
    required this.categoryComparisons,
    required this.weekendWeekday,
    required this.heatMap,
    required this.repeatedExpenses,
    required this.impulsePurchases,
    required this.subscriptionTrend,
    required this.salaryPaise,
  });

  final TrendsComparisonMode mode;
  final PeriodSnapshot current;
  final PeriodSnapshot? comparison;
  final List<String> summaries;
  final CategoryTrendPoint? highestCategory;
  final CategoryTrendPoint? fastestGrowingCategory;
  final List<TimeSeriesPoint> timeSeries;
  final List<CategoryTrendPoint> categoryComparisons;
  final WeekendWeekdaySplit weekendWeekday;
  final List<HeatMapCell> heatMap;
  final List<RepeatedExpensePattern> repeatedExpenses;
  final ImpulsePurchaseSummary impulsePurchases;
  final SubscriptionTrendSummary subscriptionTrend;
  final int salaryPaise;
}
