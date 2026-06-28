import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/utils/date_utils.dart';
import 'package:rupee_track/core/utils/money_utils.dart';

class SalaryScreen extends HookConsumerWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cycleKey = ref.watch(selectedCycleKeyProvider);
    final salaryDay = ref.watch(salaryDayProvider);
    final amountController = useTextEditingController();
    final isSaving = useState(false);
    final isLoaded = useState(false);

    final salaryAsync = ref.watch(_salaryForMonthProvider(cycleKey));

    salaryAsync.whenData((salary) {
      if (!isLoaded.value && salary != null) {
        amountController.text =
            paiseToRupees(salary.amountPaise).round().toString();
        isLoaded.value = true;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly salary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              formatCycleLabel(cycleKey, salaryDay: salaryDay),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Salary for this cycle anchors budgets, reports, and daily allowance.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monthly salary',
                prefixText: '₹ ',
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: isSaving.value
                  ? null
                  : () async {
                      final amount = rupeesToPaise(amountController.text);
                      if (amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Enter valid salary')),
                        );
                        return;
                      }
                      isSaving.value = true;
                      try {
                        final dao = await ref.read(salaryDaoProvider.future);
                        await dao.upsertSalary(
                          monthKey: cycleKey,
                          amountPaise: amount,
                          receivedAt: DateTime.now().toUtc(),
                        );
                        ref.invalidate(_salaryForMonthProvider(cycleKey));
                        if (context.mounted) {
                          context.pop();
                          context.push(AppRoutes.budgetSetup);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Salary saved — set up your budget'),
                            ),
                          );
                        }
                      } finally {
                        isSaving.value = false;
                      }
                    },
              child: Text(isSaving.value ? 'Saving...' : 'Save salary'),
            ),
          ],
        ),
      ),
    );
  }
}

final _salaryForMonthProvider =
    FutureProvider.family<dynamic, String>((ref, monthKey) async {
  final dao = await ref.watch(salaryDaoProvider.future);
  return dao.getSalaryForMonth(monthKey);
});
