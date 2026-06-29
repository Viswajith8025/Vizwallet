-- =============================================================================
-- Vizwallet — complete Supabase base schema (synced with app schema v10)
-- =============================================================================
-- Run once in Supabase Dashboard → SQL Editor → New query → Run
--
-- Safe to run on a fresh project OR one that already has older Vizwallet tables.
-- Creates every table, index, policy, trigger, and RPC the app needs for cloud
-- auth and future sync (universal search, activity history, recycle bin, etc.).
--
-- After running:
--   1. Authentication → Providers → Email → enable Email provider and Allow signups
--   2. Authentication → Providers → Email → disable "Confirm email"
--   3. Settings → Cloud account in the app should show "Connected to Supabase"
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. PROFILES (extends auth.users)
-- -----------------------------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  password_hint text,
  currency_code text not null default 'INR',
  salary_day int not null default 1 check (salary_day between 1 and 31),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles
  add column if not exists password_hint text;

-- -----------------------------------------------------------------------------
-- 2. USER SETTINGS (theme, thresholds, PIN, recycle bin — per user)
-- -----------------------------------------------------------------------------
create table if not exists public.user_settings (
  user_id uuid primary key references auth.users (id) on delete cascade,
  theme_mode text not null default 'system',
  major_expense_threshold_paise int not null default 50000,
  large_expense_threshold_paise int not null default 200000,
  very_large_expense_threshold_paise int not null default 1000000,
  major_purchase_threshold_paise int not null default 500000,
  recycle_bin_retention_days int not null default 30 check (recycle_bin_retention_days >= 0),
  pin_enabled boolean not null default false,
  pin_hash text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.user_settings
  add column if not exists recycle_bin_retention_days int not null default 30;

-- -----------------------------------------------------------------------------
-- 3. INCOME SOURCES
-- -----------------------------------------------------------------------------
create table if not exists public.income_sources (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  name text not null default 'Primary salary',
  cycle_type text not null default 'monthly_day',
  day_of_month int not null default 1 check (day_of_month between 1 and 31),
  week_start_day int,
  is_primary boolean not null default true,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists income_sources_user_idx
  on public.income_sources (user_id);

-- -----------------------------------------------------------------------------
-- 4. MONTHLY SALARY
-- -----------------------------------------------------------------------------
create table if not exists public.monthly_salaries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  month_key text not null,
  amount_paise int not null check (amount_paise >= 0),
  received_at timestamptz,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, month_key)
);

create index if not exists monthly_salaries_user_month_idx
  on public.monthly_salaries (user_id, month_key);

-- -----------------------------------------------------------------------------
-- 5. CATEGORIES
-- -----------------------------------------------------------------------------
create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  name text not null,
  slug text not null,
  icon_name text not null default 'category',
  color_value int not null default 10395294,
  is_system boolean not null default false,
  counts_toward_spending boolean not null default true,
  sort_order int not null default 0,
  is_deleted boolean not null default false,
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, slug)
);

alter table public.categories
  add column if not exists deleted_at timestamptz;

create index if not exists categories_user_idx
  on public.categories (user_id);

create index if not exists categories_user_deleted_idx
  on public.categories (user_id, is_deleted, deleted_at);

-- -----------------------------------------------------------------------------
-- 6. EXPENSES
-- -----------------------------------------------------------------------------
create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  amount_paise int not null check (amount_paise >= 0),
  category_slug text not null,
  title text not null,
  description text,
  occurred_at timestamptz not null,
  month_key text not null,
  payment_method text not null default 'UPI',
  tags jsonb not null default '[]'::jsonb,
  notes text,
  auto_labels jsonb not null default '[]'::jsonb,
  subscription_local_id int,
  loan_payment_local_id int,
  is_deleted boolean not null default false,
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.expenses
  add column if not exists deleted_at timestamptz;

alter table public.expenses
  add column if not exists subscription_local_id int;

alter table public.expenses
  add column if not exists loan_payment_local_id int;

create index if not exists expenses_user_month_idx
  on public.expenses (user_id, month_key);

create index if not exists expenses_user_occurred_idx
  on public.expenses (user_id, occurred_at desc);

create index if not exists expenses_user_category_slug_idx
  on public.expenses (user_id, category_slug);

-- Universal search (v8)
create index if not exists expenses_user_title_idx
  on public.expenses (user_id, title);

create index if not exists expenses_user_payment_method_idx
  on public.expenses (user_id, payment_method);

-- Recycle bin / soft delete (v9)
create index if not exists expenses_user_deleted_idx
  on public.expenses (user_id, is_deleted, deleted_at);

-- -----------------------------------------------------------------------------
-- 7. SUBSCRIPTIONS
-- -----------------------------------------------------------------------------
create table if not exists public.subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  name text not null,
  amount_paise int not null check (amount_paise >= 0),
  category_slug text,
  billing_cycle text not null default 'monthly',
  billing_interval_days int,
  next_renewal_at timestamptz,
  payment_method text not null default 'Auto Debit',
  is_active boolean not null default true,
  status text not null default 'active',
  usage_frequency text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.subscriptions
  add column if not exists status text not null default 'active';

alter table public.subscriptions
  add column if not exists usage_frequency text;

update public.subscriptions
set status = case when is_active then 'active' else 'cancelled' end
where status is null
   or (status = 'active' and not is_active);

create index if not exists subscriptions_user_idx
  on public.subscriptions (user_id);

create index if not exists subscriptions_user_status_idx
  on public.subscriptions (user_id, status);

-- -----------------------------------------------------------------------------
-- 8. SUBSCRIPTION PAYMENTS
-- -----------------------------------------------------------------------------
create table if not exists public.subscription_payments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  subscription_id uuid not null references public.subscriptions (id) on delete cascade,
  amount_paise int not null check (amount_paise >= 0),
  paid_at timestamptz not null,
  month_key text not null,
  expense_local_id int,
  status text not null default 'paid',
  created_at timestamptz not null default now()
);

create index if not exists subscription_payments_user_idx
  on public.subscription_payments (user_id);

-- -----------------------------------------------------------------------------
-- 9. LOANS
-- -----------------------------------------------------------------------------
create table if not exists public.loans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  person_name text not null,
  direction text not null default 'borrowed_by_me',
  principal_paise int not null check (principal_paise >= 0),
  balance_paise int not null check (balance_paise >= 0),
  reason text,
  borrowed_at timestamptz not null,
  expected_return_at timestamptz,
  status text not null default 'pending',
  notes text,
  is_deleted boolean not null default false,
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.loans
  add column if not exists deleted_at timestamptz;

create index if not exists loans_user_idx
  on public.loans (user_id);

create index if not exists loans_user_deleted_idx
  on public.loans (user_id, is_deleted, deleted_at);

-- -----------------------------------------------------------------------------
-- 10. LOAN PAYMENTS
-- -----------------------------------------------------------------------------
create table if not exists public.loan_payments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  loan_id uuid not null references public.loans (id) on delete cascade,
  amount_paise int not null check (amount_paise >= 0),
  paid_at timestamptz not null,
  notes text,
  expense_local_id int,
  created_at timestamptz not null default now()
);

create index if not exists loan_payments_user_idx
  on public.loan_payments (user_id);

-- -----------------------------------------------------------------------------
-- 11. BUDGET PLANS
-- -----------------------------------------------------------------------------
create table if not exists public.budget_plans (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  month_key text not null,
  salary_paise int not null check (salary_paise >= 0),
  allocation_mode text not null default 'percentage',
  rollover_enabled boolean not null default true,
  ai_notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, month_key)
);

create index if not exists budget_plans_user_idx
  on public.budget_plans (user_id);

-- -----------------------------------------------------------------------------
-- 12. BUDGET BUCKETS
-- -----------------------------------------------------------------------------
create table if not exists public.budget_buckets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  plan_id uuid not null references public.budget_plans (id) on delete cascade,
  bucket_key text not null,
  display_name text not null,
  category_slug text,
  bucket_type text not null default 'spending',
  allocated_paise int not null default 0 check (allocated_paise >= 0),
  allocated_percent double precision,
  rollover_paise int not null default 0,
  sort_order int not null default 0,
  unique (plan_id, bucket_key)
);

create index if not exists budget_buckets_user_idx
  on public.budget_buckets (user_id);

-- -----------------------------------------------------------------------------
-- 13. SAVINGS GOALS & WISHLIST (v7)
-- -----------------------------------------------------------------------------
create table if not exists public.savings_goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  name text not null,
  target_paise int not null check (target_paise >= 0),
  saved_paise int not null default 0 check (saved_paise >= 0),
  monthly_contribution_paise int not null default 0 check (monthly_contribution_paise >= 0),
  is_wishlist boolean not null default false,
  target_date timestamptz,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists savings_goals_user_idx
  on public.savings_goals (user_id);

create index if not exists savings_goals_user_active_idx
  on public.savings_goals (user_id, is_active);

-- -----------------------------------------------------------------------------
-- 14. TAGGING RULES (smart categorization)
-- -----------------------------------------------------------------------------
create table if not exists public.tagging_rules (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  pattern text not null,
  match_field text not null default 'title',
  category_slug text,
  tags jsonb not null default '[]'::jsonb,
  source text not null,
  confidence double precision not null default 0.8,
  use_count int not null default 0,
  updated_at timestamptz not null default now(),
  unique (user_id, pattern, match_field)
);

create index if not exists tagging_rules_user_idx
  on public.tagging_rules (user_id);

-- -----------------------------------------------------------------------------
-- 15. ACTIVITY LOG — audit trail, undo, recycle bin (v9)
-- Append-only; only is_undone may change after insert.
-- -----------------------------------------------------------------------------
create table if not exists public.activity_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  local_id int,
  action text not null,
  module text not null,
  entity_id int,
  entity_label text not null default '',
  old_value_json jsonb,
  new_value_json jsonb,
  reason text,
  severity text not null default 'info',
  performed_by text not null default 'user',
  is_undoable boolean not null default false,
  is_undone boolean not null default false,
  occurred_at timestamptz not null default now()
);

create index if not exists activity_log_user_occurred_idx
  on public.activity_log (user_id, occurred_at desc);

create index if not exists activity_log_user_module_action_idx
  on public.activity_log (user_id, module, action);

-- -----------------------------------------------------------------------------
-- HELPERS
-- -----------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, display_name, password_hint)
  values (
    new.id,
    coalesce(
      new.raw_user_meta_data ->> 'display_name',
      split_part(new.email, '@', 1)
    ),
    nullif(trim(new.raw_user_meta_data ->> 'password_hint'), '')
  )
  on conflict (id) do update
  set
    display_name = excluded.display_name,
    password_hint = coalesce(excluded.password_hint, public.profiles.password_hint),
    updated_at = now();

  insert into public.user_settings (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

-- Password hint: only the authenticated user can read their own hint (secure v2).
create or replace function public.get_password_hint(p_email text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_hint text;
  v_user_email text;
begin
  if p_email is null or length(trim(p_email)) = 0 then
    return null;
  end if;

  if auth.uid() is null then
    return null;
  end if;

  select lower(u.email)
  into v_user_email
  from auth.users u
  where u.id = auth.uid();

  if v_user_email is null or v_user_email <> lower(trim(p_email)) then
    return null;
  end if;

  select p.password_hint
  into v_hint
  from public.profiles p
  where p.id = auth.uid();

  return v_hint;
end;
$$;

revoke all on function public.get_password_hint(text) from public;
revoke all on function public.get_password_hint(text) from anon;
grant execute on function public.get_password_hint(text) to authenticated;

-- -----------------------------------------------------------------------------
-- TRIGGERS: updated_at
-- -----------------------------------------------------------------------------
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

drop trigger if exists profiles_updated_at on public.profiles;
create trigger profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

drop trigger if exists user_settings_updated_at on public.user_settings;
create trigger user_settings_updated_at
  before update on public.user_settings
  for each row execute function public.set_updated_at();

drop trigger if exists income_sources_updated_at on public.income_sources;
create trigger income_sources_updated_at
  before update on public.income_sources
  for each row execute function public.set_updated_at();

drop trigger if exists monthly_salaries_updated_at on public.monthly_salaries;
create trigger monthly_salaries_updated_at
  before update on public.monthly_salaries
  for each row execute function public.set_updated_at();

drop trigger if exists categories_updated_at on public.categories;
create trigger categories_updated_at
  before update on public.categories
  for each row execute function public.set_updated_at();

drop trigger if exists expenses_updated_at on public.expenses;
create trigger expenses_updated_at
  before update on public.expenses
  for each row execute function public.set_updated_at();

drop trigger if exists subscriptions_updated_at on public.subscriptions;
create trigger subscriptions_updated_at
  before update on public.subscriptions
  for each row execute function public.set_updated_at();

drop trigger if exists loans_updated_at on public.loans;
create trigger loans_updated_at
  before update on public.loans
  for each row execute function public.set_updated_at();

drop trigger if exists budget_plans_updated_at on public.budget_plans;
create trigger budget_plans_updated_at
  before update on public.budget_plans
  for each row execute function public.set_updated_at();

drop trigger if exists savings_goals_updated_at on public.savings_goals;
create trigger savings_goals_updated_at
  before update on public.savings_goals
  for each row execute function public.set_updated_at();

-- -----------------------------------------------------------------------------
-- ROW LEVEL SECURITY
-- -----------------------------------------------------------------------------
alter table public.profiles enable row level security;
alter table public.user_settings enable row level security;
alter table public.income_sources enable row level security;
alter table public.monthly_salaries enable row level security;
alter table public.categories enable row level security;
alter table public.expenses enable row level security;
alter table public.subscriptions enable row level security;
alter table public.subscription_payments enable row level security;
alter table public.loans enable row level security;
alter table public.loan_payments enable row level security;
alter table public.budget_plans enable row level security;
alter table public.budget_buckets enable row level security;
alter table public.savings_goals enable row level security;
alter table public.tagging_rules enable row level security;
alter table public.activity_log enable row level security;

-- Profiles
drop policy if exists "Users read own profile" on public.profiles;
create policy "Users read own profile"
  on public.profiles for select
  using (auth.uid() = id);

drop policy if exists "Users update own profile" on public.profiles;
create policy "Users update own profile"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- User settings
drop policy if exists "Users manage own settings" on public.user_settings;
create policy "Users manage own settings"
  on public.user_settings for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Per-user data tables
drop policy if exists "Users manage own income_sources" on public.income_sources;
create policy "Users manage own income_sources"
  on public.income_sources for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own monthly_salaries" on public.monthly_salaries;
create policy "Users manage own monthly_salaries"
  on public.monthly_salaries for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own categories" on public.categories;
create policy "Users manage own categories"
  on public.categories for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own expenses" on public.expenses;
create policy "Users manage own expenses"
  on public.expenses for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own subscriptions" on public.subscriptions;
create policy "Users manage own subscriptions"
  on public.subscriptions for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own subscription_payments" on public.subscription_payments;
create policy "Users manage own subscription_payments"
  on public.subscription_payments for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own loans" on public.loans;
create policy "Users manage own loans"
  on public.loans for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own loan_payments" on public.loan_payments;
create policy "Users manage own loan_payments"
  on public.loan_payments for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own budget_plans" on public.budget_plans;
create policy "Users manage own budget_plans"
  on public.budget_plans for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own budget_buckets" on public.budget_buckets;
create policy "Users manage own budget_buckets"
  on public.budget_buckets for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own savings_goals" on public.savings_goals;
create policy "Users manage own savings_goals"
  on public.savings_goals for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "Users manage own tagging_rules" on public.tagging_rules;
create policy "Users manage own tagging_rules"
  on public.tagging_rules for all
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- Activity log: select + insert; updates only for undo flag
drop policy if exists "Users read own activity_log" on public.activity_log;
create policy "Users read own activity_log"
  on public.activity_log for select
  using (auth.uid() = user_id);

drop policy if exists "Users insert own activity_log" on public.activity_log;
create policy "Users insert own activity_log"
  on public.activity_log for insert
  with check (auth.uid() = user_id);

drop policy if exists "Users update own activity_log undo" on public.activity_log;
create policy "Users update own activity_log undo"
  on public.activity_log for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- -----------------------------------------------------------------------------
-- 16. SCHEMA BACKFILL (app v10 — expense thresholds)
-- Safe to re-run; only updates rows still on legacy defaults.
-- -----------------------------------------------------------------------------
update public.user_settings
set major_expense_threshold_paise = 50000
where major_expense_threshold_paise = 10000;

update public.user_settings
set large_expense_threshold_paise = 200000
where large_expense_threshold_paise = 50000;

update public.user_settings
set very_large_expense_threshold_paise = 1000000
where very_large_expense_threshold_paise = 100000;

-- -----------------------------------------------------------------------------
-- 17. DATA MAINTENANCE (mirrors app Settings → App management)
-- Per-user deletes; use in SQL editor while signed in, or wrap in RPC later.
-- Uncomment the block you need — each respects RLS via auth.uid().
-- -----------------------------------------------------------------------------
-- delete from public.expenses where user_id = auth.uid();
-- delete from public.budget_buckets where user_id = auth.uid();
-- delete from public.budget_plans where user_id = auth.uid();
-- delete from public.savings_goals where user_id = auth.uid() and is_wishlist = false;
-- delete from public.savings_goals where user_id = auth.uid() and is_wishlist = true;
-- delete from public.subscription_payments where user_id = auth.uid();
-- delete from public.subscriptions where user_id = auth.uid();
-- delete from public.loan_payments where user_id = auth.uid();
-- delete from public.loans where user_id = auth.uid();
-- delete from public.activity_log where user_id = auth.uid();
-- delete from public.tagging_rules where user_id = auth.uid();
-- delete from public.monthly_salaries where user_id = auth.uid();
-- delete from public.categories where user_id = auth.uid() and is_system = false;

-- Factory reset (cloud data only — does not touch auth.users):
-- delete from public.activity_log where user_id = auth.uid();
-- delete from public.tagging_rules where user_id = auth.uid();
-- delete from public.budget_buckets where user_id = auth.uid();
-- delete from public.budget_plans where user_id = auth.uid();
-- delete from public.savings_goals where user_id = auth.uid();
-- delete from public.subscription_payments where user_id = auth.uid();
-- delete from public.subscriptions where user_id = auth.uid();
-- delete from public.loan_payments where user_id = auth.uid();
-- delete from public.loans where user_id = auth.uid();
-- delete from public.expenses where user_id = auth.uid();
-- delete from public.monthly_salaries where user_id = auth.uid();
-- delete from public.income_sources where user_id = auth.uid();
-- delete from public.categories where user_id = auth.uid() and is_system = false;
-- update public.user_settings set
--   theme_mode = 'system',
--   major_expense_threshold_paise = 50000,
--   large_expense_threshold_paise = 200000,
--   very_large_expense_threshold_paise = 1000000,
--   major_purchase_threshold_paise = 500000,
--   recycle_bin_retention_days = 30,
--   pin_enabled = false,
--   pin_hash = null,
--   updated_at = now()
-- where user_id = auth.uid();

-- -----------------------------------------------------------------------------
-- 18. LOCAL SQLITE REFERENCE (device-only — not executed on Supabase)
-- The Flutter app uses Drift/SQLite with _table suffix names. Kept here so
-- all project SQL lives in one file. Do not run this block on Postgres.
--
-- PRAGMA foreign_keys = ON;
--
-- CREATE INDEX IF NOT EXISTS idx_expenses_month_deleted
--   ON expenses_table (month_key, is_deleted);
-- CREATE INDEX IF NOT EXISTS idx_expenses_occurred_at ON expenses_table (occurred_at);
-- CREATE INDEX IF NOT EXISTS idx_expenses_category ON expenses_table (category_id);
-- CREATE INDEX IF NOT EXISTS idx_expenses_title ON expenses_table (title);
-- CREATE INDEX IF NOT EXISTS idx_expenses_payment_method ON expenses_table (payment_method);
-- CREATE INDEX IF NOT EXISTS idx_activity_occurred_at ON activity_log_table (occurred_at DESC);
-- CREATE INDEX IF NOT EXISTS idx_activity_module_action ON activity_log_table (module, action);
-- CREATE INDEX IF NOT EXISTS idx_expenses_deleted_at ON expenses_table (is_deleted, deleted_at);
-- CREATE INDEX IF NOT EXISTS idx_loans_deleted_at ON loans_table (is_deleted, deleted_at);
--
-- UPDATE subscriptions_table SET status = CASE
--   WHEN is_active = 1 THEN 'active' ELSE 'cancelled' END;
-- UPDATE app_settings SET major_expense_threshold_paise = 50000
--   WHERE major_expense_threshold_paise = 10000;
-- UPDATE app_settings SET large_expense_threshold_paise = 200000
--   WHERE large_expense_threshold_paise = 50000;
-- UPDATE app_settings SET very_large_expense_threshold_paise = 1000000
--   WHERE very_large_expense_threshold_paise = 100000;
--
-- DELETE FROM expenses_table;
-- DELETE FROM budget_buckets_table;
-- DELETE FROM budget_plans_table;
-- DELETE FROM savings_goals_table WHERE is_wishlist = 0;
-- DELETE FROM savings_goals_table WHERE is_wishlist = 1;
-- DELETE FROM subscription_payments_table;
-- DELETE FROM subscriptions_table;
-- DELETE FROM loan_payments_table;
-- DELETE FROM loans_table;
-- DELETE FROM activity_log_table;
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- DONE — 15 tables under public schema:
--   profiles, user_settings, income_sources, monthly_salaries, categories,
--   expenses, subscriptions, subscription_payments, loans, loan_payments,
--   budget_plans, budget_buckets, savings_goals, tagging_rules, activity_log
--
-- Single source of truth: supabase/base.sql (migrations folder is CLI history only)
-- -----------------------------------------------------------------------------
