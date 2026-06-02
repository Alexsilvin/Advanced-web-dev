const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const User = require('../models/User');
const Enrollment = require('../models/Enrollment');
const { auth } = require('../middleware/auth');

// GET /api/users/profile
router.get('/profile', auth, async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });

    const enrollmentCount = await Enrollment.countByUser(req.user.id);

    res.json({
      success: true,
      user,
      stats: {
        enrolledCourses: enrollmentCount,
        hoursLearned: enrollmentCount * 8,
        certificates: Math.floor(enrollmentCount * 0.4),
      },
    });
  } catch (error) {
    next(error);
  }
});

// PUT /api/users/profile
router.put(
  '/profile',
  auth,
  [
    body('name').optional().trim().isLength({ min: 2 }).withMessage('Name must be at least 2 characters'),
    body('bio').optional().isLength({ max: 500 }).withMessage('Bio cannot exceed 500 characters'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }

      const allowed = ['name', 'bio', 'avatar'];
      const updates = {};
      allowed.forEach((f) => { if (req.body[f] !== undefined) updates[f] = req.body[f]; });

      const user = await User.findByIdAndUpdate(req.user.id, updates);
      res.json({ success: true, user });
    } catch (error) {
      next(error);
    }
  }
);

// GET /api/users/activity
router.get('/activity', auth, async (req, res, next) => {
  try {
    const enrollmentCount = await Enrollment.countByUser(req.user.id);
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const currentMonth = new Date().getMonth();

    const activityData = months.map((month, index) => {
      if (index > currentMonth || enrollmentCount === 0) {
        return { month, hours: 0, videoHours: 0, practiceHours: 0, readingHours: 0 };
      }
      const videoHours = Math.floor(Math.random() * 4) + 1 + Math.floor(Math.random() * 3);
      const practiceHours = Math.floor(Math.random() * 3);
      const readingHours = Math.floor(Math.random() * 2);
      return { month, hours: videoHours + practiceHours + readingHours, videoHours, practiceHours, readingHours };
    });

    const totalHours = activityData.reduce((sum, d) => sum + d.hours, 0);
    const avgHours = enrollmentCount > 0
      ? (totalHours / Math.max(currentMonth + 1, 1)).toFixed(1)
      : 0;

    res.json({
      success: true,
      activityData,
      summary: {
        totalHours,
        avgMonthlyHours: parseFloat(avgHours),
        bestMonth: activityData.reduce((best, d) => (d.hours > best.hours ? d : best), activityData[0]),
      },
    });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
