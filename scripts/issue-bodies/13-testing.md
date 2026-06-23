## What is this ticket about?
Tests help you catch bugs before users do. Start with a few **important tests** — not everything.

## What you will learn
- Why testing matters
- Unit tests vs integration tests
- Jest and Supertest basics

## Backend tests to write
1. Install: `npm install -D jest supertest`
2. Test register:
   - Valid registration returns 201
   - Duplicate email returns 400
3. Test login:
   - Correct password returns token
   - Wrong password returns 401
4. Test interviews:
   - Cannot access interview without token
   - Cannot access another user's interview

## Frontend tests (optional for v1)
1. Install: `npm install -D vitest @testing-library/react`
2. Test: Login form renders email and password fields
3. Test: Submit button is disabled when fields are empty

## Steps to complete
1. Create `backend/tests/auth.test.js`
2. Create `backend/tests/interviews.test.js`
3. Use a separate test database (do not delete real data!)
4. Add `"test": "jest"` to package.json scripts
5. Run `npm test` and make all tests pass.

## Tips
- Testing is a skill — do not worry if it feels hard at first.
- Even 5 good tests are better than zero.

## Done when
- [ ] At least 5 backend tests pass
- [ ] Tests run with `npm test`
- [ ] Test database is separate from development database
