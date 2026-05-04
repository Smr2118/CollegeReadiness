-- ============================================================
-- College Ideas table — family-scoped college brainstorm
-- Run this in Supabase SQL Editor after setup.sql
-- ============================================================

CREATE TABLE IF NOT EXISTS public.college_ideas (
  id             BIGSERIAL PRIMARY KEY,
  family_id      TEXT NOT NULL,
  name           TEXT NOT NULL,
  tier           TEXT CHECK (tier IN ('Dream', 'Reach', 'Target', 'Safety')),
  course_of_study TEXT,
  interest_level TEXT CHECK (interest_level IN ('Very High', 'High', 'Medium', 'Low')),
  course_scope   TEXT CHECK (course_scope IN ('Excellent', 'Good', 'Fair', 'Limited')),
  region         TEXT,
  notes          TEXT,
  starred        BOOLEAN NOT NULL DEFAULT FALSE,
  shortlisted    BOOLEAN NOT NULL DEFAULT FALSE,
  created_at     TIMESTAMPTZ DEFAULT NOW(),
  updated_at     TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.college_ideas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "college_ideas_select" ON public.college_ideas FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "college_ideas_insert" ON public.college_ideas FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "college_ideas_update" ON public.college_ideas FOR UPDATE TO authenticated
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "college_ideas_delete" ON public.college_ideas FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
