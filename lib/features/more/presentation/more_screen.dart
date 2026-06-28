import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_app_bar.dart';
import 'package:rupee_track/core/design_system/premium_list_tile.dart';
import 'package:rupee_track/core/router/routes.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PremiumAppBar(
        title: 'More',
        subtitle: 'Tools & settings',
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: 100),
        children: [
          PremiumMenuTile(
            icon: Icons.subscriptions_outlined,
            title: 'Subscriptions',
            subtitle: 'Recurring payments & renewals',
            onTap: () => context.push(AppRoutes.subscriptions),
          ),
          PremiumMenuTile(
            icon: Icons.handshake_outlined,
            title: 'Borrowed money',
            subtitle: 'Track loans & repayments',
            onTap: () => context.push(AppRoutes.loans),
          ),
          PremiumMenuTile(
            icon: Icons.favorite_outline,
            title: 'Financial health',
            subtitle: 'Wellness score & suggestions',
            onTap: () => context.push(AppRoutes.financialHealth),
          ),
          PremiumMenuTile(
            icon: Icons.notifications_outlined,
            title: 'Budget alerts',
            subtitle: 'Thresholds & notification preferences',
            onTap: () => context.push(AppRoutes.budgetAlerts),
          ),
          PremiumMenuTile(
            icon: Icons.description_outlined,
            title: 'Monthly closing report',
            subtitle: 'Statement, trends & exports',
            onTap: () => context.push(AppRoutes.monthlyReport),
          ),
          PremiumMenuTile(
            icon: Icons.pie_chart_outline,
            title: 'Budget planner',
            subtitle: 'Allocate salary & track buckets',
            onTap: () => context.push(AppRoutes.budget),
          ),
          PremiumMenuTile(
            icon: Icons.payments_outlined,
            title: 'Monthly salary',
            subtitle: 'Set salary for current month',
            onTap: () => context.push(AppRoutes.salary),
          ),
          const SizedBox(height: AppSpacing.md),
          PremiumMenuTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Theme, cloud account & preferences',
            onTap: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}
