import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/core/branding/vis_wallet_logo.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/providers/database_provider.dart';
import 'package:rupee_track/core/providers/salary_cycle_provider.dart';
import 'package:rupee_track/core/providers/supabase_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/utils/money_utils.dart';
import 'package:rupee_track/core/widgets/theme_toggle_button.dart';

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salaryController = useTextEditingController();
    final page = useState(0);
    final isSaving = useState(false);
    final theme = Theme.of(context);
    final user = ref.watch(currentUserProvider);

    useEffect(
      () {
        if (user != null) page.value = 1;
        return null;
      },
      [user?.id],
    );

    Future<void> finishOnboarding({bool saveSalary = false}) async {
      if (isSaving.value) return;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Create an account or sign in before continuing.'),
          ),
        );
        return;
      }
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final short = AppResponsive.isShortScreen(context);
            final logoSize = short ? 64.0 : 80.0;
            final wordmarkSize = short ? 26.0 : 30.0;

            return SingleChildScrollView(
              padding: EdgeInsets.all(
                AppResponsive.horizontalPadding(constraints.maxWidth),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight -
                      MediaQuery.paddingOf(context).vertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: ThemeToggleButton(),
                    ),
                    SizedBox(height: short ? AppSpacing.xl : AppSpacing.xxxl),
                    Center(
                      child: VisWalletLogo(size: logoSize, showShadow: true),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Center(
                      child: VisWalletWordmark(fontSize: wordmarkSize),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      switch (page.value) {
                        0 =>
                          'Create your account once. You stay signed in until you choose to log out.',
                        _ =>
                          'Add your monthly salary so Viswallet can show how much you can spend each day.',
                      },
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: short ? AppSpacing.xl : AppSpacing.xxxl),
              if (page.value == 1) ...[
                if (user != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.58),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: theme.colorScheme.primary
                            .withValues(alpha: 0.16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.verified_user_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Signed in as ${user.email ?? 'your account'}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
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
                FilledButton.icon(
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
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () async {
                    final signedIn = await context.push<bool>(AppRoutes.auth);
                    if (signedIn == true && context.mounted) {
                      page.value = 1;
                    }
                  },
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Already have an account? Sign in'),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your money data stays on this phone. Your account keeps you signed in.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
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
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'You can add it anytime from Home → Salary tile or Settings → Monthly salary.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
              ],
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
