# AI Mock Interview Platform

A personal learning project where you can practice job interviews with AI. Pick a job role, answer interview questions, and get instant feedback and scores to improve over time.

Built step-by-step to learn full-stack web development — from database and APIs to React UI and OpenAI integration.

## Tech Stack

| Part | Tool | Why |
|------|------|-----|
| Frontend | React + Vite | Popular, lots of tutorials |
| Styling | Tailwind CSS | Fast to build nice UI |
| Backend | Node.js + Express | Same language as frontend (JavaScript) |
| Database | PostgreSQL + Prisma | Prisma makes database work easier |
| AI | OpenAI API | Easy to start with chat/completions |
| Auth | JWT + bcrypt | Standard way to handle login |

## Project Structure

```
AI-Mock-Interview-Platform-/
├── frontend/          # React app
├── backend/           # Express API
├── docs/              # Plans and notes
├── .gitignore
└── README.md
```

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or newer)
- [Git](https://git-scm.com/)
- PostgreSQL (local) or a free cloud database ([Neon](https://neon.tech) / [Supabase](https://supabase.com))

### Backend

```bash
cd backend
cp .env.example .env    # then fill in your real values
npm install             # coming in a later step
npm run dev             # coming in a later step
```

### Frontend

```bash
cd frontend
cp .env.example .env
npm install             # coming in a later step
npm run dev             # coming in a later step
```

> Run instructions will be updated as each part of the app is built.

## Screenshots

<!-- Add screenshots here once the app is running -->

| Landing Page | Dashboard | Interview Room | Results |
|--------------|-----------|----------------|---------|
| _Coming soon_ | _Coming soon_ | _Coming soon_ | _Coming soon_ |

## License

Personal learning project — free to use and modify.
