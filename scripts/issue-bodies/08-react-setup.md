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
