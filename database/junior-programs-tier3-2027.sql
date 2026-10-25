-- ── Junior Programs Tier 2–4 additions (Summer 2027) ────────────────────────
-- Run AFTER junior-programs-2027.sql (table must already exist).
-- Adds 8 more moderate-to-accessible programs sorted by deadline.

INSERT INTO public.junior_programs
  (name, org, category, status, tier, selectivity_label,
   college_impact, college_impact_label, format, cost, duration, grades,
   url, deadline, deadline_date, description, note, note_type, tags, sort_order)
VALUES

-- 13 — Naval SEAP (Deadline: Nov 30, 2026 — URGENT)
('Naval Science and Engineering Apprenticeship (SEAP)',
 'US Navy / ASEE',
 'General STEM', 'open', 2, 'Competitive (~15–20%)',
 4, 'Very High', 'In-Person', 'Stipend',
 '8 weeks (June 14–Aug 6, 2027)',
 'Rising Sophomores–Seniors (US citizens, 16+ by May)',
 'https://www.navalsteminterns.us/seap/',
 'November 30, 2026',
 '2026-11-30',
 'Paid 8-week research apprenticeship at active US Navy and DoD laboratory facilities across the country. Students work alongside real government scientists on genuine research projects in STEM fields.
$4,000 stipend (new), $4,500 stipend (returning). Paid bi-weekly. One of very few HS programs with authentic paid DoD lab research.
Placements vary by lab location — NJ students may find nearby facilities at NRL, Aberdeen, Picatinny, or Lakehurst.',
 'DEADLINE NOVEMBER 30, 2026 — apply now. US citizens only. Must be at least 16 by end of May 2027. Lab placement varies by location; research fields span physics, engineering, CS, and life sciences.',
 'priority',
 ARRAY['Navy','DoD','Government','$4,000 Stipend','In-Person','US Citizens Only','Physics','Engineering'],
 13),

-- 14 — BU RISE (Deadline: Feb 3, 2027)
('Boston University RISE',
 'Boston University',
 'General STEM', 'open', 3, 'Competitive (~20–25%)',
 3, 'High', 'In-Person', 'Paid',
 '6 weeks (residential or commuter)',
 'Rising Seniors (US citizens/permanent residents)',
 'https://www.bu.edu/summer/high-school-programs/rise-internship-practicum/',
 'February 3, 2027',
 '2027-02-03',
 '6-week research internship at Boston University. The internship track places students 40 hrs/week in a faculty research lab; the practicum track is more structured and coursework-based. Both end with a poster symposium.
Applications open December 17, 2026.
Cost: $6,415 (commuter) or $10,735 (residential). Limited financial aid available. Strong BU brand and genuine lab experience make this a worthwhile paid option.',
 'Paid program ($6,415 commuter / $10,735 residential). Applications open Dec 17, 2026. Rising seniors only — you must be entering 12th grade. Apply for the internship track for maximum research exposure.',
 'info',
 ARRAY['Boston University','Residential Option','Paid','Poster Symposium','Lab Research','Rising Seniors Only'],
 14),

-- 15 — George Mason ASSIP (Deadline: Feb 15, 2027)
('George Mason ASSIP',
 'George Mason University',
 'General STEM', 'open', 3, 'Moderately Competitive (~20–30%)',
 3, 'High', 'Hybrid', 'Paid',
 '8 weeks (June 18–Aug 12, 2027)',
 'Rising Sophomores–Seniors (15+ for remote, 16+ for wet lab)',
 'https://science.gmu.edu/assip',
 'February 15, 2027',
 '2027-02-15',
 'One of the broadest and most accessible free summer research programs in the US. Offers remote, hybrid, and in-person placements across nearly every STEM field. Students work with faculty mentors and present a research poster at the end.
Cost: $1,299 tuition for 3 college credits + $25 application fee. Both waivable for financial need.
Very broad field selection including CS, robotics, physics, biology, environmental science, and more.',
 'Cost ~$1,299 + $25 app fee (both waivable for need). Application opens Fall 2026. Remote option available — accessible from NJ without travel. Apply to the field closest to your robotics or physics interests.',
 'info',
 ARRAY['George Mason','Remote Option','Hybrid','Broad STEM','3 College Credits','Poster Presentation','Accessible'],
 15),

-- 16 — NASA SEES (Deadline: ~Feb 24, 2027)
('NASA SEES Internship',
 'NASA / University of Texas at Austin',
 'Environmental Science', 'open', 3, 'Competitive (~15–25%)',
 4, 'High', 'Hybrid', 'Free',
 'Spring virtual modules + summer residency (Austin, TX)',
 'Rising Juniors & Seniors (US citizens, 16+ by July)',
 'https://www.nasa.gov/learning-resources/internship-programs/',
 'Late February 2027 (~February 24)',
 '2027-02-24',
 'NASA''s official high school summer intern program for current sophomores and juniors. Combines required virtual spring learning modules with a summer experience at the University of Texas at Austin.
Free — no cost to participate. Completing interns receive a NASA certificate. Program covers Earth sciences, climate data, remote sensing, and space-based observation.
The NASA name carries exceptional weight on college applications regardless of program tier.',
 'Free program. Combines virtual spring modules with optional summer residency in Austin, TX. Applications typically open in November 2026 — monitor the NASA website. Rising juniors are the target grade.',
 'deadline',
 ARRAY['NASA','Earth Sciences','Free','Virtual','Remote Sensing','Climate','Government','Certificate'],
 16),

-- 17 — NYU ARISE (Deadline: ~Feb 27, 2027)
('NYU ARISE',
 'New York University — Tandon School of Engineering',
 'Computer Science & Engineering', 'open', 3, 'Competitive (~15–20%)',
 4, 'High', 'In-Person', 'Stipend',
 '10 weeks (4 weeks virtual + 6 weeks in-person)',
 'Rising Juniors & Seniors (NYC residents only)',
 'https://k12stem.engineering.nyu.edu/programs/arise',
 'Late February 2027 (~February 27)',
 '2027-02-27',
 'Free 10-week program placing students in NYU Tandon engineering research labs. Four weeks of virtual evening workshops followed by six weeks of full-time in-person lab research.
$2,000 stipend on completion. Students earn college credit.
Strong engineering and CS research, accessible from NJ via transit — but officially open to NYC residents only.',
 'NYC residents attending NYC schools ONLY. NJ students are technically ineligible. Listed here because the program is commutable and eligibility has occasionally been interpreted broadly — check with NYU directly.',
 'warning',
 ARRAY['NYU','Engineering','NYC Only','$2,000 Stipend','In-Person','College Credit','Tandon'],
 17),

-- 18 — MIT Beaver Works Summer Institute (Deadline: Mar 31, 2027)
('MIT Beaver Works Summer Institute (BWSI)',
 'MIT Lincoln Laboratory',
 'Computer Science & Engineering', 'open', 2, 'Competitive (~15–20%)',
 4, 'Very High', 'In-Person', 'Free',
 '4 weeks residential (July 5–Aug 1, 2027)',
 'Rising Juniors & Seniors (US residents)',
 'https://bwsi.mit.edu/',
 'March 31, 2027 (online prereq opens Feb 1)',
 '2027-03-31',
 'MIT Lincoln Laboratory''s 4-week residential summer program. Students first complete a free online prerequisite course (opens Feb 1, 2027) and, if selected, attend in person at MIT in July.
Course tracks include Autonomous RACECAR, Cognitive Assistive Technology, Medlytics, Satellite Design, Urban Air Mobility, and more — strong robotics and AI alignment with your interests.
Free for families under $200,000 income. Well recognized by college admissions due to MIT Lincoln Lab affiliation.',
 'Two-step: (1) register and complete the free online prerequisite course starting Feb 1, 2027; (2) summer program application sent to eligible students March 1, due March 31. Start the prereq course as soon as it opens.',
 'deadline',
 ARRAY['MIT','Lincoln Lab','Robotics','AI','Autonomous Systems','Residential','Free','Online Prereq First'],
 18),

-- 19 — Lumiere Research Scholar (rolling)
('Lumiere Research Scholar Program',
 'Lumiere Education',
 'General STEM', 'open', 3, 'Moderately Competitive',
 3, 'High', 'Virtual', 'Paid',
 '12 weeks (online, multiple cohorts)',
 'All High School Grades (worldwide)',
 'https://www.lumiere-education.com/program',
 'Rolling admissions (summer cohort ~Feb 2027)',
 NULL,
 'Online 1:1 research mentorship with a PhD mentor from a top university. Students produce an original research paper over 12 weeks in a field of their choice — CS, physics, biology, economics, humanities, and more.
Cost: ~$3,190. Need-based financial aid available. Multiple cohorts per year (spring, summer, fall, winter).
Value comes entirely from the research paper produced — a strong paper can be submitted to conferences or journals and cited on college applications.',
 'Paid program (~$3,190). Quality depends heavily on the mentor match and how seriously you treat the paper output. Apply for the summer cohort to get a paper ready for college applications. Financial aid available.',
 'info',
 ARRAY['Online','1-on-1 Mentorship','PhD Mentor','Research Paper','Paid','Rolling Admissions','Any Field'],
 19),

-- 20 — Veritas AI Fellowship (rolling / summer deadline Feb 2027)
('Veritas AI Fellowship',
 'Veritas AI',
 'Computer Science & Engineering', 'open', 3, 'Moderately Competitive',
 3, 'High', 'Virtual', 'Paid',
 '15 weeks (online)',
 'All High School Grades (9–12)',
 'https://www.veritasai.com/ai-fellowship',
 'Rolling (summer cohort deadline ~February 27, 2027)',
 NULL,
 'Online AI and machine learning research program pairing students with PhD and industry mentors for 15 weeks. The Fellowship track produces a research paper or project for publication or showcase.
Cost: ~$5,400 for the full fellowship (with publication). An AI Scholars intro track is available for ~$2,290.
Strong alignment with robotics and math interests — AI, ML, neural networks, and computational problem solving are central.',
 'Paid program (~$5,400 fellowship / $2,290 intro). Summer 2027 cohort deadline ~Feb 27, 2027 but rolling admissions apply earlier. Best fit given your robotics and math background — AI is the natural next step.',
 'info',
 ARRAY['AI','Machine Learning','Online','PhD Mentor','Research Paper','Publication','Robotics Adjacent','Paid'],
 20);
