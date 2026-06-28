import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/premium_bottom_nav.dart';

class PremiumSideNav extends StatelessWidget {
  const PremiumSideNav({
    required this.selectedIndex,
    required this.onSelected,
    required this.destinations,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<PremiumNavDestination> destinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: onSelected,
      labelType: NavigationRailLabelType.all,
      backgroundColor: theme.scaffoldBackgroundColor,
      indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.12),
      selectedIconTheme: IconThemeData(color: theme.colorScheme.primary),
      selectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      ),
      unselectedIconTheme: IconThemeData(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      unselectedLabelTextStyle: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      destinations: destinations
          .map(
            (dest) => NavigationRailDestination(
              icon: Icon(dest.icon),
              selectedIcon: Icon(dest.selectedIcon),
              label: Text(dest.label),
            ),
          )
          .toList(),
    );
  }
}
