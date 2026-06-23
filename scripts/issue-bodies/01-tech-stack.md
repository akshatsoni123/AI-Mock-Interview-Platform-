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
