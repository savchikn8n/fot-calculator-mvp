-- FOT calculator shared storage + access control
-- Run this in Supabase SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.workspace_members (
  workspace_id text not null,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('editor','viewer')),
  created_at timestamptz not null default now(),
  primary key (workspace_id, user_id)
);

create table if not exists public.workspace_states (
  workspace_id text primary key,
  data jsonb not null default '{"months":{}}'::jsonb,
  updated_at timestamptz not null default now()
);

create or replace function public.is_workspace_member(p_workspace_id text, p_user_id uuid)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.workspace_members wm
    where wm.workspace_id = p_workspace_id
      and wm.user_id = p_user_id
  );
$$;

create or replace function public.is_workspace_editor(p_workspace_id text, p_user_id uuid)
returns boolean
language sql
stable
as $$
  select exists (
    select 1
    from public.workspace_members wm
    where wm.workspace_id = p_workspace_id
      and wm.user_id = p_user_id
      and wm.role = 'editor'
  );
$$;

alter table public.workspace_members enable row level security;
alter table public.workspace_states enable row level security;

drop policy if exists "members can read membership rows" on public.workspace_members;
create policy "members can read membership rows"
on public.workspace_members
for select
to authenticated
using (is_workspace_member(workspace_id, auth.uid()));

drop policy if exists "members can read workspace state" on public.workspace_states;
create policy "members can read workspace state"
on public.workspace_states
for select
to authenticated
using (is_workspace_member(workspace_id, auth.uid()));

drop policy if exists "editors can insert workspace state" on public.workspace_states;
create policy "editors can insert workspace state"
on public.workspace_states
for insert
to authenticated
with check (is_workspace_editor(workspace_id, auth.uid()));

drop policy if exists "editors can update workspace state" on public.workspace_states;
create policy "editors can update workspace state"
on public.workspace_states
for update
to authenticated
using (is_workspace_editor(workspace_id, auth.uid()))
with check (is_workspace_editor(workspace_id, auth.uid()));

-- Example seed:
-- replace the UUID with your own user id from auth.users.
-- insert into public.workspace_members (workspace_id, user_id, role)
-- values ('default', '00000000-0000-0000-0000-000000000000', 'editor')
-- on conflict (workspace_id, user_id) do update set role = excluded.role;
