import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/theme_toggle_button.dart';
import 'package:rupee_track/features/budget/data/budget_repository.dart';
import 'package:rupee_track/features/budget/domain/allocation_mode.dart';
import 'package:rupee_track/features/budget/domain/budget_templates.dart';
import 'package:rupee_track/features/dashboard/data/dashboard_repository.dart';

class BudgetSetupScreen extends HookConsumerWidget {
  const BudgetSetupScreen({super.key, this.initialSalaryPaise});

  final int? initialSalaryPaise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final salaryDay = ref.watch(salaryDayProvider);
    final step = useState(0);
    final mode = useState(AllocationMode.percentage);
    final rollover = useState(true);
    final isSaving = useState(false);
    final salaryController = useTextEditingController(
      text: initialSalaryPaise != null
          ? paiseToRupees(initialSalaryPaise!).round().toString()
          : '',
    );
    final allocations = useState<List<BucketAllocationInput>>([]);
    final isLoadingAlloc = useState(false);

    useEffect(() {
      if (initialSalaryPaise != null) return null;
      Future<void> prefillSalary() async {
        if (salaryController.text.trim().isNotEmpty) return;
        final dao = await ref.read(salaryDaoProvider.future);
        final inflow = await dao.getTotalCycleInflowPaise(cycleKey);
        if (inflow > 0) {
          salaryController.text = paiseToRupees(inflow).round().toString();
        }
      }

      prefillSalary();
      return null;
    }, [cycleKey]);

    Future<void> loadAllocations() async {
      final salary = rupeesToPaise(salaryController.text);
      if (salary <= 0) return;
      isLoadingAlloc.value = true;
      try {
        final list = await ref.read(budgetRepositoryProvider).buildAllocationsForMode(
              mode: mode.value,
              salaryPaise: salary,
              monthKey: cycleKey,
              rolloverEnabled: rollover.value,
              manualInputs: allocations.value.isNotEmpty ? allocations.value : null,
            );
        allocations.value = list;
      } finally {
        isLoadingAlloc.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up your budget'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: const [ThemeToggleButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            formatCycleLabel(cycleKey, salaryDay: salaryDay),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tell Viswallet how you want to divide your salary. We will track each expense against the right spending group.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          if (step.value == 0) ...[
            TextField(
              controller: salaryController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monthly salary',
                prefixText: '₹ ',
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'How should we split your salary?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...AllocationMode.values.map(
              (m) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ModeCard(
                  mode: m,
                  selected: mode.value == m,
                  onTap: () => mode.value = m,
                ),
              ),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Carry forward money left over'),
              subtitle: const Text(
                'If you do not spend a group fully, add the leftover to next month.',
              ),
              value: rollover.value,
              onChanged: (v) => rollover.value = v,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                final salary = rupeesToPaise(salaryController.text);
                if (salary <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Enter a valid salary')),
                  );
                  return;
                }
                if (mode.value == AllocationMode.perCategory) {
                  if (context.mounted) {
                    context.push(AppRoutes.categoryBudget);
                  }
                  return;
                }
                await loadAllocations();
                step.value = 1;
              },
              child: const Text('Continue'),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Check your salary split',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (mode.value == AllocationMode.aiSuggested)
                  TextButton(
                    onPressed: isLoadingAlloc.value ? null : loadAllocations,
                    child: const Text('Suggest again'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (isLoadingAlloc.value)
              const Center(child: CircularProgressIndicator())
            else
              ...allocations.value.map(
                (a) => _AllocationTile(
                  allocation: a,
                  salaryPaise: rupeesToPaise(salaryController.text),
                  editable: mode.value != AllocationMode.aiSuggested,
                  onChanged: (updated) {
                    final list = [...allocations.value];
                    final i = list.indexWhere((b) => b.bucketKey == a.bucketKey);
                    if (i >= 0) list[i] = updated;
                    allocations.value = list;
                  },
                ),
              ),
            const SizedBox(height: 16),
            _TotalRow(
              salaryPaise: rupeesToPaise(salaryController.text),
              allocated: allocations.value.fold<int>(
                0,
                (s, b) => s + b.allocatedPaise + b.rolloverPaise,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => step.value = 0,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: isSaving.value
                        ? null
                        : () async {
                            final salary = rupeesToPaise(salaryController.text);
                            if (salary <= 0) return;
                            final allocated = allocations.value.fold<int>(
                              0,
                              (s, b) => s + b.allocatedPaise + b.rolloverPaise,
                            );
                            if (allocated > salary) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Planned amounts cannot exceed your salary',
                                    ),
                                  ),
                                );
                              }
                              return;
                            }
                            isSaving.value = true;
                            try {
                              final aiNotes = mode.value == AllocationMode.aiSuggested
                                  ? await ref
                                      .read(budgetRepositoryProvider)
                                      .buildAiNotes()
                                  : null;
                              await ref
                                  .read(budgetRepositoryProvider)
                                  .saveBudgetPlan(
                                    monthKey: cycleKey,
                                    salaryPaise: salary,
                                    mode: mode.value,
                                    rolloverEnabled: rollover.value,
                                    allocations: allocations.value,
                                    aiNotes: aiNotes,
                                  );
                              ref.invalidate(budgetPlanStatusProvider(cycleKey));
                              ref.invalidate(monthlySummaryProvider(cycleKey));
                              if (context.mounted) {
                                context.go(AppRoutes.budget);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Budget plan saved'),
                                  ),
                                );
                              }
                            } finally {
                              isSaving.value = false;
                            }
                          },
                    child: Text(isSaving.value ? 'Saving...' : 'Save my budget'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final AllocationMode mode;
  final bool selected;
  final VoidCallback onTap;

  String get _subtitle => switch (mode) {
        AllocationMode.manual => 'You choose the exact rupee amount for each group.',
        AllocationMode.percentage =>
          'Beginner-friendly: divide salary using simple percentages.',
        AllocationMode.perCategory =>
          'Set a separate monthly limit for each category.',
        AllocationMode.aiSuggested =>
          'Viswallet suggests a split from your spending habits.',
      };

  IconData get _icon => switch (mode) {
        AllocationMode.manual => Icons.edit_outlined,
        AllocationMode.percentage => Icons.pie_chart_outline,
        AllocationMode.perCategory => Icons.category_outlined,
        AllocationMode.aiSuggested => Icons.auto_awesome,
      };

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: selected ? scheme.primaryContainer.withValues(alpha: 0.35) : null,
      child: ListTile(
        leading: Icon(_icon, color: selected ? scheme.primary : null),
        title: Text(mode.label),
        subtitle: Text(_subtitle),
        trailing: selected ? Icon(Icons.check_circle, color: scheme.primary) : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class _AllocationTile extends StatelessWidget {
  const _AllocationTile({
    required this.allocation,
    required this.salaryPaise,
    required this.editable,
    required this.onChanged,
  });

  final BucketAllocationInput allocation;
  final int salaryPaise;
  final bool editable;
  final ValueChanged<BucketAllocationInput> onChanged;

  @override
  Widget build(BuildContext context) {
    final percent = salaryPaise > 0
        ? (allocation.allocatedPaise / salaryPaise * 100).toStringAsFixed(1)
        : '0';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(allocation.displayName),
                  Text(
                    '$percent%${allocation.rolloverPaise > 0 ? ' · +${formatPaise(allocation.rolloverPaise)} from last month' : ''}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (editable)
              Flexible(
                flex: 2,
                child: TextFormField(
                  initialValue:
                      paiseToRupees(allocation.allocatedPaise).round().toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '₹',
                    isDense: true,
                  ),
                  onChanged: (v) {
                    onChanged(
                      BucketAllocationInput(
                        bucketKey: allocation.bucketKey,
                        displayName: allocation.displayName,
                        categoryId: allocation.categoryId,
                        bucketType: allocation.bucketType,
                        allocatedPaise: rupeesToPaise(v),
                        allocatedPercent: allocation.allocatedPercent,
                        rolloverPaise: allocation.rolloverPaise,
                        sortOrder: allocation.sortOrder,
                      ),
                    );
                  },
                ),
              )
            else
              Text(
                formatPaise(allocation.allocatedPaise),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.salaryPaise, required this.allocated});

  final int salaryPaise;
  final int allocated;

  @override
  Widget build(BuildContext context) {
    final diff = salaryPaise - allocated;
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total planned', style: theme.textTheme.titleSmall),
        Text(
          '${formatPaise(allocated)} / ${formatPaise(salaryPaise)}',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: diff < 0 ? theme.colorScheme.error : null,
          ),
        ),
      ],
    );
  }
}
