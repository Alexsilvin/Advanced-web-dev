import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import {
  PlayCircle, CheckCircle, Lock, ChevronDown,
  BookOpen, Zap, Code, Lightbulb, ArrowRight,
} from 'lucide-react';
import ExerciseModal from './ExerciseModal';

/* ─── notes renderer ───────────────────────────────────────── */
const NotesView = ({ notes }) => {
  if (!notes) return <p className="text-sm text-gray-400 italic">No notes available yet for this lesson.</p>;

  const isString = typeof notes === 'string';
  if (isString) {
    return <p className="text-sm text-gray-700 leading-relaxed whitespace-pre-line">{notes}</p>;
  }

  const { overview, keyPoints, codeExample, deepDive, summary } = notes;

  return (
    <div className="space-y-5">
      {/* overview */}
      {overview && (
        <div className="flex gap-3">
          <div className="w-8 h-8 rounded-xl bg-blue-50 flex items-center justify-center flex-shrink-0">
            <BookOpen size={14} className="text-blue-600" />
          </div>
          <div>
            <p className="text-xs font-bold text-blue-600 uppercase tracking-wide mb-1">Overview</p>
            <p className="text-sm text-gray-700 leading-relaxed">{overview}</p>
          </div>
        </div>
      )}

      {/* key points */}
      {keyPoints?.length > 0 && (
        <div className="flex gap-3">
          <div className="w-8 h-8 rounded-xl bg-emerald-50 flex items-center justify-center flex-shrink-0">
            <Zap size={14} className="text-emerald-600" />
          </div>
          <div className="flex-1">
            <p className="text-xs font-bold text-emerald-600 uppercase tracking-wide mb-2">Key Concepts</p>
            <ul className="space-y-2">
              {keyPoints.map((pt, i) => (
                <li key={i} className="flex gap-2 text-sm text-gray-700">
                  <span className="w-5 h-5 rounded-full bg-emerald-100 text-emerald-700 text-xs font-bold flex items-center justify-center flex-shrink-0 mt-0.5">
                    {i + 1}
                  </span>
                  <span className="leading-relaxed">{pt}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>
      )}

      {/* code example */}
      {codeExample && (
        <div className="flex gap-3">
          <div className="w-8 h-8 rounded-xl bg-gray-800 flex items-center justify-center flex-shrink-0">
            <Code size={14} className="text-green-400" />
          </div>
          <div className="flex-1 min-w-0">
            <p className="text-xs font-bold text-gray-500 uppercase tracking-wide mb-2">Code Example</p>
            <pre
              className="bg-gray-900 text-green-300 text-xs leading-relaxed p-4 rounded-xl overflow-x-auto"
              style={{ fontFamily: "'JetBrains Mono', 'Fira Code', 'Courier New', monospace" }}
            >
              <code>{codeExample}</code>
            </pre>
          </div>
        </div>
      )}

      {/* deep dive */}
      {deepDive && (
        <div className="flex gap-3">
          <div className="w-8 h-8 rounded-xl bg-amber-50 flex items-center justify-center flex-shrink-0">
            <Lightbulb size={14} className="text-amber-600" />
          </div>
          <div>
            <p className="text-xs font-bold text-amber-600 uppercase tracking-wide mb-1">Deep Dive</p>
            <p className="text-sm text-gray-700 leading-relaxed italic border-l-2 border-amber-300 pl-3">{deepDive}</p>
          </div>
        </div>
      )}

      {/* summary */}
      {summary && (
        <div className="bg-dark rounded-xl p-4">
          <p className="text-xs font-bold text-gray-400 uppercase tracking-wide mb-1">Summary</p>
          <p className="text-sm text-white leading-relaxed font-medium">{summary}</p>
        </div>
      )}
    </div>
  );
};

/* ─── main component ───────────────────────────────────────── */
const LessonPanel = ({ lesson, index, isCompleted, isLocked, onComplete, courseColor }) => {
  const [open, setOpen] = useState(false);
  const [showExercise, setShowExercise] = useState(false);

  const hasNotes = lesson?.notes && (
    typeof lesson.notes === 'string'
      ? lesson.notes.trim().length > 0
      : Object.keys(lesson.notes).length > 0
  );
  const hasExercise = lesson?.exercise?.questions?.length > 0;
  const canOpen = !isLocked && (hasNotes || hasExercise);

  const handleToggle = () => {
    if (canOpen) setOpen((o) => !o);
  };

  const handleExerciseComplete = (score, passed) => {
    if (passed) onComplete?.(index);
    setShowExercise(false);
  };

  return (
    <>
      {/* ── row ── */}
      <motion.div
        initial={{ opacity: 0, x: -8 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ delay: index * 0.03 }}
        className={`rounded-2xl border overflow-hidden transition-colors
          ${isCompleted ? 'border-green-200 bg-green-50/60' : 'border-gray-100 bg-white'}
          ${canOpen ? 'cursor-pointer' : ''}
        `}
      >
        {/* header row */}
        <div
          className="flex items-center gap-4 px-5 py-4"
          onClick={handleToggle}
        >
          {/* status icon */}
          <div className="flex-shrink-0">
            {isCompleted
              ? <CheckCircle size={20} className="text-green-500" />
              : isLocked
                ? <Lock size={20} className="text-gray-300" />
                : <PlayCircle size={20} className="text-dark" />
            }
          </div>

          {/* number + title */}
          <div className="flex-1 min-w-0">
            <p className={`text-sm font-semibold leading-snug ${isLocked ? 'text-gray-400' : 'text-dark'}`}>
              <span className="text-gray-400 font-normal mr-1.5">{String(index + 1).padStart(2, '0')}.</span>
              {lesson.title}
            </p>
            {lesson.description && (
              <p className="text-xs text-gray-400 mt-0.5 truncate">{lesson.description}</p>
            )}
          </div>

          {/* badges */}
          <div className="flex items-center gap-2 flex-shrink-0">
            {hasExercise && !isLocked && (
              <span className="text-xs bg-dark text-white px-2 py-0.5 rounded-full font-medium">Quiz</span>
            )}
            <span className="text-xs text-gray-400">{lesson.duration}</span>
            {canOpen && (
              <motion.div animate={{ rotate: open ? 180 : 0 }} transition={{ duration: 0.2 }}>
                <ChevronDown size={16} className="text-gray-400" />
              </motion.div>
            )}
          </div>
        </div>

        {/* expanded notes + exercise button */}
        <AnimatePresence initial={false}>
          {open && (
            <motion.div
              key="panel"
              initial={{ height: 0, opacity: 0 }}
              animate={{ height: 'auto', opacity: 1 }}
              exit={{ height: 0, opacity: 0 }}
              transition={{ duration: 0.3, ease: [0.4, 0, 0.2, 1] }}
              style={{ overflow: 'hidden' }}
            >
              <div className="px-5 pb-5 border-t border-gray-100">
                {/* notes */}
                {hasNotes ? (
                  <div className="mt-4">
                    <NotesView notes={lesson.notes} />
                  </div>
                ) : (
                  <p className="mt-4 text-sm text-gray-400 italic">Lecture notes coming soon.</p>
                )}

                {/* exercise call-to-action */}
                {hasExercise && (
                  <motion.button
                    initial={{ opacity: 0, y: 6 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.15 }}
                    onClick={(e) => { e.stopPropagation(); setShowExercise(true); }}
                    className="mt-6 w-full flex items-center justify-between px-5 py-4 rounded-2xl text-white font-semibold text-sm"
                    style={{
                      background: `linear-gradient(135deg, #1a1a2e 0%, #2d2d52 100%)`,
                    }}
                    whileHover={{ scale: 1.01 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 rounded-xl bg-white/10 flex items-center justify-center">
                        <Zap size={16} className="text-yellow-300" />
                      </div>
                      <div className="text-left">
                        <p className="font-bold">{lesson.exercise.title ?? 'Start Exercise'}</p>
                        <p className="text-xs text-gray-300 font-normal">
                          {lesson.exercise.questions.length} questions &nbsp;·&nbsp;
                          {lesson.exercise.timeLimit ?? Math.max(8, Math.round(parseInt(lesson.duration) * 0.2))} min
                        </p>
                      </div>
                    </div>
                    <ArrowRight size={18} className="text-white/60" />
                  </motion.button>
                )}

                {isCompleted && (
                  <div className="mt-3 flex items-center gap-2 text-green-600 text-xs font-medium">
                    <CheckCircle size={14} />
                    Lesson completed
                  </div>
                )}
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </motion.div>

      {/* exercise modal */}
      <AnimatePresence>
        {showExercise && (
          <ExerciseModal
            lesson={lesson}
            onComplete={handleExerciseComplete}
            onClose={() => setShowExercise(false)}
          />
        )}
      </AnimatePresence>
    </>
  );
};

export default LessonPanel;
