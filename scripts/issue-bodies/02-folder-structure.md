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
