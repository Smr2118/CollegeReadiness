-- ============================================================
-- College Readiness Hub — Full Database Setup
-- Run this in Supabase SQL Editor to reset and rebuild schema.
-- Preserves: program_data (cards, notes, interest selections)
-- Drops and recreates: families, user_profiles, RLS policies
-- ============================================================


-- ── 1. Drop old objects ──────────────────────────────────────────
-- Tables first (CASCADE removes dependent policies), then function
DROP TABLE IF EXISTS public.user_profiles CASCADE;
DROP TABLE IF EXISTS public.families CASCADE;
DROP FUNCTION IF EXISTS public.get_my_family_id();

-- Drop all RLS policies on program_data so we can reapply them cleanly
DROP POLICY IF EXISTS "family_read"   ON public.program_data;
DROP POLICY IF EXISTS "family_write"  ON public.program_data;
DROP POLICY IF EXISTS "family_select" ON public.program_data;
DROP POLICY IF EXISTS "family_insert" ON public.program_data;
DROP POLICY IF EXISTS "family_update" ON public.program_data;
DROP POLICY IF EXISTS "family_delete" ON public.program_data;


-- ── 2. Families ──────────────────────────────────────────────────
CREATE TABLE public.families (
  id         TEXT PRIMARY KEY,
  name       TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO public.families (id, name) VALUES ('Sant', 'Sant Family');


-- ── 3. User profiles ─────────────────────────────────────────────
CREATE TABLE public.user_profiles (
  user_id      UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email        TEXT,
  display_name TEXT,
  family_id    TEXT REFERENCES public.families(id),
  role         TEXT DEFAULT 'member' CHECK (role IN ('admin', 'member')),
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- Migrate existing auth users in
INSERT INTO public.user_profiles (user_id, email, display_name, family_id, role)
SELECT
  id,
  email,
  raw_user_meta_data->>'display_name',
  raw_user_meta_data->>'family_id',
  COALESCE(raw_user_meta_data->>'role', 'member')
FROM auth.users
ON CONFLICT (user_id) DO NOTHING;


-- ── 4. Helper function (table must exist first) ───────────────────
CREATE OR REPLACE FUNCTION public.get_my_family_id()
RETURNS TEXT LANGUAGE SQL SECURITY DEFINER STABLE AS $$
  SELECT family_id FROM public.user_profiles WHERE user_id = auth.uid()
$$;


-- ── 5. RLS: families ─────────────────────────────────────────────
ALTER TABLE public.families ENABLE ROW LEVEL SECURITY;

CREATE POLICY "all_read_families"     ON public.families FOR SELECT TO authenticated USING (true);
CREATE POLICY "admin_write_families"  ON public.families FOR INSERT TO authenticated
  WITH CHECK ((auth.jwt()->'user_metadata'->>'role') = 'admin');
CREATE POLICY "admin_update_families" ON public.families FOR UPDATE TO authenticated
  USING ((auth.jwt()->'user_metadata'->>'role') = 'admin');


-- ── 6. RLS: user_profiles ────────────────────────────────────────
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "admin_all_profiles" ON public.user_profiles FOR ALL TO authenticated
  USING  ((auth.jwt()->'user_metadata'->>'role') = 'admin')
  WITH CHECK ((auth.jwt()->'user_metadata'->>'role') = 'admin');

CREATE POLICY "members_read_family" ON public.user_profiles FOR SELECT TO authenticated
  USING (family_id = public.get_my_family_id());


-- ── 7. program_data: ensure family_id column exists ─────────────
ALTER TABLE public.program_data
  ADD COLUMN IF NOT EXISTS family_id TEXT DEFAULT 'Sant';

-- Backfill any existing rows
UPDATE public.program_data SET family_id = 'Sant' WHERE family_id IS NULL;

-- ── 8. RLS: program_data ─────────────────────────────────────────
ALTER TABLE public.program_data ENABLE ROW LEVEL SECURITY;

CREATE POLICY "family_select" ON public.program_data FOR SELECT
  USING (family_id = public.get_my_family_id());

CREATE POLICY "family_insert" ON public.program_data FOR INSERT
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "family_update" ON public.program_data FOR UPDATE
  USING     (family_id = public.get_my_family_id())
  WITH CHECK (family_id = public.get_my_family_id());

CREATE POLICY "family_delete" ON public.program_data FOR DELETE
  USING (family_id = public.get_my_family_id());


-- ── Post-setup ───────────────────────────────────────────────────
-- After running this script:
-- 1. Go to Supabase Auth → Users → edit your account
-- 2. Set raw user metadata:
--    { "role": "admin", "family_id": "Sant", "display_name": "YourName" }
-- 3. Deploy the Edge Function:
--    npx supabase link --project-ref <your-project-ref>
--    npx supabase functions deploy create-user
