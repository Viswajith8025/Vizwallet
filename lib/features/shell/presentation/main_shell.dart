import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/design_system/premium_bottom_nav.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/features/quick_add/presentation/quick_add_fab.dart';

class MainShell extends ConsumerWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  static const _destinations = [
    PremiumNavDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    PremiumNavDestination(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
      label: 'Expenses',
    ),
    PremiumNavDestination(
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights_rounded,
      label: 'Insights',
    ),
    PremiumNavDestination(
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view_rounded,
      label: 'More',
    ),
  ];

  int _indexForLocation(String location) {
    if (location.startsWith(AppRoutes.expenses)) return 1;
    if (location.startsWith(AppRoutes.insights)) return 2;
    if (location.startsWith(AppRoutes.more)) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexForLocation(location);

    return Scaffold(
      extendBody: true,
      body: child,
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 88),
        child: QuickAddFab(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: PremiumBottomNav(
        selectedIndex: index,
        destinations: _destinations,
        onSelected: (i) {
          switch (i) {
            case 0:
              context.go(AppRoutes.home);
            case 1:
              context.go(AppRoutes.expenses);
            case 2:
              context.go(AppRoutes.insights);
            case 3:
              context.go(AppRoutes.more);
          }
        },
      ),
    );
  }
}
