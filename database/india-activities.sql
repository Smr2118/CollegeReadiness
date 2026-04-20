-- ── India Activities Ideas ────────────────────────────────────────────────────
-- Brainstorm table for India-related activities: cultural, language, volunteering,
-- programs in India, diaspora networks, etc.
-- Run this in Supabase SQL Editor.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.india_activities (
  id          BIGSERIAL PRIMARY KEY,
  family_id   TEXT NOT NULL,
  title       TEXT NOT NULL,
  category    TEXT,
  details     TEXT,
  status      TEXT NOT NULL DEFAULT 'Open',
  starred     BOOLEAN NOT NULL DEFAULT false,
  shortlisted BOOLEAN NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.india_activities ENABLE ROW LEVEL SECURITY;

CREATE POLICY "ia_select" ON public.india_activities FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "ia_insert" ON public.india_activities FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "ia_update" ON public.india_activities FOR UPDATE TO authenticated
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "ia_delete" ON public.india_activities FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
