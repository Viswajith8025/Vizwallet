# Viswallet Supabase schema

## Single source of truth: `production.sql`

**Run [`production.sql`](./production.sql) for production** (same content as `base.sql`).

Paste the full file in [SQL editor](https://supabase.com/dashboard/project/fuoczdljmzvcmkimlant/sql/new) → **Run**.

## What Supabase stores today

| Layer | Storage | Used by app? |
|-------|---------|--------------|
| Sign-in, sessions | **auth.users** (Supabase Auth) | Yes |
| Profile, password hint | **public.profiles** | Yes |
| Expenses, budgets, loans, goals, etc. | **Local SQLite** (Drift on phone) | Yes (not Supabase) |

The 14 finance tables that used to exist in Supabase were **placeholders for future cloud sync**. The app does not read or write them. They were removed in migration `20260331000000_drop_unused_cloud_tables.sql`.

**Nothing is missing** for current app behavior — only `profiles` (+ Auth) is required.

## Apply / clean up remote database

**Supabase Dashboard (recommended)**

1. Open [SQL editor](https://supabase.com/dashboard/project/fuoczdljmzvcmkimlant/sql/new)
2. Paste the full contents of `supabase/production.sql`
3. Click **Run**
4. Table list should show only **profiles** under `public`

**Supabase CLI**

```bash
npm run login
npm run link
npm run db:push
```

## Fresh start (wipe all data, keep tables)

When relaunching the app and you want **zero users / zero rows** in Supabase:

```bash
npm run db:fresh-start
```

Or paste [`fresh_start.sql`](./fresh_start.sql) in the SQL editor and run it.

This deletes all `auth.users` (logins) and truncates every `public` table. **Schema, RLS, and triggers stay.** New sign-ups each get their own account + `profiles` row.

**Note:** Finance data on phones (local SQLite) is **not** cleared by this — only the cloud database. Users should log out and use Settings → clear data, or reinstall the app, for a fully clean device.


- **Authentication → Providers → Email** — enable Email and Allow signups
- Optional: disable **Confirm email** for faster dev sign-up
- **Settings → Account** in the app checks `profiles` to show cloud connection status
