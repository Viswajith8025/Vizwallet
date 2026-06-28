import 'package:drift/drift.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/tables.dart';

part 'subscriptions_dao.g.dart';

@DriftAccessor(tables: [SubscriptionsTable])
class SubscriptionsDao extends DatabaseAccessor<AppDatabase>
    with _$SubscriptionsDaoMixin {
  SubscriptionsDao(super.db);

  Stream<List<SubscriptionsTableData>> watchActiveSubscriptions() {
    return (select(subscriptionsTable)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.nextRenewalAt)]))
        .watch();
  }

  Future<int> monthlyTotalPaise() async {
    final subs = await (select(subscriptionsTable)
          ..where((t) => t.isActive.equals(true)))
        .get();

    return subs.fold<int>(0, (total, sub) {
      if (sub.billingCycle == 'yearly') {
        return total + (sub.amountPaise / 12).round();
      }
      return total + sub.amountPaise;
    });
  }

  Future<List<SubscriptionsTableData>> upcomingRenewals({int days = 7}) {
    final now = DateTime.now().toUtc();
    final until = now.add(Duration(days: days));
    return (select(subscriptionsTable)
          ..where((t) => t.isActive.equals(true))
          ..where((t) => t.nextRenewalAt.isBiggerOrEqualValue(now))
          ..where((t) => t.nextRenewalAt.isSmallerOrEqualValue(until)))
        .get();
  }
}
