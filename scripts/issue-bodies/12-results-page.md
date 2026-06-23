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
