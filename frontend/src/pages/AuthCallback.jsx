import React, { useEffect, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { CheckCircle, XCircle, RefreshCw } from 'lucide-react';
import supabase from '../services/supabaseClient';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';

// Steps shown to the user while the callback is processing
const STEPS = [
  { id: 'session',  label: 'Verifying Google identity…'   },
  { id: 'backend',  label: 'Connecting to server…'        },
  { id: 'token',    label: 'Generating secure session…'   },
];

// Render free tier wakes up in 30-50 s after inactivity.
// Give the backend call a 70 s timeout — longer than any cold start.
const BACKEND_TIMEOUT = 70_000;

const AuthCallback = () => {
  const navigate  = useNavigate();
  const { login } = useAuth();

  const [status,  setStatus]  = useState('loading');  // loading | success | error
  const [stepIdx, setStepIdx] = useState(0);
  const [slow,    setSlow]    = useState(false);       // show "waking up server" after 8 s
  const [message, setMessage] = useState('');
  const [retrying,setRetrying]= useState(false);

  const slowTimer = useRef(null);

  const runCallback = async () => {
    setStatus('loading');
    setStepIdx(0);
    setSlow(false);
    setMessage('');

    try {
      // ── Step 1: get Supabase session from URL hash ──────────────────
      // With flowType:'implicit' the access_token is in the URL hash and
      // getSession() parses it synchronously — no network call needed.
      const { data: { session }, error: sessionError } =
        await supabase.auth.getSession();

      if (sessionError || !session?.access_token) {
        throw new Error(
          sessionError?.message ??
          'Google did not return a session. Please try signing in again.'
        );
      }

      // ── Step 2: exchange for our custom JWT ─────────────────────────
      setStepIdx(1);

      // Start the "server is waking up" hint after 8 s of waiting
      slowTimer.current = setTimeout(() => setSlow(true), 8_000);

      const res = await api.post(
        '/auth/google',
        { access_token: session.access_token },
        { timeout: BACKEND_TIMEOUT }
      );

      clearTimeout(slowTimer.current);

      // ── Step 3: store token and navigate ───────────────────────────
      setStepIdx(2);
      login(res.data.token, res.data.user);
      setStatus('success');
      setTimeout(() => navigate('/'), 900);

    } catch (err) {
      clearTimeout(slowTimer.current);
      console.error('[AuthCallback]', err);

      const isTimeout = err.code === 'ECONNABORTED' || err.message?.includes('timeout');
      const msg = isTimeout
        ? 'The server took too long to respond. It may be starting up — please try again.'
        : (err.response?.data?.message ?? err.message ?? 'Authentication failed');

      setMessage(msg);
      setStatus('error');
    }
  };

  useEffect(() => {
    runCallback();
    return () => clearTimeout(slowTimer.current);
  }, []);

  const handleRetry = () => {
    setRetrying(true);
    runCallback().finally(() => setRetrying(false));
  };

  return (
    <div className="min-h-screen bg-edubg flex items-center justify-center p-4">
      <motion.div
        initial={{ opacity: 0, scale: 0.92, y: 20 }}
        animate={{ opacity: 1, scale: 1,    y: 0  }}
        className="bg-white rounded-3xl shadow-xl p-10 flex flex-col items-center gap-6 w-full max-w-sm"
      >

        {/* ── LOADING ── */}
        {status === 'loading' && (
          <>
            <div className="relative w-16 h-16">
              <div className="absolute inset-0 border-4 border-gray-100 rounded-full" />
              <div className="absolute inset-0 border-4 border-dark border-t-transparent rounded-full animate-spin" />
            </div>

            <div className="text-center space-y-1">
              <AnimatePresence mode="wait">
                <motion.p
                  key={stepIdx}
                  initial={{ opacity: 0, y: 6 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{    opacity: 0, y: -6 }}
                  className="font-semibold text-dark"
                >
                  {STEPS[stepIdx]?.label}
                </motion.p>
              </AnimatePresence>

              <AnimatePresence>
                {slow && (
                  <motion.p
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: 'auto' }}
                    className="text-xs text-amber-500 font-medium mt-1"
                  >
                    ⏳ Server is waking up — this can take up to 30 s on first visit
                  </motion.p>
                )}
              </AnimatePresence>
            </div>

            {/* progress dots */}
            <div className="flex gap-2">
              {STEPS.map((s, i) => (
                <motion.div
                  key={s.id}
                  className="h-2 rounded-full"
                  animate={{
                    width:      i <= stepIdx ? 24 : 8,
                    background: i < stepIdx  ? '#10b981'
                                             : i === stepIdx ? '#1a1a2e' : '#e5e7eb',
                  }}
                  transition={{ duration: 0.3 }}
                />
              ))}
            </div>
          </>
        )}

        {/* ── SUCCESS ── */}
        {status === 'success' && (
          <>
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', stiffness: 260, damping: 18 }}
            >
              <CheckCircle size={60} className="text-green-500" />
            </motion.div>
            <div className="text-center">
              <p className="font-black text-dark text-xl">Signed in!</p>
              <p className="text-sm text-gray-400 mt-1">Redirecting to dashboard…</p>
            </div>
          </>
        )}

        {/* ── ERROR ── */}
        {status === 'error' && (
          <>
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', stiffness: 260, damping: 18 }}
            >
              <XCircle size={60} className="text-red-500" />
            </motion.div>

            <div className="text-center space-y-1">
              <p className="font-bold text-dark text-lg">Authentication failed</p>
              <p className="text-sm text-red-500 leading-snug">{message}</p>
            </div>

            <div className="flex flex-col gap-2 w-full">
              <motion.button
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.97 }}
                onClick={handleRetry}
                disabled={retrying}
                className="btn-primary w-full flex items-center justify-center gap-2 text-sm"
              >
                <RefreshCw size={15} className={retrying ? 'animate-spin' : ''} />
                {retrying ? 'Retrying…' : 'Try Again'}
              </motion.button>

              <button
                onClick={() => navigate('/login')}
                className="text-sm text-gray-500 hover:text-dark transition-colors text-center"
              >
                Back to login
              </button>
            </div>
          </>
        )}

      </motion.div>
    </div>
  );
};

export default AuthCallback;
