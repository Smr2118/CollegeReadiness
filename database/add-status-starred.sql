-- Add status and starred columns to all Brainstorm section tables

ALTER TABLE essay_topics    ADD COLUMN IF NOT EXISTS status  text    NOT NULL DEFAULT 'Open';
ALTER TABLE essay_topics    ADD COLUMN IF NOT EXISTS starred boolean NOT NULL DEFAULT false;

ALTER TABLE robotics_ideas  ADD COLUMN IF NOT EXISTS status  text    NOT NULL DEFAULT 'Open';
ALTER TABLE robotics_ideas  ADD COLUMN IF NOT EXISTS starred boolean NOT NULL DEFAULT false;

ALTER TABLE ideas            ADD COLUMN IF NOT EXISTS status  text    NOT NULL DEFAULT 'Open';
ALTER TABLE ideas            ADD COLUMN IF NOT EXISTS starred boolean NOT NULL DEFAULT false;

ALTER TABLE family_notes    ADD COLUMN IF NOT EXISTS status  text    NOT NULL DEFAULT 'Open';
ALTER TABLE family_notes    ADD COLUMN IF NOT EXISTS starred boolean NOT NULL DEFAULT false;
