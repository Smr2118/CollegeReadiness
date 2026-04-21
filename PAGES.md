# College Readiness Hub — Pages Reference

Quick reference for every user-facing page: layout, fields, filters, how to add data, and JSON import format.

---

## Brainstorm

### ✍️ Essay Ideas (`/essay-topics/`)
**Component:** `EssayTopics.astro` | **DB table:** `essay_topics`

**Layout:** Card grid (`repeat(auto-fill, minmax(280px, 1fr))`)

**Fields:**
| Field | Type | Notes |
|---|---|---|
| Title | text | Required |
| Category | select | Application Point, Personal Story, Challenge, Achievement, Values, Other |
| Status | select | Open, Interested, Drafting, Complete, Cancelled |
| Details / Notes | textarea | Collapsible on card (click title to expand) |
| Starred | toggle | ★ button on card |
| Shortlisted | toggle | 📌 button on card |

**Card colors:** Left border = category color. Status shown as inline colored dropdown.

**Filters (sidebar):** Status chips, Category chips, Starred toggle, Sort (Newest/Oldest/A–Z/Z–A/By Status)

**Add data:** Fill form at top → click "Add Idea"

**JSON import format:**
```json
[
  {
    "title": "Overcoming fear of public speaking",
    "category": "Challenge",
    "details": "Speech team sophomore year",
    "status": "Open",
    "starred": false,
    "shortlisted": false
  }
]
```

---

### 🤖 Robotics Ideas (`/robotics-ideas/`)
**Component:** `RoboticsIdeas.astro` | **DB table:** `robotics_ideas`

**Layout:** Table

**Fields:**
| Field | Type | Notes |
|---|---|---|
| Idea / Point | text | Required |
| Category | select | Fun, Charity, Benefit Community, Other |
| Status | select | Open, Interested, Cancelled, Complete |
| Details & Notes | textarea | Shown as truncated subtitle in table row |
| Starred | toggle | ★ column |
| Shortlisted | toggle | 📌 column |

**Filters (sidebar):** Status chips, Category chips, Starred toggle, Sort

**Add data:** Fill form at top → click "Add Idea"

**JSON import format:**
```json
[
  {
    "title": "Build a sorting robot for food bank donations",
    "category": "Charity",
    "details": "Use computer vision to sort canned goods by expiry",
    "status": "Open",
    "starred": false,
    "shortlisted": false
  }
]
```

---

### 🇮🇳 India Activities Ideas (`/india-ideas/`)
**Component:** `IndiaActivities.astro` | **DB table:** `india_activities`

**Layout:** Table

**Fields:**
| Field | Type | Notes |
|---|---|---|
| Activity / Idea | text | Required |
| Category | select | Cultural, Language, Volunteering, Program, Diaspora Network, Other |
| Status | select | Open, Interested, Cancelled, Complete |
| Details & Notes | textarea | Truncated subtitle in table |
| Starred | toggle | ★ column |
| Shortlisted | toggle | 📌 column |

**Add data:** Fill form → click "Add Idea"

**JSON import format:**
```json
[
  {
    "title": "Tamil language summer program",
    "category": "Language",
    "details": "3-week immersive program in Chennai",
    "status": "Interested",
    "starred": false,
    "shortlisted": false
  }
]
```

---

### 💡 Ideas Board (`/ideas/`)
**Component:** `IdeasBoard.astro` | **DB table:** `ideas`

**Layout:** Table

**Fields:** Title, Category (freeform), Details, Status (Open/Interested/Complete/Cancelled), Starred, Shortlisted

---

### 🏃 Extra Curriculars (`/ec-ideas/`)
**Component:** `EcIdeas.astro` | **DB table:** `ec_ideas`

**Layout:** Card grid (`repeat(auto-fill, minmax(280px, 1fr))`)

**Fields:**
| Field | Type | Notes |
|---|---|---|
| Activity / Idea | text | Required |
| Category | select | Sports, Arts, Community Service, Leadership, Academic, STEM, Cultural, Other |
| Status | select | Open, Interested, Pursuing, Complete, Cancelled |
| Details & Notes | textarea | Collapsible on card (click title to expand) |
| Starred | toggle | ★ button |
| Shortlisted | toggle | 📌 button |

**Card colors:**
| Category | Color |
|---|---|
| Sports | Red `#ef4444` |
| Arts | Pink `#ec4899` |
| Community Service | Green `#22c55e` |
| Leadership | Amber `#f59e0b` |
| Academic | Blue `#3b82f6` |
| STEM | Purple `#8b5cf6` |
| Cultural | Orange `#f97316` |
| Other | Gray `#94a3b8` |

**Status colors:** Open=Blue, Interested=Amber, Pursuing=Purple, Complete=Green, Cancelled=Gray

**Filters (sidebar):** Status chips, Category chips, Starred toggle, Sort

**Add data:** Fill form at top → click "Add Idea"

**JSON import format:**
```json
[
  {
    "title": "Start a coding club at school",
    "category": "STEM",
    "details": "Teach Python basics to classmates, mentor younger students",
    "status": "Open",
    "starred": false,
    "shortlisted": false
  }
]
```

---

### 🔧 Past Projects (`/past-projects/`)
**Component:** `PastProjects.astro` | **DB table:** `past_projects`

**Layout:** Card grid (`repeat(auto-fill, minmax(300px, 1fr))`)

**Fields:**
| Field | Type | Notes |
|---|---|---|
| Project Name | text | Required |
| Category | select | School, Personal, Research, Competition, Volunteer, Other |
| Status | select | Ongoing, Completed, On Hold, Abandoned |
| Year(s) | text | e.g. `2024–2025` |
| Role | text | e.g. "Lead Developer" |
| Skills / Tools | text | e.g. "Python, TensorFlow, CAD" |
| Description & Notes | textarea | Collapsible on card (click title to expand) |
| Starred | toggle | ★ button |
| Shortlisted | toggle | 📌 button |

**Card colors (category):**
| Category | Color |
|---|---|
| School | Blue `#3b82f6` |
| Personal | Purple `#8b5cf6` |
| Research | Cyan `#0891b2` |
| Competition | Amber `#f59e0b` |
| Volunteer | Green `#22c55e` |
| Other | Gray `#94a3b8` |

**Card details:** Year shown always (if present); Role, Skills, and Description are hidden until you click the title (collapsible).

**Add data:** Fill form at top → click "Add Project"

**JSON import format:**
```json
[
  {
    "title": "AI-powered recycling sorter",
    "category": "Personal",
    "status": "Completed",
    "year": "2024–2025",
    "role": "Lead Developer",
    "skills": "Python, TensorFlow, Raspberry Pi",
    "details": "Built a CV model that classifies recyclables with 94% accuracy",
    "starred": false,
    "shortlisted": false
  }
]
```

---

## Programs & Activities

### ☀️ College Summer Programs (`/programs/`)
**Component:** `ProgramGrid.astro` + `ProgramCard.astro` | **DB table:** `programs` + `program_data`

**Layout:** Card grid

**Fields:** Name, Organization, Description, Deadline, Status, Cost, Tier, Access Level (public/basic/premium)

**Filters:** Status, Tier, Starred — controlled via sidebar filter panel

---

### 💼 Internships (`/internships/`)  
### 🏆 Extra Curriculars (`/extracurriculars/`)  
### 🇮🇳 India Activities (`/india-activities/`)  
These pages use the same `ProgramGrid` component filtered by type.

---

## Resources

### 🏫 Colleges Info (`/colleges/`)
**Component:** `CollegesInfo.astro` | **DB table:** `colleges`

**Layout:** Card grid (`repeat(auto-fill, minmax(280px, 1fr))`)

**Fields:**
| Field | Type | Notes |
|---|---|---|
| College Name | text | Required |
| Location | text | Shown with 📍 on card |
| Type | select | Ivy League, Liberal Arts, Research University, State University, Other |
| Status | select | Researching, Applying, Applied, Accepted, Waitlisted, Deferred, Rejected |
| Notes | textarea | Collapsible on card |
| Starred | toggle | ★ button |
| Shortlisted | toggle | 📌 button |

**Card colors (type):**
| Type | Color |
|---|---|
| Ivy League | Purple `#7c3aed` |
| Liberal Arts | Cyan `#0891b2` |
| Research University | Blue `#1d4ed8` |
| State University | Green `#047857` |
| Other | Gray `#94a3b8` |

**Special:** Accepted cards get a green left border override. Rejected card names get strikethrough.

**JSON import format:**
```json
[
  {
    "name": "MIT",
    "location": "Cambridge, MA",
    "type": "Research University",
    "status": "Researching",
    "notes": "Strong CS and robotics programs",
    "starred": false,
    "shortlisted": false
  }
]
```

---

### 📅 Deadline Calendar (`/calendar/`)
**Component:** `DeadlineCalendar.astro`

Calendar view of program deadlines pulled from the `programs` table.

### ✅ Family To-Do (`/todos/`)
**Component:** `TodoList.astro` | **DB table:** `todos`

Shared family checklist. Items can be assigned to family members, toggled done/undone.

### 📓 Notes (`/notes/`)
**Component:** `FamilyNotes.astro` | **DB table:** `notes`

Free-form family notes, organized by topic/tag.

### 🔗 Reference Links (`/references/`)
**Component:** `ReferenceLinks.astro` | **DB table:** `reference_links`

Bookmarks with title, URL, and category.

---

## Shortlists

All shortlist pages display items pinned (📌) from their source brainstorm page.

| Page | Source |
|---|---|
| ✍️ Essay Theme (`/shortlists/essay-theme/`) | `essay_topics` where `shortlisted = true` |
| 🤖 Robotics (`/shortlists/robotics/`) | `robotics_ideas` where `shortlisted = true` |
| 🏆 Extra Curriculars (`/shortlists/extracurriculars/`) | `extracurriculars` where `shortlisted = true` |
| 🤝 Volunteering (`/shortlists/volunteering/`) | filtered from programs |

---

## Common UI Patterns

### Card layout
All card pages share the same structure:
- **Top row:** Category badge (colored pill) + Status dropdown + Star + Pin buttons
- **Title row:** Clickable to expand/collapse details (▶ chevron rotates when open)
- **Extra info:** Hidden by default, shown when card is open
- **Footer:** Date added + Edit / Delete buttons (small, 0.62rem)

### Filters (sidebar panel — `CustomPageSidebar.astro`)
Standard filter controls injected into the right sidebar:
- Status filter chips (click to filter by status)
- Category filter chips
- Sort dropdown (`bs-sort`): Newest, Oldest, A–Z, Z–A, By Status
- Starred only checkbox (`bs-starred`)

### JSON Import flow
1. Click "⬆ Import JSON" → file picker opens
2. Select a `.json` file (array of objects)
3. Preview bar shows count + first 3 titles
4. Click "Import" to confirm, or "Cancel" to abort
5. Invalid files show an inline error message

### CSV Export
Click "⬇ Export CSV" — downloads a `.csv` with all current records (not filtered).
