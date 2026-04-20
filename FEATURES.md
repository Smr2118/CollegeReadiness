# College Readiness Hub — User Features

All features require being signed in (the auth modal blocks access until login). Most data is scoped to the signed-in user's family.

---

## Navigation Structure

```
Home
Programs & Activities
  ├── ☀️ College Summer Programs
  ├── 💼 Internships
  ├── 🏆 Extra Curriculars
  └── 🇮🇳 India Activities
Brainstorm
  ├── ✍️ Essay Ideas
  ├── 🤖 Robotics Ideas
  ├── 🇮🇳 India Activities Ideas
  └── 💡 Ideas Board
Shortlists
  ├── ✍️ Essay Theme
  ├── 🤖 Robotics
  ├── 🏆 Extra Curriculars
  └── 🤝 Volunteering
Resources
  ├── 📅 Deadline Calendar
  ├── ✅ Family To-Do
  ├── 📓 Notes
  └── 🔗 Reference Links
Admin
  └── ⚙️ Admin Panel
```

Sidebar links are hidden based on the family's plan tier (standard < basic < premium). Admins see all links regardless of plan.

---

## Programs & Activities

### ☀️ College Summer Programs

Browse and track a catalog of summer programs.

**Browse & Filter**
- Grid of program cards showing: name, organization, tier (T1–T4), cost, selectivity, and deadline
- Filter by: Status (Open / Closed / Next Year / Conflict), Tier, Cost (Free / Stipend / Paid), Format (In-Person / Virtual / Hybrid), Category (Math, CS, Robotics, STEM, Life Sciences, etc.), and your interest level
- Search by program name, organization, or tags
- Sort by: default order, nearest deadline, or interest level

**Per-Program Actions**
- Expand card to see full description, rating, college impact, duration, grades, and tags
- Set interest level: Applied → Applying → Researching → Maybe → Skip
- Add/edit a personal note on the program
- Click "Apply" to open the program's website

**Export**
- Export visible/filtered programs as CSV

**Access control**: Some programs are visible only to families on a basic or premium plan. Admins always see all programs.

---

### 💼 Internships

Coming soon — not yet implemented.

---

### 🏆 Extra Curriculars

Coming soon — not yet implemented.

---

### 🇮🇳 India Activities

Static reference page listing India-based activities the family is doing or has done. Managed via the database; displayed read-only.

---

## Brainstorm

All brainstorm pages share the same core feature set:

| Feature | Details |
|---|---|
| **Add item** | Form at the top of the page |
| **Edit item** | Form pre-populates with existing values |
| **Delete item** | Confirm dialog before deletion |
| **Star** ★ | Mark a favourite; filter to starred-only |
| **Pin** 📌 | Adds item to the matching Shortlist page |
| **Status dropdown** | Change status inline: Open → Interested → Complete → Cancelled |
| **Filters** | Right sidebar chips: status, category/theme, starred-only |
| **Sort** | Newest, Oldest, A–Z, Z–A, by Status |
| **Count** | Shows how many items match current filters |
| **CSV export** | Downloads all visible items |
| **JSON import** | Upload a `.json` file to bulk-add items (validated before import) |

### ✍️ Essay Ideas

Track essay story points and themes.

**Form fields**: Title (required), Theme (STEM / Political / Family / Other), Status, Details & Examples

**JSON import format**:
```json
[
  {
    "title": "Led robotics team despite losing half the members",
    "category": "STEM",
    "details": "Junior year — recruited 3 new members mid-season",
    "status": "Open",
    "starred": false,
    "shortlisted": false
  }
]
```

---

### 🤖 Robotics Ideas

Track project ideas for robotics competitions and builds.

**Form fields**: Title (required), Category (Fun / Charity / Benefit Community / Other), Status, Details & Notes

**JSON import format**:
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

### 🇮🇳 India Activities Ideas

Brainstorm cultural, language, volunteer, and India-based program ideas.

**Form fields**: Title (required), Category (Cultural & Heritage / Language / Volunteer / Service / Programs in India / Diaspora Networks / Other), Status, Details & Notes

**JSON import format**:
```json
[
  {
    "title": "Classical Bharatanatyam with local troupe",
    "category": "Cultural & Heritage",
    "details": "Performing at temple events and cultural festivals",
    "status": "Open",
    "starred": false,
    "shortlisted": false
  }
]
```

---

### 💡 Ideas Board

General-purpose brainstorm board that doesn't fit the other categories.

**Form fields**: Title (required), Priority (🔴 High / 🟡 Medium / 🟢 Low), Status, Tags (Summer / Internship / EC / Essay / India / Research / Misc — multi-select), Notes

**Extra filters**: Priority level, Tags

**Note**: The add/edit form opens in a modal overlay.

---

## Shortlists

Each shortlist shows items that were pinned (📌) in the corresponding brainstorm page. All shortlist pages share the same capabilities:

- View shortlisted items in a table with title, category/theme, status, and date
- **Unpin** an item to remove it from the shortlist (the item remains in the brainstorm page)
- View item count

| Shortlist | Source |
|---|---|
| ✍️ Essay Theme | Essay Ideas brainstorm |
| 🤖 Robotics | Robotics Ideas brainstorm |
| 🏆 Extra Curriculars | Ideas Board (tag: EC) |
| 🤝 Volunteering | Ideas Board (tag: Volunteering) |

---

## Resources

### 📅 Deadline Calendar

View program application deadlines in a calendar and list format.

- Month view with colored dots per day (T1 = gold, T2 = blue, T3 = green, T4 = gray)
- Navigate forward and backward by month
- Click a date to see a popup with all deadlines on that day: program name, organization, tier, and Apply link
- **Upcoming Deadlines** list below the calendar, grouped by month
- Days-remaining countdown with urgency colors: red (≤ 7 days), orange (≤ 21 days)
- Export deadlines as CSV (sorted by date)

---

### ✅ Family To-Do

Shared task list for the whole family.

- Create task: title and assignee (a specific family member, or "Everyone")
- Check off tasks as done (strikethrough styling)
- Delete tasks you created
- Tasks grouped by assignee: current user first, then others alphabetically, then "Everyone"
- Open task count shown per person
- Export as CSV (task, assigned to, status, created date)

---

### 📓 Notes

Freeform notes, optionally linked to a specific program.

**Form fields**: Note content (required), Program (optional dropdown, populated from loaded programs), Status

**Actions**: Edit, Delete, Star, Change status inline, Filter, Sort, Export CSV

---

### 🔗 Reference Links

Curated list of external resources (Reddit college guides, scholarship tools, internship directories, etc.). Read-only static content.

---

## Admin Panel

Access restricted to users with role `admin`.

### Families tab
- View all family groups
- Create a new family: ID (slug, e.g. `sant`) and Display Name

### Users tab
- View all users with email, display name, and family assignment
- Create a new user: email, password (≥ 8 chars), display name (≥ 2 chars), family group

### Programs tab
- View all programs in a table
- Add or edit a program with a full form:
  - **Basic**: name, org, category, status, tier, cost, format, deadline
  - **Details**: duration, grades, rating, selectivity, college impact
  - **Content**: description, note (with type: priority / deadline / info / warning / conflict / nextyear), URL, tags, sort order
- Delete programs

### Nav Access tab
- View and manage path-based access rules
- Set a minimum plan tier (standard / basic / premium) per sidebar link path
- Admins bypass all access rules

### Stats tab
- View login events and usage statistics

---

## Authentication

- **Sign in** via the auth modal (email + password)
- **Sign out** via the user bar at the bottom-right
- Session is restored automatically across page loads
- All user data is scoped to the signed-in user's family (`family_id`)
- Admins have full access; standard users may have sidebar links hidden based on plan tier
