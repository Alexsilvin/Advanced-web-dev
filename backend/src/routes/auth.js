const express = require('express');
const router = express.Router();
const { body, validationResult } = require('express-validator');
const jwt = require('jsonwebtoken');
const User = require('../models/User');
const supabase = require('../config/supabase');
const { auth } = require('../middleware/auth');

const generateToken = (user) => {
  return jwt.sign(
    { id: user.id, email: user.email, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: '7d' }
  );
};

const safeUser = (u) => ({
  id: u.id,
  _id: u.id,
  name: u.name,
  email: u.email,
  role: u.role,
  avatar: u.avatar,
  bio: u.bio,
  createdAt: u.created_at,
});

// POST /api/auth/register
router.post(
  '/register',
  [
    body('name').trim().notEmpty().withMessage('Name is required')
      .isLength({ min: 2 }).withMessage('Name must be at least 2 characters'),
    body('email').trim().isEmail().withMessage('Please provide a valid email').normalizeEmail(),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }

      const { name, email, password } = req.body;

      const existing = await User.findOne({ email });
      if (existing) {
        return res.status(400).json({ message: 'Email already registered' });
      }

      const user = await User.create({ name, email, password });
      const token = generateToken(user);

      res.status(201).json({ success: true, token, user: safeUser(user) });
    } catch (error) {
      if (error.code === 'DUPLICATE_EMAIL') {
        return res.status(400).json({ message: 'Email already registered' });
      }
      next(error);
    }
  }
);

// POST /api/auth/login
router.post(
  '/login',
  [
    body('email').trim().isEmail().withMessage('Please provide a valid email').normalizeEmail(),
    body('password').notEmpty().withMessage('Password is required'),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ message: errors.array()[0].msg });
      }

      const { email, password } = req.body;

      const user = await User.findOne({ email }, true);
      if (!user) {
        return res.status(401).json({ message: 'Invalid email or password' });
      }

      const isMatch = await User.comparePassword(password, user.password_hash);
      if (!isMatch) {
        return res.status(401).json({ message: 'Invalid email or password' });
      }

      const token = generateToken(user);
      res.json({ success: true, token, user: safeUser(user) });
    } catch (error) {
      next(error);
    }
  }
);

// GET /api/auth/me
router.get('/me', auth, async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json({ success: true, user: safeUser(user) });
  } catch (error) {
    next(error);
  }
});

// POST /api/auth/google
// Receives the Supabase access_token from the frontend OAuth callback,
// verifies it, then finds-or-creates the user in our own users table
// and returns our custom JWT — exactly the same shape as /login.
router.post('/google', async (req, res, next) => {
  try {
    const { access_token } = req.body;
    if (!access_token) {
      return res.status(400).json({ message: 'access_token is required' });
    }

    // Verify the token with Supabase and get the Google profile
    const { data: { user: googleUser }, error } = await supabase.auth.getUser(access_token);
    if (error || !googleUser) {
      return res.status(401).json({ message: 'Invalid or expired Google token' });
    }

    const googleId = googleUser.id;
    const email    = googleUser.email;
    const meta     = googleUser.user_metadata ?? {};
    const name     = meta.full_name || meta.name || email.split('@')[0];
    const avatar   = meta.avatar_url || meta.picture || '';

    // 1. Try email lookup first (works even without the migration)
    let user = await User.findOne({ email });

    // 2. If not found by email, try by google_id (requires add_google_auth.sql)
    if (!user) {
      user = await User.findByGoogleId(googleId);
    }

    // 3. Brand-new user — create a record in our users table
    if (!user) {
      user = await User.createOAuth({ name, email, avatar, googleId });
    }

    const token = generateToken(user);
    res.json({ success: true, token, user: safeUser(user) });
  } catch (error) {
    next(error);
  }
});

module.exports = router;
