import 'package:flutter/material.dart';
import 'package:rupee_track/core/branding/brand_colors.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';

class EmptyState extends StatefulWidget {
  const EmptyState({
    required this.title,
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.accentColor,
  });

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;
  final Color? accentColor;

  @override
  State<EmptyState> createState() => _EmptyStateState();
}

class _EmptyStateState extends State<EmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.slow,
    );
    _fade = CurvedAnimation(parent: _controller, curve: AppCurves.enter);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: AppCurves.enter));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = widget.accentColor ?? theme.colorScheme.primary;

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxxl,
              vertical: AppSpacing.xxl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.xl),
                    border: Border.all(
                      color: accent.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Icon(widget.icon, size: 42, color: accent),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  widget.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.message != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.message!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.55,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                if (widget.action != null) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  widget.action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Branded empty states for common screens.
abstract final class EmptyStates {
  static Widget expenses({required VoidCallback onAdd}) {
    return Builder(
      builder: (context) => EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No expenses yet',
        message:
            'Add the money you spend, one entry at a time.\nStart with your latest purchase.',
        accentColor: BrandColors.accentLight,
        action: FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded, size: 20),
          label: const Text('Add expense'),
        ),
      ),
    );
  }

  static Widget subscriptions({VoidCallback? onAdd}) {
    return EmptyState(
      icon: Icons.subscriptions_outlined,
      title: 'No subscriptions yet',
      message:
          'Add monthly payments like Netflix, Spotify, internet, or recharge plans.\nVizwallet will track what is coming.',
      accentColor: BrandColors.accentLight,
      action: onAdd == null
          ? null
          : FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add subscription'),
            ),
    );
  }

  static Widget loans({VoidCallback? onAdd}) {
    return EmptyState(
      icon: Icons.handshake_outlined,
      title: 'No borrowed money',
      message:
          'Track money you borrowed from someone or lent to someone.\nYou will always know what is pending.',
      accentColor: BrandColors.primaryLightDeep,
      action: onAdd == null
          ? null
          : FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('Add loan'),
            ),
    );
  }
}
