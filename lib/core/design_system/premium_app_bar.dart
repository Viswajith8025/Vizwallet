import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/responsive.dart';
import 'package:rupee_track/core/widgets/theme_toggle_button.dart';
/// Consistent screen app bar — transparent, bold title, optional subtitle.
class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PremiumAppBar({
    required this.title,
    super.key,
    this.subtitle,
    this.actions,
    this.leading,
    this.centerTitle = false,
  });

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 72 : kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final horizontal = AppResponsive.horizontalPadding(
      MediaQuery.sizeOf(context).width,
    );
    final appBarActions = [
      ...?actions,
      const ThemeToggleButton(),
    ];
    final titleWidget = subtitle == null
        ? Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle!,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          );

    return AppBar(
      toolbarHeight: subtitle != null ? 72 : kToolbarHeight,
      titleSpacing: leading == null ? 0 : null,
      leading: leading,
      automaticallyImplyLeading: leading == null,
      centerTitle: centerTitle,
      actions: appBarActions,
      title: centerTitle
          ? titleWidget
          : Padding(
              padding: EdgeInsets.only(left: leading == null ? horizontal : 0),
              child: titleWidget,
            ),
    );
  }
}

/// Standard horizontal padding for scrollable screens.
class PremiumScreenBody extends StatelessWidget {
  const PremiumScreenBody({
    required this.child,
    super.key,
    this.bottomPadding = 100,
  });

  final Widget child;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBody(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: child,
      ),
    );
  }
}