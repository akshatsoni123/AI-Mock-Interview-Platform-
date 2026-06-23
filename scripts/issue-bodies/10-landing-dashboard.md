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
