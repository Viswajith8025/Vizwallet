# Apply Vizwallet schema to your Supabase project

## Recommended — full schema (`base.sql`)

Use this for a complete cloud schema (profiles, expenses, budgets, loans, etc.) with RLS.

**Supabase Dashboard**

1. Open [SQL editor](https://supabase.com/dashboard/project/fuoczdljmzvcmkimlant/sql/new)
2. Paste the contents of `supabase/base.sql`
3. Click **Run**
4. Apply follow-up migrations in order:
   - `supabase/migrations/20260628000000_password_hint.sql` (if not already in `base.sql`)
   - `supabase/migrations/20260629000000_secure_password_hint.sql`

**Supabase CLI** (linked project)

```bash
npx supabase login
npx supabase link --project-ref fuoczdljmzvcmkimlant
npx supabase db push
```

## Minimal schema (auth + profiles only)

If you only need sign-in today (app data stays on-device), you can run:

- `supabase/migrations/20260617000000_initial_schema.sql`
- `supabase/migrations/20260628000000_password_hint.sql`
- `supabase/migrations/20260629000000_secure_password_hint.sql`

The Flutter app uses **local SQLite** for expenses and budgets. Cloud tables beyond `profiles` are prepared for future sync.

After migration, **Settings → Account** should show “Account service is online” when Supabase is reachable.
