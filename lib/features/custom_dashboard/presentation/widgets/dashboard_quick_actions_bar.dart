import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/app_scroll_behavior.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/features/quick_add/presentation/quick_add_hub_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardQuickActionsBar extends ConsumerWidget {
  const DashboardQuickActionsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppHorizontalScrollRow(
      padding: EdgeInsets.zero,
      children: [
        _QuickAction(
          icon: Icons.add_rounded,
          label: 'Expense',
          onTap: () => showQuickAddSheet(context, ref),
        ),
        _QuickAction(
          icon: Icons.payments_outlined,
          label: 'Income',
          onTap: () => context.push(AppRoutes.salary),
        ),
        _QuickAction(
          icon: Icons.calendar_month_outlined,
          label: 'Calendar',
          onTap: () => context.push(AppRoutes.calendar),
        ),
        _QuickAction(
          icon: Icons.search_rounded,
          label: 'Search',
          onTap: () => context.push(AppRoutes.search),
        ),
        _QuickAction(
          icon: Icons.subscriptions_outlined,
          label: 'Subs',
          onTap: () => context.push(AppRoutes.subscriptions),
        ),
        _QuickAction(
          icon: Icons.favorite_border,
          label: 'Wishlist',
          onTap: () => context.push(AppRoutes.more),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ActionChip(
        avatar: Icon(icon, size: 18, color: theme.colorScheme.primary),
        label: Text(label),
        onPressed: onTap,
      ),
    );
  }
}
