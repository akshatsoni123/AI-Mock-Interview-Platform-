import OpenAI from "openai";

const groq = new OpenAI({
  apiKey: process.env.GROQ_API_KEY,
  baseURL: "https://api.groq.com/openai/v1",
});

const MODEL = "llama-3.3-70b-versatile";

function cleanJsonText(text) {
  return text.replace(/```json|```/g, "").trim();
}

function parseJsonObject(text) {
  return JSON.parse(cleanJsonText(text));
}

async function askGroq(prompt, maxTokens = 800) {
  const response = await groq.chat.completions.create({
    model: MODEL,
    messages: [{ role: "user", content: prompt }],
    max_tokens: maxTokens,
    temperature: 0.5,
  });
  return response.choices[0].message.content.trim();
}

function parseQuestionsJson(text) {
  const questions = JSON.parse(cleanJsonText(text));

  if (!Array.isArray(questions) || questions.length === 0) {
    throw new Error("AI returned invalid questions format");
  }

  return questions.map((q) => ({
    question: q.question,
    topic: q.topic ?? "general",
  }));
}

function getFallbackQuestions(jobRole, difficulty, count) {
  const pool = [
    {
      question: `What motivated you to pursue a role as a ${jobRole}?`,
      topic: "motivation",
    },
    {
      question: `Explain a key skill required for a ${jobRole} at ${difficulty} level.`,
      topic: "technical",
    },
    {
      question: `Describe a project that best demonstrates your fit for a ${jobRole} role.`,
      topic: "experience",
    },
    {
      question: `How do you approach learning new tools or technologies for ${jobRole} work?`,
      topic: "learning",
    },
    {
      question: `What is a common challenge in ${jobRole} roles and how would you handle it?`,
      topic: "problem-solving",
    },
  ];

  return pool.slice(0, count);
}

export async function generateQuestions(jobRole, difficulty, count = 3) {
  if (!process.env.GROQ_API_KEY) {
    const err = new Error("GROQ_API_KEY is not configured");
    err.code = "CONFIG_ERROR";
    throw err;
  }

  const prompt = `You are a technical interviewer. Generate ${count} interview questions for a ${jobRole} position at ${difficulty} difficulty level.

Return ONLY a valid JSON array with no markdown, no code fences, no extra text.
Format: [{"question": "...", "topic": "..."}]`;

  try {
    const response = await groq.chat.completions.create({
      model: MODEL,
      messages: [{ role: "user", content: prompt }],
      max_tokens: 1000,
      temperature: 0.7,
    });

    const text = response.choices[0].message.content.trim();
    return { questions: parseQuestionsJson(text), source: "groq" };
  } catch (error) {
    const status = error.status ?? error?.response?.status;
    console.warn("Groq API failed:", status ?? error.message);

    if ([429, 503].includes(status)) {
      return {
        questions: getFallbackQuestions(jobRole, difficulty, count),
        source: "fallback",
        warning:
          "Groq rate limit or service unavailable. Using built-in questions for now.",
      };
    }

    throw error;
  }
}

export async function evaluateAnswer(question, userAnswer, jobRole) {
  if (!process.env.GROQ_API_KEY) {
    const err = new Error("GROQ_API_KEY is not configured");
    err.code = "CONFIG_ERROR";
    throw err;
  }

  const prompt = `You are an interviewer for a ${jobRole} role.
Question: ${question}
Candidate answer: ${userAnswer}

Rate the answer from 1 to 10 and give 2-3 sentences of constructive, encouraging feedback.
Return ONLY valid JSON: {"score": number, "feedback": "string"}`;

  const text = await askGroq(prompt);
  const result = parseJsonObject(text);

  return {
    score: Math.min(10, Math.max(1, Math.round(Number(result.score)))),
    feedback: result.feedback,
  };
}

export async function generateInterviewSummary(jobRole, questionsWithAnswers) {
  if (!process.env.GROQ_API_KEY) {
    const err = new Error("GROQ_API_KEY is not configured");
    err.code = "CONFIG_ERROR";
    throw err;
  }

  const qaBlock = questionsWithAnswers
    .map(
      (q, i) =>
        `Q${i + 1}: ${q.questionText}\nAnswer: ${q.answer?.answerText ?? "(no answer)"}\nScore: ${q.answer?.score ?? "N/A"}/10`
    )
    .join("\n\n");

  const prompt = `You are an interview coach. Review this ${jobRole} mock interview:

${qaBlock}

Return ONLY valid JSON with no markdown:
{
  "overallScore": number,
  "strengths": "2-3 sentences about what went well",
  "weaknesses": "2-3 sentences about areas to improve",
  "tips": "2-3 actionable tips for next time"
}

overallScore should be 1-10 reflecting overall performance.`;

  const text = await askGroq(prompt, 1000);
  const result = parseJsonObject(text);

  return {
    overallScore: Math.min(10, Math.max(1, Number(result.overallScore))),
    strengths: result.strengths,
    weaknesses: result.weaknesses,
    tips: result.tips,
  };
}
