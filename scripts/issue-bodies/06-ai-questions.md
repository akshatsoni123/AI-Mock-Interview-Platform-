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
