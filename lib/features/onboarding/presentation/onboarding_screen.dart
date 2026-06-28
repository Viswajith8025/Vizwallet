import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/core/branding/vis_wallet_logo.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/money_utils.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salaryController = useTextEditingController();
    final page = useState(0);
    final isSaving = useState(false);
    final theme = Theme.of(context);

    Future<void> finishOnboarding({bool saveSalary = false}) async {
      if (isSaving.value) return;
      isSaving.value = true;
      try {
        if (saveSalary) {
          final amount = rupeesToPaise(salaryController.text);
          if (amount > 0) {
            final cycleKey = ref.read(selectedCycleKeyProvider);
            final dao = await ref.read(salaryDaoProvider.future);
            await dao.upsertSalary(
              monthKey: cycleKey,
              amountPaise: amount,
              receivedAt: DateTime.now().toUtc(),
            );
          }
        }

        await sharedPreferences.setBool(
          AppConstants.onboardingCompleteKey,
          true,
        );

        if (context.mounted) {
          context.go(AppRoutes.home);
        }
      } finally {
        isSaving.value = false;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(child: VisWalletLogo(size: 80, showShadow: true)),
              const SizedBox(height: AppSpacing.xl),
              const Center(child: VisWalletWordmark(fontSize: 30)),
              const SizedBox(height: AppSpacing.md),
              Text(
                switch (page.value) {
                  0 => AppConstants.appTagline,
                  _ =>
                    'Set your monthly salary to unlock savings insights and daily spending limits.',
                },
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              if (page.value == 1) ...[
                TextField(
                  controller: salaryController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Monthly salary',
                    prefixText: '₹ ',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (page.value == 0) ...[
                FilledButton(
                  onPressed: () => page.value = 1,
                  child: const Text('Continue'),
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () async {
                    final signedIn =
                        await context.push<bool>('${AppRoutes.auth}?signup=1');
                    if (signedIn == true && context.mounted) {
                      page.value = 1;
                    }
                  },
                  icon: const Icon(Icons.person_add_outlined),
                  label: const Text('Create account'),
                ),
                const SizedBox(height: AppSpacing.xs),
                TextButton(
                  onPressed: () => context.push(AppRoutes.auth),
                  child: const Text('Already have an account? Sign in'),
                ),
              ] else ...[
                FilledButton(
                  onPressed: isSaving.value
                      ? null
                      : () => finishOnboarding(saveSalary: true),
                  child: isSaving.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Get started'),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: isSaving.value
                      ? null
                      : () => finishOnboarding(saveSalary: false),
                  child: const Text('Skip salary for now'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
