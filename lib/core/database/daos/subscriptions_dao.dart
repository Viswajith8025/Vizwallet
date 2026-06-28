import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';

part 'subscriptions_dao.g.dart';

@DriftAccessor(tables: [SubscriptionsTable, SubscriptionPaymentsTable])
class SubscriptionsDao extends DatabaseAccessor<AppDatabase>
    with _$SubscriptionsDaoMixin {
  SubscriptionsDao(super.db);

  Stream<List<SubscriptionsTableData>> watchActiveSubscriptions() {
    return (select(subscriptionsTable)
          ..where((t) => t.status.equals('active'))
          ..orderBy([(t) => OrderingTerm.asc(t.nextRenewalAt)]))
        .watch();
  }

  Stream<List<SubscriptionsTableData>> watchAllSubscriptions() {
    return (select(subscriptionsTable)
          ..orderBy([(t) => OrderingTerm.asc(t.nextRenewalAt)]))
        .watch();
  }

  Future<int> monthlyTotalPaise({bool activeOnly = true}) async {
    final query = select(subscriptionsTable);
    if (activeOnly) {
      query.where((t) => t.status.equals('active'));
    } else {
      query.where((t) => t.status.isNotIn(['cancelled']));
    }
    final subs = await query.get();

    return subs.fold<int>(0, (total, sub) => total + monthlyEquivalentPaise(sub));
  }

  Future<int> yearlyTotalPaise({bool activeOnly = true}) async {
    final monthly = await monthlyTotalPaise(activeOnly: activeOnly);
    return monthly * 12;
  }

  static int monthlyEquivalentPaise(SubscriptionsTableData sub) {
    if (sub.billingCycle == 'yearly') {
      return (sub.amountPaise / 12).round();
    }
    if (sub.billingCycle == 'weekly') {
      return (sub.amountPaise * 52 / 12).round();
    }
    return sub.amountPaise;
  }

  static int yearlyEquivalentPaise(SubscriptionsTableData sub) {
    return monthlyEquivalentPaise(sub) * 12;
  }

  Future<List<SubscriptionsTableData>> upcomingRenewals({int days = 7}) {
    final now = DateTime.now().toUtc();
    final until = now.add(Duration(days: days));
    return (select(subscriptionsTable)
          ..where((t) => t.status.equals('active'))
          ..where((t) => t.nextRenewalAt.isBiggerOrEqualValue(now))
          ..where((t) => t.nextRenewalAt.isSmallerOrEqualValue(until)))
        .get();
  }

  Future<List<SubscriptionPaymentsTableData>> listPaymentsSince(
    DateTime since,
  ) {
    return (select(subscriptionPaymentsTable)
          ..where((t) => t.paidAt.isBiggerOrEqualValue(since))
          ..orderBy([(t) => OrderingTerm.asc(t.paidAt)]))
        .get();
  }

  Future<int> insertSubscription(SubscriptionsTableCompanion subscription) {
    return into(subscriptionsTable).insert(subscription);
  }

  Future<void> deactivateSubscription(int id) {
    return _setStatus(id, 'cancelled');
  }

  Future<void> pauseSubscription(int id) => _setStatus(id, 'paused');

  Future<void> resumeSubscription(int id) => _setStatus(id, 'active');

  Future<SubscriptionsTableData?> getSubscriptionById(int id) {
    return (select(subscriptionsTable)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Stream<List<SubscriptionsTableData>> watchCancelledSubscriptions() {
    return (select(subscriptionsTable)
          ..where((t) => t.status.equals('cancelled'))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Future<bool> permanentDeleteSubscription(int id) {
    return (delete(subscriptionsTable)..where((t) => t.id.equals(id)))
        .go()
        .then((count) => count > 0);
  }

  Future<void> updateUsageFrequency(int id, String? frequency) {
    return (update(subscriptionsTable)..where((t) => t.id.equals(id))).write(
      SubscriptionsTableCompanion(
        usageFrequency: Value(frequency),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> _setStatus(int id, String status) {
    return (update(subscriptionsTable)..where((t) => t.id.equals(id))).write(
      SubscriptionsTableCompanion(
        status: Value(status),
        isActive: Value(status == 'active'),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}
