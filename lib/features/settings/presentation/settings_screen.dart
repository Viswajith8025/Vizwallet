import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/shell_bottom_inset.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/core/providers/settings_provider.dart';
import 'package:rupee_track/features/budget_alerts/presentation/widgets/budget_alert_settings.dart';
import 'package:rupee_track/features/settings/presentation/widgets/salary_cycle_settings.dart';
import 'package:rupee_track/features/app_lock/presentation/widgets/app_lock_settings_card.dart';
import 'package:rupee_track/features/auth/presentation/widgets/cloud_account_panel.dart';
import 'package:rupee_track/features/settings/presentation/widgets/app_management_settings_card.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'Settings',
        subtitle: 'Preferences & data',
      ),
      body: ResponsiveBody(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            ShellBottomInset.scrollBottom(context),
          ),
          children: [
            PremiumCard(
              variant: PremiumCardVariant.elevated,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Appearance',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Light feels calm · Dark feels luxurious',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                        icon: Icon(Icons.brightness_auto_rounded),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                        icon: Icon(Icons.light_mode_rounded),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Dark'),
                        icon: Icon(Icons.dark_mode_rounded),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (set) {
                      ref
                          .read(themeModeProvider.notifier)
                          .setThemeMode(set.first);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppLockSettingsCard(),
            const SizedBox(height: AppSpacing.lg),
            const SalaryCycleSettings(),
            const SizedBox(height: AppSpacing.lg),
            const BudgetAlertSettings(),
            const SizedBox(height: AppSpacing.lg),
            const CloudAccountPanel(),
            const SizedBox(height: AppSpacing.lg),
            const AppManagementSettingsCard(),
            const SizedBox(height: AppSpacing.lg),
            PremiumMenuTile(
              icon: Icons.help_outline_rounded,
              title: 'Help & support',
              subtitle: 'Answers to common questions',
              onTap: () => context.push(AppRoutes.helpSupport),
            ),
            PremiumMenuTile(
              icon: Icons.info_outline_rounded,
              title: 'About ${AppConstants.appName}',
              subtitle: 'Version, mission & brand',
              onTap: () => context.push(AppRoutes.about),
            ),
          ],
        ),
      ),
    );
  }
}
