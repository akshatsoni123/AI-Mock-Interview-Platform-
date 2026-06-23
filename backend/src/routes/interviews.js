import { Router } from "express";
import prisma from "../lib/prisma.js";
import { authMiddleware } from "../middleware/authMiddleware.js";

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
        userId: req.user.id,      // from authMiddleware
        jobRole,
        difficulty,
        status: "in_progress",  // default in schema too
      },
    });

    return res.status(201).json({ interview });
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

    const updated = await prisma.interview.update({
      where: { id: req.params.id },
      data: {
        status: "completed",
        endedAt: new Date(),
      },
    });

    return res.json({ interview: updated });
  } catch (error) {
    console.error("Finish interview error:", error);
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