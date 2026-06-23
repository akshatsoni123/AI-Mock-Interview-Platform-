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
