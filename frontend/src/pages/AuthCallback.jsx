import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion } from 'framer-motion';
import { CheckCircle, XCircle } from 'lucide-react';
import supabase from '../services/supabaseClient';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';

const AuthCallback = () => {
  const navigate  = useNavigate();
  const { login } = useAuth();
  const [status, setStatus]   = useState('loading'); // loading | success | error
  const [message, setMessage] = useState('');

  useEffect(() => {
    const handleCallback = async () => {
      try {
        // Supabase puts the session tokens in the URL hash after the OAuth redirect.
        // getSession() parses them and returns the session.
        const { data: { session }, error: sessionError } = await supabase.auth.getSession();

        if (sessionError || !session?.access_token) {
          throw new Error(sessionError?.message ?? 'No session found in callback URL');
        }

        // Exchange the Supabase access token for our own custom JWT
        const res = await api.post('/auth/google', {
          access_token: session.access_token,
        });

        login(res.data.token, res.data.user);
        setStatus('success');
        setTimeout(() => navigate('/'), 800);
      } catch (err) {
        console.error('[AuthCallback]', err);
        setMessage(err.response?.data?.message ?? err.message ?? 'Authentication failed');
        setStatus('error');
        setTimeout(() => navigate('/login'), 3000);
      }
    };

    handleCallback();
  }, []);

  return (
    <div className="min-h-screen bg-edubg flex items-center justify-center">
      <motion.div
        initial={{ opacity: 0, scale: 0.92 }}
        animate={{ opacity: 1, scale: 1 }}
        className="bg-white rounded-3xl shadow-xl p-10 flex flex-col items-center gap-5 max-w-sm w-full"
      >
        {status === 'loading' && (
          <>
            <div className="w-14 h-14 border-4 border-dark border-t-transparent rounded-full animate-spin" />
            <p className="font-semibold text-dark">Signing you in with Google…</p>
            <p className="text-sm text-gray-400">This will only take a moment</p>
          </>
        )}

        {status === 'success' && (
          <>
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', stiffness: 260, damping: 20 }}
            >
              <CheckCircle size={56} className="text-green-500" />
            </motion.div>
            <p className="font-bold text-dark text-lg">Signed in!</p>
            <p className="text-sm text-gray-400">Redirecting to dashboard…</p>
          </>
        )}

        {status === 'error' && (
          <>
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: 'spring', stiffness: 260, damping: 20 }}
            >
              <XCircle size={56} className="text-red-500" />
            </motion.div>
            <p className="font-bold text-dark text-lg">Authentication failed</p>
            <p className="text-sm text-red-500 text-center">{message}</p>
            <p className="text-xs text-gray-400">Redirecting back to login…</p>
          </>
        )}
      </motion.div>
    </div>
  );
};

export default AuthCallback;
