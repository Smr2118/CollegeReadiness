-- ── Nav Access Table ─────────────────────────────────────────────────────────
-- Controls which sidebar links are visible per plan tier.
-- Run this in Supabase SQL Editor.
-- ─────────────────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS public.nav_access (
  path      TEXT PRIMARY KEY,
  min_plan  TEXT NOT NULL DEFAULT 'standard'
    CHECK (min_plan IN ('standard', 'basic', 'premium'))
);

ALTER TABLE public.nav_access ENABLE ROW LEVEL SECURITY;

-- All authenticated users can read (needed for client-side link hiding)
CREATE POLICY "nav_access_select" ON public.nav_access FOR SELECT TO authenticated
  USING (true);

-- Only admins can write
CREATE POLICY "nav_access_admin_write" ON public.nav_access FOR ALL TO authenticated
  USING  ((auth.jwt()->'user_metadata'->>'role') = 'admin')
  WITH CHECK ((auth.jwt()->'user_metadata'->>'role') = 'admin');
