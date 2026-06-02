<div align="center">

```
███████╗██████╗ ██╗   ██╗███████╗██╗  ██╗██╗██╗     ██╗     ███████╗
██╔════╝██╔══██╗██║   ██║██╔════╝██║ ██╔╝██║██║     ██║     ██╔════╝
█████╗  ██║  ██║██║   ██║███████╗█████╔╝ ██║██║     ██║     ███████╗
██╔══╝  ██║  ██║██║   ██║╚════██║██╔═██╗ ██║██║     ██║     ╚════██║
███████╗██████╔╝╚██████╔╝███████║██║  ██╗██║███████╗███████╗███████║
╚══════╝╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝
```

### National Digital Skills & E-Learning Portal

*Empowering Africa's Workforce — One Skill at a Time*

<br/>

[![React](https://img.shields.io/badge/React-18.2-61DAFB?style=for-the-badge&logo=react&logoColor=black)](https://react.dev)
[![Vite](https://img.shields.io/badge/Vite-5.0-646CFF?style=for-the-badge&logo=vite&logoColor=white)](https://vitejs.dev)
[![Node.js](https://img.shields.io/badge/Node.js-20+-339933?style=for-the-badge&logo=node.js&logoColor=white)](https://nodejs.org)
[![Express](https://img.shields.io/badge/Express-4.18-000000?style=for-the-badge&logo=express&logoColor=white)](https://expressjs.com)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)

[![Tailwind CSS](https://img.shields.io/badge/Tailwind-3.3-06B6D4?style=for-the-badge&logo=tailwindcss&logoColor=white)](https://tailwindcss.com)
[![Framer Motion](https://img.shields.io/badge/Framer_Motion-10-FF0055?style=for-the-badge&logo=framer&logoColor=white)](https://www.framer.com/motion)
[![Netlify](https://img.shields.io/badge/Frontend-Netlify-00C7B7?style=for-the-badge&logo=netlify&logoColor=white)](https://netlify.com)
[![Render](https://img.shields.io/badge/Backend-Render-46E3B7?style=for-the-badge&logo=render&logoColor=white)](https://render.com)

<br/>

[Live Demo](#-live-demo) · [Features](#-features) · [Getting Started](#-getting-started) · [API Docs](#-api-reference) · [Deploy](#-deployment)

</div>

---

## The Problem We're Solving

> Africa faces a dual crisis: a **skills gap** that leaves employers struggling to fill digital roles, and **youth unemployment** that leaves millions without direction. At the same time, social media misuse, digital illiteracy, and financial ignorance continue to hold communities back.

**EduSkills** is a national-scale e-learning portal built to bridge that gap — offering free and low-cost courses in high-demand digital skills, entrepreneurship, financial literacy, and digital citizenship, all accessible from any device.

---

## Features

<table>
<tr>
<td width="50%">

### For Learners
- **Browse & Enroll** in 8+ curated courses across 7 categories
- **Track Progress** with a real-time progress bar per course
- **Activity Dashboard** showing monthly learning hours via an interactive chart
- **My Courses** panel for quick access to enrolled content
- **Profile Management** — update name, bio, and avatar

</td>
<td width="50%">

### Platform Highlights
- **Animated Sidebar** — spring-physics open/close (Framer Motion)
- **Auth Screen Animations** — floating geometric shapes + SVG illustration
- **Category Filtering** with a smooth animated active-pill indicator
- **Responsive Layout** — works on desktop, tablet, and mobile
- **JWT Authentication** — secure, stateless, 7-day tokens
- **Supabase Backend** — PostgreSQL with full relational data integrity

</td>
</tr>
</table>

---

## Tech Stack

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENT (Netlify)                        │
│                                                                 │
│   React 18  ·  Vite 5  ·  Tailwind CSS  ·  Framer Motion      │
│   React Router v6  ·  Axios  ·  Recharts  ·  Lucide React      │
└─────────────────────────┬───────────────────────────────────────┘
                          │  HTTPS / REST API
┌─────────────────────────▼───────────────────────────────────────┐
│                         SERVER (Render)                         │
│                                                                 │
│         Node.js  ·  Express 4  ·  JWT  ·  bcryptjs             │
│              express-validator  ·  CORS  ·  dotenv             │
└─────────────────────────┬───────────────────────────────────────┘
                          │  @supabase/supabase-js (service role)
┌─────────────────────────▼───────────────────────────────────────┐
│                      DATABASE (Supabase)                        │
│                                                                 │
│          PostgreSQL  ·  3 tables  ·  JSONB lessons field       │
│              UUID primary keys  ·  Relational joins            │
└─────────────────────────────────────────────────────────────────┘
```

---

## Project Structure

```
advanced-web-dev/
│
├── frontend/                        # React + Vite application
│   ├── public/
│   ├── src/
│   │   ├── components/
│   │   │   ├── ActivityChart.jsx    # Recharts stacked bar chart
│   │   │   ├── CategoryFilter.jsx   # Animated filter pills
│   │   │   ├── CourseCard.jsx       # Pastel course cards w/ hover
│   │   │   ├── Navbar.jsx           # Top search + notifications bar
│   │   │   ├── Sidebar.jsx          # Spring-animated collapsible nav
│   │   │   └── UserProfilePanel.jsx # Right panel with stats
│   │   ├── context/
│   │   │   └── AuthContext.jsx      # JWT auth state + localStorage
│   │   ├── pages/
│   │   │   ├── Login.jsx            # Animated auth screen
│   │   │   ├── Signup.jsx           # Animated auth screen
│   │   │   ├── Dashboard.jsx        # Main 3-column layout
│   │   │   ├── Courses.jsx          # Full course catalogue
│   │   │   ├── CourseDetail.jsx     # Lessons + enroll card
│   │   │   └── Profile.jsx          # User stats + edit form
│   │   ├── services/
│   │   │   └── api.js               # Axios instance + interceptors
│   │   ├── App.jsx                  # Routes + ProtectedRoute
│   │   ├── index.css                # Tailwind + global styles
│   │   └── main.jsx
│   ├── .env.example
│   ├── index.html
│   ├── netlify.toml
│   ├── postcss.config.js
│   ├── tailwind.config.js
│   └── vite.config.js
│
├── backend/                         # Node.js + Express API
│   ├── src/
│   │   ├── config/
│   │   │   ├── db.js                # Connection health check
│   │   │   └── supabase.js          # Supabase client (service role)
│   │   ├── middleware/
│   │   │   ├── auth.js              # JWT verify + requireRole
│   │   │   └── errorHandler.js      # Global error handler
│   │   ├── models/
│   │   │   ├── Course.js            # Supabase query helper
│   │   │   ├── Enrollment.js        # Supabase query helper
│   │   │   └── User.js              # Supabase query helper + bcrypt
│   │   ├── routes/
│   │   │   ├── auth.js              # /register  /login  /me
│   │   │   ├── courses.js           # CRUD + search + featured
│   │   │   ├── enrollments.js       # Enroll + progress tracking
│   │   │   └── users.js             # Profile + activity data
│   │   └── utils/
│   │       └── seedData.js          # 8 pre-built courses
│   ├── supabase/
│   │   └── schema.sql               # Run once in Supabase SQL Editor
│   ├── .env.example
│   ├── package.json
│   ├── render.yaml
│   └── server.js
│
└── README.md
```

---

## Getting Started

### Prerequisites

| Tool | Version |
|------|---------|
| Node.js | 18+ |
| npm | 9+ |
| A free [Supabase](https://supabase.com) project | — |

---

### 1 — Set Up the Database

1. Create a new project at **[supabase.com](https://supabase.com)**
2. Navigate to **SQL Editor** in the left sidebar
3. Paste the entire contents of [`backend/supabase/schema.sql`](backend/supabase/schema.sql) and click **Run**

This creates three tables (`users`, `courses`, `enrollments`), performance indexes, and the `increment_course_students` helper function.

4. Go to **Settings → API** and copy:
   - **Project URL** → `SUPABASE_URL`
   - **service_role** secret → `SUPABASE_SERVICE_ROLE_KEY`

---

### 2 — Configure the Backend

```bash
cd backend
cp .env.example .env
```

Open `.env` and fill in your values:

```env
PORT=5000
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
JWT_SECRET=choose_a_long_random_secret_string_here
NODE_ENV=development
FRONTEND_URL=http://localhost:5173
```

```bash
npm install
npm run dev
# API running at http://localhost:5000
```

---

### 3 — Seed the Database

With the server running, fire one POST request to populate all 8 courses:

```bash
curl -X POST http://localhost:5000/api/seed
```

Expected response:
```json
{
  "success": true,
  "message": "Database seeded with 8 courses",
  "seeded": true,
  "count": 8
}
```

---

### 4 — Configure the Frontend

```bash
cd frontend
cp .env.example .env
```

```env
VITE_API_URL=http://localhost:5000/api
```

```bash
npm install
npm run dev
# App running at http://localhost:5173
```

Open **[http://localhost:5173](http://localhost:5173)** — you'll land on the Login screen.

---

## Course Catalogue

| # | Course | Category | Rating | Students |
|---|--------|----------|--------|----------|
| 1 | Python for Data Analysis | Data Science | ⭐ 4.8 | 9,530 |
| 2 | Digital Marketing Fundamentals | Digital Marketing | ⭐ 4.9 | 1,463 |
| 3 | Web Development Bootcamp | IT & Software | ⭐ 4.7 | 6,726 |
| 4 | Financial Literacy for Entrepreneurs | Entrepreneurship | ⭐ 5.0 | 8,735 |
| 5 | Digital Citizenship & Online Safety | Digital Citizenship | ⭐ 4.6 | 3,210 |
| 6 | UI/UX Design Fundamentals | Media Training | ⭐ 4.9 | 5,430 |
| 7 | Cloud Computing Basics | IT & Software | ⭐ 4.7 | 4,120 |
| 8 | Entrepreneurship 101 | Entrepreneurship | ⭐ 4.8 | 7,650 |

---

## API Reference

**Base URL:** `http://localhost:5000/api` (dev) · `https://your-app.onrender.com/api` (prod)

All protected routes require an `Authorization: Bearer <token>` header.

### Auth

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/auth/register` | — | Create a new account |
| `POST` | `/auth/login` | — | Sign in, receive JWT |
| `GET` | `/auth/me` | Protected | Get current user |

<details>
<summary><strong>POST /auth/register</strong> — request body</summary>

```json
{
  "name": "Annette Black",
  "email": "annette@example.com",
  "password": "securepassword"
}
```
</details>

<details>
<summary><strong>POST /auth/login</strong> — response</summary>

```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "name": "Annette Black",
    "email": "annette@example.com",
    "role": "student",
    "avatar": "",
    "bio": ""
  }
}
```
</details>

---

### Courses

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `GET` | `/courses` | — | List courses (supports `?category=&search=&page=&limit=`) |
| `GET` | `/courses/featured` | — | Top 4 highest-rated courses |
| `GET` | `/courses/:id` | — | Single course with lessons |
| `POST` | `/courses` | Instructor/Admin | Create a course |
| `PUT` | `/courses/:id` | Owner/Admin | Update a course |

---

### Enrollments

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `POST` | `/enrollments/enroll/:courseId` | Protected | Enroll in a course |
| `GET` | `/enrollments/my-courses` | Protected | Get enrolled courses + progress |
| `PUT` | `/enrollments/progress/:courseId` | Protected | Update lesson progress |

---

### Users

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| `GET` | `/users/profile` | Protected | Get profile + enrollment stats |
| `PUT` | `/users/profile` | Protected | Update name / bio / avatar |
| `GET` | `/users/activity` | Protected | Monthly activity chart data |

---

## Database Schema

```sql
users
  id            UUID  PK
  name          VARCHAR(100)
  email         VARCHAR(255)  UNIQUE
  password_hash VARCHAR(255)
  avatar        TEXT
  bio           TEXT
  role          student | instructor | admin
  created_at    TIMESTAMPTZ

courses
  id              UUID  PK
  title           VARCHAR(200)
  description     TEXT
  category        VARCHAR(100)
  color           VARCHAR(20)        ← card background hex
  rating          NUMERIC(2,1)
  total_students  INTEGER
  instructor_id   UUID  FK → users
  lessons         JSONB              ← [{title, duration, videoUrl}]
  tags            TEXT[]
  is_free         BOOLEAN
  created_at      TIMESTAMPTZ

enrollments
  id                UUID  PK
  user_id           UUID  FK → users    ON DELETE CASCADE
  course_id         UUID  FK → courses  ON DELETE CASCADE
  progress          INTEGER  0–100
  completed_lessons JSONB              ← [lessonIndex, ...]
  enrolled_at       TIMESTAMPTZ
  last_accessed     TIMESTAMPTZ
  UNIQUE(user_id, course_id)
```

---

## Deployment

### Backend → Render

1. Push the repo to GitHub
2. Go to **[render.com](https://render.com)** → **New Web Service** → connect your repo
3. Set **Root Directory** to `backend`
4. Render will detect `render.yaml` automatically — it sets build command to `npm install` and start to `node server.js`
5. Add the following **Environment Variables** in the Render dashboard:

   | Key | Value |
   |-----|-------|
   | `NODE_ENV` | `production` |
   | `SUPABASE_URL` | your Supabase project URL |
   | `SUPABASE_SERVICE_ROLE_KEY` | your service_role key |
   | `JWT_SECRET` | a long random string |
   | `FRONTEND_URL` | your Netlify URL (after step below) |

6. Deploy — your API will be live at `https://your-service.onrender.com`

---

### Frontend → Netlify

1. Go to **[netlify.com](https://netlify.com)** → **Add new site** → **Import from Git**
2. Select your repo — Netlify auto-detects `netlify.toml`:
   - **Base directory:** `frontend`
   - **Build command:** `npm run build`
   - **Publish directory:** `dist`
3. Add one **Environment Variable**:

   | Key | Value |
   |-----|-------|
   | `VITE_API_URL` | `https://your-service.onrender.com/api` |

4. Deploy — your app will be live at `https://your-site.netlify.app`
5. Go back to Render and update `FRONTEND_URL` to the Netlify URL

> **Note:** After deploying, hit `POST https://your-service.onrender.com/api/seed` once to populate the production database with the 8 starter courses.

---

## UI Design Decisions

| Element | Implementation |
|---------|---------------|
| **Sidebar** | Framer Motion `animate={{ width }}` spring — collapses to 70 px (icon-only), expands to 240 px on hover, labels fade in with opacity transition |
| **Auth Screens** | Split layout — animated panel (mint green `#7ec8a4` gradient) with 5+ floating geometric shapes using `y: [0, -20, 0]` infinite loop and staggered durations |
| **Course Cards** | Pastel backgrounds per course (pink, yellow, purple, peach) with `whileHover={{ scale: 1.03 }}` lift effect |
| **Category Pills** | Framer Motion `layoutId` shared element animation for the sliding active indicator |
| **Activity Chart** | Recharts `BarChart` with a custom rounded `Bar` shape, stacked by video / practice / reading hours |
| **Color System** | Cream background `#f5f0e8`, white sidebar, dark text `#1a1a2e` — matches the Figma reference |

---

## Environment Variables Reference

### Backend (`backend/.env`)

| Variable | Required | Description |
|----------|----------|-------------|
| `PORT` | No | Server port (default: 5000) |
| `SUPABASE_URL` | **Yes** | Your Supabase project URL |
| `SUPABASE_SERVICE_ROLE_KEY` | **Yes** | Service role secret (never expose to client) |
| `JWT_SECRET` | **Yes** | Random string for signing tokens |
| `NODE_ENV` | No | `development` or `production` |
| `FRONTEND_URL` | **Yes** | Allowed CORS origin |

### Frontend (`frontend/.env`)

| Variable | Required | Description |
|----------|----------|-------------|
| `VITE_API_URL` | **Yes** | Full API base URL including `/api` |

---

## Security Notes

- Passwords are hashed with **bcryptjs** (12 salt rounds) before storage — plaintext is never persisted
- The Supabase **service_role** key is backend-only and never sent to the browser
- JWT tokens expire after **7 days**; the frontend interceptor redirects to `/login` on 401
- CORS is locked to the `FRONTEND_URL` env var plus `*.netlify.app` patterns
- The `/api/seed` endpoint is disabled in `NODE_ENV=production`

---

<div align="center">

Built with purpose for the people.

**Learn · Grow · Succeed**

</div>
