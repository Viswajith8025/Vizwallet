-- =============================================================================
-- Viswallet — FRESH START (data only — tables & RLS stay)
-- =============================================================================
-- Wipes every row in public schema + all auth accounts/sessions.
-- Safe to run when relaunching the app: new users sign up from scratch.
-- Each new user still gets their own auth.users row + profiles row (RLS).
--
-- Run: npm run db:fresh-start
-- Or paste in Supabase Dashboard → SQL Editor
-- =============================================================================

begin;

-- 1) Clear all app tables in public (profiles + any legacy tables still present)
do $$
declare
  r record;
begin
  for r in
    select tablename
    from pg_tables
    where schemaname = 'public'
  loop
    execute format(
      'truncate table public.%I restart identity cascade',
      r.tablename
    );
  end loop;
end $$;

-- 2) Clear Supabase Auth (logins, sessions, identities)
delete from auth.sessions;
delete from auth.refresh_tokens;
delete from auth.identities;
delete from auth.users;

commit;

-- Verify (optional — comment out in production scripts)
-- select count(*) as profiles_left from public.profiles;
-- select count(*) as users_left from auth.users;
