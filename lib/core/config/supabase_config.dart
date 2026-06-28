/// Supabase client configuration.
///
/// The anon key is safe to embed in the app — access is enforced by RLS.
/// Never put the service role key in client code.
abstract final class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://fuoczdljmzvcmkimlant.supabase.co',
  );

  static const publishableKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ1b2N6ZGxqbXp2Y21raW1sYW50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI2MzQ1MjksImV4cCI6MjA5ODIxMDUyOX0.iKuqbLJqmK387yBE8yn4MYWBFk6vYBOeXRGh9pkevdw',
  );

  @Deprecated('Use publishableKey')
  static const anonKey = publishableKey;
}
