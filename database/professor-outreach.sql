-- Professor outreach tracker
-- Run in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS public.professor_outreach (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id     UUID        NOT NULL REFERENCES public.families(id) ON DELETE CASCADE,
  college       TEXT        NOT NULL,
  professor     TEXT        NOT NULL,
  department    TEXT,
  research_area TEXT,
  email_date    DATE,
  status        TEXT        NOT NULL DEFAULT 'drafting',
  notes         TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.professor_outreach ENABLE ROW LEVEL SECURITY;

CREATE POLICY "family_professor_outreach"
  ON public.professor_outreach FOR ALL
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());
