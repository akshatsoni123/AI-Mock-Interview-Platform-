## What is this ticket about?
These APIs let a logged-in user **start**, **continue**, and **finish** a mock interview.

## What you will learn
- CRUD operations (Create, Read, Update)
- Protected routes (only logged-in user can access their interviews)
- RESTful URL design

## API routes to build
### 1. `POST /api/interviews` — Start new interview
**Body:** `{ "jobRole": "Backend Developer", "difficulty": "medium" }`
**Does:**
- Create new Interview row linked to logged-in user
- Set status = `in_progress`
- Return interview id and details

### 2. `GET /api/interviews` — List my interviews
**Does:**
- Return all interviews for logged-in user
- Show job role, status, date, score (if completed)

### 3. `GET /api/interviews/:id` — Get one interview
**Does:**
- Return interview with all questions and answers
- Make sure this interview belongs to the logged-in user (security!)

### 4. `PATCH /api/interviews/:id/finish` — End interview
**Does:**
- Set status = `completed`, set `endedAt` time
- (AI summary will be added in a later ticket)

## Steps to complete
1. Create `routes/interviews.js` and connect to Express app.
2. Add `authMiddleware` to all interview routes.
3. Implement each route one by one.
4. Always check: `interview.userId === req.user.id` before returning data.
5. Test with Postman using a real JWT token from login.

## Tips
- Build and test one route at a time. Do not try to build all at once.
- Use good status codes: 201 for created, 404 if interview not found, 403 if not your interview.

## Done when
- [ ] User can start a new interview
- [ ] User can see list of past interviews
- [ ] User can open one interview by id
- [ ] User can mark interview as finished
- [ ] Users cannot access other users' interviews
