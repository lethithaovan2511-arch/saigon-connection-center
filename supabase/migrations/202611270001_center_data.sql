create table if not exists public.center_data (
  id text primary key check (id = 'main'),
  data jsonb not null default '{"students":[],"payments":{},"bankImports":{}}'::jsonb,
  updated_by uuid not null references auth.users(id),
  updated_at timestamptz not null default now()
);

alter table public.center_data enable row level security;
revoke all on public.center_data from anon;
grant select, insert, update on public.center_data to authenticated;

create policy "authorized staff read center data" on public.center_data
  for select to authenticated
  using ((auth.jwt() -> 'app_metadata' ->> 'role') in ('owner', 'accountant'));

create policy "authorized staff initialize center data" on public.center_data
  for insert to authenticated
  with check (
    (auth.jwt() -> 'app_metadata' ->> 'role') in ('owner', 'accountant')
    and updated_by = auth.uid()
  );

create policy "authorized staff update center data" on public.center_data
  for update to authenticated
  using ((auth.jwt() -> 'app_metadata' ->> 'role') in ('owner', 'accountant'))
  with check (
    (auth.jwt() -> 'app_metadata' ->> 'role') in ('owner', 'accountant')
    and updated_by = auth.uid()
  );

alter table public.center_data replica identity full;
do $$ begin
  alter publication supabase_realtime add table public.center_data;
exception when duplicate_object then null;
end $$;

