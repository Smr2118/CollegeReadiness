-- ============================================================
-- Past Projects table — family-scoped project tracker
-- Run this in Supabase SQL Editor after setup.sql
-- ============================================================

CREATE TABLE IF NOT EXISTS public.past_projects (
  id          BIGSERIAL PRIMARY KEY,
  family_id   TEXT NOT NULL,
  title       TEXT NOT NULL,
  category    TEXT CHECK (category IN ('School', 'Personal', 'Research', 'Competition', 'Volunteer', 'Other')),
  status      TEXT NOT NULL DEFAULT 'Ongoing'
                   CHECK (status IN ('Ongoing', 'Completed', 'On Hold', 'Abandoned')),
  year        TEXT,
  role        TEXT,
  skills      TEXT,
  details     TEXT,
  starred     BOOLEAN NOT NULL DEFAULT FALSE,
  shortlisted BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.past_projects ENABLE ROW LEVEL SECURITY;

CREATE POLICY "past_projects_select" ON public.past_projects FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "past_projects_insert" ON public.past_projects FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "past_projects_update" ON public.past_projects FOR UPDATE TO authenticated
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "past_projects_delete" ON public.past_projects FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
