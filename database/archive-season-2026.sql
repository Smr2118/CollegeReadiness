-- ── Season Column Migration ───────────────────────────────────────────────────
-- Run once in Supabase SQL Editor.
-- Adds a "season" column so programs can be grouped by planning cycle.
-- All existing programs are tagged as "Summer 2026" (archived).
-- New programs added going forward will default to "Summer 2027".

ALTER TABLE public.programs
  ADD COLUMN IF NOT EXISTS season TEXT NOT NULL DEFAULT 'Summer 2027';

-- Archive all currently existing programs as Summer 2026
UPDATE public.programs
  SET season = 'Summer 2026';
