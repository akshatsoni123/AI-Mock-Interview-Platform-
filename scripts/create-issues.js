const { execSync } = require("child_process");
const fs = require("fs");
const path = require("path");

const REPO = "akshatsoni123/AI-Mock-Interview-Platform-";
const issuesDir = path.join(__dirname, "issue-bodies");

// Skip issue 1 (tech stack) — already created as #2 with stub; we'll update it
const issues = [
  { file: "01-tech-stack.md", title: "[Setup] Choose your tech stack and draw a simple plan", labels: "setup", milestone: "Phase 1 - Setup", update: 2 },
  { file: "02-folder-structure.md", title: "[Setup] Create project folder structure and README", labels: "setup", milestone: "Phase 1 - Setup" },
  { file: "03-database.md", title: "[Database] Design tables and set up Prisma", labels: "database,backend", milestone: "Phase 2 - Backend" },
  { file: "04-auth-api.md", title: "[Backend] Build user registration and login APIs", labels: "backend", milestone: "Phase 2 - Backend" },
  { file: "05-interview-api.md", title: "[Backend] Build interview session APIs", labels: "backend", milestone: "Phase 2 - Backend" },
  { file: "06-ai-questions.md", title: "[AI] Connect OpenAI and generate interview questions", labels: "ai,backend", milestone: "Phase 4 - AI Features" },
  { file: "07-ai-feedback.md", title: "[AI] Evaluate answers and generate feedback", labels: "ai,backend", milestone: "Phase 4 - AI Features" },
  { file: "08-react-setup.md", title: "[Frontend] Set up React app with routing and Tailwind", labels: "frontend,setup", milestone: "Phase 3 - Frontend" },
  { file: "09-auth-pages.md", title: "[Frontend] Build Login and Register pages", labels: "frontend", milestone: "Phase 3 - Frontend" },
  { file: "10-landing-dashboard.md", title: "[Frontend] Build Landing page and Dashboard", labels: "frontend", milestone: "Phase 3 - Frontend" },
  { file: "11-interview-room.md", title: "[Frontend] Build Interview Room page", labels: "frontend", milestone: "Phase 3 - Frontend" },
  { file: "12-results-page.md", title: "[Frontend] Build Results and Feedback page", labels: "frontend", milestone: "Phase 3 - Frontend" },
  { file: "13-testing.md", title: "[Testing] Add basic tests for APIs and key flows", labels: "testing,backend,frontend", milestone: "Phase 5 - Polish and Launch" },
  { file: "14-deployment.md", title: "[Deployment] Put your app online", labels: "deployment", milestone: "Phase 5 - Polish and Launch" },
  { file: "15-bonus.md", title: "[Bonus] Extra features to level up (after v1)", labels: "frontend,backend,ai", milestone: "Phase 5 - Polish and Launch" },
];

function run(cmd) {
  console.log(cmd);
  execSync(cmd, { stdio: "inherit", shell: true });
}

for (const issue of issues) {
  const bodyPath = path.join(issuesDir, issue.file);
  if (!fs.existsSync(bodyPath)) {
    console.error(`Missing: ${bodyPath}`);
    process.exit(1);
  }

  if (issue.update) {
    run(`gh issue edit ${issue.update} --repo ${REPO} --title "${issue.title}" --body-file "${bodyPath}" --milestone "${issue.milestone}" --add-label "${issue.labels}"`);
  } else {
    run(`gh issue create --repo ${REPO} --title "${issue.title}" --body-file "${bodyPath}" --label "${issue.labels}" --milestone "${issue.milestone}"`);
  }
}

console.log("\nDone! https://github.com/" + REPO + "/issues");
