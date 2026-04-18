-- ── Fix program_data unique constraint ───────────────────────────────────────
-- The original program_data table predates the family_id column.
-- The upsert in SupabaseSync uses onConflict:'family_id,program_name' which
-- requires a unique constraint on BOTH columns. Without it, every save inserts
-- a new duplicate row instead of updating, so interest/notes are never updated.
--
-- Run this once in Supabase SQL Editor.
-- Safe to re-run (uses IF NOT EXISTS / DROP IF EXISTS).
-- ─────────────────────────────────────────────────────────────────────────────

-- 1. Drop any stale single-column unique constraint on program_name alone
--    (the old constraint name may vary — drop by name if known, otherwise skip)
ALTER TABLE public.program_data
  DROP CONSTRAINT IF EXISTS program_data_program_name_key;

-- 3. Add the composite unique constraint required by the upsert (idempotent)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'program_data_family_program_unique'
      AND conrelid = 'public.program_data'::regclass
  ) THEN
    ALTER TABLE public.program_data
      ADD CONSTRAINT program_data_family_program_unique
      UNIQUE (family_id, program_name);
  END IF;
END $$;

-- 4. Deduplicate: keep only the most-recently-updated row per (family_id, program_name)
--    so the new constraint can be applied cleanly.
DELETE FROM public.program_data
WHERE ctid NOT IN (
  SELECT DISTINCT ON (family_id, program_name) ctid
  FROM public.program_data
  ORDER BY family_id, program_name, updated_at DESC NULLS LAST
);

-- Done. Verify with:
--   SELECT constraint_name FROM information_schema.table_constraints
--   WHERE table_name = 'program_data';
