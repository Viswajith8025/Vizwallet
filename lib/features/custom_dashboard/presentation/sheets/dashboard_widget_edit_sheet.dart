import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_sheet.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/features/custom_dashboard/data/dashboard_layout_repository.dart';
import 'package:rupee_track/features/custom_dashboard/domain/dashboard_layout_models.dart';
import 'package:rupee_track/features/custom_dashboard/presentation/sheets/dashboard_add_widget_sheet.dart';
import 'package:rupee_track/features/custom_dashboard/presentation/sheets/dashboard_template_sheet.dart';

Future<void> showDashboardWidgetEditSheet(
  BuildContext context,
  WidgetRef ref,
  DashboardWidgetInstance instance,
) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.72,
    child: _DashboardWidgetEditSheet(instance: instance),
  );
}

class _DashboardWidgetEditSheet extends ConsumerWidget {
  const _DashboardWidgetEditSheet({required this.instance});

  final DashboardWidgetInstance instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final notifier = ref.read(dashboardLayoutProvider.notifier);

    return ListView(
      padding: AppResponsive.screenPadding(context, bottom: AppSpacing.xl),
      children: [
        Text(
          DashboardWidgetCatalog.label(instance.type),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Size', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<DashboardWidgetSize>(
          segments: const [
            ButtonSegment(
              value: DashboardWidgetSize.compact,
              label: Text('Compact'),
            ),
            ButtonSegment(
              value: DashboardWidgetSize.standard,
              label: Text('Standard'),
            ),
            ButtonSegment(
              value: DashboardWidgetSize.large,
              label: Text('Large'),
            ),
          ],
          selected: {instance.size},
          onSelectionChanged: (v) {
            notifier.updateWidget(instance.copyWith(size: v.first));
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        SwitchListTile(
          title: const Text('Pin to full width'),
          value: instance.pinned,
          onChanged: (_) {
            notifier.togglePinned(instance.id);
            Navigator.pop(context);
          },
        ),
        SwitchListTile(
          title: const Text('Collapsed'),
          value: instance.collapsed,
          onChanged: (_) {
            notifier.toggleCollapsed(instance.id);
            Navigator.pop(context);
          },
        ),
        SwitchListTile(
          title: const Text('Glass effect'),
          value: instance.glassEffect,
          onChanged: (v) {
            notifier.updateWidget(instance.copyWith(glassEffect: v));
          },
        ),
        ListTile(
          title: const Text('Transparency'),
          subtitle: Slider(
            value: instance.transparency,
            min: 0.5,
            max: 1,
            onChanged: (v) {
              notifier.updateWidget(instance.copyWith(transparency: v));
            },
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.content_copy_outlined),
          title: const Text('Duplicate'),
          onTap: () {
            notifier.duplicateWidget(instance.id);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(Icons.visibility_off_outlined),
          title: const Text('Hide'),
          onTap: () {
            notifier.hideWidget(instance.id);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline, color: theme.colorScheme.error),
          title: Text('Remove', style: TextStyle(color: theme.colorScheme.error)),
          onTap: () {
            notifier.removeWidget(instance.id);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

Future<void> showDashboardCustomizeSheet(BuildContext context, WidgetRef ref) {
  return showPremiumBottomSheet<void>(
    context: context,
    initialSize: 0.85,
    child: _DashboardCustomizeSheet(),
  );
}

class _DashboardCustomizeSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(dashboardLayoutProvider);
    final notifier = ref.read(dashboardLayoutProvider.notifier);
    final theme = Theme.of(context);

    return ListView(
      padding: AppResponsive.screenPadding(context, bottom: AppSpacing.xl),
      children: [
        Text(
          'Customize dashboard',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Layout', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          children: DashboardLayoutMode.values.map((mode) {
            final selected = layout.layoutMode == mode;
            return FilterChip(
              selected: selected,
              label: Text(_layoutLabel(mode)),
              onSelected: (_) => notifier.setLayoutMode(mode),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Theme', style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: DashboardThemePreset.values.map((t) {
            return FilterChip(
              selected: layout.theme == t,
              label: Text(_themeLabel(t)),
              onSelected: (_) => notifier.setTheme(t),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Density', style: theme.textTheme.titleSmall),
        SegmentedButton<DashboardDensity>(
          segments: const [
            ButtonSegment(value: DashboardDensity.compact, label: Text('Compact')),
            ButtonSegment(
              value: DashboardDensity.comfortable,
              label: Text('Comfortable'),
            ),
          ],
          selected: {layout.density},
          onSelectionChanged: (v) => notifier.setDensity(v.first),
        ),
        const SizedBox(height: AppSpacing.lg),
        ListTile(
          leading: const Icon(Icons.widgets_outlined),
          title: const Text('Add widget'),
          onTap: () {
            Navigator.pop(context);
            showDashboardAddWidgetSheet(context, ref);
          },
        ),
        ListTile(
          leading: const Icon(Icons.dashboard_customize_outlined),
          title: const Text('Apply template'),
          onTap: () {
            Navigator.pop(context);
            showDashboardTemplateSheet(context, ref);
          },
        ),
        ListTile(
          leading: const Icon(Icons.restore_rounded),
          title: const Text('Restore defaults'),
          onTap: () {
            notifier.restoreDefaults();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  String _layoutLabel(DashboardLayoutMode mode) => switch (mode) {
        DashboardLayoutMode.singleColumn => '1 column',
        DashboardLayoutMode.twoColumn => '2 columns',
        DashboardLayoutMode.grid => 'Grid',
        DashboardLayoutMode.adaptive => 'Adaptive',
      };

  String _themeLabel(DashboardThemePreset t) => switch (t) {
        DashboardThemePreset.minimal => 'Minimal',
        DashboardThemePreset.professional => 'Professional',
        DashboardThemePreset.analytics => 'Analytics',
        DashboardThemePreset.goalsFocused => 'Goals',
        DashboardThemePreset.budgetFocused => 'Budget',
        DashboardThemePreset.student => 'Student',
        DashboardThemePreset.business => 'Business',
        DashboardThemePreset.custom => 'Custom',
      };
}
