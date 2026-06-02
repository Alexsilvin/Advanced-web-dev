import React, { useState, useEffect, useRef, useCallback } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { X, Clock, CheckCircle, XCircle, ChevronRight, Trophy, RotateCcw } from 'lucide-react';

/* ─── helpers ──────────────────────────────────────────────── */
const parseDurationMinutes = (str = '') => {
  const m = parseInt(str);
  return isNaN(m) ? 10 : m;
};

const fmt = (secs) => {
  const m = String(Math.floor(secs / 60)).padStart(2, '0');
  const s = String(secs % 60).padStart(2, '0');
  return `${m}:${s}`;
};

const timerColor = (ratio) => {
  if (ratio > 0.5) return '#10b981';   // green
  if (ratio > 0.25) return '#f59e0b';  // amber
  return '#ef4444';                    // red
};

/* ─── SVG countdown ring ───────────────────────────────────── */
const R = 54;
const CIRC = 2 * Math.PI * R;

const TimerRing = ({ ratio, seconds }) => {
  const color = timerColor(ratio);
  return (
    <div className="relative w-36 h-36 flex items-center justify-center">
      <svg className="absolute inset-0 -rotate-90" viewBox="0 0 120 120">
        <circle cx="60" cy="60" r={R} fill="none" stroke="#e5e7eb" strokeWidth="8" />
        <circle
          cx="60" cy="60" r={R} fill="none"
          stroke={color} strokeWidth="8"
          strokeLinecap="round"
          strokeDasharray={CIRC}
          strokeDashoffset={CIRC * (1 - ratio)}
          style={{ transition: 'stroke-dashoffset 1s linear, stroke 0.5s' }}
        />
      </svg>
      <div className="text-center z-10">
        <p className="text-2xl font-black" style={{ color }}>{fmt(seconds)}</p>
        <p className="text-xs text-gray-400 mt-0.5">remaining</p>
      </div>
    </div>
  );
};

/* ─── main component ───────────────────────────────────────── */
const ExerciseModal = ({ lesson, onComplete, onClose }) => {
  const exercise = lesson?.exercise;
  const questions = exercise?.questions ?? [];
  const totalSecs = (exercise?.timeLimit ?? Math.max(8, Math.round(parseDurationMinutes(lesson?.duration) * 0.2))) * 60;

  const [phase, setPhase] = useState('ready');           // ready | active | finished
  const [timeLeft, setTimeLeft] = useState(totalSecs);
  const [qIndex, setQIndex] = useState(0);
  const [answers, setAnswers] = useState({});            // { [qId]: chosenIndex }
  const [revealed, setRevealed] = useState({});          // { [qId]: true } after answering
  const [direction, setDirection] = useState(1);

  const intervalRef = useRef(null);

  const stopTimer = useCallback(() => clearInterval(intervalRef.current), []);

  const autoSubmit = useCallback(() => {
    stopTimer();
    setPhase('finished');
  }, [stopTimer]);

  useEffect(() => {
    if (phase !== 'active') return;
    intervalRef.current = setInterval(() => {
      setTimeLeft((t) => {
        if (t <= 1) { autoSubmit(); return 0; }
        return t - 1;
      });
    }, 1000);
    return stopTimer;
  }, [phase, autoSubmit, stopTimer]);

  const score = questions.reduce((acc, q) => {
    return answers[q.id] === q.correct ? acc + 1 : acc;
  }, 0);
  const passed = questions.length > 0 && score / questions.length >= 0.6;

  const handleAnswer = (qId, idx) => {
    if (revealed[qId]) return;
    setAnswers((a) => ({ ...a, [qId]: idx }));
    setRevealed((r) => ({ ...r, [qId]: true }));
  };

  const handleNext = () => {
    if (qIndex < questions.length - 1) {
      setDirection(1);
      setQIndex((i) => i + 1);
    } else {
      stopTimer();
      setPhase('finished');
    }
  };

  const handleFinish = () => {
    onComplete?.(score, passed);
    onClose();
  };

  const handleRetry = () => {
    setPhase('ready');
    setTimeLeft(totalSecs);
    setQIndex(0);
    setAnswers({});
    setRevealed({});
    setDirection(1);
  };

  const q = questions[qIndex];
  const ratio = timeLeft / totalSecs;

  /* ── option styling ── */
  const optionStyle = (q, idx) => {
    if (!revealed[q.id]) return 'border-gray-200 bg-white hover:border-dark hover:bg-gray-50 cursor-pointer';
    if (idx === q.correct) return 'border-green-400 bg-green-50 text-green-800 cursor-default';
    if (idx === answers[q.id] && idx !== q.correct) return 'border-red-400 bg-red-50 text-red-800 cursor-default';
    return 'border-gray-100 bg-gray-50 text-gray-400 cursor-default';
  };

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 z-50 flex items-center justify-center p-4"
      style={{ background: 'rgba(26,26,46,0.85)', backdropFilter: 'blur(6px)' }}
    >
      <motion.div
        initial={{ scale: 0.92, y: 40, opacity: 0 }}
        animate={{ scale: 1, y: 0, opacity: 1 }}
        exit={{ scale: 0.92, y: 40, opacity: 0 }}
        transition={{ type: 'spring', stiffness: 320, damping: 28 }}
        className="bg-white rounded-3xl shadow-2xl w-full max-w-xl overflow-hidden"
        style={{ maxHeight: '90vh', overflowY: 'auto' }}
      >
        {/* close */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 z-10 p-2 rounded-full bg-gray-100 hover:bg-gray-200 transition-colors"
        >
          <X size={16} className="text-gray-600" />
        </button>

        {/* ═══════════════ READY ═══════════════ */}
        {phase === 'ready' && (
          <div className="p-8 text-center">
            <div className="w-16 h-16 bg-dark rounded-2xl flex items-center justify-center mx-auto mb-4">
              <Clock size={28} className="text-white" />
            </div>
            <h2 className="text-xl font-black text-dark mb-2">{exercise?.title ?? 'Lesson Exercise'}</h2>
            <p className="text-sm text-gray-500 mb-6">
              {questions.length} question{questions.length !== 1 ? 's' : ''} &nbsp;·&nbsp;
              <span className="font-semibold text-dark">{exercise?.timeLimit ?? Math.round(totalSecs / 60)} min</span> time limit
              &nbsp;·&nbsp; 60 % to pass
            </p>
            <div className="bg-edubg rounded-2xl p-4 mb-6 text-left">
              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">Instructions</p>
              <ul className="text-sm text-gray-600 space-y-1">
                <li>• Select the best answer for each question</li>
                <li>• Feedback is shown immediately after each choice</li>
                <li>• The timer starts when you click Start</li>
                <li>• Unanswered questions when time runs out count as wrong</li>
              </ul>
            </div>
            <motion.button
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.97 }}
              onClick={() => setPhase('active')}
              className="btn-primary w-full flex items-center justify-center gap-2"
            >
              Start Exercise <ChevronRight size={16} />
            </motion.button>
          </div>
        )}

        {/* ═══════════════ ACTIVE ═══════════════ */}
        {phase === 'active' && q && (
          <div className="p-6">
            {/* timer + progress */}
            <div className="flex items-center justify-between mb-6">
              <div>
                <p className="text-xs text-gray-400 font-medium">Question {qIndex + 1} of {questions.length}</p>
                <div className="flex gap-1 mt-1.5">
                  {questions.map((_, i) => (
                    <div
                      key={i}
                      className="h-1.5 rounded-full transition-all"
                      style={{
                        width: i === qIndex ? 24 : 8,
                        background: i < qIndex ? '#10b981' : i === qIndex ? '#1a1a2e' : '#e5e7eb',
                      }}
                    />
                  ))}
                </div>
              </div>
              <TimerRing ratio={ratio} seconds={timeLeft} />
            </div>

            {/* question */}
            <AnimatePresence mode="wait">
              <motion.div
                key={qIndex}
                initial={{ x: direction * 40, opacity: 0 }}
                animate={{ x: 0, opacity: 1 }}
                exit={{ x: -direction * 40, opacity: 0 }}
                transition={{ duration: 0.25 }}
              >
                <p className="font-bold text-dark text-base leading-snug mb-5">{q.question}</p>

                {/* options */}
                <div className="space-y-2">
                  {q.options.map((opt, idx) => (
                    <button
                      key={idx}
                      onClick={() => handleAnswer(q.id, idx)}
                      className={`w-full text-left px-4 py-3 rounded-xl border-2 text-sm font-medium transition-all ${optionStyle(q, idx)}`}
                    >
                      <span className="inline-block w-6 h-6 rounded-full bg-gray-100 text-center leading-6 text-xs font-bold mr-3">
                        {String.fromCharCode(65 + idx)}
                      </span>
                      {opt}
                      {revealed[q.id] && idx === q.correct && <CheckCircle size={16} className="inline ml-2 text-green-500" />}
                      {revealed[q.id] && idx === answers[q.id] && idx !== q.correct && <XCircle size={16} className="inline ml-2 text-red-500" />}
                    </button>
                  ))}
                </div>

                {/* explanation */}
                <AnimatePresence>
                  {revealed[q.id] && (
                    <motion.div
                      initial={{ opacity: 0, y: 8 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="mt-4 p-4 bg-blue-50 border border-blue-200 rounded-xl"
                    >
                      <p className="text-xs font-semibold text-blue-700 mb-1">Explanation</p>
                      <p className="text-sm text-blue-800 leading-relaxed">{q.explanation}</p>
                    </motion.div>
                  )}
                </AnimatePresence>
              </motion.div>
            </AnimatePresence>

            {/* next button */}
            {revealed[q.id] && (
              <motion.button
                initial={{ opacity: 0, y: 8 }}
                animate={{ opacity: 1, y: 0 }}
                whileHover={{ scale: 1.02 }}
                whileTap={{ scale: 0.97 }}
                onClick={handleNext}
                className="btn-primary w-full mt-5 flex items-center justify-center gap-2"
              >
                {qIndex < questions.length - 1 ? 'Next Question' : 'Finish Exercise'}
                <ChevronRight size={16} />
              </motion.button>
            )}
          </div>
        )}

        {/* ═══════════════ FINISHED ═══════════════ */}
        {phase === 'finished' && (
          <div className="p-8 text-center">
            <motion.div
              initial={{ scale: 0.5, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{ type: 'spring', stiffness: 280, damping: 20 }}
              className={`w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4 ${passed ? 'bg-green-100' : 'bg-red-100'}`}
            >
              {passed
                ? <Trophy size={36} className="text-green-600" />
                : <XCircle size={36} className="text-red-500" />
              }
            </motion.div>

            <h2 className="text-2xl font-black text-dark mb-1">
              {passed ? 'Well done!' : 'Keep practising!'}
            </h2>
            <p className="text-gray-500 text-sm mb-6">
              {passed ? 'You passed the exercise.' : 'You need 60% to pass. Review the notes and try again.'}
            </p>

            {/* score ring */}
            <div className="relative w-28 h-28 mx-auto mb-6">
              <svg className="absolute inset-0 -rotate-90" viewBox="0 0 120 120">
                <circle cx="60" cy="60" r={R} fill="none" stroke="#e5e7eb" strokeWidth="8" />
                <motion.circle
                  cx="60" cy="60" r={R} fill="none"
                  stroke={passed ? '#10b981' : '#ef4444'}
                  strokeWidth="8" strokeLinecap="round"
                  strokeDasharray={CIRC}
                  initial={{ strokeDashoffset: CIRC }}
                  animate={{ strokeDashoffset: CIRC * (1 - score / questions.length) }}
                  transition={{ duration: 1.2, ease: 'easeOut' }}
                />
              </svg>
              <div className="absolute inset-0 flex flex-col items-center justify-center">
                <p className="text-3xl font-black text-dark">{score}/{questions.length}</p>
                <p className="text-xs text-gray-400">correct</p>
              </div>
            </div>

            {/* per-question summary */}
            <div className="space-y-2 mb-6 text-left">
              {questions.map((q, i) => {
                const userAns = answers[q.id];
                const correct = userAns === q.correct;
                return (
                  <div key={q.id} className={`flex items-start gap-3 p-3 rounded-xl text-sm ${correct ? 'bg-green-50' : 'bg-red-50'}`}>
                    {correct
                      ? <CheckCircle size={16} className="text-green-500 mt-0.5 flex-shrink-0" />
                      : <XCircle size={16} className="text-red-500 mt-0.5 flex-shrink-0" />
                    }
                    <div>
                      <p className={`font-medium ${correct ? 'text-green-800' : 'text-red-800'}`}>Q{i+1}: {q.question}</p>
                      {!correct && userAns !== undefined && (
                        <p className="text-xs text-red-600 mt-0.5">Your answer: {q.options[userAns]}</p>
                      )}
                      {!correct && (
                        <p className="text-xs text-green-700 mt-0.5">Correct: {q.options[q.correct]}</p>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>

            <div className="flex gap-3">
              {!passed && (
                <motion.button
                  whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
                  onClick={handleRetry}
                  className="btn-secondary flex-1 flex items-center justify-center gap-2"
                >
                  <RotateCcw size={15} /> Retry
                </motion.button>
              )}
              <motion.button
                whileHover={{ scale: 1.02 }} whileTap={{ scale: 0.97 }}
                onClick={handleFinish}
                className="btn-primary flex-1"
              >
                {passed ? 'Mark Complete' : 'Back to Notes'}
              </motion.button>
            </div>
          </div>
        )}
      </motion.div>
    </motion.div>
  );
};

export default ExerciseModal;
