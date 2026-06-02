import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Link, useNavigate } from 'react-router-dom';
import { Eye, EyeOff, Mail, Lock } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import api from '../services/api';

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
  const { login } = useAuth();
  const navigate = useNavigate();

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

          {/* Form */}
          <motion.form
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
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
