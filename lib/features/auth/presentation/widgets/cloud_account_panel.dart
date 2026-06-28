import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rupee_track/core/config/supabase_config.dart';
import 'package:rupee_track/core/providers/supabase_provider.dart';
import 'package:rupee_track/core/router/routes.dart';
import 'package:rupee_track/features/auth/data/auth_repository.dart';

class CloudAccountPanel extends ConsumerStatefulWidget {
  const CloudAccountPanel({super.key});

  @override
  ConsumerState<CloudAccountPanel> createState() => _CloudAccountPanelState();
}

class _CloudAccountPanelState extends ConsumerState<CloudAccountPanel> {
  bool? _connected;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    setState(() => _checking = true);
    final ok = await ref.read(authRepositoryProvider).checkConnection();
    if (mounted) {
      setState(() {
        _connected = ok;
        _checking = false;
      });
    }
  }

  Future<void> _openAuth({required bool signUp}) async {
    final route = signUp ? '${AppRoutes.auth}?signup=1' : AppRoutes.auth;
    final signedIn = await context.push<bool>(route);
    if (signedIn == true) _checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListTile(
          title: Text('Cloud account'),
          subtitle: Text('Sign in to your account (sync coming soon)'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        user != null ? Icons.cloud_done : Icons.cloud_off,
                        color: user != null ? scheme.primary : scheme.outline,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          user != null
                              ? 'Signed in as ${user.email ?? 'user'}'
                              : 'Not signed in',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        _connected == true
                            ? Icons.check_circle_outline
                            : Icons.error_outline,
                        size: 18,
                        color: _connected == true
                            ? Colors.green
                            : scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _checking
                              ? 'Checking connection…'
                              : _connected == true
                                  ? 'Connected to Supabase'
                                  : 'Database schema not ready — run migration',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      if (!_checking)
                        IconButton(
                          tooltip: 'Retry',
                          onPressed: _checkConnection,
                          icon: const Icon(Icons.refresh, size: 20),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    SupabaseConfig.url,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 16),
                  if (user == null) ...[
                    FilledButton.icon(
                      onPressed: () => _openAuth(signUp: false),
                      icon: const Icon(Icons.login),
                      label: const Text('Sign in'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => _openAuth(signUp: true),
                      icon: const Icon(Icons.person_add_outlined),
                      label: const Text('Create account'),
                    ),
                  ] else
                    OutlinedButton.icon(
                      onPressed: () async {
                        await ref.read(authRepositoryProvider).signOut();
                        _checkConnection();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign out'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
