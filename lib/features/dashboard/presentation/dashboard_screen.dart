import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/branding/vis_wallet_logo.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/widgets/theme_toggle_button.dart';
import 'package:rupee_track/features/custom_dashboard/data/dashboard_layout_repository.dart';
import 'package:rupee_track/features/custom_dashboard/presentation/sheets/dashboard_add_widget_sheet.dart';
import 'package:rupee_track/features/custom_dashboard/presentation/sheets/dashboard_widget_edit_sheet.dart';
import 'package:rupee_track/features/custom_dashboard/presentation/widgets/dashboard_canvas.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editMode = ref.watch(dashboardEditModeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const VisWalletLogo(size: 28),
            const SizedBox(width: 10),
            Text(AppConstants.appName, style: theme.textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            tooltip: editMode ? 'Done editing' : 'Customize dashboard',
            icon: Icon(editMode ? Icons.check_rounded : Icons.dashboard_customize_outlined),
            onPressed: () {
              final next = !editMode;
              ref.read(dashboardEditModeProvider.notifier).state = next;
            },
          ),
          if (editMode)
            IconButton(
              tooltip: 'Add widget',
              icon: const Icon(Icons.add_box_outlined),
              onPressed: () => showDashboardAddWidgetSheet(context, ref),
            ),
          if (editMode)
            IconButton(
              tooltip: 'Dashboard settings',
              icon: const Icon(Icons.tune_rounded),
              onPressed: () => showDashboardCustomizeSheet(context, ref),
            ),
          const ThemeToggleButton(),
        ],
      ),
      body: ResponsiveBody(child: const DashboardCanvas()),
    );
  }
}
