import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';

/// App-wide scroll behavior: touch scrolling + visible scrollbars.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return Scrollbar(
      controller: details.controller,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      radius: const Radius.circular(8),
      child: child,
    );
  }
}

/// Horizontal chip/action row with padding and a visible scrollbar.
class AppHorizontalScrollRow extends StatelessWidget {
  const AppHorizontalScrollRow({
    required this.children,
    super.key,
    this.padding,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
        child: Row(children: children),
      ),
    );
  }
}
