/**
 * seed-programs.ts
 *
 * Usage:
 *   cd scripts && npm install && npm run seed
 *
 * Reads ANTHROPIC_API_KEY from ../.env
 * Calls Claude for each program in PROGRAMS_TO_SEED.
 * Writes SQL to out/programs-summer-2027.sql — paste into Supabase SQL Editor.
 *
 * To add new programs: append to PROGRAMS_TO_SEED and re-run.
 * Already-seeded programs won't be duplicated (the SQL uses ON CONFLICT DO NOTHING).
 */

import Anthropic from '@anthropic-ai/sdk';
import { writeFileSync, mkdirSync } from 'fs';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: path.join(__dirname, '..', '.env') });

// ── Programs to research ─────────────────────────────────────────────────────
// Edit this list and re-run to seed new programs.
const PROGRAMS_TO_SEED: string[] = [
  'MITES Summer (MIT — Minority Introduction to Engineering and Science, residential summer program)',
  'MITES Semester (MIT — Minority Introduction to Engineering and Science, semester program)',
  'MIT Research Science Institute (RSI) — MIT / Center for Excellence in Education',
  'Carnegie Mellon AI Scholars (CMU Summer Program in Artificial Intelligence)',
  'Carnegie Mellon CS Scholars (CMU Summer Program in Computer Science)',
  'MIT Beaver Works Summer Institute (BWSI)',
  'Stanford Institutes of Medicine Summer Research Program (SIMR)',
  'Simons Summer Research Program — Stony Brook University',
  'Boston University RISE (Research in Science & Engineering)',
  'UCSB Research Mentorship Program (RMP)',
  'Yale Young Global Scholars (YYGS)',
  'Clark Scholars Program — Texas Tech University',
  'Stanford SHTEM (Stanford Health, Technology, and Engineering Medicine Summer Internship)',
  'UCSB Summer Research Academies',
  'NASA SEES (Student Exploration & Experimentation in Space — UT Austin)',
  'Rockefeller University Summer Science Research Program (SSRP)',
  'Garcia Summer Research Program — Stony Brook University',
  'COSMOS (California State Summer School for Mathematics and Science — UC system)',
  'Algoverse AI Research Program',
];

// ── Tool schema ──────────────────────────────────────────────────────────────
const PROGRAM_TOOL: Anthropic.Tool = {
  name: 'save_program',
  description: 'Save structured, admissions-focused data about a high school summer program.',
  input_schema: {
    type: 'object' as const,
    required: [
      'name','org','category','tier','rating','selectivity','selectivity_label',
      'college_impact','college_impact_label','format','cost','duration','grades',
      'url','deadline','description','note','note_type','tags',
    ],
    properties: {
      name:                 { type: 'string', description: 'Official program name (concise)' },
      org:                  { type: 'string', description: 'University or organization hosting the program' },
      category:             {
        type: 'string',
        enum: ['Math & Physics','Computer Science & Engineering','Robotics & AI',
               'General STEM','Life Sciences','Quantum Computing','Humanities',
               'Environmental Science','Miscellaneous'],
      },
      tier: {
        type: 'integer', minimum: 1, maximum: 4,
        description: '1=Elite/most prestigious, 2=Highly selective, 3=Moderately selective, 4=Accessible',
      },
      rating: { type: 'number', minimum: 0, maximum: 5, description: 'Overall quality/prestige rating 0–5' },
      selectivity:          { type: 'string', enum: ['elite','very','competitive','moderate','open'] },
      selectivity_label:    { type: 'string', description: "e.g. 'Elite (<2% acceptance)' or 'Competitive (~15–20%)'" },
      college_impact: {
        type: 'integer', minimum: 1, maximum: 5,
        description: '5=Transformative, 4=Very High, 3=High, 2=Moderate, 1=Low',
      },
      college_impact_label: { type: 'string', description: "e.g. 'Transformative', 'Very High', 'High'" },
      format:               { type: 'string', enum: ['In-Person','Virtual','Hybrid'] },
      cost:                 { type: 'string', enum: ['Free','Stipend','Paid'] },
      duration:             { type: 'string', description: "e.g. '6 weeks (residential)' or '8 weeks (summer)'" },
      grades:               { type: 'string', description: "Eligible grades, e.g. 'Rising Juniors & Seniors'" },
      url:                  { type: 'string', description: 'Official program URL' },
      deadline: {
        type: 'string',
        description: "Typical application deadline. Use 'Typically [Month] — check website for 2027 dates' if exact date unknown",
      },
      description: {
        type: 'string',
        description: '3–4 sentences focused on: what the program does, why it matters for college apps, notable outcomes/alumni, what makes it unique. Be specific and factual.',
      },
      note: {
        type: 'string',
        description: 'What helps get selected: specific factors that strengthen an application (research experience, essays, grades, competition wins, underrepresented background, etc.). Be concrete and actionable. 2–3 sentences.',
      },
      note_type:            { type: 'string', enum: ['priority','deadline','info','warning'] },
      tags:                 { type: 'array', items: { type: 'string' }, description: 'Up to 6 concise tags' },
    },
  },
};

// ── Claude client ────────────────────────────────────────────────────────────
const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });

async function researchProgram(programDescription: string): Promise<Record<string, unknown>> {
  console.log(`  Researching: ${programDescription.split(' (')[0].split(' —')[0]}…`);

  const msg = await anthropic.messages.create({
    model: 'claude-sonnet-4-6',
    max_tokens: 1500,
    tools: [PROGRAM_TOOL],
    tool_choice: { type: 'any' },
    messages: [{
      role: 'user',
      content: `You are a college admissions expert with deep knowledge of high school summer programs.

Research this program: "${programDescription}"

Fill in all fields accurately. This data will be shown to a high school student planning college applications for Summer 2027. The student is academically strong (interested in STEM/CS/AI). Focus on:
- Accurate acceptance rates and selectivity
- What genuinely helps applicants get in (not generic advice — specific to THIS program)
- Honest college application impact (T1 programs like RSI/MITES are truly transformative; don't inflate others)
- Practical deadline info (since 2027 deadlines aren't announced, give typical month based on past years)

Be specific, factual, and useful for an ambitious high schooler planning their application strategy.`,
    }],
  });

  const toolUse = msg.content.find(b => b.type === 'tool_use');
  if (!toolUse || toolUse.type !== 'tool_use') {
    throw new Error(`No tool use in response for: ${programDescription}`);
  }
  return toolUse.input as Record<string, unknown>;
}

// ── SQL helpers ──────────────────────────────────────────────────────────────
function sqlStr(val: unknown): string {
  if (val === null || val === undefined) return 'NULL';
  return `'${String(val).replace(/'/g, "''")}'`;
}

function sqlArr(val: unknown): string {
  if (!Array.isArray(val) || val.length === 0) return "'{}'";
  const items = val.map(v => `"${String(v).replace(/"/g, '\\"')}"`).join(',');
  return `'{${items}}'`;
}

function toInsert(p: Record<string, unknown>, sortOrder: number): string {
  return `(
  ${sqlStr(p.name)},
  ${sqlStr(p.org)},
  ${sqlStr(p.category)},
  'open',
  ${Number(p.tier) || 2},
  ${Number(p.rating) || 4.0},
  ${sqlStr(p.selectivity)},
  ${sqlStr(p.selectivity_label)},
  ${Number(p.college_impact) || 4},
  ${sqlStr(p.college_impact_label)},
  ${sqlStr(p.format)},
  ${sqlStr(p.cost)},
  ${sqlStr(p.duration)},
  ${sqlStr(p.grades)},
  ${sqlStr(p.url)},
  ${sqlStr(p.deadline)},
  ${sqlStr(p.description)},
  ${sqlStr(p.note)},
  ${sqlStr(p.note_type)},
  ${sqlArr(p.tags)},
  'public',
  ${sortOrder},
  'Summer 2027'
)`;
}

// ── Main ─────────────────────────────────────────────────────────────────────
async function main() {
  console.log(`\nSeeding ${PROGRAMS_TO_SEED.length} programs for Summer 2027…\n`);

  const results: Record<string, unknown>[] = [];
  const failed: string[] = [];

  for (const prog of PROGRAMS_TO_SEED) {
    try {
      const data = await researchProgram(prog);
      results.push(data);
      console.log(`  ✓ ${data.name}`);
    } catch (err) {
      console.error(`  ✗ Failed: ${prog}\n    ${err}`);
      failed.push(prog);
    }
    // Small delay to avoid rate limits
    await new Promise(r => setTimeout(r, 300));
  }

  if (results.length === 0) {
    console.error('\nNo programs successfully researched. Check your ANTHROPIC_API_KEY.');
    process.exit(1);
  }

  const valueBlocks = results.map((p, i) => toInsert(p, i + 1)).join(',\n');

  const sql = `-- Summer 2027 Programs — generated by seed-programs.ts on ${new Date().toISOString()}
-- Paste into Supabase SQL Editor and run once.
-- To prevent re-running the same names: wrap in a DO block or just check before running.

INSERT INTO public.programs (
  name, org, category, status, tier, rating,
  selectivity, selectivity_label,
  college_impact, college_impact_label,
  format, cost, duration, grades, url, deadline,
  description, note, note_type, tags,
  access_level, sort_order, season
)
VALUES
${valueBlocks};

-- ${results.length} programs inserted (${failed.length} failed)
${failed.length > 0 ? '-- Failed: ' + failed.join(', ') : ''}
`;

  mkdirSync(path.join(__dirname, 'out'), { recursive: true });
  const outPath = path.join(__dirname, 'out', 'programs-summer-2027.sql');
  writeFileSync(outPath, sql, 'utf8');

  console.log(`\n✓ SQL written to: scripts/out/programs-summer-2027.sql`);
  console.log(`  ${results.length} programs ready to insert.`);
  if (failed.length > 0) {
    console.log(`  ${failed.length} failed — add them manually or re-run.`);
  }
  console.log('\nNext step: paste the SQL file contents into Supabase SQL Editor and run.\n');
}

main().catch(err => { console.error(err); process.exit(1); });
