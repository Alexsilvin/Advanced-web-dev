const express = require('express');
const router = express.Router();
const Enrollment = require('../models/Enrollment');
const Course = require('../models/Course');
const { auth } = require('../middleware/auth');

// POST /api/enrollments/enroll/:courseId
router.post('/enroll/:courseId', auth, async (req, res, next) => {
  try {
    const course = await Course.findById(req.params.courseId);
    if (!course) return res.status(404).json({ message: 'Course not found' });

    const existing = await Enrollment.findOne({
      userId: req.user.id,
      courseId: req.params.courseId,
    });
    if (existing) return res.status(400).json({ message: 'Already enrolled in this course' });

    const enrollment = await Enrollment.create({
      userId: req.user.id,
      courseId: req.params.courseId,
    });

    await Course.incrementStudents(req.params.courseId);

    res.status(201).json({ success: true, enrollment });
  } catch (error) {
    if (error.code === 'DUPLICATE_ENROLLMENT') {
      return res.status(400).json({ message: 'Already enrolled in this course' });
    }
    next(error);
  }
});

// GET /api/enrollments/my-courses
router.get('/my-courses', auth, async (req, res, next) => {
  try {
    const enrollments = await Enrollment.findByUser(req.user.id);
    res.json({ success: true, enrollments });
  } catch (error) {
    next(error);
  }
});

// PUT /api/enrollments/progress/:courseId
router.put('/progress/:courseId', auth, async (req, res, next) => {
  try {
    const { progress, completedLessons } = req.body;

    const existing = await Enrollment.findOne({
      userId: req.user.id,
      courseId: req.params.courseId,
    });
    if (!existing) return res.status(404).json({ message: 'Enrollment not found' });

    let computedProgress = progress;
    if (completedLessons !== undefined) {
      const course = await Course.findById(req.params.courseId);
      if (course && course.lessons && course.lessons.length > 0) {
        computedProgress = Math.round((completedLessons.length / course.lessons.length) * 100);
      }
    }

    const enrollment = await Enrollment.updateProgress(
      req.user.id,
      req.params.courseId,
      {
        progress: computedProgress !== undefined ? Math.min(100, Math.max(0, computedProgress)) : undefined,
        completedLessons,
      }
    );

    res.json({ success: true, enrollment });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
