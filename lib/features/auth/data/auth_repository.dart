import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rupee_track/core/providers/supabase_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? displayName,
    String? passwordHint,
  }) {
    final metadata = <String, dynamic>{};
    if (displayName != null && displayName.isNotEmpty) {
      metadata['display_name'] = displayName;
    }
    if (passwordHint != null && passwordHint.isNotEmpty) {
      metadata['password_hint'] = passwordHint;
    }

    return _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: metadata.isEmpty ? null : metadata,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() => _client.auth.signOut();

  /// Fetches the user's password hint (requires SQL migration + RPC).
  Future<String?> fetchPasswordHint(String email) async {
    final trimmed = email.trim();
    if (trimmed.isEmpty) return null;

    try {
      final result = await _client.rpc(
        'get_password_hint',
        params: {'p_email': trimmed},
      );
      if (result == null) return null;
      final hint = result.toString().trim();
      return hint.isEmpty ? null : hint;
    } catch (_) {
      return null;
    }
  }

  Future<bool> checkConnection() async {
    try {
      await _client.from('profiles').select('id').limit(1);
      return true;
    } catch (_) {
      return false;
    }
  }
}
