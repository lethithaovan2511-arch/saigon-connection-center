create schema if not exists private;
revoke all on schema private from public, anon, authenticated;

create table if not exists private.auth_signup_allowlist (
  email text primary key,
  role text not null check (role in ('owner', 'accountant'))
);
revoke all on table private.auth_signup_allowlist from public, anon, authenticated;

create or replace function private.assign_allowlisted_auth_role()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  allowed_role text;
begin
  select role into allowed_role
  from private.auth_signup_allowlist
  where email = lower(new.email);

  if allowed_role is null then
    raise exception 'This application does not allow public signups';
  end if;

  new.raw_app_meta_data := coalesce(new.raw_app_meta_data, '{}'::jsonb)
    || jsonb_build_object('role', allowed_role);
  return new;
end;
$$;
revoke all on function private.assign_allowlisted_auth_role() from public, anon, authenticated;

drop trigger if exists assign_allowlisted_auth_role on auth.users;
create trigger assign_allowlisted_auth_role
  before insert on auth.users
  for each row execute function private.assign_allowlisted_auth_role();

