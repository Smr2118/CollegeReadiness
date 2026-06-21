-- ============================================================
-- Summer Goals tables — family-scoped goals with subtasks
-- Run this in Supabase SQL Editor
-- ============================================================

CREATE TABLE IF NOT EXISTS public.summer_goals (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  family_id   TEXT NOT NULL REFERENCES public.families(id) ON DELETE CASCADE,
  created_by  UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  description TEXT,
  end_date    DATE,
  category    TEXT NOT NULL DEFAULT 'college_readiness'
                CHECK (category IN ('college_readiness','passion_project','extra_curriculars')),
  done        BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT NOW(),
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.summer_goal_subtasks (
  id          UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  goal_id     UUID NOT NULL REFERENCES public.summer_goals(id) ON DELETE CASCADE,
  family_id   TEXT NOT NULL REFERENCES public.families(id) ON DELETE CASCADE,
  title       TEXT NOT NULL,
  done        BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.summer_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.summer_goal_subtasks ENABLE ROW LEVEL SECURITY;

-- Goals policies
CREATE POLICY "summer_goals_select" ON public.summer_goals FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "summer_goals_insert" ON public.summer_goals FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "summer_goals_update" ON public.summer_goals FOR UPDATE TO authenticated
  USING  (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "summer_goals_delete" ON public.summer_goals FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id() AND created_by = auth.uid());

-- Subtasks policies
CREATE POLICY "subtasks_select" ON public.summer_goal_subtasks FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());

CREATE POLICY "subtasks_insert" ON public.summer_goal_subtasks FOR INSERT TO authenticated
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "subtasks_update" ON public.summer_goal_subtasks FOR UPDATE TO authenticated
  USING  (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "subtasks_delete" ON public.summer_goal_subtasks FOR DELETE TO authenticated
  USING (family_id = public.get_my_family_id());
