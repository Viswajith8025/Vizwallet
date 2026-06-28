import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/features/custom_dashboard/data/dashboard_layout_repository.dart';
import 'package:rupee_track/features/custom_dashboard/domain/dashboard_templates.dart';

Future<void> showDashboardTemplateSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.75,
    child: const _DashboardTemplateSheet(),
  );
}

class _DashboardTemplateSheet extends ConsumerWidget {
  const _DashboardTemplateSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ListView(
      padding: AppResponsive.screenPadding(context, bottom: AppSpacing.xl),
      children: [
        Text(
          'Dashboard templates',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Start from a layout tuned to your lifestyle',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...DashboardTemplates.presets.map((preset) {
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              title: Text(preset.label),
              subtitle: Text(
                '${preset.config.widgets.length} widgets · '
                '${preset.config.layoutMode.name}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ref
                    .read(dashboardLayoutProvider.notifier)
                    .applyTemplate(preset.config);
                Navigator.pop(context);
              },
            ),
          );
        }),
      ],
    );
  }
}
