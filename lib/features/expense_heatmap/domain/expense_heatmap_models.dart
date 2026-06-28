import 'package:flutter/material.dart';

enum HeatmapViewMode {
  monthly,
  quarterly,
  yearly,
  salaryCycle,
  custom,
}

enum HeatmapIntensityLevel {
  none,
  veryLow,
  medium,
  high,
  veryHigh,
}

enum HeatmapFilterKind {
  all,
  income,
  expense,
  subscriptions,
  loans,
  goals,
  wishlist,
}

class HeatmapThresholds {
  const HeatmapThresholds({
    required this.veryLowMaxPaise,
    required this.mediumMaxPaise,
    required this.highMaxPaise,
  });

  final int veryLowMaxPaise;
  final int mediumMaxPaise;
  final int highMaxPaise;

  static HeatmapThresholds fromAverageDaily(int avgDailyPaise) {
    final base = avgDailyPaise > 0 ? avgDailyPaise : 100000;
    return HeatmapThresholds(
      veryLowMaxPaise: (base * 0.35).round(),
      mediumMaxPaise: (base * 0.75).round(),
      highMaxPaise: (base * 1.4).round(),
    );
  }

  HeatmapIntensityLevel levelFor(int spentPaise) {
    if (spentPaise <= 0) return HeatmapIntensityLevel.none;
    if (spentPaise <= veryLowMaxPaise) return HeatmapIntensityLevel.veryLow;
    if (spentPaise <= mediumMaxPaise) return HeatmapIntensityLevel.medium;
    if (spentPaise <= highMaxPaise) return HeatmapIntensityLevel.high;
    return HeatmapIntensityLevel.veryHigh;
  }

  Map<String, dynamic> toJson() => {
        'veryLowMaxPaise': veryLowMaxPaise,
        'mediumMaxPaise': mediumMaxPaise,
        'highMaxPaise': highMaxPaise,
      };

  factory HeatmapThresholds.fromJson(Map<String, dynamic> json) =>
      HeatmapThresholds(
        veryLowMaxPaise: json['veryLowMaxPaise'] as int,
        mediumMaxPaise: json['mediumMaxPaise'] as int,
        highMaxPaise: json['highMaxPaise'] as int,
      );
}

class HeatmapFilters {
  const HeatmapFilters({
    this.kind = HeatmapFilterKind.all,
    this.categoryId,
    this.merchantQuery,
    this.paymentMethod,
    this.tagQuery,
  });

  final HeatmapFilterKind kind;
  final int? categoryId;
  final String? merchantQuery;
  final String? paymentMethod;
  final String? tagQuery;

  bool get hasActiveFilters =>
      kind != HeatmapFilterKind.all ||
      categoryId != null ||
      (merchantQuery?.trim().isNotEmpty ?? false) ||
      (paymentMethod?.trim().isNotEmpty ?? false) ||
      (tagQuery?.trim().isNotEmpty ?? false);

  HeatmapFilters copyWith({
    HeatmapFilterKind? kind,
    int? categoryId,
    bool clearCategoryId = false,
    String? merchantQuery,
    String? paymentMethod,
    String? tagQuery,
  }) {
    return HeatmapFilters(
      kind: kind ?? this.kind,
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      merchantQuery: merchantQuery ?? this.merchantQuery,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tagQuery: tagQuery ?? this.tagQuery,
    );
  }
}

class HeatmapDayCell {
  const HeatmapDayCell({
    required this.date,
    required this.spentPaise,
    required this.incomePaise,
    required this.level,
    required this.inRange,
    required this.weekIndex,
    required this.weekdayIndex,
  });

  final DateTime date;
  final int spentPaise;
  final int incomePaise;
  final HeatmapIntensityLevel level;
  final bool inRange;
  final int weekIndex;
  final int weekdayIndex;
}

class HeatmapWeekColumn {
  const HeatmapWeekColumn({
    required this.weekIndex,
    required this.label,
    required this.totalSpentPaise,
    required this.cells,
  });

  final int weekIndex;
  final String label;
  final int totalSpentPaise;
  final List<HeatmapDayCell?> cells;
}

class HeatmapTransaction {
  const HeatmapTransaction({
    required this.id,
    required this.title,
    required this.amountPaise,
    required this.categoryName,
    this.categoryId,
    required this.paymentMethod,
    required this.occurredAt,
    required this.isIncome,
    required this.tags,
  });

  final int id;
  final String title;
  final int amountPaise;
  final String categoryName;
  final int? categoryId;
  final String paymentMethod;
  final DateTime occurredAt;
  final bool isIncome;
  final List<String> tags;
}

class HeatmapMerchantSlice {
  const HeatmapMerchantSlice({
    required this.name,
    required this.totalPaise,
    required this.count,
  });

  final String name;
  final int totalPaise;
  final int count;
}

class HeatmapDayDetail {
  const HeatmapDayDetail({
    required this.date,
    required this.totalSpentPaise,
    required this.totalIncomePaise,
    required this.safeDailySpendPaise,
    required this.budgetRemainingPaise,
    required this.healthScore,
    required this.healthLabel,
    required this.goalContributionsPaise,
    required this.transactions,
    required this.merchants,
    required this.level,
  });

  final DateTime date;
  final int totalSpentPaise;
  final int totalIncomePaise;
  final int safeDailySpendPaise;
  final int budgetRemainingPaise;
  final int? healthScore;
  final String? healthLabel;
  final int goalContributionsPaise;
  final List<HeatmapTransaction> transactions;
  final List<HeatmapMerchantSlice> merchants;
  final HeatmapIntensityLevel level;
}

class HeatmapStatistics {
  const HeatmapStatistics({
    required this.highestSpendingDay,
    required this.highestSpendingPaise,
    required this.averageDailySpendingPaise,
    required this.noSpendDays,
    required this.mostActiveWeekLabel,
    required this.mostActiveWeekPaise,
    required this.longestNoSpendStreak,
    required this.highestSpendingMonthLabel,
    required this.highestSpendingMonthPaise,
    required this.averageWeekendSpendingPaise,
    required this.averageWeekdaySpendingPaise,
  });

  final DateTime? highestSpendingDay;
  final int highestSpendingPaise;
  final int averageDailySpendingPaise;
  final int noSpendDays;
  final String mostActiveWeekLabel;
  final int mostActiveWeekPaise;
  final int longestNoSpendStreak;
  final String highestSpendingMonthLabel;
  final int highestSpendingMonthPaise;
  final int averageWeekendSpendingPaise;
  final int averageWeekdaySpendingPaise;
}

class HeatmapInsight {
  const HeatmapInsight({
    required this.message,
    required this.icon,
  });

  final String message;
  final IconData icon;
}

class ExpenseHeatmapReport {
  const ExpenseHeatmapReport({
    required this.viewMode,
    required this.rangeLabel,
    required this.rangeStart,
    required this.rangeEnd,
    required this.weeks,
    required this.thresholds,
    required this.statistics,
    required this.insights,
    required this.allTransactions,
    required this.generatedAt,
  });

  final HeatmapViewMode viewMode;
  final String rangeLabel;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final List<HeatmapWeekColumn> weeks;
  final HeatmapThresholds thresholds;
  final HeatmapStatistics statistics;
  final List<HeatmapInsight> insights;
  final List<HeatmapTransaction> allTransactions;
  final DateTime generatedAt;

  HeatmapDayCell? cellForDate(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    for (final week in weeks) {
      for (final cell in week.cells) {
        if (cell == null) continue;
        final c = DateTime(cell.date.year, cell.date.month, cell.date.day);
        if (c == day) return cell;
      }
    }
    return null;
  }
}

class HeatmapColorScheme {
  const HeatmapColorScheme({
    required this.none,
    required this.veryLow,
    required this.medium,
    required this.high,
    required this.veryHigh,
  });

  final Color none;
  final Color veryLow;
  final Color medium;
  final Color high;
  final Color veryHigh;

  Color forLevel(HeatmapIntensityLevel level) => switch (level) {
        HeatmapIntensityLevel.none => none,
        HeatmapIntensityLevel.veryLow => veryLow,
        HeatmapIntensityLevel.medium => medium,
        HeatmapIntensityLevel.high => high,
        HeatmapIntensityLevel.veryHigh => veryHigh,
      };

  static HeatmapColorScheme of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isDark) {
      return const HeatmapColorScheme(
        none: Color(0xFF2D333B),
        veryLow: Color(0xFF0E4429),
        medium: Color(0xFF006D32),
        high: Color(0xFF26A641),
        veryHigh: Color(0xFF39D353),
      );
    }
    return const HeatmapColorScheme(
      none: Color(0xFFEBEDF0),
      veryLow: Color(0xFF9BE9A8),
      medium: Color(0xFF40C463),
      high: Color(0xFF30A14E),
      veryHigh: Color(0xFF216E39),
    );
  }
}
