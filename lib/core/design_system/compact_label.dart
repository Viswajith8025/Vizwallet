import 'package:flutter/material.dart';

/// Single-line label for rows and list tiles.
class SingleLineLabel extends StatelessWidget {
  const SingleLineLabel(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: style,
    );
  }
}

/// Shrinks text to fit instead of wrapping in tight grid cells and metric cards.
class FittingLabel extends StatelessWidget {
  const FittingLabel(
    this.text, {
    super.key,
    this.style,
    this.alignment = Alignment.centerLeft,
    this.maxLines = 1,
  });

  final String text;
  final TextStyle? style;
  final Alignment alignment;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignment,
      child: Text(
        text,
        maxLines: maxLines,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}
