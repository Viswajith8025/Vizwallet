import 'package:flutter/material.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/daos/subscriptions_dao.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_models.dart';

/// Rule-based subscription optimization engine — local-first, no external AI.
abstract final class SubscriptionHealthEngine {
  static const _entertainmentKeywords = [
    'netflix',
    'prime',
    'hotstar',
    'disney',
    'spotify',
    'youtube',
    'apple music',
    'zee5',
    'sonyliv',
    'jiocinema',
    'hulu',
    'hbo',
  ];

  static const _productivityKeywords = [
    'notion',
    'dropbox',
    'google one',
    'icloud',
    'microsoft',
    'office',
    'adobe',
    'canva',
  ];

  static SubscriptionHealthReport build({
    required List<SubscriptionsTableData> subscriptions,
    required Map<int, String> categoryNames,
    required Map<int, int> categoryColors,
    required int salaryPaise,
    List<SubscriptionPaymentsTableData> payments = const [],
    DateTime? now,
  }) {
    final clock = (now ?? DateTime.now()).toLocal();
    final active =
        subscriptions.where((s) => _parseStatus(s) == SubscriptionStatus.active);
    final paused =
        subscriptions.where((s) => _parseStatus(s) == SubscriptionStatus.paused);
    final cancelled = subscriptions
        .where((s) => _parseStatus(s) == SubscriptionStatus.cancelled);

    final monthlyTotal = active.fold<int>(
      0,
      (sum, s) => sum + SubscriptionsDao.monthlyEquivalentPaise(s),
    );
    final yearlyTotal = monthlyTotal * 12;
    final avgMonthly =
        active.isEmpty ? 0 : (monthlyTotal / active.length).round();

    int? largestId;
    var largestMonthly = 0;
    int? longestId;
    DateTime? oldestCreated;
    for (final sub in active) {
      final monthly = SubscriptionsDao.monthlyEquivalentPaise(sub);
      if (monthly > largestMonthly) {
        largestMonthly = monthly;
        largestId = sub.id;
      }
      if (oldestCreated == null || sub.createdAt.isBefore(oldestCreated)) {
        oldestCreated = sub.createdAt;
        longestId = sub.id;
      }
    }

    final upcomingRenewals = active.where((s) {
      if (s.nextRenewalAt == null) return false;
      final renewal = s.nextRenewalAt!.toLocal();
      final diff = renewal.difference(clock).inDays;
      return diff >= 0 && diff <= 30;
    }).length;

    final overlapGroups = _detectOverlapGroups(active.toList());
    final incomeShare =
        salaryPaise > 0 ? (monthlyTotal / salaryPaise) * 100 : 0.0;

    final cards = subscriptions.map((sub) {
      return _buildCard(
        sub: sub,
        categoryNames: categoryNames,
        categoryColors: categoryColors,
        overlapGroups: overlapGroups,
        monthlyTotal: monthlyTotal,
      );
    }).toList()
      ..sort((a, b) {
        final rank = (SubscriptionStatus s) => switch (s) {
              SubscriptionStatus.active => 0,
              SubscriptionStatus.paused => 1,
              SubscriptionStatus.cancelled => 2,
            };
        final byStatus = rank(a.status).compareTo(rank(b.status));
        if (byStatus != 0) return byStatus;
        return b.monthlyEquivalentPaise.compareTo(a.monthlyEquivalentPaise);
      });

    final overview = SubscriptionHealthOverview(
      activeCount: active.length,
      pausedCount: paused.length,
      cancelledCount: cancelled.length,
      upcomingRenewalCount: upcomingRenewals,
      monthlyTotalPaise: monthlyTotal,
      yearlyTotalPaise: yearlyTotal,
      averageMonthlyCostPaise: avgMonthly,
      largestSubscriptionId: largestId,
      longestRunningSubscriptionId: longestId,
    );

    final healthScore = _computeHealthScore(
      monthlyTotal: monthlyTotal,
      incomeShare: incomeShare,
      active: active.toList(),
      overlapGroups: overlapGroups,
      upcomingRenewals: upcomingRenewals,
    );

    final insights = _insights(
      monthlyTotal: monthlyTotal,
      yearlyTotal: yearlyTotal,
      incomeShare: incomeShare,
      salaryPaise: salaryPaise,
      active: active.toList(),
      overlapGroups: overlapGroups,
    );

    final suggestions = _suggestions(
      active: active.toList(),
      overlapGroups: overlapGroups,
      incomeShare: incomeShare,
      monthlyTotal: monthlyTotal,
    );

    final renewalTimeline = _renewalTimeline(active.toList(), clock);
    final alerts = _alerts(active.toList(), clock);
    final categoryBreakdown = _categoryBreakdown(
      active.toList(),
      categoryNames,
      categoryColors,
    );
    final costTrend = _costTrend(
      payments: payments,
      currentMonthly: monthlyTotal,
      clock: clock,
    );

    return SubscriptionHealthReport(
      overview: overview,
      healthScore: healthScore,
      cards: cards,
      insights: insights,
      suggestions: suggestions,
      renewalTimeline: renewalTimeline,
      alerts: alerts,
      categoryBreakdown: categoryBreakdown,
      costTrend: costTrend,
      salaryPaise: salaryPaise,
      incomeSharePercent: incomeShare,
      overlapGroups: overlapGroups,
      generatedAt: clock,
    );
  }

  static SubscriptionStatus _parseStatus(SubscriptionsTableData sub) {
    switch (sub.status) {
      case 'paused':
        return SubscriptionStatus.paused;
      case 'cancelled':
        return SubscriptionStatus.cancelled;
      default:
        return sub.isActive
            ? SubscriptionStatus.active
            : SubscriptionStatus.cancelled;
    }
  }

  static SubscriptionUsageFrequency _parseUsage(String? raw) {
    return switch (raw) {
      'daily' => SubscriptionUsageFrequency.daily,
      'weekly' => SubscriptionUsageFrequency.weekly,
      'monthly' => SubscriptionUsageFrequency.monthly,
      'rarely' => SubscriptionUsageFrequency.rarely,
      'never' => SubscriptionUsageFrequency.never,
      _ => SubscriptionUsageFrequency.unknown,
    };
  }

  static SubscriptionCardViewModel _buildCard({
    required SubscriptionsTableData sub,
    required Map<int, String> categoryNames,
    required Map<int, int> categoryColors,
    required Map<String, List<int>> overlapGroups,
    required int monthlyTotal,
  }) {
    final monthly = SubscriptionsDao.monthlyEquivalentPaise(sub);
    final yearly = SubscriptionsDao.yearlyEquivalentPaise(sub);
    final status = _parseStatus(sub);
    final usage = _parseUsage(sub.usageFrequency);
    final categoryName =
        sub.categoryId != null ? (categoryNames[sub.categoryId] ?? 'Other') : 'Subscriptions';
    final colorValue = sub.categoryId != null
        ? (categoryColors[sub.categoryId] ?? 0xFF9B59B6)
        : 0xFF9B59B6;
    final logo = _logoForName(sub.name);
    final overlapGroup = _overlapGroupFor(sub, overlapGroups);

    return SubscriptionCardViewModel(
      id: sub.id,
      name: sub.name,
      logoIcon: logo.icon,
      logoColor: Color(colorValue),
      amountPaise: sub.amountPaise,
      billingCycle: sub.billingCycle,
      nextRenewalAt: sub.nextRenewalAt,
      paymentMethod: sub.paymentMethod,
      categoryName: categoryName,
      status: status,
      notes: sub.notes,
      usageFrequency: usage,
      health: _cardHealth(
        status: status,
        usage: usage,
        monthly: monthly,
        monthlyTotal: monthlyTotal,
        hasOverlap: overlapGroup != null,
      ),
      monthlyEquivalentPaise: monthly,
      yearlyEquivalentPaise: yearly,
      overlapGroup: overlapGroup,
    );
  }

  static _LogoHint _logoForName(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('netflix')) {
      return const _LogoHint(Icons.movie_filter_rounded);
    }
    if (lower.contains('spotify') || lower.contains('music')) {
      return const _LogoHint(Icons.music_note_rounded);
    }
    if (lower.contains('prime') || lower.contains('hotstar') || lower.contains('disney')) {
      return const _LogoHint(Icons.live_tv_rounded);
    }
    if (lower.contains('youtube')) {
      return const _LogoHint(Icons.play_circle_rounded);
    }
    if (lower.contains('gym') || lower.contains('fitness')) {
      return const _LogoHint(Icons.fitness_center_rounded);
    }
    if (lower.contains('cloud') || lower.contains('drive') || lower.contains('dropbox')) {
      return const _LogoHint(Icons.cloud_rounded);
    }
    if (lower.contains('mobile') || lower.contains('jio') || lower.contains('airtel')) {
      return const _LogoHint(Icons.smartphone_rounded);
    }
    return const _LogoHint(Icons.subscriptions_rounded);
  }

  static Map<String, List<int>> _detectOverlapGroups(
    List<SubscriptionsTableData> active,
  ) {
    final groups = <String, List<int>>{};

    void addGroup(String key, int id) {
      groups.putIfAbsent(key, () => []).add(id);
    }

    for (final sub in active) {
      final lower = sub.name.toLowerCase();
      if (_entertainmentKeywords.any(lower.contains)) {
        addGroup('entertainment', sub.id);
      }
      if (_productivityKeywords.any(lower.contains)) {
        addGroup('productivity', sub.id);
      }
      if (sub.categoryId != null) {
        addGroup('category_${sub.categoryId}', sub.id);
      }
    }

    return Map.fromEntries(
      groups.entries.where((e) => e.value.length > 1),
    );
  }

  static String? _overlapGroupFor(
    SubscriptionsTableData sub,
    Map<String, List<int>> groups,
  ) {
    for (final entry in groups.entries) {
      if (entry.value.contains(sub.id)) {
        return entry.key;
      }
    }
    return null;
  }

  static SubscriptionCardHealth _cardHealth({
    required SubscriptionStatus status,
    required SubscriptionUsageFrequency usage,
    required int monthly,
    required int monthlyTotal,
    required bool hasOverlap,
  }) {
    if (status == SubscriptionStatus.paused) {
      return SubscriptionCardHealth.watch;
    }
    if (status == SubscriptionStatus.cancelled) {
      return SubscriptionCardHealth.watch;
    }
    if (usage == SubscriptionUsageFrequency.never ||
        usage == SubscriptionUsageFrequency.rarely) {
      return SubscriptionCardHealth.unused;
    }
    if (hasOverlap) return SubscriptionCardHealth.atRisk;
    if (monthlyTotal > 0 && monthly / monthlyTotal > 0.35) {
      return SubscriptionCardHealth.watch;
    }
    if (usage == SubscriptionUsageFrequency.daily ||
        usage == SubscriptionUsageFrequency.weekly) {
      return SubscriptionCardHealth.excellent;
    }
    return SubscriptionCardHealth.healthy;
  }

  static SubscriptionHealthScore _computeHealthScore({
    required int monthlyTotal,
    required double incomeShare,
    required List<SubscriptionsTableData> active,
    required Map<String, List<int>> overlapGroups,
    required int upcomingRenewals,
  }) {
    var score = 100;
    final factors = <SubscriptionHealthFactor>[];

    if (incomeShare > 20) {
      final penalty = ((incomeShare - 20) * 1.5).round().clamp(0, 25);
      score -= penalty;
      factors.add(SubscriptionHealthFactor(
        name: 'Income share',
        impact: -penalty,
        detail:
            'Recurring costs are ${incomeShare.toStringAsFixed(0)}% of salary',
      ));
    } else if (incomeShare > 12) {
      final penalty = ((incomeShare - 12) * 1.2).round().clamp(0, 12);
      score -= penalty;
      factors.add(SubscriptionHealthFactor(
        name: 'Income share',
        impact: -penalty,
        detail:
            'Subscriptions use ${incomeShare.toStringAsFixed(0)}% of income',
      ));
    } else {
      factors.add(SubscriptionHealthFactor(
        name: 'Income share',
        impact: 5,
        detail: 'Recurring spend is a modest share of income',
      ));
      score = (score + 5).clamp(0, 100);
    }

    final unusedCount = active
        .where((s) {
          final u = _parseUsage(s.usageFrequency);
          return u == SubscriptionUsageFrequency.never ||
              u == SubscriptionUsageFrequency.rarely;
        })
        .length;
    if (unusedCount > 0) {
      final penalty = (unusedCount * 8).clamp(0, 24);
      score -= penalty;
      factors.add(SubscriptionHealthFactor(
        name: 'Unused services',
        impact: -penalty,
        detail: '$unusedCount subscription${unusedCount == 1 ? '' : 's'} rarely used',
      ));
    }

    final overlapCount =
        overlapGroups.values.fold<int>(0, (sum, ids) => sum + ids.length);
    if (overlapCount > 0) {
      final penalty = (overlapGroups.length * 6).clamp(0, 18);
      score -= penalty;
      factors.add(SubscriptionHealthFactor(
        name: 'Duplicate services',
        impact: -penalty,
        detail: '${overlapGroups.length} overlapping group${overlapGroups.length == 1 ? '' : 's'} detected',
      ));
    }

    if (active.length > 8) {
      const penalty = 8;
      score -= penalty;
      factors.add(SubscriptionHealthFactor(
        name: 'Subscription count',
        impact: -penalty,
        detail: '${active.length} active services — consolidation may help',
      ));
    }

    if (upcomingRenewals >= 4) {
      const penalty = 6;
      score -= penalty;
      factors.add(SubscriptionHealthFactor(
        name: 'Renewal frequency',
        impact: -penalty,
        detail: '$upcomingRenewals renewals in the next 30 days',
      ));
    }

    score = score.clamp(0, 100);
    final label = switch (score) {
      >= 85 => 'Excellent',
      >= 70 => 'Healthy',
      >= 50 => 'Needs attention',
      >= 30 => 'At risk',
      _ => 'Critical',
    };

    return SubscriptionHealthScore(
      score: score,
      label: label,
      factors: factors,
    );
  }

  static List<SubscriptionInsight> _insights({
    required int monthlyTotal,
    required int yearlyTotal,
    required double incomeShare,
    required int salaryPaise,
    required List<SubscriptionsTableData> active,
    required Map<String, List<int>> overlapGroups,
  }) {
    final insights = <SubscriptionInsight>[];

    if (salaryPaise > 0) {
      insights.add(SubscriptionInsight(
        message:
            'Subscriptions consume ${incomeShare.toStringAsFixed(0)}% of your salary.',
        severity: incomeShare > 15 ? 'warning' : 'info',
      ));
    }

    final entertainment = overlapGroups['entertainment'];
    if (entertainment != null && entertainment.length >= 2) {
      insights.add(SubscriptionInsight(
        message:
            'You pay for ${entertainment.length} entertainment services.',
        severity: 'warning',
      ));
    }

    if (active.isNotEmpty) {
      final largest = active.reduce(
        (a, b) => SubscriptionsDao.monthlyEquivalentPaise(a) >
                SubscriptionsDao.monthlyEquivalentPaise(b)
            ? a
            : b,
      );
      final annualSave = SubscriptionsDao.yearlyEquivalentPaise(largest);
      insights.add(SubscriptionInsight(
        message:
            'Cancelling ${largest.name} saves ${formatPaise(annualSave)} annually.',
        severity: 'info',
      ));
    }

    if (salaryPaise > 0 && yearlyTotal >= salaryPaise) {
      insights.add(SubscriptionInsight(
        message: 'Your yearly subscription cost equals one month of salary.',
        severity: 'critical',
      ));
    } else if (salaryPaise > 0 && yearlyTotal >= salaryPaise * 0.5) {
      insights.add(SubscriptionInsight(
        message:
            'Yearly subscriptions (${formatPaise(yearlyTotal)}) are half a month of income.',
        severity: 'warning',
      ));
    }

    if (monthlyTotal > 0 && active.length >= 3) {
      insights.add(SubscriptionInsight(
        message:
            '${active.length} active subscriptions average ${formatPaise((monthlyTotal / active.length).round())}/mo each.',
        severity: 'info',
      ));
    }

    return insights;
  }

  static List<SubscriptionSuggestion> _suggestions({
    required List<SubscriptionsTableData> active,
    required Map<String, List<int>> overlapGroups,
    required double incomeShare,
    required int monthlyTotal,
  }) {
    final suggestions = <SubscriptionSuggestion>[];

    for (final sub in active) {
      final usage = _parseUsage(sub.usageFrequency);
      if (usage == SubscriptionUsageFrequency.never ||
          usage == SubscriptionUsageFrequency.rarely) {
        suggestions.add(SubscriptionSuggestion(
          action: SubscriptionSuggestionAction.pause,
          title: 'Pause ${sub.name}',
          detail: 'Marked as rarely used — pause until you need it again.',
          subscriptionId: sub.id,
          annualSavingsPaise: SubscriptionsDao.yearlyEquivalentPaise(sub),
        ));
      }
    }

    final entertainment = overlapGroups['entertainment'];
    if (entertainment != null && entertainment.length >= 3) {
      suggestions.add(SubscriptionSuggestion(
        action: SubscriptionSuggestionAction.combineServices,
        title: 'Consolidate entertainment',
        detail:
            'Three or more streaming services — keep your favourite and rotate others.',
      ));
    }

    if (entertainment != null && entertainment.length >= 2) {
      suggestions.add(const SubscriptionSuggestion(
        action: SubscriptionSuggestionAction.shareFamilyPlan,
        title: 'Share a family plan',
        detail:
            'Split one family plan with household members instead of separate accounts.',
      ));
    }

    for (final sub in active) {
      if (sub.billingCycle == 'monthly' &&
          SubscriptionsDao.monthlyEquivalentPaise(sub) >= 50000) {
        suggestions.add(SubscriptionSuggestion(
          action: SubscriptionSuggestionAction.switchToAnnual,
          title: 'Switch ${sub.name} to annual',
          detail: 'Higher monthly plans often save 15–20% on yearly billing.',
          subscriptionId: sub.id,
        ));
      }
      if (sub.billingCycle == 'yearly' && incomeShare > 18) {
        suggestions.add(SubscriptionSuggestion(
          action: SubscriptionSuggestionAction.switchToMonthly,
          title: 'Consider monthly for ${sub.name}',
          detail:
              'With tight cash flow, monthly billing spreads the cost.',
          subscriptionId: sub.id,
        ));
      }
    }

    if (overlapGroups.isNotEmpty) {
      for (final entry in overlapGroups.entries) {
        if (entry.value.length < 2) continue;
        final names = entry.value
            .map((id) => active.firstWhere((s) => s.id == id).name)
            .join(', ');
        suggestions.add(SubscriptionSuggestion(
          action: SubscriptionSuggestionAction.cancel,
          title: 'Review overlapping services',
          detail: 'Similar subscriptions: $names',
        ));
      }
    }

    if (monthlyTotal > 0 && suggestions.isEmpty) {
      suggestions.add(const SubscriptionSuggestion(
        action: SubscriptionSuggestionAction.reviewUsage,
        title: 'Track usage frequency',
        detail:
            'Mark how often you use each service for sharper recommendations.',
      ));
    }

    return suggestions.take(6).toList();
  }

  static List<RenewalTimelineEntry> _renewalTimeline(
    List<SubscriptionsTableData> active,
    DateTime clock,
  ) {
    final entries = <RenewalTimelineEntry>[];
    final today = DateTime(clock.year, clock.month, clock.day);
    final daysUntilWeekEnd = 7 - today.weekday % 7;
    final weekEnd = today.add(Duration(days: daysUntilWeekEnd));
    final nextWeekEnd = weekEnd.add(const Duration(days: 7));
    final monthEnd = DateTime(clock.year, clock.month + 1, 0);
    final quarterEnd = today.add(const Duration(days: 90));

    for (final sub in active) {
      if (sub.nextRenewalAt == null) continue;
      final renewal = sub.nextRenewalAt!.toLocal();
      final renewalDay =
          DateTime(renewal.year, renewal.month, renewal.day);
      if (renewalDay.isBefore(today)) continue;

      final bucket = () {
        if (renewalDay == today) return RenewalTimelineBucket.today;
        if (!renewalDay.isAfter(weekEnd)) {
          return RenewalTimelineBucket.thisWeek;
        }
        if (!renewalDay.isAfter(nextWeekEnd)) {
          return RenewalTimelineBucket.nextWeek;
        }
        if (!renewalDay.isAfter(monthEnd)) {
          return RenewalTimelineBucket.thisMonth;
        }
        if (!renewalDay.isAfter(quarterEnd)) {
          return RenewalTimelineBucket.upcomingQuarter;
        }
        return null;
      }();

      if (bucket == null) continue;
      entries.add(RenewalTimelineEntry(
        subscriptionId: sub.id,
        name: sub.name,
        renewalAt: renewal,
        amountPaise: sub.amountPaise,
        bucket: bucket,
      ));
    }

    entries.sort((a, b) => a.renewalAt.compareTo(b.renewalAt));
    return entries;
  }

  static List<SubscriptionNotificationAlert> _alerts(
    List<SubscriptionsTableData> active,
    DateTime clock,
  ) {
    final alerts = <SubscriptionNotificationAlert>[];
    final today = DateTime(clock.year, clock.month, clock.day);
    final tomorrow = today.add(const Duration(days: 1));

    for (final sub in active) {
      if (sub.nextRenewalAt == null) continue;
      final renewal = sub.nextRenewalAt!.toLocal();
      final renewalDay =
          DateTime(renewal.year, renewal.month, renewal.day);

      if (renewalDay == tomorrow) {
        alerts.add(SubscriptionNotificationAlert(
          kind: 'renew_tomorrow',
          title: 'Renews tomorrow',
          message: '${sub.name} · ${formatPaise(sub.amountPaise)}',
          subscriptionId: sub.id,
        ));
      }

      final notes = sub.notes?.toLowerCase() ?? '';
      if (notes.contains('trial') &&
          renewalDay.difference(today).inDays <= 3) {
        alerts.add(SubscriptionNotificationAlert(
          kind: 'trial_ending',
          title: 'Trial ending soon',
          message: '${sub.name} converts on ${renewal.day}/${renewal.month}',
          subscriptionId: sub.id,
        ));
      }

      final usage = _parseUsage(sub.usageFrequency);
      if (usage == SubscriptionUsageFrequency.never) {
        alerts.add(SubscriptionNotificationAlert(
          kind: 'unused',
          title: 'Unused subscription',
          message: 'You marked ${sub.name} as never used.',
          subscriptionId: sub.id,
        ));
      }
    }

    return alerts;
  }

  static List<CategoryCostSlice> _categoryBreakdown(
    List<SubscriptionsTableData> active,
    Map<int, String> categoryNames,
    Map<int, int> categoryColors,
  ) {
    final totals = <String, int>{};
    final colors = <String, int>{};

    for (final sub in active) {
      final name = sub.categoryId != null
          ? (categoryNames[sub.categoryId] ?? 'Other')
          : 'Subscriptions';
      final monthly = SubscriptionsDao.monthlyEquivalentPaise(sub);
      totals[name] = (totals[name] ?? 0) + monthly;
      colors[name] = sub.categoryId != null
          ? (categoryColors[sub.categoryId] ?? 0xFF9B59B6)
          : 0xFF9B59B6;
    }

    return totals.entries
        .map(
          (e) => CategoryCostSlice(
            categoryName: e.key,
            monthlyPaise: e.value,
            colorValue: colors[e.key] ?? 0xFF9E9E9E,
          ),
        )
        .toList()
      ..sort((a, b) => b.monthlyPaise.compareTo(a.monthlyPaise));
  }

  static List<SubscriptionCostTrendPoint> _costTrend({
    required List<SubscriptionPaymentsTableData> payments,
    required int currentMonthly,
    required DateTime clock,
  }) {
    if (payments.isEmpty) {
      final points = <SubscriptionCostTrendPoint>[];
      for (var i = 5; i >= 0; i--) {
        final month = DateTime(clock.year, clock.month - i, 1);
        final key =
            '${month.year}-${month.month.toString().padLeft(2, '0')}';
        points.add(SubscriptionCostTrendPoint(
          monthKey: key,
          totalPaise: currentMonthly,
        ));
      }
      return points;
    }

    final grouped = <String, int>{};
    for (final payment in payments) {
      grouped[payment.monthKey] =
          (grouped[payment.monthKey] ?? 0) + payment.amountPaise;
    }
    final keys = grouped.keys.toList()..sort();
    return keys
        .map(
          (k) => SubscriptionCostTrendPoint(
            monthKey: k,
            totalPaise: grouped[k]!,
          ),
        )
        .toList();
  }
}

class _LogoHint {
  const _LogoHint(this.icon);
  final IconData icon;
}
