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
