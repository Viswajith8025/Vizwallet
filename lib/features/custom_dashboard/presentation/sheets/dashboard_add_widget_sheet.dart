import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/features/custom_dashboard/data/dashboard_layout_repository.dart';
import 'package:rupee_track/features/custom_dashboard/domain/dashboard_layout_models.dart';

Future<void> showDashboardAddWidgetSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.88,
    child: const _DashboardAddWidgetSheet(),
  );
}

class _DashboardAddWidgetSheet extends ConsumerWidget {
  const _DashboardAddWidgetSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(dashboardLayoutProvider);
    final existing = layout.widgets.map((w) => w.type).toSet();
    final theme = Theme.of(context);

    return ListView(
      padding: AppResponsive.screenPadding(context, bottom: AppSpacing.xl),
      children: [
        Text(
          'Add widget',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Build your financial command center',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        ...DashboardWidgetCatalog.allTypes.map((type) {
          final already = existing.contains(type);
          return ListTile(
            leading: Icon(DashboardWidgetCatalog.icon(type)),
            title: Text(DashboardWidgetCatalog.label(type)),
            trailing: already
                ? Text(
                    'Added',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : const Icon(Icons.add_circle_outline),
            onTap: already
                ? null
                : () {
                    ref.read(dashboardLayoutProvider.notifier).addWidget(type);
                    Navigator.pop(context);
                  },
          );
        }),
      ],
    );
  }
}
