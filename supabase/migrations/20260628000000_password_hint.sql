-- Password hint for login recovery (user-provided mnemonic, not the password itself).
alter table public.profiles
  add column if not exists password_hint text;

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
  );
  return new;
end;
$$;

-- Returns hint for a registered email (anon callable for forgot-password UX).
create or replace function public.get_password_hint(p_email text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  v_hint text;
begin
  if p_email is null or length(trim(p_email)) = 0 then
    return null;
  end if;

  select p.password_hint
  into v_hint
  from public.profiles p
  inner join auth.users u on u.id = p.id
  where lower(u.email) = lower(trim(p_email));

  return v_hint;
end;
$$;

revoke all on function public.get_password_hint(text) from public;
grant execute on function public.get_password_hint(text) to anon, authenticated;
