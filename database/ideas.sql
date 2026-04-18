-- ── Ideas Board ───────────────────────────────────────────────────────────────
-- Quick scratchpad ideas with priority and tags.
-- Run this in Supabase SQL Editor.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.ideas (
  id          BIGSERIAL PRIMARY KEY,
  family_id   TEXT NOT NULL,
  title       TEXT NOT NULL,
  priority    TEXT NOT NULL DEFAULT 'medium'
                CHECK (priority IN ('high', 'medium', 'low')),
  tags        TEXT[] DEFAULT '{}',
  notes       TEXT,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.ideas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "ideas_select" ON public.ideas FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "ideas_insert" ON public.ideas FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "ideas_update" ON public.ideas FOR UPDATE TO authenticated
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "ideas_delete" ON public.ideas FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
