import 'package:flutter/material.dart';
import 'package:rupee_track/features/budget/domain/bucket_status.dart';
import 'package:rupee_track/features/health_score/domain/financial_health_models.dart';
import 'package:rupee_track/features/safe_spend/domain/safe_spend_snapshot.dart';
import 'package:rupee_track/features/savings_forecast/domain/savings_forecast_models.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_models.dart';
import 'package:rupee_track/features/trends/domain/spending_trends_report.dart';

enum InsightCategory {
  spending,
  savings,
  budget,
  goal,
  subscription,
  loan,
  wishlist,
  income,
  health,
  calendar,
  merchant,
  category,
  noSpend,
  salaryCycle,
  forecast,
  achievement,
  behavioral,
  safeSpend,
  tip,
}

enum InsightKind {
  insight,
  warning,
  achievement,
  recommendation,
  trend,
  opportunity,
  tip,
}

enum InsightSeverity {
  info,
  warning,
  opportunity,
  achievement,
  critical,
}

class InsightFeedItem {
  const InsightFeedItem({
    required this.id,
    required this.category,
    required this.kind,
    required this.severity,
    required this.title,
    required this.body,
    this.metricLabel,
    this.metricValue,
    this.actionRoute,
    this.actionLabel,
    this.actionQuery,
    this.icon,
    this.colorValue,
    this.rankScore = 50,
    this.source = 'engine',
  });

  final String id;
  final InsightCategory category;
  final InsightKind kind;
  final InsightSeverity severity;
  final String title;
  final String body;
  final String? metricLabel;
  final String? metricValue;
  final String? actionRoute;
  final String? actionLabel;
  final String? actionQuery;
  final IconData? icon;
  final int? colorValue;
  final int rankScore;
  final String source;
}

class InsightsFeedReport {
  const InsightsFeedReport({
    required this.cycleKey,
    required this.items,
    required this.dailyTip,
    required this.achievements,
    required this.generatedAt,
  });

  final String cycleKey;
  final List<InsightFeedItem> items;
  final InsightFeedItem dailyTip;
  final List<InsightFeedItem> achievements;
  final DateTime generatedAt;

  List<InsightFeedItem> get heroItems =>
      items.where((i) => i.kind != InsightKind.tip).take(12).toList();
}

class InsightsFeedInput {
  const InsightsFeedInput({
    required this.cycleKey,
    required this.salaryDay,
    required this.trends,
    this.health,
    this.safeSpend,
    this.subscriptions,
    this.budget,
    this.forecast,
    this.goals = const [],
    this.overdueLoans = const [],
    this.daysUntilSalary,
    this.topMerchant,
    this.topMerchantPaise = 0,
    this.categoryNoSpendDays = const {},
    this.expenseTrackingStreakDays = 0,
    this.savingsRatePercent = 0,
  });

  final String cycleKey;
  final int salaryDay;
  final SpendingTrendsReport trends;
  final FinancialHealthReport? health;
  final SafeSpendSnapshot? safeSpend;
  final SubscriptionHealthReport? subscriptions;
  final BudgetPlanStatus? budget;
  final SavingsForecastReport? forecast;
  final List<SavingsGoalSnapshot> goals;
  final List<LoanOverdueSnapshot> overdueLoans;
  final int? daysUntilSalary;
  final String? topMerchant;
  final int topMerchantPaise;
  final Map<String, int> categoryNoSpendDays;
  final int expenseTrackingStreakDays;
  final double savingsRatePercent;
}

class LoanOverdueSnapshot {
  const LoanOverdueSnapshot({
    required this.personName,
    required this.balancePaise,
    required this.daysOverdue,
    required this.daysUntilDue,
    required this.isOverdue,
  });

  final String personName;
  final int balancePaise;
  final int daysOverdue;
  final int? daysUntilDue;
  final bool isOverdue;
}

IconData iconForInsightCategory(InsightCategory category) =>
    switch (category) {
      InsightCategory.spending => Icons.receipt_long_outlined,
      InsightCategory.savings => Icons.savings_outlined,
      InsightCategory.budget => Icons.pie_chart_outline,
      InsightCategory.goal => Icons.flag_outlined,
      InsightCategory.subscription => Icons.subscriptions_outlined,
      InsightCategory.loan => Icons.handshake_outlined,
      InsightCategory.wishlist => Icons.favorite_border,
      InsightCategory.income => Icons.payments_outlined,
      InsightCategory.health => Icons.favorite_rounded,
      InsightCategory.calendar => Icons.calendar_month_outlined,
      InsightCategory.merchant => Icons.storefront_outlined,
      InsightCategory.category => Icons.category_outlined,
      InsightCategory.noSpend => Icons.nightlight_round,
      InsightCategory.salaryCycle => Icons.event_repeat_outlined,
      InsightCategory.forecast => Icons.trending_up,
      InsightCategory.achievement => Icons.emoji_events_outlined,
      InsightCategory.behavioral => Icons.psychology_outlined,
      InsightCategory.safeSpend => Icons.shield_outlined,
      InsightCategory.tip => Icons.lightbulb_outline,
    };

String emojiForInsightCategory(InsightCategory category) =>
    switch (category) {
      InsightCategory.spending => '💸',
      InsightCategory.savings => '🐷',
      InsightCategory.budget => '📊',
      InsightCategory.goal => '🎯',
      InsightCategory.subscription => '📺',
      InsightCategory.loan => '🤝',
      InsightCategory.wishlist => '💝',
      InsightCategory.income => '💰',
      InsightCategory.health => '❤️',
      InsightCategory.calendar => '📅',
      InsightCategory.merchant => '🏪',
      InsightCategory.category => '🏷️',
      InsightCategory.noSpend => '🌙',
      InsightCategory.salaryCycle => '🔄',
      InsightCategory.forecast => '📈',
      InsightCategory.achievement => '🏆',
      InsightCategory.behavioral => '🧠',
      InsightCategory.safeSpend => '🛡️',
      InsightCategory.tip => '💡',
    };

String labelForInsightCategory(InsightCategory category) =>
    switch (category) {
      InsightCategory.spending => 'Spending',
      InsightCategory.savings => 'Savings',
      InsightCategory.budget => 'Budget',
      InsightCategory.goal => 'Goals',
      InsightCategory.subscription => 'Subscriptions',
      InsightCategory.loan => 'Loans',
      InsightCategory.wishlist => 'Wishlist',
      InsightCategory.income => 'Income',
      InsightCategory.health => 'Health',
      InsightCategory.calendar => 'Calendar',
      InsightCategory.merchant => 'Merchant',
      InsightCategory.category => 'Category',
      InsightCategory.noSpend => 'No-spend',
      InsightCategory.salaryCycle => 'Pay cycle',
      InsightCategory.forecast => 'Forecast',
      InsightCategory.achievement => 'Win',
      InsightCategory.behavioral => 'Habits',
      InsightCategory.safeSpend => 'Safe spend',
      InsightCategory.tip => 'Tip',
    };

String labelForInsightKind(InsightKind kind) =>
    switch (kind) {
      InsightKind.insight => 'Insight',
      InsightKind.warning => 'Alert',
      InsightKind.achievement => 'Win',
      InsightKind.recommendation => 'Tip',
      InsightKind.trend => 'Trend',
      InsightKind.opportunity => 'Opportunity',
      InsightKind.tip => 'Daily tip',
    };

String emojiForInsightKind(InsightKind kind) =>
    switch (kind) {
      InsightKind.insight => '💡',
      InsightKind.warning => '⚠️',
      InsightKind.achievement => '🏆',
      InsightKind.recommendation => '✨',
      InsightKind.trend => '📉',
      InsightKind.opportunity => '🌱',
      InsightKind.tip => '💡',
    };
