-- ── Junior Programs (Summer 2027) ──────────────────────────────────────────
-- Programs for current HS juniors (rising seniors) applying to Summer 2027.
-- Separate table so it does not affect the existing programs page.
-- Run in Supabase SQL Editor.

CREATE TABLE IF NOT EXISTS public.junior_programs (
  id                   UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name                 TEXT NOT NULL,
  org                  TEXT NOT NULL,
  category             TEXT NOT NULL,
  status               TEXT NOT NULL DEFAULT 'open',
  tier                 INTEGER NOT NULL,
  selectivity_label    TEXT,
  college_impact       INTEGER,
  college_impact_label TEXT,
  format               TEXT,
  cost                 TEXT,
  duration             TEXT,
  grades               TEXT,
  url                  TEXT,
  deadline             TEXT,
  deadline_date        DATE,
  description          TEXT,
  note                 TEXT,
  note_type            TEXT,
  tags                 TEXT[] DEFAULT '{}',
  sort_order           INTEGER DEFAULT 0,
  created_at           TIMESTAMPTZ DEFAULT NOW()
);

-- ── RLS ─────────────────────────────────────────────────────────────────────
ALTER TABLE public.junior_programs ENABLE ROW LEVEL SECURITY;

-- All signed-in users can read
CREATE POLICY "junior_programs_read"
  ON public.junior_programs FOR SELECT
  USING (auth.uid() IS NOT NULL);

-- Only admins can write
CREATE POLICY "junior_programs_admin_insert"
  ON public.junior_programs FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.user_profiles WHERE user_id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "junior_programs_admin_update"
  ON public.junior_programs FOR UPDATE
  USING (
    EXISTS (SELECT 1 FROM public.user_profiles WHERE user_id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "junior_programs_admin_delete"
  ON public.junior_programs FOR DELETE
  USING (
    EXISTS (SELECT 1 FROM public.user_profiles WHERE user_id = auth.uid() AND role = 'admin')
  );

-- ── Seed Data ────────────────────────────────────────────────────────────────
-- Ordered by deadline_date ascending (soonest first).

INSERT INTO public.junior_programs
  (name, org, category, status, tier, selectivity_label,
   college_impact, college_impact_label, format, cost, duration, grades,
   url, deadline, deadline_date, description, note, note_type, tags, sort_order)
VALUES

-- 1 — MIT PRIMES-USA (Deadline: Nov 2, 2026 — URGENT)
('MIT PRIMES-USA',
 'Massachusetts Institute of Technology',
 'Math & Physics', 'open', 1, 'Elite (~2–5% acceptance)',
 5, 'Transformative', 'Virtual', 'Free', 'Year-long (virtual, results in May 2027)',
 'Sophomores & Juniors (outside Greater Boston)',
 'https://math.mit.edu/research/highschool/primes/usa/',
 'November 2, 2026',
 '2026-11-02',
 'The most prestigious high school math research program in the US. Year-long virtual program matching students with MIT faculty mentors to work on original, publishable mathematics.
Students write a research paper and present at the PRIMES Conference in May.
Many alumni win top Regeneron STS, ISEF, and Putnam awards. Free with no prerequisites except strong math ability.',
 'DEADLINE IS NOVEMBER 2, 2026 — apply immediately. Rec letters due Nov 6. Requires solving ≥70% of the problem set in the application. Year-long commitment: research runs Jan–May 2027.',
 'priority',
 ARRAY['MIT','Mathematics','Year-Long','Research Paper','Publication Possible','Free','Virtual'],
 1),

-- 2 — RSI (Deadline: Dec 11, 2026)
('Research Science Institute (RSI)',
 'MIT / Center for Excellence in Education',
 'General STEM', 'open', 1, 'Elite (<2% acceptance)',
 5, 'Transformative', 'In-Person', 'Free', '6 weeks (residential)',
 'Rising Seniors (currently in 11th grade)',
 'https://www.cee.org/programs/research-science-institute',
 'December 11, 2026',
 '2026-12-11',
 'The most prestigious free STEM summer program in the US. Students conduct original research with MIT and Stanford faculty, write a research paper, and give an oral presentation.
2027 runs at MIT (June 20–July 31) and Stanford (June 27–August 7) — ~80 and ~50 students respectively.
RSI alumni attend MIT, Harvard, and Caltech at exceptional rates. Widely considered the single most impactful STEM program for college admissions.',
 'PRIORITY — Deadline December 11, 2026. Apply immediately. PSAT Math ≥740 recommended. Open to U.S. and international students.',
 'priority',
 ARRAY['MIT','Stanford','Residential','Research Paper','Publication Possible','Elite','Free'],
 2),

-- 3 — Rockefeller SSRP (Deadline: Jan 4, 2027)
('Rockefeller Summer Science Research Program (SSRP)',
 'Rockefeller University',
 'Life Sciences', 'open', 2, 'Very Competitive (~3–4% acceptance)',
 5, 'Transformative', 'In-Person', 'Free', '7 weeks (June 21–August 5, 2027)',
 'Juniors & Seniors (must be 16+ at start)',
 'https://www.rockefeller.edu/outreach/ssrp/',
 'January 4, 2027',
 '2027-01-04',
 'Free 7-week guided research program at Rockefeller University in NYC. One of the world''s top biomedical research institutions.
32 students placed into 4 research teams; each student commits ~35 hrs/week and presents at a final symposium.
3–4% acceptance rate. Non-residential — accessible from NJ via train/bus. Strong life sciences and computational biology focus.',
 'Deadline January 4, 2027 at 5:00pm ET. Non-residential — commute from NJ is feasible. Must be at least 16 by June 21, 2027.',
 'deadline',
 ARRAY['Rockefeller','NYC','Life Sciences','Biomedical','Non-Residential','~3% Acceptance','Free'],
 3),

-- 4 — NJ Governor's School in the Sciences (Deadline: ~Jan 10, 2027)
('NJ Governor''s School in the Sciences',
 'Drew University / State of New Jersey',
 'General STEM', 'open', 2, 'Very Competitive (NJ-nominated)',
 4, 'Very High', 'In-Person', 'Free', '3 weeks (residential)',
 'Rising Seniors (NJ juniors only)',
 'https://www.nj.gov/govschool/',
 'January 10, 2027 (est. — verify at nj.gov/govschool)',
 '2027-01-10',
 'Highly selective, tuition-free 3-week residential science program at Drew University for NJ high school juniors.
Students take advanced lab courses and complete a team research project under faculty guidance.
One of the most prestigious summer programs specifically for NJ students. Administered by the State of NJ; admission is very competitive.',
 'NJ residents only. Rising seniors (currently 11th grade). Deadline ~January 10 — verify exact 2027 date at nj.gov/govschool.',
 'deadline',
 ARRAY['New Jersey','Drew University','Residential','Free','NJ Residents Only','Rising Seniors'],
 4),

-- 5 — CMU SAMS (Deadline: Jan 15, 2027)
('Carnegie Mellon SAMS',
 'Carnegie Mellon University',
 'General STEM', 'open', 2, 'Competitive (~10–15% acceptance)',
 4, 'Very High', 'In-Person', 'Free', '6 weeks (residential)',
 'Rising Juniors (11th grade, 16+ by program start)',
 'https://www.cmu.edu/pre-college/academic-programs/sams.html',
 'January 15, 2027',
 '2027-01-15',
 'Fully funded 6-week residential pre-college program at Carnegie Mellon University for students from underrepresented backgrounds in STEM.
Combines rigorous coursework, hands-on research, and college-prep workshops. Virtual jumpstart precedes the in-person session.
CMU brand recognition adds significant college application weight.',
 'Program targets underrepresented students in STEM (first-gen, low-income, Black/Hispanic/Native American). South Asian students are generally not considered underrepresented in STEM — verify eligibility with CMU before applying.',
 'warning',
 ARRAY['CMU','Residential','Underrepresented','Free','Research','College Prep'],
 5),

-- 6 — Broad Institute BSSP (Deadline: Jan 20, 2027)
('Broad Summer Scholars Program (BSSP)',
 'Broad Institute of MIT & Harvard',
 'Life Sciences', 'open', 1, 'Elite (<5% acceptance)',
 5, 'Transformative', 'In-Person', 'Stipend', '6 weeks (July 6–Aug 13, 2027)',
 'Rising Seniors (Massachusetts HS students only)',
 'https://www.broadinstitute.org/partnerships/education/k-12-outreach/broad-summer-scholars-program',
 'January 20, 2027',
 '2027-01-20',
 'Paid 6-week biomedical research program at the Broad Institute (MIT & Harvard). Students conduct original research in genomics, cancer biology, computational biology, or infectious disease.
$3,600 stipend. Acceptance notification mid-to-late March 2027.
Among the most prestigious HS research programs in the country due to Broad Institute''s world-leading status.',
 'Massachusetts high school students ONLY. NJ students are not eligible. Listed here for awareness — file this for future reference if circumstances change.',
 'warning',
 ARRAY['Broad Institute','MIT','Harvard','$3,600 Stipend','MA Students Only','Genomics','Life Sciences'],
 6),

-- 7 — Simons Summer Research Program (Deadline: Feb 5, 2027)
('Simons Summer Research Program',
 'Stony Brook University',
 'General STEM', 'open', 1, 'Very Competitive (~5% acceptance)',
 5, 'Transformative', 'In-Person', 'Stipend', '6 weeks (June 28–Aug 6, 2027)',
 'Rising Juniors ONLY (currently in 11th grade, 16+ by June 28)',
 'https://www.stonybrook.edu/simons/',
 'February 5, 2027 (school nomination: January 29)',
 '2027-02-05',
 'Prestigious 6-week summer research fellowship at Stony Brook University. Students are matched 1:1 with faculty mentors for hands-on original STEM research in science, math, or engineering.
Receive a $1,000 stipend at the closing symposium. <5% acceptance.
Exclusively open to current 11th graders — you cannot apply as a senior. Frequently cited alongside RSI in prestige.',
 'Requires a school nomination (due Jan 29, 2027) before submitting your own application (due Feb 5, 2027). Ask your school counselor to nominate you NOW. JUNIORS ONLY — you cannot apply next year.',
 'deadline',
 ARRAY['Stony Brook','$1,000 Stipend','Faculty Mentorship','Juniors Only','~5% Acceptance','NY'],
 7),

-- 8 — Clark Scholars Program (Deadline: Feb 15, 2027)
('Anson L. Clark Scholars Program',
 'Texas Tech University',
 'General STEM', 'open', 1, 'Elite (~1–2%, only 12 students)',
 5, 'Transformative', 'In-Person', 'Stipend', '7 weeks (residential)',
 'Rising Seniors (must be 17+ by program start)',
 'https://www.depts.ttu.edu/clarkscholars',
 'February 15, 2027',
 '2027-02-15',
 'Ultra-selective 7-week residential research program: only 12 students chosen nationally from ~700+ applicants (~2%).
Free (room, board, activities) plus a $750 stipend upon submitting a research report.
Students design and execute an independent research project under faculty mentorship. Covers both STEM and humanities disciplines. Often compared to RSI in prestige despite the Texas Tech location.',
 'Application opens January 2, 2027. Must be at least 17 years old by the program start date in June 2027. U.S. citizens/permanent residents only.',
 'deadline',
 ARRAY['Texas Tech','Residential','$750 Stipend','12 Students Total','~2% Acceptance','Elite','Free'],
 8),

-- 9 — Stanford SIMR (Deadline: ~Feb 21, 2027)
('Stanford SIMR',
 'Stanford University School of Medicine',
 'Life Sciences', 'open', 2, 'Very Competitive',
 4, 'Very High', 'In-Person', 'Free', '8 weeks (~June 7–July 29, 2027)',
 'Rising Juniors & Seniors (16+ by program start)',
 'https://med.stanford.edu/simr.html',
 'Late February 2027 (~February 21)',
 '2027-02-21',
 'Free 8-week in-person biomedical research internship at Stanford School of Medicine. Students are placed in Stanford labs to work on real faculty research projects.
National competition open to US students everywhere — NJ students are eligible.
Application opens December 18, 2026. Waives the $50 application fee for families under $80,000 gross income.',
 'Application opens December 18, 2026. Deadline ~February 21, 2027. No cost (small $50 app fee waived for low-income families).',
 'deadline',
 ARRAY['Stanford','Biomedical','Life Sciences','8 Weeks','Faculty Research','National','In-Person','Free'],
 9),

-- 10 — PROMYS (Deadline: ~Feb 28, 2027)
('PROMYS — Program in Mathematics for Young Scientists',
 'Boston University',
 'Math & Physics', 'open', 2, 'Competitive (~10–15% acceptance)',
 4, 'Very High', 'In-Person', 'Paid', '6 weeks (June 27–Aug 7, 2027, residential)',
 'Rising 9th–12th Graders',
 'https://promys.org/programs/promys/for-students/',
 'Late February 2027 (exact date TBD)',
 '2027-02-28',
 'Elite 6-week residential mathematics program at Boston University. Deep, proof-based exploration of number theory and mathematical thinking — no prior formal training required, just strong curiosity and problem-solving ability.
~80 students per year (plus ~25 undergraduate counselors). Application requires solving a challenging problem set — no standardized test scores considered.
Alumni frequently attend MIT, Harvard, Princeton math departments. AMS-recognized program.',
 'Full price ~$8,000 but generous need-based financial aid available (including full scholarship). Application is a challenging problem set — start it early. Deadline end of February 2027.',
 'info',
 ARRAY['Boston University','Mathematics','Residential','6 Weeks','Number Theory','Financial Aid Available','Problem Set Application'],
 10),

-- 11 — Garcia Center for Polymers (Deadline: Mar 1, 2027)
('Garcia Center for Polymers Summer Research',
 'Stony Brook University — Garcia Center',
 'General STEM', 'open', 2, 'Competitive (~10–15%, ~30–40 students)',
 4, 'Very High', 'In-Person', 'Free', '7 weeks (late June–mid August)',
 'Rising Juniors & Seniors (16+, must have completed chemistry)',
 'https://www.stonybrook.edu/commcms/garcia/',
 'March 1, 2027',
 '2027-03-01',
 'NSF-funded 7-week research program at Stony Brook focused on polymers, nanomaterials, soft matter, biomaterials, and energy materials. Students design and execute original research projects with faculty guidance.
~30–40 students selected nationally. Program has an exceptional track record producing Regeneron STS and Intel/ISEF finalists.
Free (NSF-funded). Proximity to NJ makes commuting or short-term housing straightforward.',
 'Deadline March 1, 2027. Must have completed high school chemistry. NSF funding = free. Strong materials science / nanotechnology research output.',
 'deadline',
 ARRAY['Stony Brook','NSF-Funded','Materials Science','Nanomaterials','Polymers','Regeneron STS Alums','Free'],
 11),

-- 12 — Princeton Laboratory Learning Program (Deadline: Mar 16, 2027)
('Princeton Laboratory Learning Program (LLP)',
 'Princeton University',
 'General STEM', 'open', 2, 'Very Competitive (~5–10%)',
 4, 'Very High', 'In-Person', 'Free', '5–6 weeks (summer)',
 'High School Students (NJ residents, 16+ by June 15)',
 'https://lsi.princeton.edu/high-school-students',
 'March 16, 2027',
 '2027-03-16',
 'Free full-time research internship at Princeton University for local NJ high school students. Students assist in actual undergraduate-level research under direct Princeton faculty or research staff supervision.
700+ applicants annually; most individual projects accept only 1–2 students. NJ''s most prestigious university-affiliated high school research opportunity.
Application opens February 15, 2027.',
 'NJ and local high school students only. Must be 16+ by June 15, 2027. Application opens Feb 15, 2027. Deadline March 16, 2027. One of the most competitive NJ-specific opportunities.',
 'deadline',
 ARRAY['Princeton','NJ Residents','Free','In-Person','Faculty Research','Ultra-Competitive','NJ'],
 12);
