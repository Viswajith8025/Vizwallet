import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/branding/vis_wallet_logo.dart';
import 'package:rupee_track/core/constants/app_constants.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/features/app_lock/data/app_lock_provider.dart';
import 'package:rupee_track/features/app_lock/data/app_lock_service.dart';

class AppLockScreen extends ConsumerStatefulWidget {
  const AppLockScreen({super.key});

  @override
  ConsumerState<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends ConsumerState<AppLockScreen> {
  final _pinController = TextEditingController();
  String? _error;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometricIfEnabled());
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _tryBiometricIfEnabled() async {
    final lockState = ref.read(appLockProvider);
    if (!lockState.biometricEnabled || !lockState.biometricAvailable) return;
    await _tryBiometric();
  }

  Future<void> _tryBiometric() async {
    final service = ref.read(appLockServiceProvider);
    final ok = await service.authenticateWithBiometrics();
    if (ok && mounted) {
      ref.read(appLockProvider.notifier).unlock();
    }
  }

  Future<void> _submitPin() async {
    final pin = _pinController.text.trim();
    if (pin.length < 4) {
      setState(() => _error = 'Enter your PIN');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    final service = ref.read(appLockServiceProvider);
    final ok = await service.verifyPin(pin);

    if (!mounted) return;

    if (ok) {
      HapticFeedback.lightImpact();
      ref.read(appLockProvider.notifier).unlock();
      _pinController.clear();
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _error = 'Incorrect PIN';
        _submitting = false;
      });
      _pinController.clear();
      return;
    }

    setState(() => _submitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lockState = ref.watch(appLockProvider);
    final showBiometric =
        lockState.biometricEnabled && lockState.biometricAvailable;

    return Material(
      color: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(),
              const VisWalletLogo(size: 56),
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppConstants.appName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter your PIN to continue',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 6,
                textInputAction: TextInputAction.done,
                enabled: !_submitting,
                decoration: InputDecoration(
                  labelText: 'PIN',
                  errorText: _error,
                  counterText: '',
                ),
                onSubmitted: (_) => _submitPin(),
              ),
              const SizedBox(height: AppSpacing.md),
              FilledButton(
                onPressed: _submitting ? null : _submitPin,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(_submitting ? 'Checking…' : 'Unlock'),
                ),
              ),
              if (showBiometric) ...[
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: _submitting ? null : _tryBiometric,
                  icon: const Icon(Icons.fingerprint_rounded),
                  label: const Text('Use biometrics'),
                ),
              ],
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
