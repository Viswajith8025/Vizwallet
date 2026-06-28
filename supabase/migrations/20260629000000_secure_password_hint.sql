-- Restrict password hint lookup to authenticated users matching the email.
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
