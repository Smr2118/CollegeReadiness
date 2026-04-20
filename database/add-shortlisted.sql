-- Add shortlisted flag to all three brainstorm tables
ALTER TABLE essay_topics   ADD COLUMN IF NOT EXISTS shortlisted boolean NOT NULL DEFAULT false;
ALTER TABLE robotics_ideas ADD COLUMN IF NOT EXISTS shortlisted boolean NOT NULL DEFAULT false;
ALTER TABLE ideas          ADD COLUMN IF NOT EXISTS shortlisted boolean NOT NULL DEFAULT false;
