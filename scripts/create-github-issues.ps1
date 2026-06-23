# Creates all GitHub issues for AI Mock Interview Platform
# Run: powershell -ExecutionPolicy Bypass -File scripts/create-github-issues.ps1

$Repo = "akshatsoni123/AI-Mock-Interview-Platform-"

$labels = @(
    @{ name = "setup"; color = "0052CC"; desc = "Project setup and planning" },
    @{ name = "backend"; color = "D93F0B"; desc = "Server and API work" },
    @{ name = "frontend"; color = "0E8A16"; desc = "UI and user pages" },
    @{ name = "database"; color = "5319E7"; desc = "Database and data models" },
    @{ name = "ai"; color = "FBCA04"; desc = "AI interview features" },
    @{ name = "testing"; color = "BFD4F2"; desc = "Tests and quality checks" },
    @{ name = "deployment"; color = "1D76DB"; desc = "Hosting and going live" }
)

foreach ($l in $labels) {
    gh label create $l.name --repo $Repo --color $l.color --description $l.desc 2>$null
}

function New-Milestone($title, $desc) {
    $result = gh api --method POST "repos/$Repo/milestones" -f title=$title -f description=$desc 2>$null | ConvertFrom-Json
    return $result.number
}

# Milestones already exist — gh needs the title string, not the number
$m1 = "Phase 1 - Setup"
$m2 = "Phase 2 - Backend"
$m3 = "Phase 3 - Frontend"
$m4 = "Phase 4 - AI Features"
$m5 = "Phase 5 - Polish and Launch"

$issues = @(
    @{
        title = "[Setup] Choose your tech stack and draw a simple plan"
        labels = "setup"
        milestone = $m1
        body = @"
## What is this ticket about?
Before writing code, decide **what tools** you will use and **how the app will work** at a high level. This saves time later.

## What you will learn
- How real projects are planned before coding
- Difference between frontend, backend, and database
- How data flows in a web app (user -> UI -> API -> database -> AI -> back to user)

## Recommended stack (good for learning)
| Part | Tool | Why |
|------|------|-----|
| Frontend | React + Vite | Popular, lots of tutorials |
| Styling | Tailwind CSS | Fast to build nice UI |
| Backend | Node.js + Express | Same language as frontend (JavaScript) |
| Database | PostgreSQL + Prisma | Prisma makes database work easier |
| AI | OpenAI API | Easy to start with chat/completions |
| Auth | JWT + bcrypt | Standard way to handle login |

> You can swap tools later, but pick one stack and stick with it for this project.

## Steps to complete
1. Create a simple diagram on paper or [Excalidraw](https://excalidraw.com):
   - User opens website
   - User signs up / logs in
   - User starts mock interview (picks job role)
   - App asks AI for questions
   - User answers each question
   - AI gives feedback and score
   - User sees results on dashboard
2. Write down your main pages:
   - Landing page
   - Login / Register
   - Dashboard
   - Interview room
   - Results page
3. Write down your main API routes (just names, no code yet):
   - `POST /auth/register`
   - `POST /auth/login`
   - `POST /interviews` (start new interview)
   - `GET /interviews/:id`
   - `POST /interviews/:id/answer`
   - `POST /interviews/:id/finish`
4. Add a `docs/PROJECT_PLAN.md` file in your repo with your choices.

## Tips
- Keep it simple for v1. You do not need video, payments, or admin panel yet.
- Focus on: login -> one interview type -> text answers -> AI feedback.

## Done when
- [ ] You picked your tech stack
- [ ] You drew or wrote a simple user flow
- [ ] You listed pages and API routes
- [ ] `docs/PROJECT_PLAN.md` exists in the repo
"@
    }
    @{
        title = "[Setup] Create project folder structure and README"
        labels = "setup"
        milestone = $m1
        body = @"
## What is this ticket about?
Set up your GitHub repo with a clean folder structure so frontend and backend code stay organized.

## What you will learn
- Monorepo vs separate folders
- Environment variables (`.env`)
- How to write a good README for your portfolio

## Steps to complete
1. Clone your repo locally:
   ```bash
   git clone https://github.com/akshatsoni123/AI-Mock-Interview-Platform-.git
   cd AI-Mock-Interview-Platform-
   ```
2. Create this folder structure:
   ```
   AI-Mock-Interview-Platform-/
   ├── frontend/          # React app
   ├── backend/           # Express API
   ├── docs/              # Plans and notes
   ├── .gitignore
   └── README.md
   ```
3. Create `.gitignore` and make sure these are ignored:
   - `node_modules/`
   - `.env`
   - `dist/` or `build/`
4. Create `.env.example` files (no real secrets!) in frontend and backend showing what keys are needed:
   - `OPENAI_API_KEY=your_key_here`
   - `DATABASE_URL=your_database_url`
   - `JWT_SECRET=your_secret_here`
5. Write a README with:
   - Project name and 2-3 line description
   - Tech stack list
   - How to run frontend and backend (you can fill this in later)
   - A screenshot placeholder section

## Tips
- Never commit real API keys to GitHub.
- Commit small and often. Good habit for any developer.

## Done when
- [ ] Folder structure exists
- [ ] `.gitignore` is set up
- [ ] `.env.example` files exist
- [ ] README has project description
- [ ] First commit is pushed to GitHub
"@
    }
    @{
        title = "[Database] Design tables and set up Prisma"
        labels = "database,backend"
        milestone = $m2
        body = @"
## What is this ticket about?
Your app needs to **save data** — users, interviews, questions, answers, and feedback. We use a database for this.

## What you will learn
- What a database table is (like a spreadsheet)
- Relationships: one user has many interviews
- Prisma ORM basics (write schema, run migrations)

## Tables you need (v1)
### 1. User
- `id`, `name`, `email`, `password` (hashed, never plain text!), `createdAt`

### 2. Interview
- `id`, `userId`, `jobRole` (e.g. "Frontend Developer"), `difficulty` (easy/medium/hard)
- `status` (in_progress / completed), `startedAt`, `endedAt`

### 3. Question
- `id`, `interviewId`, `questionText`, `order` (1, 2, 3...)

### 4. Answer
- `id`, `questionId`, `answerText`, `score` (0-10, filled after AI review)
- `feedback` (text from AI)

### 5. InterviewSummary (optional but nice)
- `id`, `interviewId`, `overallScore`, `strengths`, `weaknesses`, `tips`

## Steps to complete
1. Install PostgreSQL locally OR use a free cloud DB ([Neon](https://neon.tech) or [Supabase](https://supabase.com) — both have free tiers).
2. In `backend/`, init Node project: `npm init -y`
3. Install Prisma: `npm install prisma @prisma/client`
4. Run: `npx prisma init`
5. Write your schema in `prisma/schema.prisma` based on tables above.
6. Run: `npx prisma migrate dev --name init`
7. Test connection with a small script that creates and reads one user.

## Tips
- Draw tables on paper with arrows: User -> Interview -> Question -> Answer
- Use `uuid` or `cuid` for IDs (Prisma supports `@default(cuid())`)

## Done when
- [ ] Database is running (local or cloud)
- [ ] Prisma schema has all tables
- [ ] Migration ran successfully
- [ ] You can create and read a test record
"@
    }
    @{
        title = "[Backend] Build user registration and login APIs"
        labels = "backend"
        milestone = $m2
        body = @"
## What is this ticket about?
Users need accounts so their interview history is saved. Build **sign up** and **log in** APIs.

## What you will learn
- REST API basics (POST requests, JSON body)
- Password hashing with bcrypt (never store plain passwords!)
- JWT tokens (a secure "ticket" that proves user is logged in)
- Middleware (code that runs before your route handler)

## Steps to complete
1. In `backend/`, install packages:
   ```bash
   npm install express cors dotenv bcryptjs jsonwebtoken
   npm install -D nodemon
   ```
2. Create `src/index.js` (or `server.js`) — basic Express server on port 5000.
3. Create `POST /api/auth/register`:
   - Accept: `name`, `email`, `password`
   - Check if email already exists
   - Hash password with bcrypt
   - Save user to database
   - Return success message (do not return password!)
4. Create `POST /api/auth/login`:
   - Accept: `email`, `password`
   - Find user by email
   - Compare password with bcrypt
   - If correct, create JWT token with user id inside
   - Return token + basic user info
5. Create `authMiddleware` function:
   - Read `Authorization: Bearer <token>` header
   - Verify JWT
   - Attach user to request so protected routes can use it
6. Create `GET /api/auth/me` (protected):
   - Return current logged-in user's info
7. Test all routes with Postman or Thunder Client (VS Code extension).

## Tips
- Return clear error messages: "Email already exists", "Wrong password"
- Use `HTTP 400` for bad input, `401` for wrong login, `201` for created

## Done when
- [ ] User can register with email and password
- [ ] User can login and get a JWT token
- [ ] Protected route works only with valid token
- [ ] Passwords are hashed in database
- [ ] You tested with Postman/Thunder Client
"@
    }
    @{
        title = "[Backend] Build interview session APIs"
        labels = "backend"
        milestone = $m2
        body = @"
## What is this ticket about?
These APIs let a logged-in user **start**, **continue**, and **finish** a mock interview.

## What you will learn
- CRUD operations (Create, Read, Update)
- Protected routes (only logged-in user can access their interviews)
- RESTful URL design

## API routes to build
### 1. `POST /api/interviews` — Start new interview
**Body:** `{ "jobRole": "Backend Developer", "difficulty": "medium" }`
**Does:**
- Create new Interview row linked to logged-in user
- Set status = `in_progress`
- Return interview id and details

### 2. `GET /api/interviews` — List my interviews
**Does:**
- Return all interviews for logged-in user
- Show job role, status, date, score (if completed)

### 3. `GET /api/interviews/:id` — Get one interview
**Does:**
- Return interview with all questions and answers
- Make sure this interview belongs to the logged-in user (security!)

### 4. `PATCH /api/interviews/:id/finish` — End interview
**Does:**
- Set status = `completed`, set `endedAt` time
- (AI summary will be added in a later ticket)

## Steps to complete
1. Create `routes/interviews.js` and connect to Express app.
2. Add `authMiddleware` to all interview routes.
3. Implement each route one by one.
4. Always check: `interview.userId === req.user.id` before returning data.
5. Test with Postman using a real JWT token from login.

## Tips
- Build and test one route at a time. Do not try to build all at once.
- Use good status codes: 201 for created, 404 if interview not found, 403 if not your interview.

## Done when
- [ ] User can start a new interview
- [ ] User can see list of past interviews
- [ ] User can open one interview by id
- [ ] User can mark interview as finished
- [ ] Users cannot access other users' interviews
"@
    }
    @{
        title = "[AI] Connect OpenAI and generate interview questions"
        labels = "ai,backend"
        milestone = $m4
        body = @"
## What is this ticket about?
When a user starts an interview, the app should ask AI to create **realistic interview questions** based on job role and difficulty.

## What you will learn
- How to call OpenAI API from Node.js
- Prompt writing (how you ask AI matters a lot!)
- Parsing AI response into structured data (JSON)
- Saving AI output to database

## Steps to complete
1. Get an OpenAI API key from [platform.openai.com](https://platform.openai.com) and add to `backend/.env`:
   ```
   OPENAI_API_KEY=sk-...
   ```
2. Install OpenAI SDK: `npm install openai`
3. Create `services/aiService.js` with a function:
   ```js
   generateQuestions(jobRole, difficulty, count = 5)
   ```
4. Write a good prompt, for example:
   > "You are a technical interviewer. Generate 5 interview questions for a {jobRole} position at {difficulty} level. Return ONLY valid JSON array: [{ question: string, topic: string }]"
5. Parse the JSON response and handle errors (AI sometimes returns extra text).
6. Update `POST /api/interviews` to:
   - Create interview
   - Call `generateQuestions()`
   - Save each question to Question table with order 1, 2, 3...
   - Return interview + questions to frontend
7. Test with 3 different job roles.

## Tips
- Start with 3 questions, not 10 — saves API cost while learning.
- Log the raw AI response during development to debug parsing issues.
- Set a max token limit to control cost.

## Done when
- [ ] OpenAI is connected
- [ ] Starting an interview creates 3-5 questions in database
- [ ] Questions match the job role and difficulty
- [ ] Errors are handled gracefully (show friendly message if AI fails)
"@
    }
    @{
        title = "[AI] Evaluate answers and generate feedback"
        labels = "ai,backend"
        milestone = $m4
        body = @"
## What is this ticket about?
After the user answers a question, AI should **score the answer** and give **helpful feedback** — like a real interviewer would.

## What you will learn
- Chaining AI calls (one for scoring, one for summary)
- Storing AI results in database
- Building a complete interview loop

## Steps to complete
1. Create `evaluateAnswer(question, userAnswer, jobRole)` in `aiService.js`.
2. Prompt example:
   > "You are an interviewer for {jobRole}. Question: {question}. Candidate answer: {answer}. Rate 1-10 and give 2-3 sentences of constructive feedback. Return JSON: { score: number, feedback: string }"
3. Create `POST /api/interviews/:id/questions/:questionId/answer`:
   - Accept: `{ "answerText": "..." }`
   - Call `evaluateAnswer()`
   - Save Answer row with score and feedback
   - Return score + feedback to frontend
4. Create `generateInterviewSummary(interviewId)` function:
   - Load all Q&A for this interview
   - Ask AI for overall summary: strengths, weaknesses, tips, overall score
   - Save to InterviewSummary table
5. Call summary when user finishes interview (`PATCH .../finish`).
6. Update `GET /api/interviews/:id` to include summary when completed.

## Tips
- Show feedback immediately after each answer — users learn faster that way.
- Keep feedback kind but honest. Prompt AI to be constructive, not harsh.

## Done when
- [ ] User can submit an answer and get score + feedback
- [ ] All answers are saved in database
- [ ] Finishing interview generates overall summary
- [ ] Completed interview shows full results
"@
    }
    @{
        title = "[Frontend] Set up React app with routing and Tailwind"
        labels = "frontend,setup"
        milestone = $m3
        body = @"
## What is this ticket about?
Create the **frontend** (what users see in the browser) using React.

## What you will learn
- Creating a React app with Vite
- React Router (moving between pages without reload)
- Tailwind CSS (styling with utility classes)
- Folder structure for components

## Steps to complete
1. Inside `frontend/` folder, create React app:
   ```bash
   npm create vite@latest . -- --template react
   npm install
   ```
2. Install extras:
   ```bash
   npm install react-router-dom axios
   npm install -D tailwindcss @tailwindcss/vite
   ```
3. Set up Tailwind (follow Vite + Tailwind docs).
4. Create folder structure:
   ```
   frontend/src/
   ├── components/     # Reusable UI pieces (Button, Navbar, Card)
   ├── pages/          # Full pages (Home, Login, Dashboard...)
   ├── services/       # API calls (api.js)
   ├── context/        # Auth state (AuthContext.jsx)
   └── App.jsx
   ```
5. Set up React Router in `App.jsx`:
   - `/` — Home
   - `/login` — Login
   - `/register` — Register
   - `/dashboard` — Dashboard (protected)
   - `/interview/:id` — Interview room (protected)
   - `/results/:id` — Results (protected)
6. Create a simple `Navbar` component with links.
7. Create `services/api.js` — axios instance with base URL `http://localhost:5000/api`.

## Tips
- Get routing working first with placeholder text on each page.
- Use `npm run dev` to see changes live in browser.

## Done when
- [ ] React app runs on localhost (usually port 5173)
- [ ] All routes work and show placeholder pages
- [ ] Tailwind styling works
- [ ] Navbar appears on all pages
- [ ] axios is set up to talk to backend
"@
    }
    @{
        title = "[Frontend] Build Login and Register pages"
        labels = "frontend"
        milestone = $m3
        body = @"
## What is this ticket about?
Build the pages where users **create an account** and **log in**.

## What you will learn
- React forms and controlled inputs
- Calling APIs from frontend
- Storing JWT token (localStorage)
- React Context for global auth state

## Steps to complete
1. Create `context/AuthContext.jsx`:
   - Store: `user`, `token`, `login()`, `logout()`, `register()`
   - On app load, check if token exists in localStorage
2. Create `pages/Register.jsx`:
   - Form fields: name, email, password, confirm password
   - Basic validation (passwords match, email format)
   - On submit: call `POST /api/auth/register`
   - On success: redirect to login
3. Create `pages/Login.jsx`:
   - Form fields: email, password
   - On submit: call `POST /api/auth/login`
   - Save token to localStorage
   - Update AuthContext
   - Redirect to `/dashboard`
4. Create `components/ProtectedRoute.jsx`:
   - If not logged in, redirect to `/login`
   - Wrap dashboard and interview pages with this
5. Add logout button in Navbar.

## Tips
- Show loading spinner while API call is running.
- Show error messages in red below the form (e.g. "Wrong password").
- Disable submit button while loading.

## Done when
- [ ] User can register a new account
- [ ] User can login and see dashboard
- [ ] Token persists after page refresh
- [ ] Protected pages redirect to login if not authenticated
- [ ] User can logout
"@
    }
    @{
        title = "[Frontend] Build Landing page and Dashboard"
        labels = "frontend"
        milestone = $m3
        body = @"
## What is this ticket about?
Build the **home page** (first impression) and **dashboard** (where users manage interviews).

## What you will learn
- Layout and visual design basics
- Fetching data from API and showing lists
- Empty states (what to show when user has no interviews yet)

## Landing page (`pages/Home.jsx`)
Include these sections:
1. **Hero** — Big headline: "Practice interviews with AI" + "Get Started" button
2. **How it works** — 3 steps: Sign up -> Pick role -> Get feedback
3. **Features** — Role-based questions, instant feedback, track progress
4. **Footer** — Your name, GitHub link

## Dashboard (`pages/Dashboard.jsx`)
1. Welcome message with user's name
2. **"Start New Interview"** button (opens a form or modal):
   - Job role (text input or dropdown)
   - Difficulty (easy / medium / hard)
   - On submit: call `POST /api/interviews` and go to interview page
3. **Past interviews table/cards**:
   - Job role, date, status, score
   - Click to view results (if completed) or continue (if in progress)
4. If no interviews yet, show friendly empty state: "No interviews yet. Start your first one!"

## Steps to complete
1. Build Home page with Tailwind — make it look clean and modern.
2. Build Dashboard — fetch `GET /api/interviews` on page load.
3. Wire up "Start New Interview" form to API.
4. Add loading and error states.

## Tips
- Look at [Dribbble](https://dribbble.com) for UI inspiration (search "dashboard").
- Mobile-friendly layout is a nice bonus skill to practice.

## Done when
- [ ] Landing page looks good and links to register/login
- [ ] Dashboard shows user's interview history
- [ ] User can start a new interview from dashboard
- [ ] Clicking an interview navigates to the right page
"@
    }
    @{
        title = "[Frontend] Build Interview Room page"
        labels = "frontend"
        milestone = $m3
        body = @"
## What is this ticket about?
This is the **main feature** — the page where the user actually takes the mock interview.

## What you will learn
- Multi-step UI (question 1 of 5)
- Managing form state across steps
- Real-time API calls and showing AI feedback
- UX patterns for long forms

## Page layout (`pages/InterviewRoom.jsx`)
```
┌─────────────────────────────────────┐
│  Frontend Developer · Medium        │
│  Question 2 of 5          [Timer]   │
├─────────────────────────────────────┤
│                                     │
│  "Explain the difference between    │
│   let and const in JavaScript."     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  Your answer (textarea)     │    │
│  └─────────────────────────────┘    │
│                                     │
│  [Submit Answer]                    │
│                                     │
│  --- After submit ---               │
│  Score: 7/10                        │
│  Feedback: "Good start! You..."     │
│                                     │
│  [Next Question]  or  [Finish]      │
└─────────────────────────────────────┘
```

## Steps to complete
1. Load interview data: `GET /api/interviews/:id`
2. Show current question based on index (track with `useState`)
3. Textarea for answer + Submit button
4. On submit:
   - Call `POST /api/interviews/:id/questions/:questionId/answer`
   - Show score and feedback below
   - Disable editing after submit
5. "Next Question" button moves to next question
6. On last question, show "Finish Interview" button
7. Finish calls `PATCH /api/interviews/:id/finish` and redirects to results
8. Add a simple timer (optional but nice) showing elapsed time

## Tips
- Save which questions are already answered so user can refresh the page safely.
- Show a progress bar (e.g. 2/5 = 40%).

## Done when
- [ ] User sees questions one by one
- [ ] User can type and submit answers
- [ ] Score and feedback show after each answer
- [ ] User can finish and go to results page
- [ ] Progress indicator works
"@
    }
    @{
        title = "[Frontend] Build Results and Feedback page"
        labels = "frontend"
        milestone = $m3
        body = @"
## What is this ticket about?
After finishing an interview, show the user a **clear summary** of how they did and what to improve.

## What you will learn
- Displaying nested data (questions + answers + scores)
- Visual score indicators (progress bars, color coding)
- Making a page portfolio-worthy

## Page sections (`pages/Results.jsx`)
1. **Header** — Job role, date, overall score (big number)
2. **Summary card** — AI strengths, weaknesses, and tips
3. **Question-by-question breakdown**:
   - Question text
   - User's answer
   - Score (color: green > 7, yellow 4-7, red < 4)
   - AI feedback
4. **Actions**:
   - "Back to Dashboard"
   - "Try Another Interview"

## Steps to complete
1. Fetch `GET /api/interviews/:id` (with summary and all Q&A).
2. Build each section with Tailwind cards.
3. Add overall score visual (circle or bar).
4. Make it readable on mobile (stack cards vertically).

## Tips
- This page will be in your portfolio screenshots — make it look polished.
- Use icons (lucide-react or heroicons) for strengths/weaknesses sections.

## Done when
- [ ] Overall score and summary are visible
- [ ] Every question shows with answer, score, and feedback
- [ ] User can navigate back to dashboard
- [ ] Page looks good on desktop and mobile
"@
    }
    @{
        title = "[Testing] Add basic tests for APIs and key flows"
        labels = "testing,backend,frontend"
        milestone = $m5
        body = @"
## What is this ticket about?
Tests help you catch bugs before users do. Start with a few **important tests** — not everything.

## What you will learn
- Why testing matters
- Unit tests vs integration tests
- Jest and Supertest basics

## Backend tests to write
1. Install: `npm install -D jest supertest`
2. Test register:
   - Valid registration returns 201
   - Duplicate email returns 400
3. Test login:
   - Correct password returns token
   - Wrong password returns 401
4. Test interviews:
   - Cannot access interview without token
   - Cannot access another user's interview

## Frontend tests (optional for v1)
1. Install: `npm install -D vitest @testing-library/react`
2. Test: Login form renders email and password fields
3. Test: Submit button is disabled when fields are empty

## Steps to complete
1. Create `backend/tests/auth.test.js`
2. Create `backend/tests/interviews.test.js`
3. Use a separate test database (do not delete real data!)
4. Add `"test": "jest"` to package.json scripts
5. Run `npm test` and make all tests pass.

## Tips
- Testing is a skill — do not worry if it feels hard at first.
- Even 5 good tests are better than zero.

## Done when
- [ ] At least 5 backend tests pass
- [ ] Tests run with `npm test`
- [ ] Test database is separate from development database
"@
    }
    @{
        title = "[Deployment] Put your app online"
        labels = "deployment"
        milestone = $m5
        body = @"
## What is this ticket about?
Deploy your project so anyone can visit it with a real URL. Great for your resume and portfolio!

## What you will learn
- Environment variables in production
- Frontend vs backend hosting
- CORS settings for live URLs

## Recommended free hosting
| Part | Service | Notes |
|------|---------|-------|
| Frontend | [Vercel](https://vercel.com) | Connect GitHub repo, auto deploys |
| Backend | [Render](https://render.com) or [Railway](https://railway.app) | Free tier available |
| Database | [Neon](https://neon.tech) or [Supabase](https://supabase.com) | Already set up from earlier |

## Steps to complete
1. **Database** — Make sure production DATABASE_URL is set on your host.
2. **Backend on Render/Railway**:
   - Connect GitHub repo
   - Set root directory to `backend/`
   - Add env vars: `DATABASE_URL`, `JWT_SECRET`, `OPENAI_API_KEY`
   - Set start command: `node src/index.js`
   - Note your backend URL (e.g. `https://your-app.onrender.com`)
3. **Update CORS** in backend to allow your frontend URL.
4. **Frontend on Vercel**:
   - Connect GitHub repo
   - Set root directory to `frontend/`
   - Add env var: `VITE_API_URL=https://your-app.onrender.com/api`
   - Update `api.js` to use `import.meta.env.VITE_API_URL`
5. Test full flow on live URL: register -> interview -> results.
6. Add live demo link to README.

## Tips
- Free backend hosts "sleep" after inactivity — first request may be slow. That is normal.
- Never put secrets in frontend code. Only `VITE_` public vars go there.

## Done when
- [ ] App is live with a public URL
- [ ] Register, login, interview, and results work online
- [ ] README has live demo link
- [ ] No secrets exposed in GitHub
"@
    }
    @{
        title = "[Bonus] Extra features to level up (after v1)"
        labels = "frontend,backend,ai"
        milestone = $m5
        body = @"
## What is this ticket about?
Once your basic app works, pick **one or two** extras to learn more skills. Do not try all at once!

## Ideas (pick what excites you)

### 1. Resume upload
- User uploads PDF resume
- AI reads it and tailors questions to their experience
- **Learn:** file uploads, PDF parsing

### 2. Interview types
- Add tabs: Technical / Behavioral / System Design
- Different AI prompts for each type
- **Learn:** prompt engineering, conditional logic

### 3. Voice answers
- User speaks answer instead of typing
- Use Web Speech API or Whisper
- **Learn:** browser APIs, audio handling

### 4. Dark mode
- Toggle light/dark theme
- **Learn:** CSS variables, user preferences

### 5. Progress charts
- Show score history over time on dashboard
- **Learn:** charts (Chart.js or Recharts)

### 6. Email reminders
- "You have not practiced this week!"
- **Learn:** cron jobs, email services (Resend, SendGrid)

## Steps to complete
1. Finish all Phase 1-4 tickets first.
2. Pick ONE bonus feature.
3. Create a small plan (what changes in frontend, backend, database).
4. Build it in a new git branch.
5. Merge when it works.

## Done when
- [ ] v1 is fully working
- [ ] You picked and built at least one bonus feature
- [ ] You can explain what you learned to someone else
"@
    }
)

Write-Host "Creating $($issues.Count) issues..." -ForegroundColor Cyan

foreach ($issue in $issues) {
    $bodyFile = [System.IO.Path]::GetTempFileName()
    Set-Content -Path $bodyFile -Value $issue.body -Encoding UTF8

    gh issue create `
        --repo $Repo `
        --title $issue.title `
        --body-file $bodyFile `
        --label $issue.labels `
        --milestone $issue.milestone

    Remove-Item $bodyFile -Force
    Write-Host "Created: $($issue.title)" -ForegroundColor Green
    Start-Sleep -Milliseconds 500
}

Write-Host "`nAll issues created! View them at: https://github.com/$Repo/issues" -ForegroundColor Cyan
