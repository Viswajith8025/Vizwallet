import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/features/activity_history/data/activity_log_service.dart';
import 'package:rupee_track/features/activity_history/domain/activity_models.dart';

final subscriptionsRepositoryProvider = Provider<SubscriptionsRepository>((ref) {
  return SubscriptionsRepository(ref);
});

class SubscriptionsRepository {
  SubscriptionsRepository(this._ref);

  final Ref _ref;

  Stream<List<SubscriptionsTableData>> watchActiveSubscriptions() async* {
    final dao = await _ref.read(subscriptionsDaoProvider.future);
    yield* dao.watchActiveSubscriptions();
  }

  Stream<List<SubscriptionsTableData>> watchAllSubscriptions() async* {
    final dao = await _ref.read(subscriptionsDaoProvider.future);
    yield* dao.watchAllSubscriptions();
  }

  Future<void> addSubscription({
    required String name,
    required int amountPaise,
    String billingCycle = 'monthly',
    DateTime? nextRenewalAt,
    int? categoryId,
    String paymentMethod = 'Auto Debit',
    String? notes,
    String? usageFrequency,
  }) async {
    final dao = await _ref.read(subscriptionsDaoProvider.future);

    final id = await dao.insertSubscription(
      SubscriptionsTableCompanion.insert(
        name: name.trim(),
        amountPaise: amountPaise,
        categoryId: Value(categoryId),
        billingCycle: Value(billingCycle),
        nextRenewalAt: Value(nextRenewalAt),
        paymentMethod: Value(paymentMethod),
        notes: Value(notes?.trim()),
        usageFrequency: Value(usageFrequency),
        status: const Value('active'),
        isActive: const Value(true),
      ),
    );
    await _ref.read(activityLogServiceProvider).log(
          action: ActivityAction.created,
          module: ActivityModule.subscription,
          entityId: id,
          entityLabel: name.trim(),
          newValue: {'amountPaise': amountPaise},
        );
  }

  Future<int?> cancelSubscription(int id) async {
    final dao = await _ref.read(subscriptionsDaoProvider.future);
    final existing = await dao.getSubscriptionById(id);
    await dao.deactivateSubscription(id);
    if (existing == null) return null;
    return _ref.read(activityLogServiceProvider).log(
          action: ActivityAction.cancelled,
          module: ActivityModule.subscription,
          entityId: id,
          entityLabel: existing.name,
          isUndoable: true,
          oldValue: {'status': existing.status},
          severity: ActivitySeverity.warning,
        );
  }

  Future<void> pauseSubscription(int id) async {
    final dao = await _ref.read(subscriptionsDaoProvider.future);
    await dao.pauseSubscription(id);
  }

  Future<void> resumeSubscription(int id) async {
    final dao = await _ref.read(subscriptionsDaoProvider.future);
    await dao.resumeSubscription(id);
  }
}

final activeSubscriptionsProvider =
    StreamProvider<List<SubscriptionsTableData>>((ref) {
  return ref.watch(subscriptionsRepositoryProvider).watchActiveSubscriptions();
});

final allSubscriptionsProvider =
    StreamProvider<List<SubscriptionsTableData>>((ref) {
  return ref.watch(subscriptionsRepositoryProvider).watchAllSubscriptions();
});
