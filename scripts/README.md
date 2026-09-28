# scripts

## seed-programs.ts

Uses the Claude API to research summer programs and generate a SQL file for Supabase.

**Setup** (one-time):
```
cd scripts
npm install
```

**Run:**
```
npm run seed
```

Outputs `scripts/out/programs-summer-2027.sql`. Paste that into Supabase SQL Editor and run it.

**To add more programs:** append the program name to `PROGRAMS_TO_SEED` in `seed-programs.ts`, then run `npm run seed` again.

Requires `ANTHROPIC_API_KEY` in the root `.env` file.
