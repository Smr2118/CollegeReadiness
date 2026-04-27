-- ============================================================
-- Demo Family Seed Data — Brainstorm pages
-- Run this in Supabase SQL Editor AFTER demo-family.sql.
-- Safe to re-run: deletes and reinserts all demo rows.
-- ============================================================

-- ── 1. Essay Topics ─────────────────────────────────────────
DELETE FROM public.essay_topics WHERE family_id = 'demo';

INSERT INTO public.essay_topics (family_id, title, category, details, status, starred, shortlisted) VALUES
  ('demo',
   'Rebuilt the robotics team from scratch after half the members quit two weeks before state finals',
   'STEM',
   'Junior year — recruited 3 new members mid-season, held emergency training sessions every evening. We placed 3rd. Taught me more about leadership under pressure than any class ever did.',
   'Open', true, true),

  ('demo',
   'Taught coding to underserved 5th graders as a 10th-grade volunteer',
   'STEM',
   'Ran 8-week Scratch workshops at a Title I elementary school. Watched kids go from "what is a computer?" to building their own games. One student joined the school coding club the next year.',
   'Interested', false, false),

  ('demo',
   'Navigating identity between two cultures at family reunions in India',
   'Family',
   'Every summer visit felt like I was re-learning who I was — too American for my cousins, too Indian for my school friends. Started journaling about it. Strong "who am I" essay angle.',
   'Open', true, false),

  ('demo',
   'Organized a student walkout to protest the school cafeteria food waste policy',
   'Political',
   '200 students participated. Got a meeting with the principal. Policy changed — compost bins added and surplus food donated to local shelter. First time I saw civic action actually work.',
   'Complete', false, true),

  ('demo',
   'Broke my ankle two weeks before regional piano recital — performed sitting on a stool anyway',
   'Other',
   'Had practiced for 6 months. Doctors said skip it. I said no. Played a 12-minute Chopin piece with my foot elevated. Got a standing ovation. Good resilience / grit angle.',
   'Interested', true, false);


-- ── 2. Robotics Ideas ───────────────────────────────────────
DELETE FROM public.robotics_ideas WHERE family_id = 'demo';

INSERT INTO public.robotics_ideas (family_id, title, category, details, status, starred, shortlisted) VALUES
  ('demo',
   'Robotic arm that sorts food bank donations by expiry date using computer vision',
   'Charity',
   'Use a camera + ML model to read expiry dates on cans and boxes. Arm routes items to "use first" vs "stock" bins. Could genuinely help the Downtown Food Pantry we volunteer at.',
   'Interested', true, true),

  ('demo',
   'Autonomous maze-solving robot for the regional science fair',
   'Fun',
   'Flood-fill algorithm on a Raspberry Pi with ultrasonic sensors. Built and competed — placed 2nd. Great foundation for more complex navigation projects.',
   'Complete', false, false),

  ('demo',
   'AI-powered plant disease detector for the community garden',
   'Benefit Community',
   'Point a camera at leaves, model identifies blight/fungus and suggests treatment. Talked to the garden coordinator — they love the idea. Need a weatherproof enclosure.',
   'Open', true, false),

  ('demo',
   'Mini drone swarm (3 units) for coordinated search and rescue simulation',
   'Fun',
   'Each drone maps a zone autonomously, shares data over WiFi mesh, and marks "found" locations on a shared grid. Long-term stretch goal — would be an insane competition project.',
   'Open', false, false);


-- ── 3. India Activities ─────────────────────────────────────
DELETE FROM public.india_activities WHERE family_id = 'demo';

INSERT INTO public.india_activities (family_id, title, category, details, status, starred, shortlisted) VALUES
  ('demo',
   'Classical Bharatanatyam with local diaspora dance troupe',
   'Cultural & Heritage',
   'Performing at temple festivals and cultural events 3–4 times a year. Learning Margam pieces. Strong cultural identity angle for applications — also genuinely love it.',
   'Interested', true, true),

  ('demo',
   'Learn conversational Tamil to speak with grandparents without translation',
   'Language',
   'Currently understand ~60%, can speak maybe 40%. Goal: hold a full dinner conversation by this summer. Using a tutor + Duolingo + weekly video calls with Paati.',
   'Open', false, false),

  ('demo',
   'Summer research internship at IIT Madras AI lab',
   'Programs in India',
   'Prof. Rajan''s lab works on NLP for low-resource Dravidian languages — directly relevant to my interest in ML. Need to email him and attach my robotics project writeup.',
   'Open', true, true),

  ('demo',
   'Join the local Indian Student Association for college mentorship network',
   'Diaspora Networks',
   'They run a pairing program with Indian-American college students at nearby universities. Good way to get real application advice and build community before college.',
   'Interested', false, false);


-- ── 4. EC Ideas ─────────────────────────────────────────────
DELETE FROM public.ec_ideas WHERE family_id = 'demo';

INSERT INTO public.ec_ideas (family_id, title, category, details, status, starred, shortlisted) VALUES
  ('demo',
   'Found a school AI/ML club and run weekly hands-on workshops',
   'STEM',
   'Starting with 8 members. Cover a new topic each week — regression, image classification, ethics. Planning a mini hackathon at the end of the year. President role = strong leadership signal.',
   'Pursuing', true, true),

  ('demo',
   'Join Model UN and compete at the regional conference',
   'Leadership',
   'Interested in international policy and public speaking. The school chapter competes at three conferences per year. Would need faculty sponsor approval to start attending.',
   'Interested', false, false),

  ('demo',
   'Volunteer as a Teen Health Ambassador at the county hospital',
   'Community Service',
   'Program trains teens to run health education workshops for elementary schools — nutrition, mental health, hygiene. 4-hour commitment per week. Application opens in January.',
   'Open', false, true),

  ('demo',
   'Continue classical violin and perform at community events',
   'Arts',
   '8 years in. Currently at Grade 7 Trinity level. Want to play at the senior center monthly concert series and record a short album for college apps. Distinctly "me" — not generic.',
   'Pursuing', true, false),

  ('demo',
   'Launch peer tutoring program for underclassmen struggling in math',
   'Academic',
   'Noticed a lot of 9th graders failing Algebra II after the COVID gap years. Idea: recruit 10 upperclassmen tutors, match with students, track grade improvements over a semester.',
   'Open', false, false);


-- ── 5. Past Projects ────────────────────────────────────────
DELETE FROM public.past_projects WHERE family_id = 'demo';

INSERT INTO public.past_projects (family_id, title, category, status, year, role, skills, details, starred, shortlisted) VALUES
  ('demo',
   'AI-powered recycling sorter robot',
   'Competition',
   'Ongoing',
   '2024–2025',
   'Lead Developer',
   'Python, TensorFlow, ROS, Raspberry Pi, CAD',
   'Trained a CNN on 12k images to classify plastic, glass, metal, and paper. Robot arm routes items to the correct bin with 91% accuracy. Entered in the regional robotics competition — finals in April.',
   true, true),

  ('demo',
   'School climate action club website and awareness campaign',
   'School',
   'Completed',
   '2023–2024',
   'Founder & Developer',
   'HTML, CSS, JavaScript, Figma',
   'Built the club''s website from scratch — event calendar, petition form, resource library. 400+ visitors in first month. Club grew from 6 to 34 members after the site launched.',
   false, false),

  ('demo',
   'Food bank inventory management system',
   'Volunteer',
   'Completed',
   '2023',
   'Developer',
   'Python, Google Sheets API, Flask',
   'The pantry was tracking 800+ items on paper. Built a simple web app + barcode scanner integration that cut their weekly inventory time from 3 hours to 20 minutes.',
   true, true),

  ('demo',
   'DIY quadcopter drone built from components',
   'Personal',
   'On Hold',
   '2024',
   'Builder',
   'Arduino, C++, Fusion 360, soldering',
   'Designed frame in Fusion 360, 3D-printed it, assembled flight controller. Flew once before a prop failure. On hold until I have more time. Good mechanical engineering story.',
   false, false);
