-- Robotics Ideas table
create table if not exists robotics_ideas (
  id          bigserial primary key,
  family_id   text        not null references families(id) on delete cascade,
  title       text        not null,
  category    text,
  details     text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- Row Level Security
alter table robotics_ideas enable row level security;

-- Members of the same family can read
create policy "family members can read robotics_ideas"
  on robotics_ideas for select
  using (family_id = public.get_my_family_id());

-- Members of the same family can insert
create policy "family members can insert robotics_ideas"
  on robotics_ideas for insert
  with check (family_id = public.get_my_family_id());

-- Members of the same family can update
create policy "family members can update robotics_ideas"
  on robotics_ideas for update
  using (family_id = public.get_my_family_id());

-- Members of the same family can delete
create policy "family members can delete robotics_ideas"
  on robotics_ideas for delete
  using (family_id = public.get_my_family_id());
