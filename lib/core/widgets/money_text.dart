import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_typography.dart';
import 'package:rupee_track/core/utils/money_utils.dart';

class MoneyText extends StatelessWidget {
  const MoneyText(
    this.paise, {
    super.key,
    this.style,
    this.showPaise = false,
    this.color,
    this.compact = false,
  });

  final int paise;
  final TextStyle? style;
  final bool showPaise;
  final Color? color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatPaise(paise, showPaise: showPaise),
      style: style ??
          BrandTypography.money(
            context,
            fontSize: compact ? 18 : 22,
            color: color,
          ),
    );
  }
}
