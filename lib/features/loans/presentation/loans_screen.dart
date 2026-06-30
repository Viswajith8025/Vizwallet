import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/skeleton_loader.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/empty_state.dart';
import 'package:rupee_track/core/widgets/error_state.dart';
import 'package:rupee_track/features/loans/data/loans_repository.dart';
import 'package:rupee_track/features/loans/presentation/add_loan_sheet.dart';
import 'package:rupee_track/features/loans/presentation/record_loan_payment_sheet.dart';

class LoansScreen extends ConsumerWidget {
  const LoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loansAsync = ref.watch(activeLoansProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Borrowed money',
        subtitle: 'Loans & repayments',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAddLoanSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add loan'),
      ),
      body: ResponsiveBody(
        child: loansAsync.when(
          loading: () => ListView.separated(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xxl,
            ),
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
            itemBuilder: (_, __) => const SkeletonCard(height: 88),
          ),
          error: (e, _) => ErrorState(
            message: 'We couldn\'t load your loans.',
            onRetry: () => ref.invalidate(activeLoansProvider),
          ),
          data: (loans) {
            if (loans.isEmpty) {
              return EmptyStates.loans(
                onAdd: () => showAddLoanSheet(context, ref),
              );
            }

            final now = DateTime.now().toUtc();

            return ListView.separated(
              padding: const EdgeInsets.only(
                top: AppSpacing.md,
                bottom: AppSpacing.xxl,
              ),
              itemCount: loans.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
              itemBuilder: (context, index) {
                final loan = loans[index];
                final isOverdue = loan.expectedReturnAt != null &&
                    loan.expectedReturnAt!.isBefore(now) &&
                    loan.status != 'returned';

                return PremiumCard(
                  onTap: loan.balancePaise > 0
                      ? () => showRecordLoanPaymentSheet(context, ref, loan)
                      : null,
                  accentColor: isOverdue
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
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
                            if (loan.expectedReturnAt != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Due ${loan.expectedReturnAt!.toLocal().toString().split(' ').first}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isOverdue
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
