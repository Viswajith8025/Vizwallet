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
  DateTime? _pausedAt;
  static const _lockAfterBackground = Duration(minutes: 2);

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
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
      return;
    }
    if (state == AppLifecycleState.resumed && _pausedAt != null) {
      final away = DateTime.now().difference(_pausedAt!);
      if (away >= _lockAfterBackground) {
        ref.read(appLockProvider.notifier).lock();
      }
      _pausedAt = null;
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
