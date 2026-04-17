-- ── Programs Table ──────────────────────────────────────────────────────────
-- Run this in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS public.programs (
  id                   UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name                 TEXT NOT NULL,
  org                  TEXT NOT NULL,
  category             TEXT NOT NULL,
  status               TEXT NOT NULL DEFAULT 'open',
  tier                 INTEGER NOT NULL,
  rating               NUMERIC(3,1),
  selectivity          TEXT,
  selectivity_label    TEXT,
  college_impact       INTEGER,
  college_impact_label TEXT,
  format               TEXT,
  cost                 TEXT,
  duration             TEXT,
  grades               TEXT,
  url                  TEXT,
  deadline             TEXT,
  description          TEXT,
  note                 TEXT,
  note_type            TEXT,
  tags                 TEXT[] DEFAULT '{}',
  tracks               JSONB,
  access_level         TEXT NOT NULL DEFAULT 'public', -- 'public' | 'basic' | 'premium'
  sort_order           INTEGER DEFAULT 0,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  updated_at           TIMESTAMPTZ DEFAULT NOW()
);

-- ── RLS ─────────────────────────────────────────────────────────────────────
ALTER TABLE public.programs ENABLE ROW LEVEL SECURITY;

-- Ensure families.plan column exists before creating the access-aware policy
ALTER TABLE public.families ADD COLUMN IF NOT EXISTS plan TEXT NOT NULL DEFAULT 'standard';

-- Tiered access: public < basic < premium; admins see everything
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

-- Only admins can insert / update / delete
CREATE POLICY "programs_admin_insert"
  ON public.programs FOR INSERT
  WITH CHECK (
    EXISTS (SELECT 1 FROM public.user_profiles WHERE user_id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "programs_admin_update"
  ON public.programs FOR UPDATE
  USING (
    EXISTS (SELECT 1 FROM public.user_profiles WHERE user_id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "programs_admin_delete"
  ON public.programs FOR DELETE
  USING (
    EXISTS (SELECT 1 FROM public.user_profiles WHERE user_id = auth.uid() AND role = 'admin')
  );

-- ── Seed Data ────────────────────────────────────────────────────────────────
-- Migrate all programs from programs.json
-- Run once; skip if already seeded.

INSERT INTO public.programs
  (name, org, category, status, tier, rating, selectivity, selectivity_label,
   college_impact, college_impact_label, format, cost, duration, grades,
   url, deadline, description, note, note_type, tags, tracks, sort_order)
VALUES

-- 1
('Harvard Summer Research Institute (SRI)',
 'Harvard University',
 'General STEM', 'open', 1, 5.0, 'very', 'Very Competitive (<10%)',
 5, 'Transformative', 'In-Person', 'Free', 'Summer (6–8 weeks)', 'Rising Juniors/Seniors',
 'https://soco.college.harvard.edu/00003/openbio-home/',
 'April 27, 2026',
 'Harvard-affiliated summer research program pairing students with faculty mentors. Work on real scientific projects with access to Harvard labs and resources. Among the most prestigious HS summer programs in the country.',
 'FIRST PRIORITY — Application due April 27, 2026',
 'priority',
 ARRAY['Harvard','Research','Faculty Mentorship','Stipend Possible'],
 NULL, 1),

-- 2
('MIT Research Science Institute (RSI)',
 'MIT / Center for Excellence in Education',
 'General STEM', 'closed', 1, 5.0, 'elite', 'Elite (<2% acceptance)',
 5, 'Transformative', 'In-Person', 'Free', '6 weeks (residential)', 'Rising Seniors (Juniors)',
 'https://www.cee.org/programs/research-science-institute',
 'Deadline Passed — Apply Next Year',
 'Considered the most prestigious free high school summer STEM program in the US. Students work closely with MIT faculty and present oral and written research, with possibility of publication. Alumni regularly attend MIT, Harvard, Caltech, and other top universities at exceptional rates.',
 'Deadline passed for 2026. Add to calendar for next year. ~80 students selected nationally from thousands of applicants.',
 'deadline',
 ARRAY['MIT','Residential','Research Paper','Publication','Highly Prestigious'],
 NULL, 2),

-- 3
('MIT PRIMES-USA',
 'Massachusetts Institute of Technology',
 'Math & Physics', 'nextyear', 1, 5.0, 'elite', 'Elite (~2–5% acceptance)',
 5, 'Transformative', 'Virtual', 'Free', 'Year-long (virtual)', 'Sophomores & Juniors',
 'https://math.mit.edu/research/highschool/primes/usa/',
 'Deadline Passed (was Dec/Jan 2026) — Apply Next Year',
 'The best high school math research program in the country. Year-long virtual program with MIT mentors. Students work on original mathematics problems and write a publishable research paper. Many participants go on to win top honors at Regeneron/Siemens/Intel competitions.',
 'Deadline passed for 2026. Applications for 2027 cycle typically open in fall. Apply in December–January.',
 'deadline',
 ARRAY['MIT','Mathematics','Year-Long','Research Paper','Publication','Competitions'],
 NULL, 3),

-- 4
('MIT PRIMES (Local, Year-Round)',
 'Massachusetts Institute of Technology',
 'Math & Physics', 'nextyear', 1, 5.0, 'elite', 'Elite',
 5, 'Transformative', 'In-Person', 'Free', 'Year-long', 'All Grades',
 'https://math.mit.edu/research/highschool/primes/',
 'Deadline Passed (was Dec 1, 2025) — Apply Next Year (applications open Sept 2026)',
 'In-person local section of MIT PRIMES for students who can travel to MIT regularly. Offers guided reading and original research in mathematics, computer science, and computational biology. The most elite HS math program in the US.',
 'Deadline passed for 2026 cycle (was Dec 1, 2025). Application link for 2027 cycle appears on their website in September 2026. Requires ability to travel to MIT campus regularly.',
 'deadline',
 ARRAY['MIT','Mathematics','CS','Year-Long','In-Person Required','Research Paper'],
 NULL, 4),

-- 5
('Telluride Association Summer Seminar (TASS)',
 'Telluride Association — Cornell / UMD',
 'Humanities', 'closed', 1, 5.0, 'elite', 'Elite (~2–3% acceptance)',
 5, 'Transformative', 'In-Person', 'Free', '~6 weeks (residential)', 'Juniors & Seniors',
 'https://tellurideassociation.org/our-programs/high-school-students/',
 'Deadline Passed (was Dec 3, 2025) — Apply Next Year',
 'One of the most intellectually challenging and selective free humanities programs for high schoolers. Month-long residential seminar at Cornell University or UMD exploring advanced social science, philosophy, and critical theory. Taught by college faculty. Open to international students; travel assistance available.',
 'Deadline passed for 2026 (was Dec 3, 2025). Add to calendar for next year.',
 'deadline',
 ARRAY['Humanities','Residential','International OK','Travel Aid','Cornell / UMD','Full Scholarship'],
 NULL, 5),

-- 6
('Simons Summer Research Program',
 'Stony Brook University',
 'General STEM', 'closed', 1, 5.0, 'very', 'Very Competitive (~5% acceptance)',
 5, 'Transformative', 'In-Person', 'Free', '8 weeks', 'Rising Juniors',
 'https://www.stonybrook.edu/commcms/simons/',
 'Deadline Passed — Apply Next Year',
 'Highly prestigious 8-week summer research fellowship pairing high school juniors with Stony Brook faculty. Students conduct original research and present a poster and abstract. Exceptional for STEM college applications; frequently mentioned alongside RSI in prestige.',
 'Deadline passed for 2026. Add to calendar for next year.',
 'deadline',
 ARRAY['Research','Faculty Mentorship','Poster Presentation','Publication Possible'],
 NULL, 6),

-- 7
('Texas Tech Clark Scholars Program',
 'Texas Tech University',
 'General STEM', 'closed', 1, 5.0, 'elite', 'Elite (~1% acceptance, ~15 spots)',
 5, 'Transformative', 'In-Person', 'Stipend', '~7 weeks (residential)', 'Must be 17+',
 'https://www.depts.ttu.edu/clarkscholars',
 'Deadline Passed — Apply Next Year',
 'One of the most selective and prestigious engineering/STEM summer programs for high schoolers. Only ~15 students are selected nationally from 1,000+ applicants. Free residential program with $750 stipend. Frequently compared to RSI in prestige. Students conduct independent research under faculty mentorship.',
 'Deadline passed for 2026. Add to calendar for next year. Must be at least 17 years old to apply.',
 'deadline',
 ARRAY['Engineering','Residential','$750 Stipend','Age 17+','Very Few Spots'],
 NULL, 7),

-- 8
('Yale High School Social Robotics Internship',
 'Yale University — SCAZLAB',
 'Robotics & AI', 'closed', 2, 4.5, 'very', 'Very Competitive (~5–10% acceptance)',
 5, 'Very High', 'In-Person', 'Free', '6 weeks', 'Rising Juniors & Seniors (Must be 16+)',
 'https://scazlab.yale.edu/prospective-students/prospective-high-school-interns',
 'Deadline Passed — Apply Next Year',
 'Yale-affiliated research internship focused on social behaviors in robots and humans. Extremely prestigious program with significant college application weight. Students work in Yale''s cutting-edge HRI (Human-Robot Interaction) lab on real projects. Non-residential, in-person at Yale campus.',
 'Deadline passed for 2026. Add to calendar for next year. Must be 16+ and rising junior or senior.',
 'deadline',
 ARRAY['Yale','Robotics','HRI','Research','Non-Residential'],
 NULL, 8),

-- 9
('MIT Beaver Works Summer Institute (BWSI)',
 'MIT Lincoln Laboratory',
 'Computer Science & Engineering', 'closed', 2, 4.5, 'competitive', 'Competitive (~15–20% acceptance)',
 4, 'Very High', 'In-Person', 'Free', '4 weeks (residential)', 'Rising Seniors',
 'https://bwsi.mit.edu/bwsi-programs/',
 'Deadline Passed — Apply Next Year',
 'MIT Lincoln Laboratory''s intensive 4-week summer program. Students complete an online prerequisite course and, if selected, attend in person at MIT. Covers topics like autonomous vehicles, cybersecurity, satellite design, and more. Well-regarded by college admissions officers due to MIT affiliation.',
 'Deadline passed for 2026. Requires completion of an online prerequisite course before applying to in-person portion. Add to calendar for next year.',
 'deadline',
 ARRAY['MIT','Residential','Engineering','Technology','Online Prereq'],
 NULL, 9),

-- 10
('Air Force Research Laboratory Scholars Program',
 'AFRL / USRA',
 'Math & Physics', 'closed', 2, 4.5, 'very', 'Very Competitive',
 5, 'Very High', 'In-Person', 'Stipend', 'Summer + school-year options', 'All Grades',
 'https://afrlscholars.usra.edu/scholarsprogram/application/',
 'Deadline Passed — Apply Next Year',
 'Prestigious government research program at Air Force Research Laboratory locations across the country. Free with stipend. Students conduct real research at AFRL facilities with government scientists. Covers math, physics, engineering, CS, and general STEM. Very competitive and highly regarded by college AOs due to government prestige.',
 'Deadline passed for 2026. Add to calendar for next year.',
 'deadline',
 ARRAY['Government','AFRL','Stipend','In-Person','All Grades','Research'],
 NULL, 10),

-- 11
('Rockefeller Summer Science Research Program (SSRP)',
 'Rockefeller University',
 'Life Sciences', 'closed', 2, 4.5, 'competitive', 'Competitive (~10–15% acceptance)',
 4, 'Very High', 'In-Person', 'Free', 'Summer (~7 weeks)', 'Juniors & Seniors (Must be 16+)',
 'https://www.rockefeller.edu/outreach/ssrp/',
 'Deadline Passed — Apply Next Year',
 'Free non-residential summer research program at NYC''s premier biomedical research university. Students work in teams to develop research under Rockefeller faculty. Renowned for its scientific rigor and the prestige of working at one of the world''s top research institutions.',
 'Deadline passed for 2026. Add to calendar for next year. Non-residential; requires ability to travel to NYC.',
 'deadline',
 ARRAY['Rockefeller','NYC','Biomedical','Team Research','Non-Residential','16+'],
 NULL, 11),

-- 12
('CMU SAMS (Summer Academy for Math & Science)',
 'Carnegie Mellon University',
 'General STEM', 'closed', 2, 4.5, 'competitive', 'Competitive (~10–15%)',
 4, 'Very High', 'In-Person', 'Free', '6 weeks (residential)', 'Rising Juniors (Underrepresented students)',
 'https://www.cmu.edu/pre-college/academic-programs/sams.html',
 'Deadline Passed (was Feb 1, 2026) — Apply Next Year',
 'Fully funded 6-week residential pre-college program at Carnegie Mellon for underrepresented students in STEM. Combines rigorous coursework, hands-on research, and college-prep workshops. Strong CMU brand recognition greatly boosts college applications.',
 'Deadline passed for 2026 (was Feb 1, 2026). Add to calendar for next year. Targeted at underrepresented students in STEM (first-gen, low-income, minority).',
 'deadline',
 ARRAY['CMU','Residential','Underrepresented','Free','Research','College Prep'],
 NULL, 12),

-- 13
('Stanford SPINWIP',
 'Stanford University — Physics Department',
 'Math & Physics', 'open', 2, 4.5, 'very', 'Very Competitive',
 5, 'Very High', 'In-Person', 'Free', 'Summer', 'Rising Juniors & Seniors (Underrepresented in Physics)',
 'https://physics.stanford.edu/about/inclusion/spinwip',
 'Check website',
 'Stanford Physics'' program for students underrepresented in physics. Provides access to world-class Stanford physicists and labs. Exceptional for college applications due to Stanford affiliation and focus on diversity in physics research.',
 'Focused on underrepresented students in physics. Application still open.',
 'info',
 ARRAY['Stanford','Physics','Diversity','Research','Faculty Mentorship'],
 NULL, 13),

-- 14
('UPenn GRASP Lab High School Internships',
 'University of Pennsylvania — GRASP Lab',
 'Robotics & AI', 'nextyear', 2, 4.5, 'very', 'Very Competitive (~10% or less)',
 4, 'Very High', 'In-Person', 'Free', '6 weeks', 'Rising Seniors',
 'https://www.grasp.upenn.edu/programs/high-school-internships/',
 'Apply Next Year',
 'Internships at UPenn''s world-renowned General Robotics, Automation, Sensing & Perception (GRASP) Lab. Students work directly with robotics faculty and graduate students on cutting-edge research. Must contact faculty directly to apply. Prioritizes underrepresented students.',
 'Deadline already passed for this cycle — bookmark for next year.',
 'nextyear',
 ARRAY['UPenn','Robotics','Non-Residential','In-Person','Rising Seniors','Underrepresented'],
 NULL, 14),

-- 15
('AMNH Science Research Mentoring Program (SRMP)',
 'American Museum of Natural History',
 'General STEM', 'closed', 2, 4.0, 'competitive', 'Competitive (~10–15%)',
 4, 'Very High', 'In-Person', 'Stipend', 'Begins August, continues through school year', 'Sophomores & Juniors (NYC residents only)',
 'https://www.amnh.org/learn-teach/teens/science-research-mentoring-program',
 'Deadline Passed (was March 1, 2026) — Apply Next Year',
 'Year-long mentored research program at the American Museum of Natural History in NYC. Students receive a $2,500 stipend. Covers diverse science disciplines. Requires weekly in-person visits to the museum. Highly regarded and rare opportunity to work at a world-class museum.',
 'Deadline passed (March 1, 2026). Add to calendar for next year. NYC residents only. Must attend a partner school or specific classes. Weekly in-person attendance required.',
 'deadline',
 ARRAY['AMNH','NYC Only','$2,500 Stipend','Year-Long','Weekly In-Person'],
 NULL, 15),

-- 16
('PROMYS (Program in Mathematics for Young Scientists)',
 'Boston University',
 'Math & Physics', 'closed', 2, 4.5, 'competitive', 'Competitive (~10–15%)',
 4, 'Very High', 'In-Person', 'Free', '6 weeks (residential)', 'Rising 9th–12th',
 'https://promys.org/programs/promys/for-students/',
 'Deadline Passed — Apply Next Year',
 'Elite residential mathematics program at Boston University focused on deep exploration of mathematical thinking. Students work on problem sets, number theory, and collaborate with Boston University math faculty. Alumni frequently go on to top math PhD programs. Highly recognized by admissions offices.',
 'Deadline passed for 2026. Add to calendar for next year.',
 'deadline',
 ARRAY['Mathematics','Residential','Boston University','Number Theory','6 Weeks'],
 NULL, 16),

-- 17
('NYU ARISE',
 'New York University — Tandon School of Engineering',
 'Computer Science & Engineering', 'closed', 2, 4.0, 'competitive', 'Competitive (~15–20%)',
 4, 'Very High', 'In-Person', 'Free', 'Summer (6–7 weeks)', 'Rising Juniors & Seniors (NYC area)',
 'https://k12stem.engineering.nyu.edu/programs/arise',
 'Deadline Passed',
 'Free research program at NYU Tandon for NYC-area high schoolers. Students work in NYU labs on engineering and science research projects. Strong college application impact due to NYU affiliation and rigorous research experience.',
 'Deadline already passed for this year.',
 'deadline',
 ARRAY['NYU','Engineering','NYC Area','Research'],
 NULL, 17),

-- 18
('Naval SEAP (Science & Engineering Apprenticeship Program)',
 'US Navy / DoD — ASEE',
 'General STEM', 'nextyear', 2, 4.0, 'competitive', 'Competitive (~10–20%, varies by lab)',
 4, 'Very High', 'In-Person', 'Stipend', '8 weeks', 'Rising Juniors & Seniors (US citizens only)',
 'https://www.navalsteminterns.us/seap/',
 'Deadline Passed — Apply Next Year',
 'Run by ASEE on behalf of the US Navy. Students are placed in active Naval Research Laboratory (NRL) or other DoD facilities doing real research alongside actual scientists. ~$3,500–4,500 stipend for the summer. One of the few HS programs with paid, authentic DoD lab research. Reddit consistently praises it as among the most ''real'' research experiences available to high schoolers. Some students have published from SEAP placements.',
 'Deadline passed for 2026. Requires US citizenship. Apply next year.',
 'deadline',
 ARRAY['Navy','DoD','Government','$3,500–4,500 Stipend','In-Person','US Citizens Only','Publication Possible'],
 NULL, 18),

-- 19
('Columbia BrainYAC',
 'Columbia University — Zuckerman Institute',
 'Life Sciences', 'conflict', 2, 4.0, 'very', 'Very Competitive (<10%, ~15–25 students)',
 5, 'Very High', 'In-Person', 'Free', '6–8 weeks', 'High School Students (NYC area, underrepresented priority)',
 'https://zuckermaninstitute.columbia.edu/brainyac',
 'Not Applicable — Ineligible',
 'Students conduct neuroscience research in actual Columbia Zuckerman Institute labs — one of the world''s premier brain science centers. Extremely small cohort (~15–25 students) makes this highly selective. Alumni have used BrainYAC research as the foundation for Regeneron STS and Siemens competition entries. Highly regarded by admissions officers familiar with it.',
 'NOT ELIGIBLE — Must live in NYC and be enrolled in a partner program (S-PREP, BioBus, Lang Youth Medical, Columbia Secondary School, or Double Discovery Center).',
 'deadline',
 ARRAY['Columbia','Neuroscience','Zuckerman Institute','Tiny Cohort','Regeneron STS','Research'],
 NULL, 19),

-- 20
('George Mason ASSIP',
 'George Mason University',
 'General STEM', 'closed', 3, 3.5, 'moderate', 'Moderately Competitive (~20–30%)',
 3, 'High', 'Hybrid', 'Free', 'Summer (~8 weeks)', 'Rising Sophomores, Juniors & Seniors (Must be 15+)',
 'https://science.gmu.edu/assip',
 'Deadline Passed — Apply Next Year',
 'Aspiring Scientists Summer Internship Program — one of the most popular and accessible free summer research programs in the US. Offers remote, hybrid, and in-person options. Essentially any STEM field available. Culminates in a poster presentation. Very broad research area coverage. $25 application fee.',
 'Deadline passed for 2026. Add to calendar for next year. $25 application fee (only cost).',
 'deadline',
 ARRAY['George Mason','Remote Option','Hybrid','Poster Presentation','Broad STEM','$25 App Fee'],
 NULL, 20),

-- 21
('Columbia S-PREP',
 'Columbia University — Vagelos College',
 'Life Sciences', 'open', 3, 3.5, 'moderate', 'Moderately Competitive',
 4, 'High', 'In-Person', 'Free', 'Summer', 'High School Students (NY State Residents)',
 'https://www.vagelos.columbia.edu/education/academic-programs/educational-opportunities/summer-youth-programs/middle-high-school-students/state-pre-college-enrichment-program-s-prep',
 'Check website',
 'Columbia University''s State Pre-College Enrichment Program for NY state residents. Provides underrepresented high schoolers with biomedical science exposure, mentorship, and college preparation. Columbia affiliation significantly boosts college application appeal.',
 'NY State residents only.',
 'warning',
 ARRAY['Columbia','Biomedical','NY State Only','Pre-College','College Prep'],
 NULL, 21),

-- 22
('UIUC Grainger Young Scholars STEMM Program',
 'University of Illinois Urbana-Champaign',
 'General STEM', 'closed', 3, 3.5, 'moderate', 'Moderately Competitive (~20–25%)',
 3, 'High', 'In-Person', 'Free', 'Summer (multi-week)', 'Rising 10th, 11th & 12th (IL, WI, IN, KY, MI, MO, IA)',
 'https://wyse.grainger.illinois.edu/summer-programs/young-scholars-summer-research',
 'Deadline Passed (Priority: March 31, 2026) — Apply Next Year',
 'Free STEM research program at UIUC focused on engineering applications across STEM fields. Residential housing available for non-local students. Strong program for students in the Midwest; UIUC''s engineering reputation adds credibility.',
 'Limited to students in Wisconsin, Illinois, Indiana, Kentucky, Michigan, Missouri, or Iowa.',
 'warning',
 ARRAY['UIUC','Midwest Only','Residential Option','Engineering','10th–12th Grade'],
 NULL, 22),

-- 23
('UIUC WYSE High School Summer STEM Research',
 'University of Illinois Urbana-Champaign',
 'General STEM', 'closed', 3, 3.5, 'moderate', 'Moderately Competitive',
 3, 'High', 'In-Person', 'Free', '6 weeks', 'Rising Juniors & Seniors',
 'https://wyse.grainger.illinois.edu/summer-programs',
 'Deadline Passed — Apply Next Year',
 'Free faculty-mentored STEM research experience at UIUC for rising juniors and seniors. Non-residential. Culminates in a final poster symposium. Solid regional program with good university reputation behind it.',
 'Deadline passed for 2026. Add to calendar for next year.',
 'deadline',
 ARRAY['UIUC','Non-Residential','Faculty Mentored','Poster Symposium'],
 NULL, 23),

-- 24
('Library of Congress High School Summer Internship',
 'Library of Congress',
 'Humanities', 'open', 3, 3.5, 'moderate', 'Moderately Competitive (~20–25%)',
 3, 'High', 'Hybrid', 'Free', '~1 month', 'Sophomores, Juniors & Seniors (Must be 16+)',
 'https://www.loc.gov/item/internships/high-school-summer-internship/',
 'Check website',
 'Rare opportunity to intern at the largest library in the world. Students work with library collections, talk with visitors, and participate in museum research. Unique for humanities students; the Library of Congress name carries significant weight on college applications.',
 'Must be 16+. Hybrid program (some in-person in DC, some remote).',
 'info',
 ARRAY['Library of Congress','DC','Humanities','Museum','Collections','16+'],
 NULL, 24),

-- 25
('Metropolitan Museum of Art — High School Internship',
 'The Metropolitan Museum of Art',
 'Humanities', 'closed', 3, 4.0, 'competitive', 'Competitive (~15%)',
 4, 'High', 'In-Person', 'Stipend', '~1 month (summer); school-year options too', 'Juniors & Seniors (NYC metro: NY, CT, NJ)',
 'https://www.metmuseum.org/about-the-met/internships/high-school/summer-high-school-internships',
 'Deadline Passed (was March 13, 2026) — Apply Next Year',
 'Highly competitive and hands-on internship at one of the world''s greatest art museums. Students receive a $1,100 stipend, conduct research, and present findings at the end. School-year internships also available. Outstanding for humanities or arts-focused students.',
 'Deadline passed for 2026 (was March 13, 2026). Must live in NYC metro area (NY, CT, or NJ). Add to calendar for next year.',
 'deadline',
 ARRAY['The Met','NYC Metro Only','$1,100 Stipend','Arts','Humanities','In-Person'],
 NULL, 25),

-- 26
('NASA GL4HS (GeneLab for High School)',
 'NASA',
 'Life Sciences', 'open', 3, 3.5, 'competitive', 'Competitive',
 4, 'High', 'Virtual', 'Free', 'Summer', 'All Grades',
 'https://www.nasa.gov/learning-resources/internship-programs/',
 'Check website',
 'NASA''s GeneLab for High School program exposes students to space biology and omics data analysis. Students analyze real NASA spaceflight data. The NASA name alone carries exceptional weight on college applications, regardless of program tier.',
 NULL, NULL,
 ARRAY['NASA','Space Biology','Virtual','Data Analysis','High Prestige'],
 NULL, 26),

-- 27
('Michigan State PAN Program',
 'Facility for Rare Isotope Beams (FRIB) — Michigan State',
 'Math & Physics', 'closed', 3, 3.0, 'moderate', 'Moderately Competitive',
 3, 'Moderate', 'In-Person', 'Free', '1 week (residential)', 'All Grades',
 'https://frib.msu.edu/public/frib-outreach/pan.html',
 'Deadline Passed — Apply Next Year',
 'Free one-week residential program at Michigan State''s nuclear physics facility. Students explore applied physics with a focus on nuclear physics, working alongside FRIB scientists. Short duration limits impact, but unique exposure to nuclear physics research.',
 'Deadline passed for 2026. Add to calendar for next year. Only 1 week long — less weight on applications compared to multi-week programs.',
 'deadline',
 ARRAY['Nuclear Physics','Michigan State','FRIB','1 Week','Residential'],
 NULL, 27),

-- 28
('UNH HighTech Bound',
 'University of New Hampshire — InterOperability Lab',
 'Computer Science & Engineering', 'closed', 3, 3.0, 'moderate', 'Moderately Competitive',
 3, 'Moderate', 'In-Person', 'Stipend', '~1 month', 'Rising Seniors Only',
 'https://www.iol.unh.edu/stem/hightech-bound',
 'Deadline Passed (was Feb 28, 2026) — Apply Next Year',
 'Computer engineering internship at UNH''s InterOperability Lab working with Fortune 500 companies. Less research-focused, more like a real engineering internship. Students earn high school credit and receive a stipend. No housing provided.',
 'No housing provided. Rising seniors only.',
 'warning',
 ARRAY['Computer Engineering','Internship','Fortune 500','Stipend','HS Credit','No Housing'],
 NULL, 28),

-- 29
('King Conservation Science Scholars',
 'Brookfield Zoo — King Conservation',
 'Environmental Science', 'open', 3, 3.0, 'moderate', 'Moderately Competitive',
 3, 'Moderate', 'In-Person', 'Free', 'Summer', 'All Grades',
 'https://www.brookfieldzoo.org/KingScholars',
 'Check website',
 'Free research/internship opportunity at Chicago''s Brookfield Zoo focused on animal and environmental sciences. Less paper-focused and more hands-on. Great for students interested in wildlife biology, conservation, or zoology. Career exploration focus.',
 'Chicago-area in-person program.',
 'info',
 ARRAY['Zoo','Chicago','Conservation','Wildlife','Hands-On','Environmental'],
 NULL, 29),

-- 30
('Aresty Rutgers RISE',
 'Rutgers University',
 'General STEM', 'closed', 3, 3.5, 'moderate', 'Moderately Competitive (~20–35%)',
 3, 'Moderate–High', 'In-Person', 'Free', '~6 weeks', 'High School Students (NJ/Northeast priority)',
 'https://aresty.rutgers.edu/programs-funding/the-research-intensive-summer-experience',
 'Deadline Passed',
 'Rutgers'' flagship undergraduate research office pairs high schoolers with faculty for lab research. Strong regional reputation in NJ/Northeast. Quality of experience varies by mentor placement. Best used as a launchpad for a publishable paper or science fair entry — impact depends on output produced. Some stipends available.',
 'Deadline passed for 2026. Add to calendar for next year.',
 'deadline',
 ARRAY['Rutgers','New Jersey','Research','Faculty Mentored','Science Fair Launchpad'],
 NULL, 30),

-- 31
('QCamp (Quantum Systems Accelerator)',
 'DOE Quantum Systems Accelerator',
 'Quantum Computing', 'closed', 3, 3.5, 'moderate', 'Moderately Competitive',
 3, 'Moderate', 'In-Person', 'Free', 'Summer', 'High School Students',
 'https://quantumsystemsaccelerator.org/ecosystem/qcamp/',
 'Dates Closed — CA Only',
 'DOE-backed quantum computing summer camp. Strong government science backing. Excellent for students interested in quantum information science.',
 'California only and dates already closed for this year.',
 'deadline',
 ARRAY['Quantum Computing','DOE','California Only','Government Science'],
 NULL, 31),

-- 32
('Casper College Quantum Science Camp',
 'Casper College',
 'Quantum Computing', 'open', 4, 2.5, 'open', 'Less Competitive',
 2, 'Moderate', 'In-Person', 'Free', 'July 13–24, 2026', 'High School Students',
 'https://www.caspercollege.edu/quantumsciencecamp/',
 'Priority deadline May 31, 2026 (Camp: July 13–24, 2026)',
 'Free quantum science summer camp in Wyoming. Less prestigious than DOE/national-lab quantum programs, but free and accessible. Good introduction to quantum concepts for students who can travel to Wyoming.',
 'Located in Wyoming — travel required.',
 'warning',
 ARRAY['Quantum','Wyoming','Free','Introduction Level'],
 NULL, 32),

-- 33
('Qubit by Qubit',
 'The Coding School',
 'Quantum Computing', 'conflict', 3, 3.0, 'moderate', 'Moderately Competitive',
 3, 'Moderate', 'Virtual', 'Free', '4–5 weeks', 'High School Students',
 'https://www.qubitbyqubit.org/programs',
 'Dates conflict with India trip',
 'Well-structured virtual quantum computing program with three tracks: Data Science (June 29–July 24), Quantum Computing (June 29–July 31), and AI (June 29–July 31). IBM and Google backed. Good intro to quantum for students with no prior experience.',
 'Dates conflict with India trip. Reconsider for next year if interested.',
 'conflict',
 ARRAY['Quantum Computing','AI','Data Science','Virtual','IBM Backed','Date Conflict'],
 '[{"name":"Data Science","dates":"June 29 – July 24, 2026","duration":"4 weeks"},{"name":"Quantum Computing","dates":"June 29 – July 31, 2026","duration":"5 weeks"},{"name":"Artificial Intelligence","dates":"June 29 – July 31, 2026","duration":"5 weeks"}]'::JSONB,
 33),

-- 34
('Sci-MI (Science Mentorship Institute)',
 'Sci-MI — Nonprofit',
 'General STEM', 'open', 4, 3.0, 'open', 'Less Competitive (~30–40%)',
 2, 'Moderate', 'Virtual', 'Free', 'Summer (project-based)', 'All Grades',
 'https://sci-mi.org/',
 'May 1, 2026',
 'Free 501(c)(3) nonprofit pairing high school students with volunteer mentors for project-based summer research. Fields include neuroscience, biology, CS, electrical engineering, and chemistry. Good for students starting out in research with no prior experience.',
 NULL, NULL,
 ARRAY['Nonprofit','Virtual','Mentorship','All Grades','Beginner Friendly'],
 NULL, 34),

-- 35
('Sci-MI EEMP (Electrical Engineering Mentorship Program)',
 'Sci-MI — Nonprofit',
 'Computer Science & Engineering', 'open', 4, 3.0, 'open', 'Less Competitive (~30%)',
 2, 'Moderate', 'Virtual', 'Free', '5 weeks (summer)', 'All Grades (focused: rising Juniors & Seniors)',
 'https://sci-mi.org/eemp.html',
 'Check website',
 'Free 5-week virtual electrical engineering research mentorship program. A significant part of the program is dedicated to writing a research paper that can be submitted for publication in student journals. Good for rising juniors/seniors interested in EE.',
 NULL, NULL,
 ARRAY['Electrical Engineering','Virtual','Research Paper','Publication Possible'],
 NULL, 35),

-- 36
('SPARK SMP (Summer Mentorship Program)',
 'SPARK — Nonprofit',
 'Miscellaneous', 'open', 4, 2.5, 'open', 'Less Competitive (favors Seattle area)',
 2, 'Moderate', 'In-Person', 'Free', 'Summer', 'All Grades',
 'https://www.sparksmp.org/',
 'April 2026 — check website for exact date',
 'Free program connecting students with companies and organizations doing research in the Seattle Metro Area. Covers STEM and some humanities/marketing projects. Favors Seattle-area students. Good for local Seattle students looking for industry exposure.',
 'Strongly favors students in the Seattle area.',
 'warning',
 ARRAY['Seattle Area','Industry','Mentorship','STEM + Humanities','All Grades'],
 NULL, 36),

-- 37
('NECHR (Northeastern Centre for High School Research)',
 'NECHR — Nonprofit',
 'General STEM', 'open', 4, 2.5, 'open', 'Less Competitive',
 2, 'Moderate', 'Virtual', 'Free', 'Summer', 'All Grades',
 'https://www.nechr-research.us/',
 'Register to get details',
 'Nonprofit connecting high schoolers with university student mentors for free one-on-one and group research and entrepreneurship programs. Less well-known than other programs; requires registration to get full details.',
 'Must register on website to access program details.',
 'info',
 ARRAY['Virtual','Mentorship','Entrepreneurship','Research','Free'],
 NULL, 37),

-- 38
('EnergyMag Virtual Internships',
 'EnergyMag',
 'Environmental Science', 'open', 4, 2.0, 'open', 'Open / Very Low Barrier to Entry',
 1, 'Low', 'Virtual', 'Free', 'Flexible', 'All Grades',
 'https://energymag.net/internships/',
 'Rolling',
 'Online energy publication offering virtual internship-style experiences (writing, content creation, research summaries on renewable energy). Very little presence in college admissions circles. More useful as a portfolio/writing samples builder for energy journalism or policy tracks than as a STEM research credential.',
 'Low admissions impact on its own. More of a content portfolio builder than a research credential.',
 'warning',
 ARRAY['Renewable Energy','Virtual','Writing','Content Creation','Low Prestige','Portfolio Builder'],
 NULL, 38),

-- 39
('MiniPHD Program (JEI / Emerging Investigators)',
 'Journal of Emerging Investigators',
 'Life Sciences', 'open', 4, 3.0, 'moderate', 'Moderately Competitive (~20–40%)',
 3, 'Moderate (High if published in JEI)', 'Virtual', 'Free', '8 weeks (online)', '8th–10th Graders (U.S. only)',
 'https://emerginginvestigators.org/',
 'Check website',
 'Free 8-week program led by graduate/postdoc mentors producing a manuscript submitted to the Journal of Emerging Investigators (JEI) — a legitimate peer-reviewed journal for HS/undergrad researchers. A JEI publication is a citable, meaningful differentiator recognized by admissions officers.',
 'Targeted at 8th–10th graders. Key value: a published JEI paper is a real credential — pursue publication aggressively if admitted.',
 'info',
 ARRAY['8th–10th Grade','Virtual','JEI Publication','Peer-Reviewed Journal','Graduate Mentors','Publication Key'],
 NULL, 39),

-- 40
('Art MEDified C.R.A.F.T. Research Scholars',
 'Art MEDified',
 'Life Sciences', 'open', 4, 2.0, 'open', 'Open / Less Competitive',
 2, 'Low–Moderate', 'Virtual', 'Free', '8 weeks (online)', 'High School Students',
 'https://artmedified.org/',
 'Check website',
 'Free 8-week health literacy research camp where students conduct studies, learn R programming, navigate the Web of Science database, develop technical writing skills, and defend their work. Valuable technical skills (R, academic databases) but lower prestige.',
 NULL, NULL,
 ARRAY['Health Literacy','R Programming','Virtual','Technical Writing','Research'],
 NULL, 40),

-- 41
('SRA RMP (Research Mentorship Program)',
 'Student Research America',
 'General STEM', 'closed', 4, 2.5, 'moderate', 'Moderately Competitive (~20–35%)',
 2, 'Moderate (output-dependent)', 'Virtual', 'Free', 'Summer', 'High School Students',
 'https://studentresearchamerica.org/',
 'Deadline Passed — Apply Next Year',
 'Matches high school students with university/industry mentors for independent research projects conducted remotely. The program name is not widely recognized by selective admissions offices — what matters is the output (paper, science fair entry). Good launchpad if you produce a publishable result.',
 'Deadline passed for 2026. Add to calendar for next year. Value comes from what you produce, not the program name.',
 'deadline',
 ARRAY['Research Mentorship','Virtual','Output-Dependent','Science Fair Launchpad','Beginner Friendly'],
 NULL, 41),

-- 42
('Boston Leadership Institute',
 'Boston Leadership Institute',
 'Miscellaneous', 'open', 4, 2.0, 'open', 'Non-Selective (Pay to Attend ~$3,000–5,000+)',
 1, 'Low', 'In-Person', 'Paid', '1–2 weeks', 'All Grades',
 'https://www.bostonleadershipinstitute.com/',
 'Rolling',
 'For-profit, fee-based (~$3,000–5,000+) summer program with tracks in neuroscience, forensic science, biomedical research, etc. Admission is essentially guaranteed upon payment. College counselors on Reddit consistently flag BLI-type programs as ''resume padding'' that admissions officers recognize and discount.',
 'CAUTION: Admissions officers at selective colleges are familiar with pay-to-attend programs. Invest the cost in authentic research opportunities instead.',
 'warning',
 ARRAY['Paid','Pay-to-Attend','Non-Selective','Not Research','Low Admissions Weight'],
 NULL, 42),

-- 43
('NJ Governor''s School of Engineering & Technology',
 'New Jersey / Rutgers',
 'Computer Science & Engineering', 'nextyear', 2, 4.0, 'very', 'Very Competitive (school-nominated)',
 4, 'Very High', 'In-Person', 'Free', 'Summer (residential)', 'Rising Seniors (NJ students)',
 NULL,
 'Cannot apply — requires high school nomination',
 'Prestigious NJ Governor''s School program in engineering and technology at Rutgers. Highly regarded in NJ college admissions. Unfortunately requires a high school nomination — speak with your school counselor about being nominated for next year.',
 'Cannot self-apply — requires nomination from your high school. Ask your counselor about securing a nomination for next year.',
 'nextyear',
 ARRAY['NJ Only','School Nomination Required','Rutgers','Residential','Rising Seniors'],
 NULL, 43),

-- 44
('Waksman Student Scholars Program (WSSP / WISE)',
 'Waksman Institute of Microbiology — Rutgers University',
 'Life Sciences', 'closed', 3, 3.5, 'moderate', 'Moderately Competitive (~20–30%)',
 4, 'High', 'Hybrid', 'Paid', '2 weeks (WISE summer) or year-long (WSSP school-based)', 'High School Students (biology coursework required)',
 'https://wssp.rutgers.edu',
 'Closed for 2026 — Apply Feb 2027',
 'Rutgers-based molecular biology and bioinformatics research program. Students purify DNA, perform PCR, restriction digests, gel electrophoresis, and use BLAST to analyze sequences — with discoveries published on GenBank (international DNA database) with student credit. Two tracks: WISE (2-week summer intensive) and WSSP (year-long, school/teacher-based).',
 'Closed for 2026 (positions filled as of March 16, 2026). Next application cycle opens ~February 1, 2027. Rolling admissions — apply early. In-person sessions at Piscataway, NJ.',
 'deadline',
 ARRAY['Rutgers','New Jersey','Molecular Biology','Bioinformatics','GenBank Publication','DNA Research','Paid','Rolling Admissions'],
 NULL, 44),

-- 45
('BMES High School Poster Expo',
 'Biomedical Engineering Society (BMES)',
 'Life Sciences', 'open', 3, 3.5, 'moderate', 'Open to Juniors & Seniors (no lab required)',
 3, 'High', 'In-Person', 'Paid', '4 days — Oct 21–24, 2026', 'Rising Juniors & Seniors (by fall 2026)',
 'https://www.bmes.org/2026/annualmeeting/high-school-poster-expo',
 'Application deadline coming soon — Conference: Oct 21–24, 2026 (Orlando, FL)',
 'Present a biomedical engineering poster at the BMES 2026 Annual Meeting alongside graduate students, researchers, and industry professionals. No prior lab experience required — any BME-related topic accepted. Students receive expert feedback, networking access, and entry to scientific sessions at one of the nation''s premier BME conferences.',
 '$100 registration fee per student + $100 per chaperone (required if under 18). Travel and housing not covered. Especially encouraged for Orlando-area students, BMES chapter members, and underrepresented students.',
 'info',
 ARRAY['BMES','Biomedical Engineering','Conference','Poster Presentation','Networking','Orlando','No Lab Required','Oct 2026'],
 NULL, 45),

-- 46
('AMS Young Scholars Program (Epsilon Fund)',
 'American Mathematical Society',
 'Math & Physics', 'nextyear', 2, 4.5, 'competitive', 'Competitive (grant for program directors)',
 5, 'Transformative (via funded programs)', 'In-Person', 'Free', 'Multi-week summer programs (May–September)', 'Mathematically talented high school students (US)',
 'https://www.ams.org/grants-awards/emp-epsilon',
 'Application window opens ~November 2026',
 'The AMS Epsilon Fund awards grants to directors of summer math programs for talented high schoolers. This grant supports elite programs like PROMYS, Ross, and similar intensive math camps — being admitted to an AMS-funded program is a strong college application credential. Note: applications are submitted by program directors, not students directly.',
 'This is a grant for math program directors, not a direct student application. To benefit, apply to programs that receive AMS Epsilon funding (e.g. PROMYS, Ross Mathematics Program). Next application cycle opens ~November 2026.',
 'nextyear',
 ARRAY['AMS','Mathematics','Grant Program','Director Application','Funds PROMYS/Ross','Nov 2026 Opens'],
 NULL, 46);
