# API Testing Guide (Postman)

Use this document to test all backend APIs for the AI Mock Interview Platform.

**Base URL:** `http://localhost:5000`

**Before testing:** Start the server:
```bash
cd backend
npm run dev
```

---

## Postman collection setup

### 1. Create collection variables

Click your collection → **Variables** tab:

| Variable | Initial value | Current value |
|----------|---------------|---------------|
| `baseUrl` | `http://localhost:5000` | `http://localhost:5000` |
| `token` | *(leave empty)* | paste after login |
| `interviewId` | *(leave empty)* | paste after creating interview |

### 2. Set collection auth (for protected routes)

Collection → **Authorization**:
- Type: **Bearer Token**
- Token: `{{token}}`

For requests that need auth, set Authorization to **Inherit auth from parent**.

### 3. Test order

Run requests **in this order** the first time:

1. Health Check
2. Register
3. Login → copy `token` into collection variable `token`
4. Get Me
5. Start Interview → copy `interview.id` into `interviewId`
6. List Interviews
7. Get Interview by ID
8. Finish Interview

---

## API reference

### 1. Health Check

| | |
|---|---|
| **Method** | `GET` |
| **URL** | `{{baseUrl}}/api/health` |
| **Auth** | No |
| **Body** | None |

**Expected (200):**
```json
{
  "status": "ok",
  "message": "Server is running"
}
```

---

### 2. Register

| | |
|---|---|
| **Method** | `POST` |
| **URL** | `{{baseUrl}}/api/auth/register` |
| **Auth** | No |
| **Body** | raw → JSON |

```json
{
  "name": "Akshat",
  "email": "test@example.com",
  "password": "123456"
}
```

**Expected (201):**
```json
{
  "message": "User registered successfully"
}
```

**Errors:**
- `400` — Email already exists
- `400` — Name, email, and password are required
- `500` — Body missing (set Body → raw → JSON in Postman)

---

### 3. Login

| | |
|---|---|
| **Method** | `POST` |
| **URL** | `{{baseUrl}}/api/auth/login` |
| **Auth** | No |
| **Body** | raw → JSON |

```json
{
  "email": "test@example.com",
  "password": "123456"
}
```

**Expected (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "clx...",
    "name": "Akshat",
    "email": "test@example.com"
  }
}
```

**After login:** Copy `token` → Collection Variables → `token` → Save

---

### 4. Get Current User (Me)

| | |
|---|---|
| **Method** | `GET` |
| **URL** | `{{baseUrl}}/api/auth/me` |
| **Auth** | Bearer `{{token}}` |
| **Body** | None |

**Expected (200):**
```json
{
  "user": {
    "id": "clx...",
    "name": "Akshat",
    "email": "test@example.com",
    "createdAt": "2026-06-23T..."
  }
}
```

**Errors:**
- `401` — No token / invalid token

---

### 5. Start Interview

| | |
|---|---|
| **Method** | `POST` |
| **URL** | `{{baseUrl}}/api/interviews` |
| **Auth** | Bearer `{{token}}` |
| **Body** | raw → JSON |

```json
{
  "jobRole": "Backend Developer",
  "difficulty": "medium"
}
```

**Difficulty options:** `easy`, `medium`, `hard`

**Expected (201):**
```json
{
  "interview": {
    "id": "clx...",
    "userId": "...",
    "jobRole": "Backend Developer",
    "difficulty": "medium",
    "status": "in_progress",
    "startedAt": "...",
    "endedAt": null
  }
}
```

**After create:** Copy `interview.id` → Collection Variables → `interviewId` → Save

---

### 6. List My Interviews

| | |
|---|---|
| **Method** | `GET` |
| **URL** | `{{baseUrl}}/api/interviews` |
| **Auth** | Bearer `{{token}}` |
| **Body** | None |

**Expected (200):**
```json
{
  "interviews": [
    {
      "id": "clx...",
      "jobRole": "Backend Developer",
      "difficulty": "medium",
      "status": "in_progress",
      "startedAt": "...",
      "endedAt": null,
      "score": null
    }
  ]
}
```

---

### 7. Get Interview by ID

| | |
|---|---|
| **Method** | `GET` |
| **URL** | `{{baseUrl}}/api/interviews/{{interviewId}}` |
| **Auth** | Bearer `{{token}}` |
| **Body** | None |

**Expected (200):**
```json
{
  "interview": {
    "id": "clx...",
    "jobRole": "Backend Developer",
    "difficulty": "medium",
    "status": "in_progress",
    "questions": [],
    "summary": null
  }
}
```

**Errors:**
- `404` — Interview not found
- `403` — Not your interview

---

### 8. Finish Interview

| | |
|---|---|
| **Method** | `PATCH` |
| **URL** | `{{baseUrl}}/api/interviews/{{interviewId}}/finish` |
| **Auth** | Bearer `{{token}}` |
| **Body** | None |

**Expected (200):**
```json
{
  "interview": {
    "id": "clx...",
    "status": "completed",
    "endedAt": "..."
  }
}
```

**Errors:**
- `400` — Interview already completed
- `404` — Interview not found
- `403` — Not your interview

---

## Postman checklist

Use this when testing your collection:

- [ ] Server running (`npm run dev`)
- [ ] Health returns 200
- [ ] Register works (or skip if user exists)
- [ ] Login returns token
- [ ] Token saved in collection variable
- [ ] `/api/auth/me` returns your user
- [ ] POST interview returns interview id
- [ ] `interviewId` saved in collection variable
- [ ] List shows your interviews
- [ ] Get by id returns full interview
- [ ] Finish sets status to `completed`
- [ ] List again shows `status: "completed"`

---

## Common Postman mistakes

| Problem | Fix |
|---------|-----|
| `req.body` undefined / 500 on POST | Body → **raw** → **JSON** (not none) |
| `401 No token` | Set Bearer token in Authorization |
| `Cannot POST /api/...` | Restart server after code changes |
| Token not working | Login again, paste fresh full token |
| Wrong interview id | Use id from create/list response |

---

## Import ready-made collection

Import this file into Postman:

**File:** `docs/Mock-Interview-API.postman_collection.json`

1. Postman → **Import**
2. Select the JSON file
3. Set `token` and `interviewId` variables after login and create

---

## PowerShell quick test (alternative)

```powershell
# Login
$token = (Invoke-RestMethod -Uri "http://localhost:5000/api/auth/login" -Method POST -ContentType "application/json" -Body '{"email":"test@example.com","password":"123456"}').token

$headers = @{ Authorization = "Bearer $token" }

# Me
Invoke-RestMethod "http://localhost:5000/api/auth/me" -Headers $headers

# Start interview
$r = Invoke-RestMethod "http://localhost:5000/api/interviews" -Method POST -ContentType "application/json" -Headers $headers -Body '{"jobRole":"Backend Developer","difficulty":"medium"}'

# List
Invoke-RestMethod "http://localhost:5000/api/interviews" -Headers $headers

# Get one
Invoke-RestMethod "http://localhost:5000/api/interviews/$($r.interview.id)" -Headers $headers

# Finish
Invoke-RestMethod "http://localhost:5000/api/interviews/$($r.interview.id)/finish" -Method PATCH -Headers $headers
```
