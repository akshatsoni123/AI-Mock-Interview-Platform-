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
