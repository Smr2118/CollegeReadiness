-- ============================================================
-- Todos table — family-scoped todo items
-- Run this in Supabase SQL Editor after setup.sql
-- ============================================================

CREATE TABLE IF NOT EXISTS public.todos (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  family_id   TEXT NOT NULL REFERENCES public.families(id) ON DELETE CASCADE,
  created_by  UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  assigned_to UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  title       TEXT NOT NULL,
  done        BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.todos ENABLE ROW LEVEL SECURITY;

-- Family members can read all todos in their family
CREATE POLICY "todos_select" ON public.todos FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

-- Any family member can create a todo for their family
CREATE POLICY "todos_insert" ON public.todos FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

-- Creator or assignee can update (mark done, edit)
CREATE POLICY "todos_update" ON public.todos FOR UPDATE TO authenticated
  USING (
    family_id = public.get_my_family_id()
    AND (created_by = auth.uid() OR assigned_to = auth.uid())
  )
  WITH CHECK (family_id = public.get_my_family_id());

-- Only creator can delete
CREATE POLICY "todos_delete" ON public.todos FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id() AND created_by = auth.uid());
