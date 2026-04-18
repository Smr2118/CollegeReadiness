-- ── College Essay Topics ──────────────────────────────────────────────────────
-- Stores essay topic ideas and supporting points for college application essays.
-- Run this in Supabase SQL Editor.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.essay_topics (
  id          BIGSERIAL PRIMARY KEY,
  family_id   TEXT NOT NULL,
  title       TEXT NOT NULL,   -- the core point / story
  category    TEXT,            -- essay theme bucket
  details     TEXT,            -- supporting notes, specific examples, memories
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.essay_topics ENABLE ROW LEVEL SECURITY;

CREATE POLICY "essay_select" ON public.essay_topics FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "essay_insert" ON public.essay_topics FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "essay_update" ON public.essay_topics FOR UPDATE TO authenticated
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "essay_delete" ON public.essay_topics FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
