import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/providers/settings_provider.dart';
import 'package:rupee_track/core/router/app_router.dart';
import 'package:rupee_track/core/design_system/app_scroll_behavior.dart';
import 'package:rupee_track/core/theme/app_theme.dart';
import 'package:rupee_track/features/app_lock/presentation/app_lock_gate.dart';
import 'package:rupee_track/features/splash/presentation/splash_screen.dart';

class VisWalletApp extends ConsumerStatefulWidget {
  const VisWalletApp({super.key});

  @override
  ConsumerState<VisWalletApp> createState() => _VisWalletAppState();
}

class _VisWalletAppState extends ConsumerState<VisWalletApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) {
      return MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        scrollBehavior: const AppScrollBehavior(),
        home: const SplashScreen(),
      );
    }

    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      scrollBehavior: const AppScrollBehavior(),
      routerConfig: router,
      builder: (context, child) =>
          AppLockGate(child: child ?? const SizedBox.shrink()),
    );
  }
}
