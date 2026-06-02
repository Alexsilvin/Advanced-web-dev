const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const Course = require('../models/Course');
const { auth, requireRole } = require('../middleware/auth');

// GET /api/courses/featured
router.get('/featured', async (req, res, next) => {
  try {
    const courses = await Course.findFeatured(4);
    res.json({ success: true, courses });
  } catch (error) {
    next(error);
  }
});

// GET /api/courses
router.get('/', async (req, res, next) => {
  try {
    const { category, search, page = 1, limit = 12 } = req.query;
    const pg = parseInt(page);
    const lm = parseInt(limit);

    const total = await Course.count({ category, search });
    const { courses } = await Course.find(
      { category, search },
      { page: pg, limit: lm }
    );

    res.json({
      success: true,
      courses,
      pagination: {
        total,
        page: pg,
        limit: lm,
        pages: Math.ceil(total / lm),
      },
    });
  } catch (error) {
    next(error);
  }
});

// GET /api/courses/:id  — must come after /featured
router.get('/:id', async (req, res, next) => {
  try {
    const course = await Course.findById(req.params.id);
    if (!course) return res.status(404).json({ message: 'Course not found' });
    res.json({ success: true, course });
  } catch (error) {
    next(error);
  }
});

// POST /api/courses
router.post(
  '/',
  auth,
  requireRole('instructor', 'admin'),
  [
    body('title').trim().notEmpty().withMessage('Title is required'),
    body('description').trim().notEmpty().withMessage('Description is required'),
    body('category').notEmpty().withMessage('Category is required'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }
      const course = await Course.create({ ...req.body, instructorId: req.user.id });
      res.status(201).json({ success: true, course });
    } catch (error) {
      next(error);
    }
  }
);

// PUT /api/courses/:id
router.put('/:id', auth, async (req, res, next) => {
  try {
    const course = await Course.findById(req.params.id);
    if (!course) return res.status(404).json({ message: 'Course not found' });

    const isOwner = course.instructorId === req.user.id;
    const isAdmin = req.user.role === 'admin';
    if (!isOwner && !isAdmin) {
      return res.status(403).json({ message: 'Not authorized to update this course' });
    }

    const updated = await Course.findByIdAndUpdate(req.params.id, req.body);
    res.json({ success: true, course: updated });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
