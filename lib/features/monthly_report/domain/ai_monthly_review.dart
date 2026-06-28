class AiMonthlyReview {
  const AiMonthlyReview({
    required this.headline,
    required this.subheadline,
    required this.netCashFlowPaise,
    required this.insights,
    required this.behaviour,
    required this.achievements,
    required this.recommendations,
    required this.noSpendDays,
    required this.consecutiveBudgetDays,
    required this.expenseLogCount,
    this.wishlistProgressNote,
    this.savingsHighlight,
  });

  final String headline;
  final String subheadline;
  final int netCashFlowPaise;
  final List<String> insights;
  final SpendingBehaviourReview behaviour;
  final List<MonthlyAchievement> achievements;
  final List<MonthlyRecommendation> recommendations;
  final int noSpendDays;
  final int consecutiveBudgetDays;
  final int expenseLogCount;
  final String? wishlistProgressNote;
  final String? savingsHighlight;

  Map<String, dynamic> toJson() => {
        'headline': headline,
        'subheadline': subheadline,
        'netCashFlowPaise': netCashFlowPaise,
        'insights': insights,
        'behaviour': behaviour.toJson(),
        'achievements': achievements.map((e) => e.toJson()).toList(),
        'recommendations':
            recommendations.map((e) => e.toJson()).toList(),
        'noSpendDays': noSpendDays,
        'consecutiveBudgetDays': consecutiveBudgetDays,
        'expenseLogCount': expenseLogCount,
        'wishlistProgressNote': wishlistProgressNote,
        'savingsHighlight': savingsHighlight,
      };

  factory AiMonthlyReview.fromJson(Map<String, dynamic> json) {
    return AiMonthlyReview(
      headline: json['headline'] as String,
      subheadline: json['subheadline'] as String,
      netCashFlowPaise: json['netCashFlowPaise'] as int,
      insights: (json['insights'] as List).cast<String>(),
      behaviour: SpendingBehaviourReview.fromJson(
        json['behaviour'] as Map<String, dynamic>,
      ),
      achievements: (json['achievements'] as List)
          .map((e) => MonthlyAchievement.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List)
          .map(
            (e) => MonthlyRecommendation.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      noSpendDays: json['noSpendDays'] as int,
      consecutiveBudgetDays: json['consecutiveBudgetDays'] as int,
      expenseLogCount: json['expenseLogCount'] as int,
      wishlistProgressNote: json['wishlistProgressNote'] as String?,
      savingsHighlight: json['savingsHighlight'] as String?,
    );
  }
}

class SpendingBehaviourReview {
  const SpendingBehaviourReview({
    required this.impulseCount,
    required this.impulseTotalPaise,
    required this.impulseExamples,
    required this.overspendingCategories,
    required this.bestSavingCategory,
    required this.worstSpendingHabit,
    required this.weekendPaise,
    required this.weekdayPaise,
    required this.recurringExpenses,
    required this.merchantTrend,
  });

  final int impulseCount;
  final int impulseTotalPaise;
  final List<String> impulseExamples;
  final List<String> overspendingCategories;
  final String? bestSavingCategory;
  final String? worstSpendingHabit;
  final int weekendPaise;
  final int weekdayPaise;
  final List<String> recurringExpenses;
  final String? merchantTrend;

  double get weekendSharePercent {
    final total = weekendPaise + weekdayPaise;
    return total > 0 ? (weekendPaise / total) * 100 : 0;
  }

  Map<String, dynamic> toJson() => {
        'impulseCount': impulseCount,
        'impulseTotalPaise': impulseTotalPaise,
        'impulseExamples': impulseExamples,
        'overspendingCategories': overspendingCategories,
        'bestSavingCategory': bestSavingCategory,
        'worstSpendingHabit': worstSpendingHabit,
        'weekendPaise': weekendPaise,
        'weekdayPaise': weekdayPaise,
        'recurringExpenses': recurringExpenses,
        'merchantTrend': merchantTrend,
      };

  factory SpendingBehaviourReview.fromJson(Map<String, dynamic> json) =>
      SpendingBehaviourReview(
        impulseCount: json['impulseCount'] as int,
        impulseTotalPaise: json['impulseTotalPaise'] as int,
        impulseExamples: (json['impulseExamples'] as List).cast<String>(),
        overspendingCategories:
            (json['overspendingCategories'] as List).cast<String>(),
        bestSavingCategory: json['bestSavingCategory'] as String?,
        worstSpendingHabit: json['worstSpendingHabit'] as String?,
        weekendPaise: json['weekendPaise'] as int,
        weekdayPaise: json['weekdayPaise'] as int,
        recurringExpenses:
            (json['recurringExpenses'] as List).cast<String>(),
        merchantTrend: json['merchantTrend'] as String?,
      );
}

enum AchievementKind {
  budgetAchieved,
  goalCompleted,
  savingsMilestone,
  noSpendStreak,
  trackingConsistency,
  healthImprovement,
  subscriptionControl,
}

class MonthlyAchievement {
  const MonthlyAchievement({
    required this.kind,
    required this.title,
    required this.subtitle,
  });

  final AchievementKind kind;
  final String title;
  final String subtitle;

  Map<String, dynamic> toJson() => {
        'kind': kind.name,
        'title': title,
        'subtitle': subtitle,
      };

  factory MonthlyAchievement.fromJson(Map<String, dynamic> json) =>
      MonthlyAchievement(
        kind: AchievementKind.values.byName(json['kind'] as String),
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
      );
}

class MonthlyRecommendation {
  const MonthlyRecommendation({
    required this.title,
    required this.detail,
  });

  final String title;
  final String detail;

  Map<String, dynamic> toJson() => {'title': title, 'detail': detail};

  factory MonthlyRecommendation.fromJson(Map<String, dynamic> json) =>
      MonthlyRecommendation(
        title: json['title'] as String,
        detail: json['detail'] as String,
      );
}

/// Raw cycle stats used when building the AI review.
class CycleBehaviourStats {
  const CycleBehaviourStats({
    required this.noSpendDays,
    required this.consecutiveBudgetDays,
    required this.expenseLogCount,
  });

  final int noSpendDays;
  final int consecutiveBudgetDays;
  final int expenseLogCount;
}
