# Vizwallet Supabase schema

## Single source of truth: `base.sql`

**All Supabase SQL lives in [`base.sql`](./base.sql)** — tables, indexes, RLS, triggers, RPCs, v10 backfills, maintenance queries, and a commented SQLite reference for the local Drift database.

The `migrations/` folder is kept only for Supabase CLI history. Do **not** edit migrations for new schema changes; update `base.sql` instead.

## Apply schema (recommended)

**Supabase Dashboard**

1. Open [SQL editor](https://supabase.com/dashboard/project/fuoczdljmzvcmkimlant/sql/new)
2. Paste the full contents of `supabase/base.sql`
3. Click **Run**
4. **Authentication → Providers → Email** — enable Email and Allow signups
5. **Authentication → Providers → Email** — disable **Confirm email** (optional, for faster dev sign-up)

**Supabase CLI** (linked project)

```bash
npx supabase login
npx supabase link --project-ref fuoczdljmzvcmkimlant
# Prefer SQL editor + base.sql for full schema.
# db push only applies no-op migration stubs if history already exists.
npx supabase db push
```

## What the app uses today

| Layer | Storage | Schema file |
|-------|---------|-------------|
| Expenses, budgets, loans, etc. | **Local SQLite** (Drift v10) | Commented in `base.sql` §18 |
| Sign-in, password hint | **Supabase Auth + `profiles`** | `base.sql` §1, §HELPERS |
| Future cloud sync | **Supabase tables** | `base.sql` §2–§15 |

After applying `base.sql`, **Settings → Cloud account** should show the account service as online when Supabase is reachable.
