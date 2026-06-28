import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/features/subscriptions/data/subscriptions_repository.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_engine.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_models.dart';

final subscriptionHealthRepositoryProvider =
    Provider<SubscriptionHealthRepository>((ref) {
  return SubscriptionHealthRepository(ref);
});

class SubscriptionHealthRepository {
  SubscriptionHealthRepository(this._ref);

  final Ref _ref;

  Future<SubscriptionHealthReport> buildHealthReport() async {
    final db = await _ref.read(databaseProvider.future);
    final cycleKey = _ref.read(selectedCycleKeyProvider);
    final subs = await db.subscriptionsDao.watchAllSubscriptions().first;
    final categories = await db.categoriesDao.getActiveCategories();
    final categoryNames = {for (final c in categories) c.id: c.name};
    final categoryColors = {for (final c in categories) c.id: c.colorValue};
    final salary = await db.salaryDao.getSalaryForMonth(cycleKey);
    final since = DateTime.now().subtract(const Duration(days: 365));
    final payments =
        await db.subscriptionsDao.listPaymentsSince(since.toUtc());

    return SubscriptionHealthEngine.build(
      subscriptions: subs,
      categoryNames: categoryNames,
      categoryColors: categoryColors,
      salaryPaise: salary?.amountPaise ?? 0,
      payments: payments,
    );
  }

  Stream<SubscriptionHealthReport> watchHealthReport() async* {
    final db = await _ref.read(databaseProvider.future);
    final cycleKey = _ref.read(selectedCycleKeyProvider);

    await for (final subs in db.subscriptionsDao.watchAllSubscriptions()) {
      final categories = await db.categoriesDao.getActiveCategories();
      final categoryNames = {
        for (final c in categories) c.id: c.name,
      };
      final categoryColors = {
        for (final c in categories) c.id: c.colorValue,
      };

      final salary = await db.salaryDao.getSalaryForMonth(cycleKey);
      final since = DateTime.now().subtract(const Duration(days: 365));
      final payments =
          await db.subscriptionsDao.listPaymentsSince(since.toUtc());

      yield SubscriptionHealthEngine.build(
        subscriptions: subs,
        categoryNames: categoryNames,
        categoryColors: categoryColors,
        salaryPaise: salary?.amountPaise ?? 0,
        payments: payments,
      );
    }
  }

  Future<void> pauseSubscription(int id) async {
    final dao = await _ref.read(subscriptionsDaoProvider.future);
    await dao.pauseSubscription(id);
  }

  Future<void> resumeSubscription(int id) async {
    final dao = await _ref.read(subscriptionsDaoProvider.future);
    await dao.resumeSubscription(id);
  }

  Future<int?> cancelSubscription(int id) async {
    return _ref.read(subscriptionsRepositoryProvider).cancelSubscription(id);
  }

  Future<void> setUsageFrequency(int id, String? frequency) async {
    final dao = await _ref.read(subscriptionsDaoProvider.future);
    await dao.updateUsageFrequency(id, frequency);
  }
}

final subscriptionHealthReportProvider =
    StreamProvider<SubscriptionHealthReport>((ref) {
  return ref.watch(subscriptionHealthRepositoryProvider).watchHealthReport();
});
