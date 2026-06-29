import 'package:flutter/material.dart';

/// Subtle scale feedback for premium micro-interactions.
class PressableScale extends StatefulWidget {
  const PressableScale({
    required this.child,
    super.key,
    this.onTap,
    this.scale = 0.97,
    this.semanticLabel,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final String? semanticLabel;
  final bool enabled;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final interactive = widget.enabled && widget.onTap != null;

    Widget content = AnimatedScale(
      scale: _pressed && interactive ? widget.scale : 1,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: widget.child,
    );

    if (widget.semanticLabel != null) {
      content = Semantics(
        button: true,
        enabled: interactive,
        label: widget.semanticLabel,
        child: content,
      );
    }

    return GestureDetector(
      onTapDown: interactive ? (_) => setState(() => _pressed = true) : null,
      onTapUp: interactive ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: interactive ? () => setState(() => _pressed = false) : null,
      onTap: interactive ? widget.onTap : null,
      child: content,
    );
  }
}
