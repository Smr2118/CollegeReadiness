-- ── Login events ─────────────────────────────────────────────────────────────
-- Run this in Supabase SQL Editor.
-- Tracks every successful sign-in from the client.

CREATE TABLE IF NOT EXISTS public.login_events (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  family_id    TEXT,
  logged_in_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE public.login_events ENABLE ROW LEVEL SECURITY;

-- Users can insert their own login events
CREATE POLICY "login_events_insert" ON public.login_events
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Admins can read all login events
CREATE POLICY "login_events_admin_read" ON public.login_events
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.user_profiles
      WHERE user_id = auth.uid() AND role = 'admin'
    )
  );

-- Handy index for per-user queries
CREATE INDEX IF NOT EXISTS login_events_user_idx ON public.login_events(user_id, logged_in_at DESC);
