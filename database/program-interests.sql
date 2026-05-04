-- ============================================================
-- Program Interests table — family-scoped programs brainstorm
-- Run this in Supabase SQL Editor after setup.sql
-- ============================================================

CREATE TABLE IF NOT EXISTS public.program_interests (
  id                   BIGSERIAL PRIMARY KEY,
  family_id            TEXT NOT NULL,
  name                 TEXT NOT NULL,
  interest_level       TEXT CHECK (interest_level IN ('Very High', 'High', 'Medium', 'Low')),
  ai_risk              TEXT CHECK (ai_risk IN ('High', 'Medium', 'Low', 'Minimal')),
  job_prospects        TEXT CHECK (job_prospects IN ('Excellent', 'Good', 'Fair', 'Limited')),
  best_colleges        TEXT[],
  years_of_study       TEXT CHECK (years_of_study IN ('2', '3', '4', '5', '6+')),
  admission_difficulty TEXT CHECK (admission_difficulty IN ('Very Hard', 'Hard', 'Moderate', 'Accessible')),
  admission_tips       TEXT,
  notes                TEXT,
  starred              BOOLEAN NOT NULL DEFAULT FALSE,
  shortlisted          BOOLEAN NOT NULL DEFAULT FALSE,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  updated_at           TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.program_interests ENABLE ROW LEVEL SECURITY;

CREATE POLICY "program_interests_select" ON public.program_interests FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "program_interests_insert" ON public.program_interests FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "program_interests_update" ON public.program_interests FOR UPDATE TO authenticated
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "program_interests_delete" ON public.program_interests FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
