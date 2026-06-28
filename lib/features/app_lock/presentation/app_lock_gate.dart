import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/features/app_lock/data/app_lock_provider.dart';
import 'package:rupee_track/features/app_lock/presentation/app_lock_screen.dart';

/// Blocks the app when PIN lock is enabled until the user unlocks.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Lock when backgrounded; avoid `inactive` so biometric prompts don't re-lock.
    if (state == AppLifecycleState.paused) {
      ref.read(appLockProvider.notifier).lock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lockState = ref.watch(appLockProvider);

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (lockState.shouldShowLock)
          const Positioned.fill(child: AppLockScreen()),
      ],
    );
  }
}
