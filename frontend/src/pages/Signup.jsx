import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Link, useNavigate } from 'react-router-dom';
import { Eye, EyeOff, Mail, Lock, User } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import api from '../services/api';
import supabase from '../services/supabaseClient';

const GoogleIcon = () => (
  <svg viewBox="0 0 24 24" width="20" height="20" xmlns="http://www.w3.org/2000/svg">
    <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
    <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
    <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
    <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
  </svg>
);

const FloatingIcon = ({ children, style, duration, delay }) => (
  <motion.div
    style={{
      position: 'absolute',
      ...style,
    }}
    animate={{
      y: [0, -20, 0],
      rotate: [0, 8, -8, 0],
      scale: [1, 1.05, 1],
    }}
    transition={{ duration, delay, repeat: Infinity, ease: 'easeInOut' }}
  >
    {children}
  </motion.div>
);

const GradCap = () => (
  <svg viewBox="0 0 48 48" width="48" height="48" fill="none">
    <rect x="8" y="22" width="32" height="16" rx="4" fill="rgba(255,255,255,0.5)" />
    <polygon points="24,8 4,20 24,28 44,20" fill="rgba(255,255,255,0.7)" />
    <rect x="40" y="20" width="3" height="14" rx="1.5" fill="rgba(255,255,255,0.6)" />
    <circle cx="41.5" cy="35" r="3" fill="rgba(255,220,100,0.8)" />
  </svg>
);

const BookIcon = () => (
  <svg viewBox="0 0 40 40" width="40" height="40" fill="none">
    <rect x="4" y="4" width="24" height="32" rx="3" fill="rgba(255,255,255,0.5)" />
    <rect x="10" y="4" width="24" height="32" rx="3" fill="rgba(255,255,255,0.35)" />
    <rect x="8" y="12" width="12" height="2" rx="1" fill="rgba(255,255,255,0.7)" />
    <rect x="8" y="17" width="16" height="2" rx="1" fill="rgba(255,255,255,0.5)" />
    <rect x="8" y="22" width="10" height="2" rx="1" fill="rgba(255,255,255,0.5)" />
  </svg>
);

const LightbulbIcon = () => (
  <svg viewBox="0 0 40 40" width="40" height="40" fill="none">
    <circle cx="20" cy="16" r="10" fill="rgba(255,220,100,0.7)" />
    <rect x="15" y="26" width="10" height="4" rx="2" fill="rgba(255,255,255,0.5)" />
    <rect x="16" y="30" width="8" height="3" rx="1.5" fill="rgba(255,255,255,0.4)" />
    <line x1="20" y1="6" x2="20" y2="3" stroke="rgba(255,255,255,0.7)" strokeWidth="2" strokeLinecap="round" />
    <line x1="27" y1="9" x2="29" y2="7" stroke="rgba(255,255,255,0.7)" strokeWidth="2" strokeLinecap="round" />
    <line x1="13" y1="9" x2="11" y2="7" stroke="rgba(255,255,255,0.7)" strokeWidth="2" strokeLinecap="round" />
  </svg>
);

const FloatingShape = ({ size, color, style, duration, delay, rotate }) => (
  <motion.div
    style={{
      width: size,
      height: size,
      backgroundColor: color,
      borderRadius: rotate ? '6px' : '50%',
      position: 'absolute',
      ...style,
    }}
    animate={{
      y: [0, -18, 0],
      rotate: rotate ? [rotate, rotate + 12, rotate - 12, rotate] : undefined,
    }}
    transition={{ duration, delay, repeat: Infinity, ease: 'easeInOut' }}
  />
);

const AnimatedRightPanel = () => (
  <div
    className="hidden lg:flex flex-col items-center justify-center relative overflow-hidden"
    style={{
      background: 'linear-gradient(135deg, #4a9d78 0%, #7ec8a4 50%, #5bb08a 100%)',
      width: '45%',
      minHeight: '100vh',
    }}
  >
    <motion.div
      className="absolute rounded-full"
      style={{ width: 350, height: 350, background: 'rgba(255,255,255,0.06)', top: -100, right: -100 }}
      animate={{ rotate: [0, 360] }}
      transition={{ duration: 40, repeat: Infinity, ease: 'linear' }}
    />
    <motion.div
      className="absolute rounded-full"
      style={{ width: 200, height: 200, background: 'rgba(255,255,255,0.08)', bottom: -50, left: -50 }}
      animate={{ scale: [1, 1.2, 1] }}
      transition={{ duration: 8, repeat: Infinity, ease: 'easeInOut' }}
    />

    <FloatingShape size={50} color="rgba(255,255,255,0.15)" style={{ top: '8%', left: '10%' }} duration={5} delay={0} rotate={0} />
    <FloatingShape size={35} color="rgba(255,220,100,0.4)" style={{ top: '15%', right: '8%' }} duration={4} delay={0.5} rotate={45} />
    <FloatingShape size={25} color="rgba(255,255,255,0.2)" style={{ bottom: '20%', left: '8%' }} duration={6} delay={1} rotate={0} />
    <FloatingShape size={45} color="rgba(200,240,220,0.3)" style={{ bottom: '8%', right: '12%' }} duration={4.5} delay={0.7} rotate={30} />

    <FloatingIcon style={{ top: '12%', left: '15%' }} duration={4} delay={0}>
      <GradCap />
    </FloatingIcon>
    <FloatingIcon style={{ top: '25%', right: '12%' }} duration={5} delay={0.8}>
      <BookIcon />
    </FloatingIcon>
    <FloatingIcon style={{ bottom: '28%', left: '12%' }} duration={3.5} delay={1.2}>
      <LightbulbIcon />
    </FloatingIcon>

    <div className="relative z-10 flex flex-col items-center text-center px-8">
      <motion.div
        initial={{ scale: 0 }}
        animate={{ scale: 1 }}
        transition={{ type: 'spring', stiffness: 200, delay: 0.2 }}
        className="w-24 h-24 rounded-full bg-white bg-opacity-20 flex items-center justify-center mb-6"
      >
        <svg viewBox="0 0 80 80" width="60" height="60" fill="none">
          <circle cx="40" cy="40" r="38" fill="rgba(255,255,255,0.15)" />
          <polygon points="40,12 12,30 40,44 68,30" fill="rgba(255,255,255,0.8)" />
          <rect x="20" y="44" width="40" height="20" rx="6" fill="rgba(255,255,255,0.6)" />
          <rect x="26" y="50" width="28" height="3" rx="1.5" fill="rgba(100,180,140,0.8)" />
          <rect x="26" y="56" width="20" height="2" rx="1" fill="rgba(100,180,140,0.5)" />
        </svg>
      </motion.div>

      {['Start Your', 'Learning', 'Journey'].map((word, i) => (
        <motion.span
          key={word}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 + i * 0.15 }}
          className="block text-3xl font-black text-white leading-tight"
          style={{ textShadow: '0 2px 8px rgba(0,0,0,0.15)' }}
        >
          {word}
        </motion.span>
      ))}

      <motion.p
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 0.9 }}
        className="mt-4 text-sm font-medium"
        style={{ color: 'rgba(255,255,255,0.8)' }}
      >
        Join thousands of learners growing their skills
      </motion.p>

      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 1.1 }}
        className="flex items-center gap-4 mt-6"
      >
        {[
          { value: '10K+', label: 'Learners' },
          { value: '8+', label: 'Courses' },
          { value: '100%', label: 'Free' },
        ].map((stat) => (
          <div key={stat.label} className="text-center">
            <p className="text-xl font-black text-white">{stat.value}</p>
            <p className="text-xs" style={{ color: 'rgba(255,255,255,0.7)' }}>{stat.label}</p>
          </div>
        ))}
      </motion.div>
    </div>
  </div>
);

const Signup = () => {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: '',
    terms: false,
  });
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const { register } = useAuth();
  const navigate = useNavigate();

  const handleGoogleSignUp = async () => {
    setGoogleLoading(true);
    setError('');
    try {
      const { error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: `${window.location.origin}/auth/callback`,
          queryParams: { access_type: 'offline', prompt: 'consent' },
        },
      });
      if (error) throw error;
    } catch (err) {
      setError(err.message ?? 'Google sign-up failed. Please try again.');
      setGoogleLoading(false);
    }
  };

  const handleChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData((prev) => ({ ...prev, [name]: type === 'checkbox' ? checked : value }));
    setError('');
  };

  const validate = () => {
    if (!formData.name.trim()) return 'Name is required';
    if (formData.name.trim().length < 2) return 'Name must be at least 2 characters';
    if (!formData.email) return 'Email is required';
    if (!/^\S+@\S+\.\S+$/.test(formData.email)) return 'Please enter a valid email';
    if (formData.password.length < 6) return 'Password must be at least 6 characters';
    if (formData.password !== formData.confirmPassword) return 'Passwords do not match';
    if (!formData.terms) return 'Please accept the terms and conditions';
    return null;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const validationError = validate();
    if (validationError) {
      setError(validationError);
      return;
    }
    setLoading(true);
    try {
      const response = await api.post('/auth/register', {
        name: formData.name,
        email: formData.email,
        password: formData.password,
      });
      register(response.data.token, response.data.user);
      navigate('/');
    } catch (err) {
      setError(err.response?.data?.message || 'Registration failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex">
      {/* Left Side — Signup Form */}
      <motion.div
        initial={{ opacity: 0, x: -30 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.5 }}
        className="flex-1 flex items-center justify-center bg-edubg px-6 py-12"
      >
        <div className="w-full max-w-md">
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className="mb-8"
          >
            <div className="flex items-center gap-2 mb-6">
              <div className="w-8 h-8 rounded-lg bg-dark flex items-center justify-center">
                <svg viewBox="0 0 24 24" fill="white" width="16" height="16">
                  <path d="M12 3L1 9l11 6 9-4.91V17h2V9L12 3z" />
                  <path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82z" />
                </svg>
              </div>
              <span className="font-bold text-dark">EduSkills</span>
            </div>
            <h1 className="text-3xl font-black text-dark">Create account</h1>
            <p className="text-gray-500 mt-1 text-sm">Join the National Digital Skills Portal</p>
          </motion.div>

          {/* Google OAuth */}
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
          >
            <motion.button
              type="button"
              onClick={handleGoogleSignUp}
              disabled={googleLoading}
              whileHover={{ scale: 1.01, boxShadow: '0 4px 20px rgba(0,0,0,0.1)' }}
              whileTap={{ scale: 0.98 }}
              className="w-full flex items-center justify-center gap-3 bg-white border border-gray-200 text-dark font-semibold text-sm px-4 py-3 rounded-xl hover:bg-gray-50 transition-colors disabled:opacity-60"
            >
              {googleLoading ? (
                <div className="w-5 h-5 border-2 border-gray-300 border-t-dark rounded-full animate-spin" />
              ) : (
                <GoogleIcon />
              )}
              {googleLoading ? 'Redirecting…' : 'Continue with Google'}
            </motion.button>

            <div className="flex items-center gap-3 my-5">
              <div className="flex-1 h-px bg-gray-200" />
              <span className="text-xs text-gray-400 font-medium">or create with email</span>
              <div className="flex-1 h-px bg-gray-200" />
            </div>
          </motion.div>

          <motion.form
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.25 }}
            onSubmit={handleSubmit}
            className="space-y-4"
          >
            <AnimatePresence>
              {error && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  exit={{ opacity: 0, height: 0 }}
                  className="bg-red-50 border border-red-200 text-red-600 text-sm px-4 py-3 rounded-xl"
                >
                  {error}
                </motion.div>
              )}
            </AnimatePresence>

            <div className="relative">
              <User size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleChange}
                placeholder="Full name"
                className="input-field pl-11"
                required
                autoComplete="name"
              />
            </div>

            <div className="relative">
              <Mail size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type="email"
                name="email"
                value={formData.email}
                onChange={handleChange}
                placeholder="Email address"
                className="input-field pl-11"
                required
                autoComplete="email"
              />
            </div>

            <div className="relative">
              <Lock size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type={showPassword ? 'text' : 'password'}
                name="password"
                value={formData.password}
                onChange={handleChange}
                placeholder="Password (min. 6 characters)"
                className="input-field pl-11 pr-11"
                required
                autoComplete="new-password"
              />
              <button
                type="button"
                onClick={() => setShowPassword((v) => !v)}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-dark transition-colors"
              >
                {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>

            <div className="relative">
              <Lock size={16} className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400" />
              <input
                type={showConfirm ? 'text' : 'password'}
                name="confirmPassword"
                value={formData.confirmPassword}
                onChange={handleChange}
                placeholder="Confirm password"
                className="input-field pl-11 pr-11"
                required
                autoComplete="new-password"
              />
              <button
                type="button"
                onClick={() => setShowConfirm((v) => !v)}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-dark transition-colors"
              >
                {showConfirm ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>

            <label className="flex items-start gap-3 cursor-pointer">
              <input
                type="checkbox"
                name="terms"
                checked={formData.terms}
                onChange={handleChange}
                className="mt-0.5 w-4 h-4 rounded accent-dark"
              />
              <span className="text-sm text-gray-500">
                I agree to the{' '}
                <a href="#" className="text-dark font-semibold hover:underline">Terms of Service</a>
                {' '}and{' '}
                <a href="#" className="text-dark font-semibold hover:underline">Privacy Policy</a>
              </span>
            </label>

            <motion.button
              type="submit"
              disabled={loading}
              whileHover={{ scale: 1.01 }}
              whileTap={{ scale: 0.98 }}
              className="btn-primary w-full flex items-center justify-center gap-2"
            >
              {loading ? (
                <>
                  <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                  Creating account...
                </>
              ) : (
                'Create Account'
              )}
            </motion.button>
          </motion.form>

          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.4 }}
            className="text-center text-sm text-gray-500 mt-6"
          >
            Already have an account?{' '}
            <Link to="/login" className="text-dark font-semibold hover:underline">
              Sign in
            </Link>
          </motion.p>
        </div>
      </motion.div>

      <AnimatedRightPanel />
    </div>
  );
};

export default Signup;
