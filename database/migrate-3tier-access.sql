-- ── 3-Tier Access Migration ───────────────────────────────────────────────────
-- Extends access control from 2 tiers (public/premium) to 3 tiers:
--   Programs: public | basic | premium
--   Families: standard | basic | premium
--
-- Run this in Supabase SQL Editor on existing databases.
-- Safe to run multiple times (DROP IF EXISTS + ADD COLUMN IF NOT EXISTS).
-- ─────────────────────────────────────────────────────────────────────────────

-- No schema changes needed — access_level and plan columns already exist.
-- We only need to update the RLS read policy on programs.

-- Drop old 2-tier policy
DROP POLICY IF EXISTS "programs_read" ON public.programs;

-- New 3-tier policy: public < basic < premium; admins see everything
CREATE POLICY "programs_read"
  ON public.programs FOR SELECT
  USING (
    access_level = 'public'
    OR EXISTS (
      SELECT 1
      FROM public.user_profiles up
      LEFT JOIN public.families f ON f.id = up.family_id
      WHERE up.user_id = auth.uid()
        AND (
          up.role = 'admin'
          OR (access_level = 'basic'   AND f.plan IN ('basic', 'premium'))
          OR (access_level = 'premium' AND f.plan = 'premium')
        )
    )
  );
