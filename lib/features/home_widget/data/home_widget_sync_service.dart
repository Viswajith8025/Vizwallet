import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/providers/settings_provider.dart';
import 'package:rupee_track/core/salary_cycle/salary_cycle_engine.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/utils/savings_rate_utils.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/health_score/data/financial_health_repository.dart';
import 'package:rupee_track/features/home_widget/domain/home_widget_snapshot.dart';
import 'package:rupee_track/features/monthly_report/domain/monthly_report_engine.dart';

final homeWidgetSyncServiceProvider = Provider<HomeWidgetSyncService>((ref) {
  return HomeWidgetSyncService(ref);
});

/// Pushes live financial data to Android home screen widgets.
class HomeWidgetSyncService {
  HomeWidgetSyncService(this._ref);

  final Ref _ref;

  static const _androidProviders = [
    'com.viswajith.rupee_track.widget.VisWalletCompactWidgetProvider',
    'com.viswajith.rupee_track.widget.VisWalletStandardWidgetProvider',
    'com.viswajith.rupee_track.widget.VisWalletWideWidgetProvider',
    'com.viswajith.rupee_track.widget.VisWalletFullWidgetProvider',
  ];

  Future<void> initialize() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await HomeWidget.setAppGroupId('group.com.viswajith.rupee_track');
    } catch (_) {}
  }

  Future<void> sync() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      final snapshot = await _buildSnapshot();
      final data = snapshot.toWidgetData();
      for (final entry in data.entries) {
        await HomeWidget.saveWidgetData(entry.key, entry.value);
      }
      for (final provider in _androidProviders) {
        await HomeWidget.updateWidget(qualifiedAndroidName: provider);
      }
    } catch (_) {}
  }

  Future<HomeWidgetSnapshot> _buildSnapshot() async {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();
    final salaryDay = settings.salaryDay;
    final cycleKey = currentCycleKey(salaryDay: salaryDay);

    final salary = await db.salaryDao.getSalaryForMonth(cycleKey);
    final salaryPaise = salary?.amountPaise ?? 0;
    final spentPaise = await db.expensesDao.sumSpentForMonth(cycleKey);
    final todaySpent = await db.expensesDao.sumSpentTodayInCycle(cycleKey);

    final previousKey = previousCycleKey(cycleKey, salaryDay: salaryDay);
    final prevSalary = await db.salaryDao.getSalaryForMonth(previousKey);
    final prevSpent = await db.expensesDao.sumSpentForMonth(previousKey);
    final carryOver = SalaryCycleEngine.carryOverBalance(
      previousSalaryPaise: prevSalary?.amountPaise ?? 0,
      previousSpentPaise: prevSpent,
    );

    final moneyLeft = SalaryCycleEngine.effectiveMoneyLeft(
      salaryPaise: salaryPaise,
      spentPaise: spentPaise,
      carryOverPaise: carryOver,
    );
    final daysLeft = daysRemainingInCycle(salaryDay: salaryDay);
    final safeDaily = SalaryCycleEngine.dailySpendingAllowance(
      moneyLeftPaise: moneyLeft,
      daysRemaining: daysLeft,
    );
    final savingsPercent = SavingsRateUtils.displayPercent(
      salaryPaise: salaryPaise,
      spentPaise: spentPaise,
      carryOverPaise: carryOver,
    );

    final plan =
        await _ref.read(budgetRepositoryProvider).getPlanStatus(cycleKey);
    final budgetProgress =
        MonthlyReportEngine.budgetOnTrackPercent(plan).round();

    final goals = await db.savingsGoalsDao.listActiveGoals();
    final goalProgress = SavingsRateUtils.goalsProgressPercent(
      goals: goals.map(
        (g) => (
          savedPaise: g.savedPaise,
          targetPaise: g.targetPaise,
          isWishlist: g.isWishlist,
        ),
      ),
    );
    final wishlistGoals = goals.where((g) => g.isWishlist).toList();
    final wishlistNote = wishlistGoals.isEmpty
        ? 'No wishlist items yet'
        : '${wishlistGoals.length} wishlist item${wishlistGoals.length == 1 ? '' : 's'}';

    var healthScore = 0;
    try {
      final health = await _ref
          .read(financialHealthRepositoryProvider)
          .buildForCycle(cycleKey);
      if (health.hasEnoughData) healthScore = health.overallScore;
    } catch (_) {}

    final upcomingSubs = await db.subscriptionsDao.upcomingRenewals(days: 14);
    final overdueLoans = await db.loansDao.overdueLoans();
    final recent = await db.expensesDao.getRecentExpenses(limit: 1);

    final themeMode = _ref.read(themeModeProvider);
    final themeLabel = switch (themeMode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };

    String subsLabel = 'No renewals soon';
    if (upcomingSubs.isNotEmpty) {
      final next = upcomingSubs.first;
      final day = next.nextRenewalAt?.toLocal();
      subsLabel = next.name +
          (day != null ? ' · ${DateFormat.MMMd().format(day)}' : '');
    }

    final recentRow = recent.isNotEmpty ? recent.first : null;

    return HomeWidgetSnapshot(
      moneyLeftFormatted: formatPaise(moneyLeft),
      todaySpentFormatted: formatPaise(todaySpent),
      safeDailyFormatted: formatPaise(safeDaily),
      budgetProgressPercent: budgetProgress,
      healthScore: healthScore,
      savingsPercent: savingsPercent,
      goalProgressPercent: goalProgress,
      upcomingSubscriptionsCount: upcomingSubs.length,
      upcomingSubscriptionsLabel: subsLabel,
      overdueLoansCount: overdueLoans.length,
      recentTransactionTitle: recentRow?.expense.title ?? 'No transactions yet',
      recentTransactionAmount: recentRow != null
          ? formatPaise(recentRow.expense.amountPaise)
          : '—',
      cycleLabel: formatCycleLabel(cycleKey, salaryDay: salaryDay),
      themeMode: themeLabel,
      lastUpdatedIso: DateTime.now().toUtc().toIso8601String(),
      wishlistNote: wishlistNote,
    );
  }
}

/// Background entry point for widget button taps (Android).
@pragma('vm:entry-point')
Future<void> homeWidgetInteractivityCallback(Uri? uri) async {
  // Opens app via deep link — navigation handled in [WidgetLaunchHandler].
}
