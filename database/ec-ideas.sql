-- ============================================================
-- EC Ideas table — family-scoped extracurricular brainstorm
-- Run this in Supabase SQL Editor after setup.sql
-- ============================================================

CREATE TABLE IF NOT EXISTS public.ec_ideas (
  id          BIGSERIAL PRIMARY KEY,
  family_id   TEXT NOT NULL,
  title       TEXT NOT NULL,
  category    TEXT CHECK (category IN ('Sports', 'Arts', 'Community Service', 'Leadership', 'Academic', 'STEM', 'Cultural', 'Other')),
  details     TEXT,
  status      TEXT NOT NULL DEFAULT 'Open'
                   CHECK (status IN ('Open', 'Interested', 'Pursuing', 'Complete', 'Cancelled')),
  starred     BOOLEAN NOT NULL DEFAULT FALSE,
  shortlisted BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.ec_ideas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "ec_ideas_select" ON public.ec_ideas FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "ec_ideas_insert" ON public.ec_ideas FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "ec_ideas_update" ON public.ec_ideas FOR UPDATE TO authenticated
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "ec_ideas_delete" ON public.ec_ideas FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
