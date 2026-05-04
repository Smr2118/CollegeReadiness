-- ============================================================
-- Add family_head role to user_profiles
-- Run this in Supabase SQL Editor
-- ============================================================

-- Widen the role check constraint to include family_head
ALTER TABLE public.user_profiles DROP CONSTRAINT IF EXISTS user_profiles_role_check;
ALTER TABLE public.user_profiles
  ADD CONSTRAINT user_profiles_role_check
  CHECK (role IN ('admin', 'member', 'family_head'));
