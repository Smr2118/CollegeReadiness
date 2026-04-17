-- ── Program Access Control Migration ────────────────────────────────────────
-- Run this in Supabase SQL Editor AFTER programs.sql
-- (Skip if programs.sql was not yet run — access_level is already in the updated schema)

-- 1. Add access_level to programs (public | basic | premium)
ALTER TABLE public.programs
  ADD COLUMN IF NOT EXISTS access_level TEXT NOT NULL DEFAULT 'public';

-- 2. Add plan to families (standard | basic | premium)
ALTER TABLE public.families
  ADD COLUMN IF NOT EXISTS plan TEXT NOT NULL DEFAULT 'standard';

-- 3. Replace the blanket public read policy with a tier-aware one
DROP POLICY IF EXISTS "programs_public_read" ON public.programs;
DROP POLICY IF EXISTS "programs_read"        ON public.programs;

-- Tier hierarchy: public < basic < premium; admins see everything
CREATE POLICY "programs_read"
  ON public.programs FOR SELECT
  USING (
    -- Public programs visible to everyone (including anonymous)
    access_level = 'public'
    OR
    -- Basic/Premium programs visible based on family plan or admin role
    EXISTS (
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
