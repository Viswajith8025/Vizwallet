import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/bootstrap.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_bottom_nav.dart';
import 'package:rupee_track/core/design_system/premium_side_nav.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/design_system/shell_bottom_inset.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/features/quick_add/presentation/quick_add_fab.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  static const _fabXKey = 'quick_add_fab_x';
  static const _fabYKey = 'quick_add_fab_y';
  static const _fabSize = 56.0;
  static const _edgePadding = AppSpacing.md;

  static double _bottomClearance(
    BuildContext context, {
    required bool hasBottomNav,
  }) =>
      ShellBottomInset.of(context, hasBottomNav: hasBottomNav) + _fabSize / 2;

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
      icon: Icons.auto_awesome_outlined,
      selectedIcon: Icons.auto_awesome_rounded,
      label: 'Jithu',
    ),
    PremiumNavDestination(
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view_rounded,
      label: 'More',
    ),
  ];

  Offset? _fabOffset;

  @override
  void initState() {
    super.initState();
    final x = sharedPreferences.getDouble(_fabXKey);
    final y = sharedPreferences.getDouble(_fabYKey);
    if (x != null && y != null) {
      _fabOffset = Offset(x, y);
    }
  }

  int _indexForLocation(String location) {
    if (location.startsWith(AppRoutes.expenses)) return 1;
    if (location.startsWith(AppRoutes.insights)) return 2;
    if (location.startsWith(AppRoutes.jithu)) return 3;
    if (location.startsWith(AppRoutes.more)) return 4;
    return 0;
  }

  void _onNavSelected(BuildContext context, int i) {
    switch (i) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.expenses);
      case 2:
        context.go(AppRoutes.insights);
      case 3:
        context.go(AppRoutes.jithu);
      case 4:
        context.go(AppRoutes.more);
    }
  }

  Widget _buildShellBody(BuildContext context, Size size, {required bool hasBottomNav}) {
    final bottomInset = ShellBottomInset.of(context, hasBottomNav: hasBottomNav);
    final offset = _clampFabOffset(
      context,
      _fabOffset ?? _defaultFabOffset(context, size, hasBottomNav: hasBottomNav),
      size,
      hasBottomNav: hasBottomNav,
    );

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: widget.child,
        ),
        Positioned(
          left: offset.dx,
          top: offset.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _fabOffset = _clampFabOffset(
                  context,
                  offset + details.delta,
                  size,
                  hasBottomNav: hasBottomNav,
                );
              });
            },
            onPanEnd: (_) {
              final saved = _clampFabOffset(
                context,
                _fabOffset ?? offset,
                size,
                hasBottomNav: hasBottomNav,
              );
              _saveFabOffset(saved);
            },
            child: const QuickAddFab(),
          ),
        ),
      ],
    );
  }

  Offset _defaultFabOffset(
    BuildContext context,
    Size size, {
    required bool hasBottomNav,
  }) {
    final clearance = _bottomClearance(context, hasBottomNav: hasBottomNav);
    return Offset(
      size.width - _fabSize - _edgePadding,
      size.height - _fabSize - clearance,
    );
  }

  Offset _clampFabOffset(
    BuildContext context,
    Offset offset,
    Size size, {
    required bool hasBottomNav,
  }) {
    final clearance = _bottomClearance(context, hasBottomNav: hasBottomNav);
    final maxX = size.width - _fabSize - _edgePadding;
    final maxY = size.height - _fabSize - clearance;
    return Offset(
      offset.dx.clamp(_edgePadding, maxX),
      offset.dy.clamp(_edgePadding, maxY),
    );
  }

  Future<void> _saveFabOffset(Offset offset) async {
    await sharedPreferences.setDouble(_fabXKey, offset.dx);
    await sharedPreferences.setDouble(_fabYKey, offset.dy);
  }

  Future<void> _handleBackPress(BuildContext context, int tabIndex) async {
    if (tabIndex != 0) {
      context.go(AppRoutes.home);
      return;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit Vizwallet?'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );

    if (shouldExit == true && context.mounted) {
      SystemNavigator.pop();
    }
  }

  Widget _wrapWithExitGuard(BuildContext context, int tabIndex, Widget child) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBackPress(context, tabIndex);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexForLocation(location);
    final useRail = AppResponsive.isMediumOrWider(context);

    if (useRail) {
      return _wrapWithExitGuard(
        context,
        index,
        Scaffold(
          body: Row(
            children: [
              PremiumSideNav(
                selectedIndex: index,
                destinations: _destinations,
                onSelected: (i) => _onNavSelected(context, i),
              ),
              const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return _buildShellBody(
                      context,
                      constraints.biggest,
                      hasBottomNav: false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _wrapWithExitGuard(
      context,
      index,
      Scaffold(
        extendBody: true,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return _buildShellBody(
              context,
              constraints.biggest,
              hasBottomNav: true,
            );
          },
        ),
        bottomNavigationBar: PremiumBottomNav(
          selectedIndex: index,
          destinations: _destinations,
          onSelected: (i) => _onNavSelected(context, i),
        ),
      ),
    );
  }
}
