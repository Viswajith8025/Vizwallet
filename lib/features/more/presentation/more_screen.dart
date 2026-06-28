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
        subtitle: 'Reports, help, and settings',
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          top: AppSpacing.sm,
          bottom: AppSpacing.lg,
        ),
        children: [
          PremiumMenuTile(
            icon: Icons.calendar_month_rounded,
            title: 'Financial calendar',
            subtitle: 'Your money timeline — salary, bills, goals & more',
            onTap: () => context.push(AppRoutes.calendar),
          ),
          PremiumMenuTile(
            icon: Icons.search_rounded,
            title: 'Search',
            subtitle: 'Find expenses, goals, subscriptions & more',
            onTap: () => context.push(AppRoutes.search),
          ),
          PremiumMenuTile(
            icon: Icons.grid_on_rounded,
            title: 'Expense heatmap',
            subtitle: 'GitHub-style view of your spending habits',
            onTap: () => context.push(AppRoutes.expenseHeatmap),
          ),
          PremiumMenuTile(
            icon: Icons.trending_up_rounded,
            title: 'Savings Forecast',
            subtitle: 'See where your money is headed',
            onTap: () => context.push(AppRoutes.savingsForecast),
          ),
          PremiumMenuTile(
            icon: Icons.auto_awesome_rounded,
            title: 'AI Monthly Review',
            subtitle: 'Your Spotify Wrapped for personal finance',
            onTap: () => context.push(AppRoutes.monthlyReport),
          ),
          PremiumMenuTile(
            icon: Icons.category_outlined,
            title: 'Category budgets',
            subtitle: 'Set a limit for Food, Travel, Bills, and more',
            onTap: () => context.push(AppRoutes.categoryBudget),
          ),
          PremiumMenuTile(
            icon: Icons.pie_chart_outline,
            title: 'Budget planner',
            subtitle: 'Split salary into spending groups',
            onTap: () => context.push(AppRoutes.budget),
          ),
          PremiumMenuTile(
            icon: Icons.history_rounded,
            title: 'Activity history',
            subtitle: 'Full audit trail with undo support',
            onTap: () => context.push(AppRoutes.activityHistory),
          ),
          PremiumMenuTile(
            icon: Icons.delete_sweep_outlined,
            title: 'Recycle bin',
            subtitle: 'Restore deleted expenses, loans & more',
            onTap: () => context.push(AppRoutes.recycleBin),
          ),
          const SizedBox(height: AppSpacing.md),
          PremiumMenuTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & support',
            subtitle: 'Answers to common questions',
            onTap: () => context.push(AppRoutes.helpSupport),
          ),
          PremiumMenuTile(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Theme, salary date, alerts, and account',
            onTap: () => context.push(AppRoutes.settings),
          ),
        ],
      ),
    );
  }
}
