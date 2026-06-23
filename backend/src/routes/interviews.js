import { Router } from "express";
import prisma from "../lib/prisma.js";
import { authMiddleware } from "../middleware/authMiddleware.js";
import {
  generateQuestions,
  evaluateAnswer,
  generateInterviewSummary,
} from "../services/aiService.js";

const router = Router();

// All interview routes need login
router.use(authMiddleware);

router.post("/", async (req, res) => {
  try {
    const { jobRole, difficulty } = req.body;

    if (!jobRole || !difficulty) {
      return res.status(400).json({ message: "jobRole and difficulty are required" });
    }

    const interview = await prisma.interview.create({
      data: {
        userId: req.user.id,
        jobRole,
        difficulty,
        status: "in_progress",
      },
    });

    let aiResult;
    try {
      aiResult = await generateQuestions(jobRole, difficulty, 3);
    } catch (aiError) {
      console.error("AI question generation error:", aiError);
      await prisma.interview.delete({ where: { id: interview.id } });

      if (aiError.status === 429) {
        return res.status(429).json({
          message:
            "Groq rate limit reached. Wait a moment and try again.",
        });
      }

      if (aiError.code === "CONFIG_ERROR") {
        return res.status(500).json({
          message: "AI is not configured. Add GROQ_API_KEY to backend/.env",
        });
      }

      return res.status(503).json({
        message: "Could not generate interview questions. Please try again.",
      });
    }

    const questions = await Promise.all(
      aiResult.questions.map((q, index) =>
        prisma.question.create({
          data: {
            interviewId: interview.id,
            questionText: q.question,
            order: index + 1,
          },
        })
      )
    );

    return res.status(201).json({
      interview,
      questions,
      ...(aiResult.warning && { warning: aiResult.warning }),
      source: aiResult.source,
    });
  } catch (error) {
    console.error("Create interview error:", error);
    return res.status(500).json({ message: "Something went wrong" });
  }
});

router.get("/", async (req, res) => {
  try {
    const interviews = await prisma.interview.findMany({
      where: { userId: req.user.id },
      orderBy: { startedAt: "desc" },
      include: {
        summary: {
          select: { overallScore: true },
        },
      },
    });

    const result = interviews.map((interview) => ({
      id: interview.id,
      jobRole: interview.jobRole,
      difficulty: interview.difficulty,
      status: interview.status,
      startedAt: interview.startedAt,
      endedAt: interview.endedAt,
      score: interview.summary?.overallScore ?? null,
    }));

    return res.json({ interviews: result });
  } catch (error) {
    console.error("List interviews error:", error);
    return res.status(500).json({ message: "Something went wrong" });
  }
});

router.patch("/:id/finish", async (req, res) => {
  try {
    const interview = await prisma.interview.findUnique({
      where: { id: req.params.id },
      include: {
        questions: {
          orderBy: { order: "asc" },
          include: { answer: true },
        },
        summary: true,
      },
    });

    if (!interview) {
      return res.status(404).json({ message: "Interview not found" });
    }

    if (interview.userId !== req.user.id) {
      return res.status(403).json({ message: "Not allowed to access this interview" });
    }

    if (interview.status === "completed") {
      return res.status(400).json({ message: "Interview already completed" });
    }

    const unanswered = interview.questions.filter((q) => !q.answer);
    if (unanswered.length > 0) {
      return res.status(400).json({
        message: `Please answer all questions before finishing (${unanswered.length} remaining)`,
      });
    }

    let summaryRecord = interview.summary;

    if (!summaryRecord) {
      try {
        const summaryData = await generateInterviewSummary(
          interview.jobRole,
          interview.questions
        );

        summaryRecord = await prisma.interviewSummary.create({
          data: {
            interviewId: interview.id,
            overallScore: summaryData.overallScore,
            strengths: summaryData.strengths,
            weaknesses: summaryData.weaknesses,
            tips: summaryData.tips,
          },
        });
      } catch (aiError) {
        console.error("AI summary generation error:", aiError);
        return res.status(503).json({
          message: "Could not generate interview summary. Please try again.",
        });
      }
    }

    const updated = await prisma.interview.update({
      where: { id: req.params.id },
      data: {
        status: "completed",
        endedAt: new Date(),
      },
      include: {
        questions: {
          orderBy: { order: "asc" },
          include: { answer: true },
        },
        summary: true,
      },
    });

    return res.json({ interview: updated });
  } catch (error) {
    console.error("Finish interview error:", error);
    return res.status(500).json({ message: "Something went wrong" });
  }
});

router.post("/:id/questions/:questionId/answer", async (req, res) => {
  try {
    const { answerText } = req.body;

    if (!answerText?.trim()) {
      return res.status(400).json({ message: "answerText is required" });
    }

    const interview = await prisma.interview.findUnique({
      where: { id: req.params.id },
      include: {
        questions: { include: { answer: true } },
      },
    });

    if (!interview) {
      return res.status(404).json({ message: "Interview not found" });
    }

    if (interview.userId !== req.user.id) {
      return res.status(403).json({ message: "Not allowed to access this interview" });
    }

    if (interview.status === "completed") {
      return res.status(400).json({ message: "Interview already completed" });
    }

    const question = interview.questions.find((q) => q.id === req.params.questionId);

    if (!question) {
      return res.status(404).json({ message: "Question not found" });
    }

    if (question.answer) {
      return res.status(400).json({ message: "Question already answered" });
    }

    let score;
    let feedback;

    try {
      const evaluation = await evaluateAnswer(
        question.questionText,
        answerText.trim(),
        interview.jobRole
      );
      score = evaluation.score;
      feedback = evaluation.feedback;
    } catch (aiError) {
      console.error("AI answer evaluation error:", aiError);

      if (aiError.status === 429) {
        return res.status(429).json({
          message: "Groq rate limit reached. Wait a moment and try again.",
        });
      }

      return res.status(503).json({
        message: "Could not evaluate answer. Please try again.",
      });
    }

    const answer = await prisma.answer.create({
      data: {
        questionId: question.id,
        answerText: answerText.trim(),
        score,
        feedback,
      },
    });

    return res.json({ score, feedback, answer });
  } catch (error) {
    console.error("Submit answer error:", error);
    return res.status(500).json({ message: "Something went wrong" });
  }
});

router.get("/:id", async (req, res) => {
  try {
    const interview = await prisma.interview.findUnique({
      where: { id: req.params.id },
      include: {
        questions: {
          orderBy: { order: "asc" },
          include: { answer: true },
        },
        summary: true,
      },
    });

    if (!interview) {
      return res.status(404).json({ message: "Interview not found" });
    }

    if (interview.userId !== req.user.id) {
      return res.status(403).json({ message: "Not allowed to access this interview" });
    }

    return res.json({ interview });
  } catch (error) {
    console.error("Get interview error:", error);
    return res.status(500).json({ message: "Something went wrong" });
  }
});

export default router;