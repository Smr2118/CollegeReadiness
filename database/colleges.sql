-- ============================================================
-- Colleges table — family-scoped college research tracker
-- Run this in Supabase SQL Editor after setup.sql
-- ============================================================

CREATE TABLE IF NOT EXISTS public.colleges (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  family_id   TEXT NOT NULL REFERENCES public.families(id) ON DELETE CASCADE,
  created_by  UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name        TEXT NOT NULL,
  location    TEXT,
  type        TEXT CHECK (type IN ('Ivy League', 'Liberal Arts', 'Research University', 'State University', 'Other')),
  status      TEXT NOT NULL DEFAULT 'Researching'
                   CHECK (status IN ('Researching', 'Applying', 'Applied', 'Accepted', 'Waitlisted', 'Deferred', 'Rejected')),
  notes       TEXT,
  starred     BOOLEAN NOT NULL DEFAULT FALSE,
  shortlisted BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.colleges ENABLE ROW LEVEL SECURITY;

-- Family members can read all colleges in their family
CREATE POLICY "colleges_select" ON public.colleges FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

-- Any family member can add a college for their family
CREATE POLICY "colleges_insert" ON public.colleges FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

-- Any family member can update colleges in their family
CREATE POLICY "colleges_update" ON public.colleges FOR UPDATE TO authenticated
  USING  (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

-- Any family member can delete colleges in their family
CREATE POLICY "colleges_delete" ON public.colleges FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
