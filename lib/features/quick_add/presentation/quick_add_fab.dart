import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/features/quick_add/presentation/quick_add_hub_sheet.dart';

class QuickAddFab extends ConsumerStatefulWidget {
  const QuickAddFab({super.key});

  @override
  ConsumerState<QuickAddFab> createState() => _QuickAddFabState();
}

class _QuickAddFabState extends ConsumerState<QuickAddFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    await _pulse.reverse();
    if (!mounted) return;
    await showQuickAddSheet(context, ref);
    if (mounted) await _pulse.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ScaleTransition(
      scale: _pulse,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.fab),
          boxShadow: AppShadows.fab(isDark),
        ),
        child: FloatingActionButton(
          elevation: 0,
          highlightElevation: 0,
          onPressed: _open,
          tooltip: 'Quick Add',
          child: const Icon(Icons.add_rounded, size: 26),
        ),
      ),
    );
  }
}
