-- ── F1 Target Role preference ────────────────────────────────────────────
-- Adds a target_f1_role column to user_profiles so each user can save
-- their chosen F1 career goal from the F1 Careers Guide page.
-- Run in Supabase SQL Editor.

-- 1. Add column
ALTER TABLE public.user_profiles
  ADD COLUMN IF NOT EXISTS target_f1_role TEXT;

-- 2. Allow users to update their own profile row.
--    (Admin policy already covers admins; this covers regular members.)
CREATE POLICY "user_self_update_profile"
  ON public.user_profiles FOR UPDATE TO authenticated
  USING  (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());
