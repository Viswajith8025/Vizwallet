import 'package:supabase_flutter/supabase_flutter.dart';

/// Maps Supabase Auth errors to clear messages for users.
abstract final class AuthErrorUtils {
  static String friendlyMessage(Object error) {
    if (error is AuthException) {
      return _fromAuthException(error);
    }

    final message = error.toString();
    final lower = message.toLowerCase();

    if (lower.contains('user already registered') ||
        lower.contains('user_already_exists') ||
        lower.contains('already been registered')) {
      return 'This email already has an account. Tap "Sign in" below and use your password.';
    }
    if (lower.contains('email signups are disabled') ||
        lower.contains('signup is disabled') ||
        lower.contains('signups are disabled')) {
      return 'New account creation is temporarily unavailable. Please try again later.';
    }
    if (lower.contains('invalid login credentials')) {
      return 'Incorrect email or password.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Check your email and confirm your account, then sign in.';
    }
    if (lower.contains('invalid email') ||
        lower.contains('unable to validate email')) {
      return 'Enter a valid email address.';
    }
    if (lower.contains('password') &&
        (lower.contains('short') || lower.contains('least'))) {
      return 'Password must be at least 6 characters.';
    }
    if (lower.contains('database error saving new user')) {
      return 'Account could not be saved on the server. Please try again in a minute.';
    }
    if (lower.contains('network') ||
        lower.contains('socket') ||
        lower.contains('connection') ||
        lower.contains('timed out') ||
        lower.contains('failed host lookup')) {
      return 'Could not reach the account service. Check your internet and try again.';
    }

    final authMsg = _extractAuthMessage(message);
    if (authMsg != null && authMsg.isNotEmpty) {
      return authMsg;
    }

    return 'Account service error. Please try again.';
  }

  static String _fromAuthException(AuthException error) {
    final code = (error.code ?? '').toLowerCase();
    final msg = error.message.toLowerCase();

    if (code == 'user_already_exists' || msg.contains('already registered')) {
      return 'This email already has an account. Tap "Sign in" below and use your password.';
    }
    if (code == 'signup_disabled' || msg.contains('signups are disabled')) {
      return 'New account creation is temporarily unavailable. Please try again later.';
    }
    if (code == 'invalid_credentials') {
      return 'Incorrect email or password.';
    }
    if (code == 'email_not_confirmed') {
      return 'Check your email and confirm your account, then sign in.';
    }
    if (code == 'validation_failed' || msg.contains('invalid email')) {
      return 'Enter a valid email address.';
    }
    if (msg.contains('database error saving new user')) {
      return 'Account could not be saved on the server. Please try again in a minute.';
    }
    if (error.message.trim().isNotEmpty) {
      return error.message;
    }
    return 'Account service error. Please try again.';
  }

  static String? _extractAuthMessage(String raw) {
    final match = RegExp(
      r'message:\s*([^,]+)',
      caseSensitive: false,
    ).firstMatch(raw);
    return match?.group(1)?.trim();
  }
}
