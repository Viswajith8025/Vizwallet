import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/database/daos/budget_dao.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';
import 'package:rupee_track/features/budget/domain/budget_engine.dart';
import 'package:rupee_track/features/budget/domain/budget_templates.dart';
import 'package:rupee_track/features/budget/domain/bucket_status.dart';

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref);
});

class BudgetRepository {
  BudgetRepository(this._ref);

  final Ref _ref;

  Stream<BudgetPlanStatus?> watchPlanStatus(String monthKey) async* {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();

    await for (final plan in db.budgetDao.watchPlanForMonth(monthKey)) {
      if (plan == null) {
        yield null;
        continue;
      }
      yield await _buildStatus(
        db: db,
        plan: plan,
        monthKey: monthKey,
        salaryDay: settings.salaryDay,
      );
    }
  }

  Future<BudgetPlanStatus?> getPlanStatus(String monthKey) async {
    final db = await _ref.read(databaseProvider.future);
    final plan = await db.budgetDao.getPlanForMonth(monthKey);
    if (plan == null) return null;
    final settings = await db.settingsDao.getSettings();
    return _buildStatus(
      db: db,
      plan: plan,
      monthKey: monthKey,
      salaryDay: settings.salaryDay,
    );
  }

  Future<void> saveBudgetPlan({
    required String monthKey,
    required int salaryPaise,
    required AllocationMode mode,
    required bool rolloverEnabled,
    required List<BucketAllocationInput> allocations,
    String? aiNotes,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    await db.salaryDao.upsertSalary(
      monthKey: monthKey,
      amountPaise: salaryPaise,
      receivedAt: DateTime.now().toUtc(),
    );

    final planId = await db.budgetDao.upsertPlan(
      monthKey: monthKey,
      salaryPaise: salaryPaise,
      allocationMode: mode.storageKey,
      rolloverEnabled: rolloverEnabled,
      aiNotes: aiNotes,
    );

    final companions = allocations
        .map(
          (a) => BudgetBucketsTableCompanion.insert(
            planId: planId,
            bucketKey: a.bucketKey,
            displayName: a.displayName,
            categoryId: Value(a.categoryId),
            bucketType: Value(a.bucketType.storageKey),
            allocatedPaise: a.allocatedPaise,
            allocatedPercent: Value(a.allocatedPercent),
            rolloverPaise: Value(a.rolloverPaise),
            sortOrder: Value(a.sortOrder),
          ),
        )
        .toList();

    await db.budgetDao.replaceBuckets(planId: planId, buckets: companions);
  }

  Future<List<BucketAllocationInput>> buildAllocationsForMode({
    required AllocationMode mode,
    required int salaryPaise,
    required String monthKey,
    required bool rolloverEnabled,
    List<BucketAllocationInput>? manualInputs,
  }) async {
    final db = await _ref.read(databaseProvider.future);
    final slugToId = await _categorySlugMap(db);
    var allocations = switch (mode) {
      AllocationMode.percentage => BudgetEngine.fromPercentageTemplate(
          salaryPaise: salaryPaise,
          categorySlugToId: slugToId,
        ),
      AllocationMode.manual => manualInputs ?? [],
      AllocationMode.aiSuggested => await _aiAllocations(
          db: db,
          salaryPaise: salaryPaise,
          slugToId: slugToId,
        ),
    };

    if (rolloverEnabled) {
      final settings = await db.settingsDao.getSettings();
      final previousKey = previousCycleKey(
        monthKey,
        salaryDay: settings.salaryDay,
      );
      final previous = await getPlanStatus(previousKey);
      if (previous != null) {
        final remaining = {
          for (final b in previous.buckets)
            b.bucketKey: b.remainingPaise.clamp(0, 1 << 31),
        };
        allocations = BudgetEngine.applyRollover(
          allocations: allocations,
          previousRemainingByBucketKey: remaining,
        );
      }
    }

    return allocations;
  }

  Future<List<BucketAllocationInput>> _aiAllocations({
    required AppDatabase db,
    required int salaryPaise,
    required Map<String, int> slugToId,
  }) async {
    final settings = await db.settingsDao.getSettings();
    final months = recentCycleKeys(salaryDay: settings.salaryDay, count: 3);
    final avgSpend = await db.expensesDao.averageSpendByCategorySlug(months);
    final allocations = BudgetEngine.suggestAiAllocation(
      salaryPaise: salaryPaise,
      avgSpendBySlug: avgSpend,
      categorySlugToId: slugToId,
    );
    return allocations;
  }

  Future<String> buildAiNotes() async {
    final db = await _ref.read(databaseProvider.future);
    final settings = await db.settingsDao.getSettings();
    final months = recentCycleKeys(salaryDay: settings.salaryDay, count: 3);
    final avgSpend = await db.expensesDao.averageSpendByCategorySlug(months);
    return avgSpend.isEmpty
        ? 'Using default template — add expenses for smarter suggestions.'
        : 'Based on your last ${months.length} months of spending.';
  }

  Future<BudgetPlanStatus> _buildStatus({
    required AppDatabase db,
    required BudgetPlansTableData plan,
    required String monthKey,
    required int salaryDay,
  }) async {
    final buckets = await db.budgetDao.getBucketsForPlan(plan.id);
    final spentByCategory = await db.expensesDao.sumByCategoryForMonth(monthKey);
    final daysRemaining = daysRemainingInCycle(salaryDay: salaryDay);

    final allocations = buckets
        .map(
          (b) => BucketAllocationInput(
            bucketKey: b.bucketKey,
            displayName: b.displayName,
            categoryId: b.categoryId,
            bucketType: BucketType.fromKey(b.bucketType),
            allocatedPaise: b.allocatedPaise,
            allocatedPercent: b.allocatedPercent,
            rolloverPaise: b.rolloverPaise,
            sortOrder: b.sortOrder,
          ),
        )
        .toList();

    final statuses = BudgetEngine.computeBucketStatuses(
      allocations: allocations,
      spentByCategoryId: spentByCategory,
      daysRemaining: daysRemaining,
    );

    final planStatus = BudgetPlanStatus(
      monthKey: monthKey,
      salaryPaise: plan.salaryPaise,
      allocationMode: AllocationMode.fromKey(plan.allocationMode),
      rolloverEnabled: plan.rolloverEnabled,
      buckets: statuses,
      insights: [],
      aiNotes: plan.aiNotes,
    );

    return BudgetPlanStatus(
      monthKey: planStatus.monthKey,
      salaryPaise: planStatus.salaryPaise,
      allocationMode: planStatus.allocationMode,
      rolloverEnabled: planStatus.rolloverEnabled,
      buckets: planStatus.buckets,
      insights: BudgetEngine.generateInsights(planStatus),
      aiNotes: plan.aiNotes,
    );
  }

  Future<Map<String, int>> _categorySlugMap(AppDatabase db) async {
    final categories = await db.categoriesDao.getActiveCategories();
    return {for (final c in categories) c.slug: c.id};
  }
}

final budgetPlanStatusProvider =
    StreamProvider.family<BudgetPlanStatus?, String>((ref, monthKey) {
  final repo = ref.watch(budgetRepositoryProvider);
  return repo.watchPlanStatus(monthKey);
});

final budgetDaoProvider = FutureProvider<BudgetDao>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return db.budgetDao;
});
