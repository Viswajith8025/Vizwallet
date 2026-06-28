import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_typography.dart';
import 'package:rupee_track/core/utils/money_utils.dart';

/// Animated money display with tabular figures and smooth count-up.
class AnimatedMoneyText extends StatelessWidget {
  const AnimatedMoneyText(
    this.paise, {
    super.key,
    this.style,
    this.color,
    this.showPaise = false,
    this.duration = const Duration(milliseconds: 600),
  });

  final int paise;
  final TextStyle? style;
  final Color? color;
  final bool showPaise;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final textStyle = style ??
        BrandTypography.money(context, color: color);

    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: paise),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Text(
          formatPaise(value, showPaise: showPaise),
          style: textStyle,
        );
      },
    );
  }
}
