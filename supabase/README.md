# Apply Vizwallet schema to your Supabase project
#
# Option A — Supabase Dashboard (easiest)
# 1. Open https://supabase.com/dashboard/project/fuoczdljmzvcmkimlant/sql/new
# 2. Paste the contents of supabase/migrations/20260617000000_initial_schema.sql
# 3. Click Run
#
# Option B — Supabase CLI (linked project)
#   npx supabase login
#   npx supabase link --project-ref fuoczdljmzvcmkimlant
#   npx supabase db push
#
# Option C — Direct Postgres URL
#   npx supabase db push --db-url "postgresql://postgres.[ref]:[PASSWORD]@aws-0-[region].pooler.supabase.com:6543/postgres"
#
# After migration, Settings → Cloud account should show "Connected to Supabase".
