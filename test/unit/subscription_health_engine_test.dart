import 'package:flutter_test/flutter_test.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_engine.dart';
import 'package:rupee_track/features/subscriptions/domain/subscription_health_models.dart';

void main() {
  SubscriptionsTableData sub({
    required int id,
    required String name,
    int amountPaise = 49900,
    String billingCycle = 'monthly',
    String status = 'active',
    bool isActive = true,
    String? usageFrequency,
    int? categoryId,
    DateTime? nextRenewalAt,
    DateTime? createdAt,
  }) {
    final now = DateTime.utc(2026, 6, 1);
    return SubscriptionsTableData(
      id: id,
      name: name,
      amountPaise: amountPaise,
      categoryId: categoryId,
      billingCycle: billingCycle,
      billingIntervalDays: null,
      nextRenewalAt: nextRenewalAt,
      paymentMethod: 'Auto Debit',
      isActive: isActive,
      status: status,
      usageFrequency: usageFrequency,
      notes: null,
      createdAt: createdAt ?? now,
      updatedAt: now,
    );
  }

  group('SubscriptionHealthEngine', () {
    test('computes monthly and yearly totals from active subs only', () {
      final report = SubscriptionHealthEngine.build(
        subscriptions: [
          sub(id: 1, name: 'Netflix', amountPaise: 64900),
          sub(id: 2, name: 'Spotify', amountPaise: 11900),
          sub(
            id: 3,
            name: 'Old gym',
            status: 'cancelled',
            isActive: false,
          ),
        ],
        categoryNames: const {6: 'Entertainment'},
        categoryColors: const {6: 0xFFE91E63},
        salaryPaise: 5000000,
        now: DateTime(2026, 6, 15),
      );

      expect(report.overview.activeCount, 2);
      expect(report.overview.cancelledCount, 1);
      expect(report.overview.monthlyTotalPaise, 64900 + 11900);
      expect(report.overview.yearlyTotalPaise, (64900 + 11900) * 12);
    });

    test('detects entertainment overlap and generates insights', () {
      final report = SubscriptionHealthEngine.build(
        subscriptions: [
          sub(id: 1, name: 'Netflix', categoryId: 6),
          sub(id: 2, name: 'Amazon Prime', categoryId: 6),
          sub(id: 3, name: 'Disney+ Hotstar', categoryId: 6),
        ],
        categoryNames: const {6: 'Entertainment'},
        categoryColors: const {6: 0xFFE91E63},
        salaryPaise: 10000000,
        now: DateTime(2026, 6, 15),
      );

      expect(report.overlapGroups['entertainment']?.length, 3);
      expect(
        report.insights.any((i) => i.message.contains('entertainment')),
        isTrue,
      );
      expect(
        report.suggestions.any(
          (s) => s.action == SubscriptionSuggestionAction.combineServices,
        ),
        isTrue,
      );
    });

    test('flags unused subscriptions in health score', () {
      final report = SubscriptionHealthEngine.build(
        subscriptions: [
          sub(id: 1, name: 'Unused app', usageFrequency: 'never'),
          sub(id: 2, name: 'Daily tool', usageFrequency: 'daily'),
        ],
        categoryNames: const {},
        categoryColors: const {},
        salaryPaise: 8000000,
        now: DateTime(2026, 6, 15),
      );

      final unusedCard = report.cards.firstWhere((c) => c.id == 1);
      expect(unusedCard.health, SubscriptionCardHealth.unused);
      expect(
        report.healthScore.factors.any((f) => f.name == 'Unused services'),
        isTrue,
      );
    });

    test('buckets renewals into timeline sections', () {
      final today = DateTime(2026, 6, 15, 12);
      final report = SubscriptionHealthEngine.build(
        subscriptions: [
          sub(
            id: 1,
            name: 'Today sub',
            nextRenewalAt: DateTime.utc(2026, 6, 15),
          ),
          sub(
            id: 2,
            name: 'This week',
            nextRenewalAt: DateTime.utc(2026, 6, 18),
          ),
        ],
        categoryNames: const {},
        categoryColors: const {},
        salaryPaise: 5000000,
        now: today,
      );

      expect(report.renewalTimeline, isNotEmpty);
      expect(
        report.renewalTimeline.any(
          (e) => e.bucket == RenewalTimelineBucket.today,
        ),
        isTrue,
      );
    });

    test('income share insight reflects salary', () {
      final report = SubscriptionHealthEngine.build(
        subscriptions: [
          sub(id: 1, name: 'Big sub', amountPaise: 100000),
        ],
        categoryNames: const {},
        categoryColors: const {},
        salaryPaise: 500000,
        now: DateTime(2026, 6, 15),
      );

      expect(report.incomeSharePercent, greaterThan(15));
      expect(
        report.insights.first.message,
        contains('% of your salary'),
      );
    });
  });
}
