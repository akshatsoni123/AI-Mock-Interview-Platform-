## What is this ticket about?
Build the pages where users **create an account** and **log in**.

## What you will learn
- React forms and controlled inputs
- Calling APIs from frontend
- Storing JWT token (localStorage)
- React Context for global auth state

## Steps to complete
1. Create `context/AuthContext.jsx`:
   - Store: `user`, `token`, `login()`, `logout()`, `register()`
   - On app load, check if token exists in localStorage
2. Create `pages/Register.jsx`:
   - Form fields: name, email, password, confirm password
   - Basic validation (passwords match, email format)
   - On submit: call `POST /api/auth/register`
   - On success: redirect to login
3. Create `pages/Login.jsx`:
   - Form fields: email, password
   - On submit: call `POST /api/auth/login`
   - Save token to localStorage
   - Update AuthContext
   - Redirect to `/dashboard`
4. Create `components/ProtectedRoute.jsx`:
   - If not logged in, redirect to `/login`
   - Wrap dashboard and interview pages with this
5. Add logout button in Navbar.

## Tips
- Show loading spinner while API call is running.
- Show error messages in red below the form (e.g. "Wrong password").
- Disable submit button while loading.

## Done when
- [ ] User can register a new account
- [ ] User can login and see dashboard
- [ ] Token persists after page refresh
- [ ] Protected pages redirect to login if not authenticated
- [ ] User can logout
