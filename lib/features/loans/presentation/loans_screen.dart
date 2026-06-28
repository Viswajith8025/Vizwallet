import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/database/app_database.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/empty_state.dart';

final loansStreamProvider = StreamProvider<List<LoansTableData>>((ref) async* {
  final dao = await ref.watch(loansDaoProvider.future);
  yield* dao.watchActiveLoans();
});

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(loansStreamProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Borrowed money',
        subtitle: 'Loans & repayments',
      ),
      body: loansAsync.when(
        loading: () => ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: 5,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
          itemBuilder: (_, __) => const SkeletonCard(height: 88),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (loans) {
          if (loans.isEmpty) {
            return EmptyStates.loans();
          }

          final now = DateTime.now().toUtc();

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: loans.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
            itemBuilder: (context, index) {
              final loan = loans[index];
              final isOverdue = loan.expectedReturnAt != null &&
                  loan.expectedReturnAt!.isBefore(now) &&
                  loan.status != 'returned';

              return PremiumCard(
                accentColor:
                    isOverdue ? theme.colorScheme.error : theme.colorScheme.primary,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loan.personName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${loan.status} · ${loan.reason ?? 'No reason'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (isOverdue)
                            Text(
                              'Overdue',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      formatPaise(loan.balancePaise),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
