-- ── Family Notes ──────────────────────────────────────────────────────────────
-- General notes board, optionally linked to a summer program.
-- Run this in Supabase SQL Editor.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.family_notes (
  id           BIGSERIAL PRIMARY KEY,
  family_id    TEXT NOT NULL,
  program_name TEXT,           -- optional link to a program (nullable)
  content      TEXT NOT NULL,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  updated_at   TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.family_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "notes_select" ON public.family_notes FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "notes_insert" ON public.family_notes FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "notes_update" ON public.family_notes FOR UPDATE TO authenticated
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "notes_delete" ON public.family_notes FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
