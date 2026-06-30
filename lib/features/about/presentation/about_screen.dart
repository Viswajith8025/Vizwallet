import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rupee_track/core/branding/vis_wallet_logo.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/widgets/legal_links.dart';

final packageInfoProvider = FutureProvider<PackageInfo>((ref) async {
  return PackageInfo.fromPlatform();
});

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final infoAsync = ref.watch(packageInfoProvider);

    return Scaffold(
      appBar: const PremiumAppBar(title: 'About'),
      body: ResponsiveBody(
        child: ListView(
          padding: const EdgeInsets.only(
            top: AppSpacing.lg,
            bottom: AppSpacing.xxl,
          ),
          children: [
            const Center(child: VisWalletLogo(size: 72, showShadow: true)),
            const SizedBox(height: AppSpacing.lg),
            const Center(child: VisWalletWordmark(fontSize: 26)),
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: infoAsync.when(
                loading: () => Text(
                  'Loading version…',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                error: (_, __) => Text(
                  'Version unavailable',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                data: (info) => Text(
                  'Version ${info.version} (${info.buildNumber})',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              AppConstants.appTagline,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Built for clarity',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${AppConstants.appName} helps you understand where every rupee goes — '
                      'expenses, subscriptions, loans, and savings — in under '
                      '30 seconds a day.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const LegalLinksSection(),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '© ${DateTime.now().year} ${AppConstants.appName}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
