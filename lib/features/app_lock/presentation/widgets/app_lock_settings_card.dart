import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/design_system/design_tokens.dart';
import 'package:rupee_track/core/design_system/premium_card.dart';
import 'package:rupee_track/features/app_lock/data/app_lock_provider.dart';
import 'package:rupee_track/features/app_lock/data/app_lock_service.dart';

class AppLockSettingsCard extends ConsumerStatefulWidget {
  const AppLockSettingsCard({super.key});

  @override
  ConsumerState<AppLockSettingsCard> createState() =>
      _AppLockSettingsCardState();
}

class _AppLockSettingsCardState extends ConsumerState<AppLockSettingsCard> {
  bool _busy = false;

  Future<void> _enablePinFlow() async {
    final pin = await _promptPin(
      context,
      title: 'Set PIN',
      hint: '4–6 digits',
    );
    if (pin == null) return;

    final confirm = await _promptPin(
      context,
      title: 'Confirm PIN',
      hint: 'Enter again',
    );
    if (confirm == null) return;

    if (pin != confirm) {
      _snack('PINs do not match');
      return;
    }

    setState(() => _busy = true);
    try {
      await ref.read(appLockServiceProvider).enablePin(pin);
      await ref.read(appLockProvider.notifier).refreshFlags();
      ref.read(appLockProvider.notifier).unlock();
      _snack('App lock enabled');
    } catch (e) {
      _snack(e.toString().replaceFirst('ArgumentError: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _disablePinFlow() async {
    final pin = await _promptPin(
      context,
      title: 'Enter current PIN',
      hint: 'To turn off app lock',
    );
    if (pin == null) return;

    setState(() => _busy = true);
    try {
      await ref.read(appLockServiceProvider).disablePin(pin);
      await ref.read(appLockProvider.notifier).refreshFlags();
      _snack('App lock disabled');
    } catch (_) {
      _snack('Incorrect PIN');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _changePinFlow() async {
    final current = await _promptPin(context, title: 'Current PIN', hint: '');
    if (current == null) return;
    final newPin = await _promptPin(context, title: 'New PIN', hint: '4–6 digits');
    if (newPin == null) return;
    final confirm = await _promptPin(context, title: 'Confirm new PIN', hint: '');
    if (confirm == null || newPin != confirm) {
      _snack('PINs do not match');
      return;
    }

    setState(() => _busy = true);
    try {
      final service = ref.read(appLockServiceProvider);
      final ok = await service.verifyPin(current);
      if (!ok) {
        _snack('Incorrect PIN');
        return;
      }
      await service.enablePin(newPin);
      _snack('PIN updated');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<String?> _promptPin(
    BuildContext context, {
    required String title,
    required String hint,
  }) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: hint.isEmpty ? null : hint,
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lockState = ref.watch(appLockProvider);
    final pinOn = lockState.pinEnabled;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App lock',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Require a PIN when opening Viswallet',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('PIN lock'),
            subtitle: const Text('Protect your finances on this device'),
            value: pinOn,
            onChanged: _busy
                ? null
                : (v) {
                    if (v) {
                      _enablePinFlow();
                    } else {
                      _disablePinFlow();
                    }
                  },
          ),
          if (pinOn) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Change PIN'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: _busy ? null : _changePinFlow,
            ),
            if (lockState.biometricAvailable)
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Biometric unlock'),
                subtitle: const Text('Fingerprint or face after PIN is set'),
                value: lockState.biometricEnabled,
                onChanged: _busy
                    ? null
                    : (v) async {
                        await ref
                            .read(appLockServiceProvider)
                            .setBiometricEnabled(v);
                        await ref
                            .read(appLockProvider.notifier)
                            .refreshFlags();
                      },
              ),
          ],
        ],
      ),
    );
  }
}
