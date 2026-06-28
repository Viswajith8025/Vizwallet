import 'package:flutter/material.dart';

enum SubscriptionStatus { active, paused, cancelled }

enum SubscriptionUsageFrequency {
  daily,
  weekly,
  monthly,
  rarely,
  never,
  unknown,
}

enum SubscriptionCardHealth {
  excellent,
  healthy,
  watch,
  atRisk,
  unused,
}

enum RenewalTimelineBucket {
  today,
  thisWeek,
  nextWeek,
  thisMonth,
  upcomingQuarter,
}

enum SubscriptionSuggestionAction {
  pause,
  cancel,
  switchToAnnual,
  switchToMonthly,
  combineServices,
  shareFamilyPlan,
  reviewUsage,
}

class SubscriptionHealthOverview {
  const SubscriptionHealthOverview({
    required this.activeCount,
    required this.pausedCount,
    required this.cancelledCount,
    required this.upcomingRenewalCount,
    required this.monthlyTotalPaise,
    required this.yearlyTotalPaise,
    required this.averageMonthlyCostPaise,
    this.largestSubscriptionId,
    this.longestRunningSubscriptionId,
  });

  final int activeCount;
  final int pausedCount;
  final int cancelledCount;
  final int upcomingRenewalCount;
  final int monthlyTotalPaise;
  final int yearlyTotalPaise;
  final int averageMonthlyCostPaise;
  final int? largestSubscriptionId;
  final int? longestRunningSubscriptionId;
}

class SubscriptionHealthScore {
  const SubscriptionHealthScore({
    required this.score,
    required this.label,
    required this.factors,
  });

  final int score;
  final String label;
  final List<SubscriptionHealthFactor> factors;
}

class SubscriptionHealthFactor {
  const SubscriptionHealthFactor({
    required this.name,
    required this.impact,
    required this.detail,
  });

  final String name;
  final int impact;
  final String detail;
}

class SubscriptionCardViewModel {
  const SubscriptionCardViewModel({
    required this.id,
    required this.name,
    required this.logoIcon,
    required this.logoColor,
    required this.amountPaise,
    required this.billingCycle,
    this.nextRenewalAt,
    required this.paymentMethod,
    required this.categoryName,
    required this.status,
    this.notes,
    required this.usageFrequency,
    required this.health,
    required this.monthlyEquivalentPaise,
    required this.yearlyEquivalentPaise,
    required this.overlapGroup,
  });

  final int id;
  final String name;
  final IconData logoIcon;
  final Color logoColor;
  final int amountPaise;
  final String billingCycle;
  final DateTime? nextRenewalAt;
  final String paymentMethod;
  final String categoryName;
  final SubscriptionStatus status;
  final String? notes;
  final SubscriptionUsageFrequency usageFrequency;
  final SubscriptionCardHealth health;
  final int monthlyEquivalentPaise;
  final int yearlyEquivalentPaise;
  final String? overlapGroup;
}

class SubscriptionInsight {
  const SubscriptionInsight({
    required this.message,
    required this.severity,
  });

  final String message;
  final String severity;
}

class SubscriptionSuggestion {
  const SubscriptionSuggestion({
    required this.action,
    required this.title,
    required this.detail,
    this.subscriptionId,
    this.annualSavingsPaise,
  });

  final SubscriptionSuggestionAction action;
  final String title;
  final String detail;
  final int? subscriptionId;
  final int? annualSavingsPaise;
}

class RenewalTimelineEntry {
  const RenewalTimelineEntry({
    required this.subscriptionId,
    required this.name,
    required this.renewalAt,
    required this.amountPaise,
    required this.bucket,
  });

  final int subscriptionId;
  final String name;
  final DateTime renewalAt;
  final int amountPaise;
  final RenewalTimelineBucket bucket;
}

class SubscriptionNotificationAlert {
  const SubscriptionNotificationAlert({
    required this.kind,
    required this.title,
    required this.message,
    this.subscriptionId,
  });

  final String kind;
  final String title;
  final String message;
  final int? subscriptionId;
}

class CategoryCostSlice {
  const CategoryCostSlice({
    required this.categoryName,
    required this.monthlyPaise,
    required this.colorValue,
  });

  final String categoryName;
  final int monthlyPaise;
  final int colorValue;
}

class SubscriptionCostTrendPoint {
  const SubscriptionCostTrendPoint({
    required this.monthKey,
    required this.totalPaise,
  });

  final String monthKey;
  final int totalPaise;
}

class SubscriptionHealthReport {
  const SubscriptionHealthReport({
    required this.overview,
    required this.healthScore,
    required this.cards,
    required this.insights,
    required this.suggestions,
    required this.renewalTimeline,
    required this.alerts,
    required this.categoryBreakdown,
    required this.costTrend,
    required this.salaryPaise,
    required this.incomeSharePercent,
    required this.overlapGroups,
    required this.generatedAt,
  });

  final SubscriptionHealthOverview overview;
  final SubscriptionHealthScore healthScore;
  final List<SubscriptionCardViewModel> cards;
  final List<SubscriptionInsight> insights;
  final List<SubscriptionSuggestion> suggestions;
  final List<RenewalTimelineEntry> renewalTimeline;
  final List<SubscriptionNotificationAlert> alerts;
  final List<CategoryCostSlice> categoryBreakdown;
  final List<SubscriptionCostTrendPoint> costTrend;
  final int salaryPaise;
  final double incomeSharePercent;
  final Map<String, List<int>> overlapGroups;
  final DateTime generatedAt;
}
