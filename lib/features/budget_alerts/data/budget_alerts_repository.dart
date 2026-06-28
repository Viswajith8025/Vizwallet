import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/budget/domain/bucket_status.dart';
import 'package:rupee_track/features/budget_alerts/data/alert_preferences.dart';
import 'package:rupee_track/features/budget_alerts/data/budget_notification_service.dart';
import 'package:rupee_track/features/budget_alerts/domain/budget_alert.dart';
import 'package:rupee_track/features/budget_alerts/domain/budget_alert_engine.dart';

final alertPreferencesProvider =
    NotifierProvider<AlertPreferencesNotifier, AlertPreferences>(
  AlertPreferencesNotifier.new,
);

class AlertPreferencesNotifier extends Notifier<AlertPreferences> {
  @override
  AlertPreferences build() => AlertPreferences.load();

  Future<void> update(AlertPreferences prefs) async {
    await prefs.save();
    state = prefs;
  }
}

final budgetAlertsRepositoryProvider = Provider<BudgetAlertsRepository>((ref) {
  return BudgetAlertsRepository(ref);
});

class BudgetAlertsRepository {
  BudgetAlertsRepository(this._ref);

  final Ref _ref;
  final _throttle = AlertThrottleStore();

  Stream<BudgetAlertsSnapshot> watchAlerts(String cycleKey) async* {
    final db = await _ref.read(databaseProvider.future);
    final budgetRepo = _ref.read(budgetRepositoryProvider);

    Future<BudgetAlertsSnapshot> compute() async {
      final prefs = _ref.read(alertPreferencesProvider);
      final plan = await budgetRepo.getPlanStatus(cycleKey);
      if (plan == null) {
        return BudgetAlertsSnapshot(
          cycleKey: cycleKey,
          groups: const [],
          allAlerts: const [],
          dailySummary: null,
          weeklySummary: null,
          newEscalations: const [],
        );
      }
      return _build(plan, prefs);
    }

    yield await compute();

    await for (final _ in db.expensesDao.watchSpendingChanges()) {
      yield await compute();
    }
  }

  BudgetAlertsSnapshot _build(BudgetPlanStatus plan, AlertPreferences prefs) {
    final cycleKey = plan.monthKey;
    final allAlerts = BudgetAlertEngine.generateAlerts(
      plan: plan,
      thresholds: prefs.thresholds,
    );
    final groups = BudgetAlertEngine.groupAlerts(allAlerts);

    final escalationCandidates = allAlerts
        .map(
          (a) => (
            item: a,
            bucketKey: a.bucketKey,
            threshold: a.thresholdPercent,
          ),
        )
        .toList();

    final newEscalations = _throttle.filterNewEscalations(
      cycleKey: cycleKey,
      candidates: escalationCandidates,
    );

    String? dailySummary;
    if (_throttle.shouldShowDailySummary(enabled: prefs.dailySummaryEnabled)) {
      dailySummary = BudgetAlertEngine.buildDailySummary(allAlerts);
    }

    String? weeklySummary;
    if (_throttle.shouldShowWeeklySummary(enabled: prefs.weeklySummaryEnabled)) {
      weeklySummary = BudgetAlertEngine.buildWeeklySummary(allAlerts);
    }

    return BudgetAlertsSnapshot(
      cycleKey: cycleKey,
      groups: groups,
      allAlerts: allAlerts,
      dailySummary: dailySummary,
      weeklySummary: weeklySummary,
      newEscalations: newEscalations,
    );
  }

  Future<void> deliverEscalations(
    BudgetAlertsSnapshot snapshot,
    AlertPreferences prefs,
  ) async {
    if (snapshot.newEscalations.isEmpty) return;

    for (final alert in snapshot.newEscalations) {
      await _throttle.markNotified(
        snapshot.cycleKey,
        alert.bucketKey,
        alert.thresholdPercent,
      );

      if (prefs.silentEnabled) {
        await BudgetNotificationService.instance.show(
          title: alert.title,
          body: alert.message,
          silent: true,
        );
      }

      if (prefs.pushEnabled && await _throttle.canSendPush()) {
        await BudgetNotificationService.instance.show(
          title: alert.title,
          body: '${alert.message} ${alert.suggestion}',
        );
        await _throttle.recordPush();
      }
    }
  }
}

final budgetAlertsProvider =
    StreamProvider.family<BudgetAlertsSnapshot, String>((ref, cycleKey) {
  return ref.watch(budgetAlertsRepositoryProvider).watchAlerts(cycleKey);
});
