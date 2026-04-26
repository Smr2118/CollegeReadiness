-- ============================================================
-- Demo Family — ReadOnly flag + Demo family seed
-- Run this in Supabase SQL Editor.
-- Safe to run multiple times (idempotent).
-- ============================================================

-- ── 1. Add is_readonly to families ───────────────────────────
ALTER TABLE public.families
  ADD COLUMN IF NOT EXISTS is_readonly BOOLEAN NOT NULL DEFAULT false;

-- ── 2. Insert Demo family ─────────────────────────────────────
-- plan = 'basic' so demo users can see basic-tier programs.
-- is_readonly = true blocks all writes via RLS below.
INSERT INTO public.families (id, name, plan, is_readonly)
VALUES ('demo', 'Demo Family', 'basic', true)
ON CONFLICT (id) DO NOTHING;

-- ── 3. program_data: block writes for readonly families ───────
DROP POLICY IF EXISTS "family_insert" ON public.program_data;
DROP POLICY IF EXISTS "family_update" ON public.program_data;
DROP POLICY IF EXISTS "family_delete" ON public.program_data;

CREATE POLICY "family_insert" ON public.program_data FOR INSERT
  WITH CHECK (
    family_id = public.get_my_family_id()
    AND NOT EXISTS (
      SELECT 1 FROM public.families
      WHERE id = public.get_my_family_id() AND is_readonly = true
    )
  );

CREATE POLICY "family_update" ON public.program_data FOR UPDATE
  USING (
    family_id = public.get_my_family_id()
    AND NOT EXISTS (
      SELECT 1 FROM public.families
      WHERE id = public.get_my_family_id() AND is_readonly = true
    )
  )
  WITH CHECK (
    family_id = public.get_my_family_id()
    AND NOT EXISTS (
      SELECT 1 FROM public.families
      WHERE id = public.get_my_family_id() AND is_readonly = true
    )
  );

CREATE POLICY "family_delete" ON public.program_data FOR DELETE
  USING (
    family_id = public.get_my_family_id()
    AND NOT EXISTS (
      SELECT 1 FROM public.families
      WHERE id = public.get_my_family_id() AND is_readonly = true
    )
  );

-- ── 4. todos: block writes for readonly families ──────────────
DROP POLICY IF EXISTS "todos_insert" ON public.todos;
DROP POLICY IF EXISTS "todos_update" ON public.todos;
DROP POLICY IF EXISTS "todos_delete" ON public.todos;

CREATE POLICY "todos_insert" ON public.todos FOR INSERT TO authenticated
  WITH CHECK (
    family_id = public.get_my_family_id()
    AND NOT EXISTS (
      SELECT 1 FROM public.families
      WHERE id = public.get_my_family_id() AND is_readonly = true
    )
  );

CREATE POLICY "todos_update" ON public.todos FOR UPDATE TO authenticated
  USING (
    family_id = public.get_my_family_id()
    AND NOT EXISTS (
      SELECT 1 FROM public.families
      WHERE id = public.get_my_family_id() AND is_readonly = true
    )
  )
  WITH CHECK (
    family_id = public.get_my_family_id()
    AND NOT EXISTS (
      SELECT 1 FROM public.families
      WHERE id = public.get_my_family_id() AND is_readonly = true
    )
  );

CREATE POLICY "todos_delete" ON public.todos FOR DELETE TO authenticated
  USING (
    family_id = public.get_my_family_id()
    AND NOT EXISTS (
      SELECT 1 FROM public.families
      WHERE id = public.get_my_family_id() AND is_readonly = true
    )
  );
