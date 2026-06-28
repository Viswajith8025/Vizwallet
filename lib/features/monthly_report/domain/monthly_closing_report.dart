import 'package:rupee_track/features/monthly_report/domain/ai_monthly_review.dart';

class MonthlyClosingReport {
  const MonthlyClosingReport({
    required this.cycleKey,
    required this.cycleLabel,
    required this.generatedAt,
    required this.incomePaise,
    required this.expensesPaise,
    required this.savingsPaise,
    required this.savingsRatePercent,
    required this.carryOverPaise,
    required this.averageDailySpendPaise,
    required this.cycleDayCount,
    required this.topCategories,
    required this.largestPurchase,
    required this.majorPurchases,
    required this.subscriptions,
    required this.loans,
    required this.healthScore,
    required this.healthTrendDelta,
    required this.healthMotivation,
    required this.trendSummaries,
    required this.goalsAchieved,
    required this.goalsMissed,
    required this.budgetBuckets,
    required this.budgetOnTrackPercent,
    required this.comparison,
    this.aiReview,
  });

  final String cycleKey;
  final String cycleLabel;
  final DateTime generatedAt;
  final int incomePaise;
  final int expensesPaise;
  final int savingsPaise;
  final double savingsRatePercent;
  final int carryOverPaise;
  final int averageDailySpendPaise;
  final int cycleDayCount;
  final List<CategoryReportLine> topCategories;
  final PurchaseHighlight? largestPurchase;
  final List<PurchaseHighlight> majorPurchases;
  final SubscriptionReportSection subscriptions;
  final LoanReportSection loans;
  final int? healthScore;
  final int healthTrendDelta;
  final String healthMotivation;
  final List<String> trendSummaries;
  final List<GoalLine> goalsAchieved;
  final List<GoalLine> goalsMissed;
  final List<BudgetBucketLine> budgetBuckets;
  final double budgetOnTrackPercent;
  final CycleComparison comparison;
  final AiMonthlyReview? aiReview;

  Map<String, dynamic> toJson() => {
        'cycleKey': cycleKey,
        'cycleLabel': cycleLabel,
        'generatedAt': generatedAt.toIso8601String(),
        'incomePaise': incomePaise,
        'expensesPaise': expensesPaise,
        'savingsPaise': savingsPaise,
        'savingsRatePercent': savingsRatePercent,
        'carryOverPaise': carryOverPaise,
        'averageDailySpendPaise': averageDailySpendPaise,
        'cycleDayCount': cycleDayCount,
        'topCategories': topCategories.map((e) => e.toJson()).toList(),
        'largestPurchase': largestPurchase?.toJson(),
        'majorPurchases': majorPurchases.map((e) => e.toJson()).toList(),
        'subscriptions': subscriptions.toJson(),
        'loans': loans.toJson(),
        'healthScore': healthScore,
        'healthTrendDelta': healthTrendDelta,
        'healthMotivation': healthMotivation,
        'trendSummaries': trendSummaries,
        'goalsAchieved': goalsAchieved.map((e) => e.toJson()).toList(),
        'goalsMissed': goalsMissed.map((e) => e.toJson()).toList(),
        'budgetBuckets': budgetBuckets.map((e) => e.toJson()).toList(),
        'budgetOnTrackPercent': budgetOnTrackPercent,
        'comparison': comparison.toJson(),
        if (aiReview != null) 'aiReview': aiReview!.toJson(),
      };

  factory MonthlyClosingReport.fromJson(Map<String, dynamic> json) {
    return MonthlyClosingReport(
      cycleKey: json['cycleKey'] as String,
      cycleLabel: json['cycleLabel'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      incomePaise: json['incomePaise'] as int,
      expensesPaise: json['expensesPaise'] as int,
      savingsPaise: json['savingsPaise'] as int,
      savingsRatePercent: (json['savingsRatePercent'] as num).toDouble(),
      carryOverPaise: json['carryOverPaise'] as int,
      averageDailySpendPaise: json['averageDailySpendPaise'] as int,
      cycleDayCount: json['cycleDayCount'] as int,
      topCategories: (json['topCategories'] as List)
          .map((e) => CategoryReportLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      largestPurchase: json['largestPurchase'] != null
          ? PurchaseHighlight.fromJson(
              json['largestPurchase'] as Map<String, dynamic>,
            )
          : null,
      majorPurchases: (json['majorPurchases'] as List)
          .map((e) => PurchaseHighlight.fromJson(e as Map<String, dynamic>))
          .toList(),
      subscriptions: SubscriptionReportSection.fromJson(
        json['subscriptions'] as Map<String, dynamic>,
      ),
      loans: LoanReportSection.fromJson(json['loans'] as Map<String, dynamic>),
      healthScore: json['healthScore'] as int?,
      healthTrendDelta: json['healthTrendDelta'] as int,
      healthMotivation: json['healthMotivation'] as String,
      trendSummaries: (json['trendSummaries'] as List).cast<String>(),
      goalsAchieved: (json['goalsAchieved'] as List)
          .map((e) => GoalLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      goalsMissed: (json['goalsMissed'] as List)
          .map((e) => GoalLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      budgetBuckets: (json['budgetBuckets'] as List)
          .map((e) => BudgetBucketLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      budgetOnTrackPercent: (json['budgetOnTrackPercent'] as num).toDouble(),
      comparison: CycleComparison.fromJson(
        json['comparison'] as Map<String, dynamic>,
      ),
      aiReview: json['aiReview'] != null
          ? AiMonthlyReview.fromJson(
              json['aiReview'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class CategoryReportLine {
  const CategoryReportLine({
    required this.name,
    required this.totalPaise,
    required this.sharePercent,
    required this.colorValue,
  });

  final String name;
  final int totalPaise;
  final double sharePercent;
  final int colorValue;

  Map<String, dynamic> toJson() => {
        'name': name,
        'totalPaise': totalPaise,
        'sharePercent': sharePercent,
        'colorValue': colorValue,
      };

  factory CategoryReportLine.fromJson(Map<String, dynamic> json) =>
      CategoryReportLine(
        name: json['name'] as String,
        totalPaise: json['totalPaise'] as int,
        sharePercent: (json['sharePercent'] as num).toDouble(),
        colorValue: json['colorValue'] as int,
      );
}

class PurchaseHighlight {
  const PurchaseHighlight({
    required this.title,
    required this.categoryName,
    required this.amountPaise,
    required this.dateLabel,
  });

  final String title;
  final String categoryName;
  final int amountPaise;
  final String dateLabel;

  Map<String, dynamic> toJson() => {
        'title': title,
        'categoryName': categoryName,
        'amountPaise': amountPaise,
        'dateLabel': dateLabel,
      };

  factory PurchaseHighlight.fromJson(Map<String, dynamic> json) =>
      PurchaseHighlight(
        title: json['title'] as String,
        categoryName: json['categoryName'] as String,
        amountPaise: json['amountPaise'] as int,
        dateLabel: json['dateLabel'] as String,
      );
}

class SubscriptionReportSection {
  const SubscriptionReportSection({
    required this.cycleSpendPaise,
    required this.monthlyRecurringPaise,
    required this.salarySharePercent,
    required this.activeCount,
  });

  final int cycleSpendPaise;
  final int monthlyRecurringPaise;
  final double salarySharePercent;
  final int activeCount;

  Map<String, dynamic> toJson() => {
        'cycleSpendPaise': cycleSpendPaise,
        'monthlyRecurringPaise': monthlyRecurringPaise,
        'salarySharePercent': salarySharePercent,
        'activeCount': activeCount,
      };

  factory SubscriptionReportSection.fromJson(Map<String, dynamic> json) =>
      SubscriptionReportSection(
        cycleSpendPaise: json['cycleSpendPaise'] as int,
        monthlyRecurringPaise: json['monthlyRecurringPaise'] as int,
        salarySharePercent: (json['salarySharePercent'] as num).toDouble(),
        activeCount: json['activeCount'] as int,
      );
}

class LoanReportSection {
  const LoanReportSection({
    required this.pendingBorrowedPaise,
    required this.overdueCount,
    required this.activeLoanCount,
  });

  final int pendingBorrowedPaise;
  final int overdueCount;
  final int activeLoanCount;

  Map<String, dynamic> toJson() => {
        'pendingBorrowedPaise': pendingBorrowedPaise,
        'overdueCount': overdueCount,
        'activeCount': activeLoanCount,
      };

  factory LoanReportSection.fromJson(Map<String, dynamic> json) =>
      LoanReportSection(
        pendingBorrowedPaise: json['pendingBorrowedPaise'] as int,
        overdueCount: json['overdueCount'] as int,
        activeLoanCount: json['activeCount'] as int,
      );
}

class GoalLine {
  const GoalLine({required this.title, required this.detail});

  final String title;
  final String detail;

  Map<String, dynamic> toJson() => {'title': title, 'detail': detail};

  factory GoalLine.fromJson(Map<String, dynamic> json) => GoalLine(
        title: json['title'] as String,
        detail: json['detail'] as String,
      );
}

class BudgetBucketLine {
  const BudgetBucketLine({
    required this.name,
    required this.allocatedPaise,
    required this.spentPaise,
    required this.percentUsed,
    required this.onTrack,
  });

  final String name;
  final int allocatedPaise;
  final int spentPaise;
  final double percentUsed;
  final bool onTrack;

  Map<String, dynamic> toJson() => {
        'name': name,
        'allocatedPaise': allocatedPaise,
        'spentPaise': spentPaise,
        'percentUsed': percentUsed,
        'onTrack': onTrack,
      };

  factory BudgetBucketLine.fromJson(Map<String, dynamic> json) =>
      BudgetBucketLine(
        name: json['name'] as String,
        allocatedPaise: json['allocatedPaise'] as int,
        spentPaise: json['spentPaise'] as int,
        percentUsed: (json['percentUsed'] as num).toDouble(),
        onTrack: json['onTrack'] as bool,
      );
}

class CycleComparison {
  const CycleComparison({
    required this.previousCycleLabel,
    required this.previousIncomePaise,
    required this.previousExpensesPaise,
    required this.previousSavingsPaise,
    required this.expenseChangePercent,
    required this.savingsChangePercent,
    required this.incomeChangePercent,
  });

  final String previousCycleLabel;
  final int previousIncomePaise;
  final int previousExpensesPaise;
  final int previousSavingsPaise;
  final double? expenseChangePercent;
  final double? savingsChangePercent;
  final double? incomeChangePercent;

  Map<String, dynamic> toJson() => {
        'previousCycleLabel': previousCycleLabel,
        'previousIncomePaise': previousIncomePaise,
        'previousExpensesPaise': previousExpensesPaise,
        'previousSavingsPaise': previousSavingsPaise,
        'expenseChangePercent': expenseChangePercent,
        'savingsChangePercent': savingsChangePercent,
        'incomeChangePercent': incomeChangePercent,
      };

  factory CycleComparison.fromJson(Map<String, dynamic> json) =>
      CycleComparison(
        previousCycleLabel: json['previousCycleLabel'] as String,
        previousIncomePaise: json['previousIncomePaise'] as int,
        previousExpensesPaise: json['previousExpensesPaise'] as int,
        previousSavingsPaise: json['previousSavingsPaise'] as int,
        expenseChangePercent: (json['expenseChangePercent'] as num?)?.toDouble(),
        savingsChangePercent:
            (json['savingsChangePercent'] as num?)?.toDouble(),
        incomeChangePercent: (json['incomeChangePercent'] as num?)?.toDouble(),
      );
}
