import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Link, useNavigate } from 'react-router-dom';
import { Eye, EyeOff, Mail, Lock } from 'lucide-react';
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

// Floating geometric shapes for the animated left panel
const FloatingShape = ({ size, color, style, duration, delay, rotate }) => (
  <motion.div
    style={{
      width: size,
      height: size,
      backgroundColor: color,
      borderRadius: rotate ? '6px' : '50%',
      position: 'absolute',
      opacity: 0.7,
      ...style,
    }}
    animate={{
      y: [0, -24, 0],
      rotate: rotate ? [rotate, rotate + 10, rotate - 10, rotate] : [0, 0, 0],
      scale: [1, 1.05, 1],
    }}
    transition={{
      duration,
      delay,
      repeat: Infinity,
      ease: 'easeInOut',
    }}
  />
);

const Sparkle = ({ style, delay }) => (
  <motion.div
    style={{
      width: 6,
      height: 6,
      borderRadius: '50%',
      backgroundColor: 'rgba(255,255,255,0.9)',
      position: 'absolute',
      ...style,
    }}
    animate={{ opacity: [0, 1, 0], scale: [0.5, 1.5, 0.5] }}
    transition={{ duration: 2, delay, repeat: Infinity, ease: 'easeInOut' }}
  />
);

const StudentIllustration = () => (
  <motion.svg
    viewBox="0 0 200 200"
    width="220"
    height="220"
    animate={{ y: [0, -12, 0] }}
    transition={{ duration: 4, repeat: Infinity, ease: 'easeInOut' }}
  >
    {/* Desk */}
    <rect x="30" y="140" width="140" height="10" rx="5" fill="rgba(255,255,255,0.3)" />
    <rect x="50" y="150" width="10" height="30" rx="3" fill="rgba(255,255,255,0.2)" />
    <rect x="140" y="150" width="10" height="30" rx="3" fill="rgba(255,255,255,0.2)" />
    {/* Laptop */}
    <rect x="60" y="110" width="80" height="30" rx="4" fill="rgba(255,255,255,0.5)" />
    <rect x="55" y="138" width="90" height="4" rx="2" fill="rgba(255,255,255,0.3)" />
    {/* Screen */}
    <rect x="65" y="114" width="70" height="22" rx="2" fill="rgba(255,255,255,0.8)" />
    {/* Screen lines */}
    <rect x="70" y="118" width="30" height="3" rx="1.5" fill="#7ec8a4" />
    <rect x="70" y="124" width="50" height="2" rx="1" fill="rgba(126,200,164,0.5)" />
    <rect x="70" y="129" width="40" height="2" rx="1" fill="rgba(126,200,164,0.5)" />
    {/* Body */}
    <rect x="85" y="75" width="30" height="38" rx="6" fill="rgba(255,255,255,0.6)" />
    {/* Head */}
    <circle cx="100" cy="62" r="18" fill="rgba(255,255,255,0.8)" />
    {/* Hair */}
    <ellipse cx="100" cy="46" rx="18" ry="8" fill="rgba(120,80,40,0.6)" />
    {/* Eyes */}
    <circle cx="93" cy="62" r="2.5" fill="#1a1a2e" />
    <circle cx="107" cy="62" r="2.5" fill="#1a1a2e" />
    {/* Smile */}
    <path d="M94 70 Q100 75 106 70" stroke="#1a1a2e" strokeWidth="2" fill="none" strokeLinecap="round" />
    {/* Arms */}
    <rect x="68" y="80" width="18" height="8" rx="4" fill="rgba(255,255,255,0.5)" transform="rotate(-15 68 80)" />
    <rect x="114" y="80" width="18" height="8" rx="4" fill="rgba(255,255,255,0.5)" transform="rotate(15 114 80)" />
  </motion.svg>
);

const AnimatedPanel = () => (
  <div
    className="hidden lg:flex flex-col items-center justify-center relative overflow-hidden"
    style={{
      background: 'linear-gradient(135deg, #5bb08a 0%, #7ec8a4 50%, #4a9d78 100%)',
      width: '60%',
      minHeight: '100vh',
    }}
  >
    {/* Background blobs */}
    <motion.div
      className="absolute rounded-full"
      style={{ width: 300, height: 300, background: 'rgba(255,255,255,0.08)', top: -80, left: -80 }}
      animate={{ scale: [1, 1.1, 1], rotate: [0, 30, 0] }}
      transition={{ duration: 12, repeat: Infinity, ease: 'easeInOut' }}
    />
    <motion.div
      className="absolute rounded-full"
      style={{ width: 200, height: 200, background: 'rgba(255,255,255,0.06)', bottom: -40, right: -40 }}
      animate={{ scale: [1, 1.15, 1], rotate: [0, -20, 0] }}
      transition={{ duration: 10, repeat: Infinity, ease: 'easeInOut' }}
    />

    {/* Floating shapes */}
    <FloatingShape size={60} color="rgba(255,255,255,0.15)" style={{ top: '10%', left: '8%' }} duration={4} delay={0} rotate={0} />
    <FloatingShape size={40} color="rgba(255,255,255,0.2)" style={{ top: '20%', right: '10%' }} duration={5} delay={0.5} rotate={45} />
    <FloatingShape size={30} color="rgba(255,220,100,0.4)" style={{ bottom: '25%', left: '12%' }} duration={3.5} delay={1} rotate={0} />
    <FloatingShape size={50} color="rgba(255,255,255,0.12)" style={{ bottom: '10%', right: '15%' }} duration={4.5} delay={0.8} rotate={20} />
    <FloatingShape size={20} color="rgba(255,180,180,0.5)" style={{ top: '40%', left: '5%' }} duration={3} delay={1.5} rotate={45} />
    <FloatingShape size={25} color="rgba(200,230,255,0.5)" style={{ top: '55%', right: '8%' }} duration={6} delay={0.3} rotate={0} />

    {/* Sparkles */}
    <Sparkle style={{ top: '15%', left: '30%' }} delay={0} />
    <Sparkle style={{ top: '30%', right: '25%' }} delay={0.7} />
    <Sparkle style={{ bottom: '30%', left: '25%' }} delay={1.4} />
    <Sparkle style={{ bottom: '15%', right: '35%' }} delay={0.3} />
    <Sparkle style={{ top: '65%', left: '40%' }} delay={1} />

    {/* Central Illustration */}
    <div className="relative z-10 flex flex-col items-center">
      <StudentIllustration />

      {/* Text */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.3, duration: 0.6 }}
        className="text-center mt-6"
      >
        {['Learn.', 'Grow.', 'Succeed.'].map((word, i) => (
          <motion.span
            key={word}
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 + i * 0.15, duration: 0.5 }}
            className="text-3xl font-black text-white mr-2 inline-block"
            style={{ textShadow: '0 2px 8px rgba(0,0,0,0.15)' }}
          >
            {word}
          </motion.span>
        ))}
        <motion.p
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1, duration: 0.6 }}
          className="text-white text-opacity-80 mt-3 text-sm font-medium"
          style={{ color: 'rgba(255,255,255,0.8)' }}
        >
          National Digital Skills & E-Learning Portal
        </motion.p>
      </motion.div>
    </div>
  </div>
);

const Login = () => {
  const [formData, setFormData] = useState({ email: '', password: '' });
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleGoogleSignIn = async () => {
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
      // Browser will redirect — no navigation needed here
    } catch (err) {
      setError(err.message ?? 'Google sign-in failed. Please try again.');
      setGoogleLoading(false);
    }
  };

  const handleChange = (e) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!formData.email || !formData.password) {
      setError('Please fill in all fields');
      return;
    }
    setLoading(true);
    try {
      const response = await api.post('/auth/login', formData);
      login(response.data.token, response.data.user);
      navigate('/');
    } catch (err) {
      setError(err.response?.data?.message || 'Login failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex">
      <AnimatedPanel />

      {/* Right Side — Login Form */}
      <motion.div
        initial={{ opacity: 0, x: 30 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ duration: 0.5 }}
        className="flex-1 flex items-center justify-center bg-edubg px-6 py-12"
      >
        <div className="w-full max-w-md">
          {/* Logo */}
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
            <h1 className="text-3xl font-black text-dark">Welcome back</h1>
            <p className="text-gray-500 mt-1 text-sm">Sign in to continue your learning journey</p>
          </motion.div>

          {/* Google OAuth */}
          <motion.div
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
          >
            <motion.button
              type="button"
              onClick={handleGoogleSignIn}
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

            {/* Divider */}
            <div className="flex items-center gap-3 my-5">
              <div className="flex-1 h-px bg-gray-200" />
              <span className="text-xs text-gray-400 font-medium">or sign in with email</span>
              <div className="flex-1 h-px bg-gray-200" />
            </div>
          </motion.div>

          {/* Form */}
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
                placeholder="Password"
                className="input-field pl-11 pr-11"
                required
                autoComplete="current-password"
              />
              <button
                type="button"
                onClick={() => setShowPassword((v) => !v)}
                className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 hover:text-dark transition-colors"
              >
                {showPassword ? <EyeOff size={16} /> : <Eye size={16} />}
              </button>
            </div>

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
                  Signing in...
                </>
              ) : (
                'Sign In'
              )}
            </motion.button>
          </motion.form>

          <motion.p
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: 0.4 }}
            className="text-center text-sm text-gray-500 mt-6"
          >
            Don't have an account?{' '}
            <Link to="/signup" className="text-dark font-semibold hover:underline">
              Sign up
            </Link>
          </motion.p>
        </div>
      </motion.div>
    </div>
  );
};

export default Login;
