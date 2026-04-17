# College Readiness Hub — Claude Code Context

## Project Overview
A family-facing college readiness tracking site for the Sant family. Tracks summer programs, internships, extracurriculars, deadlines, and todos. Built with Astro/Starlight (static site, no SSR) + Supabase (auth, database, edge functions).

## Repo Structure
```
CollegeReadiness/
├── site/                          # Astro/Starlight site
│   ├── src/
│   │   ├── components/            # Astro components
│   │   │   ├── AdminPanel.astro   # Admin-only UI (tabs: Families, Users, Programs, Nav Access, Stats)
│   │   │   ├── SupabaseSync.astro # Auth modal, session management, nav-link hiding
│   │   │   ├── ProgramGrid.astro  # Program listing with filters
│   │   │   ├── ProgramCard.astro  # Individual program card
│   │   │   ├── TodoList.astro     # Family shared to-do list
│   │   │   ├── DeadlineCalendar.astro
│   │   │   ├── CustomHeader.astro
│   │   │   └── CustomPageSidebar.astro
│   │   ├── content/docs/          # Starlight pages (.mdx)
│   │   ├── lib/supabase.ts        # Supabase client (anon key, public)
│   │   └── styles/custom.css      # All custom styles
│   ├── supabase/functions/        # Deno edge functions
│   │   ├── create-user/           # Admin: create auth user + user_profiles row
│   │   ├── delete-user/           # Admin: delete user from auth + user_profiles
│   │   └── set-user-role/         # Admin: update role in auth metadata + user_profiles
│   └── astro.config.mjs           # Sidebar nav defined here
├── database/                      # SQL files to run in Supabase SQL Editor
│   ├── setup.sql                  # Full schema reset (families, user_profiles, program_data, RLS)
│   ├── programs.sql               # programs table + RLS
│   ├── programs-access.sql        # Migration: add access_level + plan columns
│   ├── migrate-3tier-access.sql   # Migration: update RLS to 3-tier (public/basic/premium)
│   ├── todos.sql                  # todos table + RLS
│   ├── nav-access.sql             # nav_access table + RLS
│   ├── login-stats.sql            # login_events table + RLS
│   └── set_admin.sql              # One-off: promote a user to admin
└── CLAUDE.md                      # This file
```

## Tech Stack
- **Frontend**: Astro 6 + Starlight 0.38, TypeScript, no framework (vanilla JS in `<script>` blocks)
- **Backend**: Supabase (Postgres + Auth + Edge Functions)
- **Edge functions**: Deno, deployed via `supabase functions deploy <name>`
- **Hosting**: GitHub Pages (`base: '/CollegeReadiness'` in astro.config.mjs)
- **CI**: GitHub Actions (`.github/workflows/`)

## Key Architecture Decisions
- **No SSR**: Fully static build. All auth and data fetching happens client-side in `<script>` blocks.
- **Auth gate**: `SupabaseSync.astro` renders a modal that blocks the entire page until sign-in. Every page includes it via `CustomHeader.astro`.
- **Admin actions that need service role key** (create/delete/set-role user) go through Supabase Edge Functions — the client SDK cannot do these.
- **Base path**: All internal links must use relative paths or account for `/CollegeReadiness` base. Sidebar links in `astro.config.mjs` use short paths (e.g. `/programs/`); the base is prepended automatically by Astro.

## Access Control (3-Tier Plan System)

### Program access_level
| Value | Visible to |
|---|---|
| `public` | All signed-in users |
| `basic` | Families on `basic` or `premium` plan |
| `premium` | Families on `premium` plan only |

Admins always see all programs regardless of plan.

### Family plan
Values: `standard` (default) < `basic` < `premium`

### Navigation link visibility
Stored in `nav_access(path, min_plan)` table. `SupabaseSync.astro` fetches rules after login and hides sidebar `<li>` elements below the user's plan tier. Admins bypass all hiding. Configured via Admin Panel → Nav Access tab.

## Database Tables
| Table | Purpose |
|---|---|
| `families` | Family groups; has `plan` column (standard/basic/premium) |
| `user_profiles` | One row per auth user; has `family_id`, `display_name`, `role` |
| `programs` | Program catalog; has `access_level`, `status`, `deadline`, `tier`, etc. |
| `program_data` | Per-family notes/interest on programs (scoped by `family_id`) |
| `todos` | Shared family to-do items |
| `nav_access` | Per-path minimum plan requirement for sidebar links |
| `login_events` | Login tracking (inserted on form sign-in, not session restore) |

All tables use Row Level Security. The helper function `public.get_my_family_id()` is `SECURITY DEFINER` and used in most RLS policies.

## Edge Functions
All verify the caller is an admin by checking `user_metadata.role === 'admin'` via the service role key.

| Function | What it does |
|---|---|
| `create-user` | Creates auth user + `user_profiles` row; validates `display_name` (min 2 chars) |
| `delete-user` | Deletes `user_profiles` row then auth user; blocks self-deletion |
| `set-user-role` | Updates role in both auth metadata and `user_profiles` |

Deploy: `npx supabase functions deploy <name> --project-ref bppzlhrzoqzqgvechswu`

## Dev Commands
```bash
cd site
npm run dev       # local dev server (http://localhost:4321/CollegeReadiness/)
npm run build     # production build
npm run preview   # preview production build
```

## Common Patterns

### Adding a new page
1. Create `src/content/docs/<slug>/index.mdx`
2. Add to sidebar in `astro.config.mjs`
3. Optionally add a `nav_access` row to control plan visibility

### Adding a new admin tab
1. Add `<button class="admin-tab" data-tab="<name>">` in the tab nav
2. Add `<div id="tab-<name>" class="admin-tab-panel" style="display:none">` panel
3. Add a `load<Name>()` async function
4. Add it to `Promise.all([...])` in `init()`

### Supabase client (anon key — safe to commit)
```ts
import { supabase } from '../lib/supabase';
```

### Checking if user is admin (client-side)
```ts
const { data: profile } = await supabase
  .from('user_profiles')
  .select('role')
  .eq('user_id', session.user.id)
  .single();
const isAdmin = profile?.role === 'admin' || session.user.user_metadata?.role === 'admin';
```

## Notes
- The Supabase anon/publishable key in `src/lib/supabase.ts` is intentionally public — it is safe to commit.
- The service role key is only used inside edge functions via `Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')` and is never exposed to the client.
- Starlight's sidebar is static (rendered at build time). Nav visibility is enforced client-side by hiding `<li>` elements — it is not a security boundary, just UX.
- The `--sl-content-margin-inline` CSS variable controls content centering when the TOC sidebar collapses; overridden in `custom.css` for the `html.toc-collapsed` state.
