## What is this ticket about?
This is the **main feature** — the page where the user actually takes the mock interview.

## What you will learn
- Multi-step UI (question 1 of 5)
- Managing form state across steps
- Real-time API calls and showing AI feedback
- UX patterns for long forms

## Page layout (`pages/InterviewRoom.jsx`)
```
┌─────────────────────────────────────┐
│  Frontend Developer · Medium        │
│  Question 2 of 5          [Timer]   │
├─────────────────────────────────────┤
│                                     │
│  "Explain the difference between    │
│   let and const in JavaScript."     │
│                                     │
│  ┌─────────────────────────────┐    │
│  │  Your answer (textarea)     │    │
│  └─────────────────────────────┘    │
│                                     │
│  [Submit Answer]                    │
│                                     │
│  --- After submit ---               │
│  Score: 7/10                        │
│  Feedback: "Good start! You..."     │
│                                     │
│  [Next Question]  or  [Finish]      │
└─────────────────────────────────────┘
```

## Steps to complete
1. Load interview data: `GET /api/interviews/:id`
2. Show current question based on index (track with `useState`)
3. Textarea for answer + Submit button
4. On submit:
   - Call `POST /api/interviews/:id/questions/:questionId/answer`
   - Show score and feedback below
   - Disable editing after submit
5. "Next Question" button moves to next question
6. On last question, show "Finish Interview" button
7. Finish calls `PATCH /api/interviews/:id/finish` and redirects to results
8. Add a simple timer (optional but nice) showing elapsed time

## Tips
- Save which questions are already answered so user can refresh the page safely.
- Show a progress bar (e.g. 2/5 = 40%).

## Done when
- [ ] User sees questions one by one
- [ ] User can type and submit answers
- [ ] Score and feedback show after each answer
- [ ] User can finish and go to results page
- [ ] Progress indicator works
