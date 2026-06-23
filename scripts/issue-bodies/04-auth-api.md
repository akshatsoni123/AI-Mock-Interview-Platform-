## What is this ticket about?
Users need accounts so their interview history is saved. Build **sign up** and **log in** APIs.

## What you will learn
- REST API basics (POST requests, JSON body)
- Password hashing with bcrypt (never store plain passwords!)
- JWT tokens (a secure "ticket" that proves user is logged in)
- Middleware (code that runs before your route handler)

## Steps to complete
1. In `backend/`, install packages:
   ```bash
   npm install express cors dotenv bcryptjs jsonwebtoken
   npm install -D nodemon
   ```
2. Create `src/index.js` (or `server.js`) — basic Express server on port 5000.
3. Create `POST /api/auth/register`:
   - Accept: `name`, `email`, `password`
   - Check if email already exists
   - Hash password with bcrypt
   - Save user to database
   - Return success message (do not return password!)
4. Create `POST /api/auth/login`:
   - Accept: `email`, `password`
   - Find user by email
   - Compare password with bcrypt
   - If correct, create JWT token with user id inside
   - Return token + basic user info
5. Create `authMiddleware` function:
   - Read `Authorization: Bearer <token>` header
   - Verify JWT
   - Attach user to request so protected routes can use it
6. Create `GET /api/auth/me` (protected):
   - Return current logged-in user's info
7. Test all routes with Postman or Thunder Client (VS Code extension).

## Tips
- Return clear error messages: "Email already exists", "Wrong password"
- Use `HTTP 400` for bad input, `401` for wrong login, `201` for created

## Done when
- [ ] User can register with email and password
- [ ] User can login and get a JWT token
- [ ] Protected route works only with valid token
- [ ] Passwords are hashed in database
- [ ] You tested with Postman/Thunder Client
