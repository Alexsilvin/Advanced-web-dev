import React, { useState, useEffect, useCallback } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useParams, useNavigate } from 'react-router-dom';
import {
  ArrowLeft, Star, Users, Clock, BookOpen, Award, CheckCircle,
} from 'lucide-react';
import Sidebar from '../components/Sidebar';
import LessonPanel from '../components/LessonPanel';
import api from '../services/api';

const CourseDetail = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [course, setCourse] = useState(null);
  const [enrollment, setEnrollment] = useState(null);
  const [loading, setLoading] = useState(true);
  const [enrolling, setEnrolling] = useState(false);
  const [enrollError, setEnrollError] = useState('');
  const [enrollSuccess, setEnrollSuccess] = useState('');

  useEffect(() => { fetchCourse(); checkEnrollment(); }, [id]);

  const fetchCourse = async () => {
    try {
      const res = await api.get(`/courses/${id}`);
      setCourse(res.data.course);
    } catch (err) {
      console.error('Failed to load course:', err);
    } finally {
      setLoading(false);
    }
  };

  const checkEnrollment = async () => {
    try {
      const res = await api.get('/enrollments/my-courses');
      const found = res.data.enrollments?.find(
        (e) => e.courseId === id || e.course?.id === id || e.course?._id === id
      );
      if (found) setEnrollment(found);
    } catch (_) {}
  };

  const handleEnroll = async () => {
    setEnrolling(true);
    setEnrollError('');
    try {
      const res = await api.post(`/enrollments/enroll/${id}`);
      setEnrollment(res.data.enrollment);
      setEnrollSuccess('Successfully enrolled! Start learning now.');
    } catch (err) {
      setEnrollError(err.response?.data?.message || 'Failed to enroll');
    } finally {
      setEnrolling(false);
    }
  };

  // Called by LessonPanel when a lesson's exercise is passed
  const handleLessonComplete = useCallback(async (lessonIndex) => {
    if (!enrollment) return;
    const prev = enrollment.completedLessons || [];
    if (prev.includes(lessonIndex)) return;
    const updated = [...prev, lessonIndex];
    const lessons = course?.lessons ?? [];
    const progress = lessons.length > 0 ? Math.round((updated.length / lessons.length) * 100) : 0;
    try {
      const res = await api.put(`/enrollments/progress/${id}`, {
        completedLessons: updated,
        progress,
      });
      setEnrollment(res.data.enrollment);
    } catch (_) {
      // optimistic fallback
      setEnrollment((e) => ({ ...e, completedLessons: updated, progress }));
    }
  }, [enrollment, course, id]);

  if (loading) {
    return (
      <div className="flex h-screen overflow-hidden bg-edubg">
        <Sidebar />
        <main className="flex-1 overflow-y-auto px-6 py-6">
          <div className="animate-pulse">
            <div className="h-48 rounded-2xl bg-gray-200 mb-6" />
            <div className="h-8 w-2/3 bg-gray-200 rounded mb-4" />
            <div className="h-4 w-full bg-gray-200 rounded mb-2" />
            <div className="h-4 w-3/4 bg-gray-200 rounded mb-2" />
          </div>
        </main>
      </div>
    );
  }

  if (!course) {
    return (
      <div className="flex h-screen overflow-hidden bg-edubg">
        <Sidebar />
        <main className="flex-1 flex items-center justify-center">
          <div className="text-center">
            <p className="text-xl font-semibold text-dark mb-2">Course not found</p>
            <button onClick={() => navigate('/courses')} className="btn-primary">
              Browse courses
            </button>
          </div>
        </main>
      </div>
    );
  }

  const levelColors = {
    Beginner: 'text-green-600 bg-green-100',
    Intermediate: 'text-yellow-600 bg-yellow-100',
    Advanced: 'text-red-600 bg-red-100',
  };

  return (
    <div className="flex h-screen overflow-hidden bg-edubg">
      <Sidebar />

      <main className="flex-1 overflow-y-auto">
        {/* Hero Banner */}
        <div
          className="relative px-8 py-10"
          style={{ backgroundColor: course.color || '#f5d5d5' }}
        >
          <button
            onClick={() => navigate(-1)}
            className="flex items-center gap-2 text-sm font-medium text-dark bg-white bg-opacity-60 px-3 py-1.5 rounded-xl mb-4 hover:bg-opacity-80 transition-colors"
          >
            <ArrowLeft size={14} /> Back
          </button>

          <div className="flex items-start justify-between">
            <div className="flex-1 pr-8">
              <span className="text-xs font-semibold bg-white bg-opacity-70 px-3 py-1 rounded-full">
                {course.category}
              </span>
              <h1 className="text-3xl font-black text-dark mt-3 mb-2">{course.title}</h1>
              <p className="text-gray-700 text-sm leading-relaxed max-w-2xl">{course.description}</p>

              <div className="flex items-center gap-5 mt-4 flex-wrap">
                <div className="flex items-center gap-1">
                  <Star size={14} className="text-yellow-500 fill-yellow-500" />
                  <span className="text-sm font-bold">{course.rating?.toFixed(1)}</span>
                </div>
                <div className="flex items-center gap-1 text-gray-600">
                  <Users size={14} />
                  <span className="text-sm">{course.totalStudents?.toLocaleString()} students</span>
                </div>
                <div className="flex items-center gap-1 text-gray-600">
                  <Clock size={14} />
                  <span className="text-sm">{course.duration}</span>
                </div>
                <div className="flex items-center gap-1 text-gray-600">
                  <BookOpen size={14} />
                  <span className="text-sm">{course.lessons?.length || 0} lessons</span>
                </div>
                <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${levelColors[course.level] || levelColors.Beginner}`}>
                  {course.level}
                </span>
              </div>
            </div>

            {/* Enroll Card */}
            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              className="bg-white rounded-2xl p-5 shadow-lg w-64 flex-shrink-0"
            >
              <div className="text-center mb-4">
                <span className="text-3xl font-black text-dark">
                  {course.isFree ? 'Free' : `$${course.price}`}
                </span>
                {!course.isFree && <span className="text-sm text-gray-400 ml-1">USD</span>}
              </div>

              {enrollment ? (
                <div>
                  <div className="flex items-center gap-2 text-green-600 mb-3 justify-center">
                    <CheckCircle size={16} />
                    <span className="text-sm font-semibold">Enrolled</span>
                  </div>
                  <div className="mb-3">
                    <div className="flex justify-between text-xs text-gray-500 mb-1">
                      <span>Progress</span>
                      <span>{enrollment.progress || 0}%</span>
                    </div>
                    <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                      <div
                        className="h-full bg-dark rounded-full transition-all"
                        style={{ width: `${enrollment.progress || 0}%` }}
                      />
                    </div>
                  </div>
                  <button className="btn-primary w-full text-sm">Continue Learning</button>
                </div>
              ) : (
                <>
                  <AnimatePresence>
                    {enrollError && (
                      <motion.p
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="text-red-500 text-xs text-center mb-2"
                      >
                        {enrollError}
                      </motion.p>
                    )}
                    {enrollSuccess && (
                      <motion.p
                        initial={{ opacity: 0 }}
                        animate={{ opacity: 1 }}
                        exit={{ opacity: 0 }}
                        className="text-green-600 text-xs text-center mb-2"
                      >
                        {enrollSuccess}
                      </motion.p>
                    )}
                  </AnimatePresence>
                  <motion.button
                    onClick={handleEnroll}
                    disabled={enrolling}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                    className="btn-primary w-full flex items-center justify-center gap-2 text-sm"
                  >
                    {enrolling ? (
                      <>
                        <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                        Enrolling...
                      </>
                    ) : (
                      <>Enroll Now — {course.isFree ? 'Free' : `$${course.price}`}</>
                    )}
                  </motion.button>
                  <p className="text-xs text-gray-400 text-center mt-2">Full lifetime access</p>
                </>
              )}
            </motion.div>
          </div>
        </div>

        {/* Content */}
        <div className="px-8 py-6 grid grid-cols-3 gap-6">
          {/* Lessons List */}
          <div className="col-span-2">
            <div className="flex items-center justify-between mb-1">
              <h2 className="font-bold text-dark text-lg flex items-center gap-2">
                <BookOpen size={18} /> Course Content
              </h2>
              {enrollment && (
                <span className="text-sm font-semibold text-dark">
                  {enrollment.completedLessons?.length ?? 0}/{course.lessons?.length} complete
                </span>
              )}
            </div>
            <p className="text-sm text-gray-400 mb-4">{course.lessons?.length} lessons · {course.duration}</p>

            {/* overall progress bar */}
            {enrollment && (
              <div className="mb-5">
                <div className="h-2 bg-gray-100 rounded-full overflow-hidden">
                  <motion.div
                    className="h-full bg-dark rounded-full"
                    initial={{ width: 0 }}
                    animate={{ width: `${enrollment.progress ?? 0}%` }}
                    transition={{ duration: 0.8, ease: 'easeOut' }}
                  />
                </div>
                <p className="text-xs text-gray-400 mt-1">{enrollment.progress ?? 0}% complete</p>
              </div>
            )}

            <div className="space-y-2">
              {course.lessons?.map((lesson, index) => {
                const isCompleted = enrollment?.completedLessons?.includes(index);
                const isLocked = !enrollment && index > 0;
                return (
                  <LessonPanel
                    key={index}
                    lesson={lesson}
                    index={index}
                    isCompleted={isCompleted}
                    isLocked={isLocked}
                    onComplete={handleLessonComplete}
                    courseColor={course.color}
                  />
                );
              })}
            </div>
          </div>

          {/* Instructor + Tags */}
          <div className="space-y-4">
            {/* Instructor */}
            {course.instructor && (
              <div className="bg-white rounded-2xl p-5 shadow-sm">
                <h3 className="font-semibold text-dark text-sm mb-3">Instructor</h3>
                <div className="flex items-center gap-3">
                  <div
                    className="w-12 h-12 rounded-full flex items-center justify-center text-sm font-bold text-white"
                    style={{ background: 'linear-gradient(135deg, #a78bfa, #f472b6)' }}
                  >
                    {course.instructor?.name?.[0]?.toUpperCase() || 'I'}
                  </div>
                  <div>
                    <p className="font-semibold text-dark text-sm">{course.instructor?.name}</p>
                    {course.instructor?.bio && (
                      <p className="text-xs text-gray-400 mt-0.5 line-clamp-2">{course.instructor.bio}</p>
                    )}
                  </div>
                </div>
              </div>
            )}

            {/* Stats */}
            <div className="bg-white rounded-2xl p-5 shadow-sm">
              <h3 className="font-semibold text-dark text-sm mb-3">Course Info</h3>
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Students</span>
                  <span className="font-medium">{course.totalStudents?.toLocaleString()}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Duration</span>
                  <span className="font-medium">{course.duration}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Level</span>
                  <span className="font-medium">{course.level}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Lessons</span>
                  <span className="font-medium">{course.lessons?.length}</span>
                </div>
                <div className="flex justify-between text-sm">
                  <span className="text-gray-500">Rating</span>
                  <span className="font-medium flex items-center gap-1">
                    <Star size={12} className="text-yellow-500 fill-yellow-500" />
                    {course.rating}
                  </span>
                </div>
              </div>
            </div>

            {/* Tags */}
            {course.tags?.length > 0 && (
              <div className="bg-white rounded-2xl p-5 shadow-sm">
                <h3 className="font-semibold text-dark text-sm mb-3">Topics</h3>
                <div className="flex flex-wrap gap-2">
                  {course.tags.map((tag, i) => (
                    <span
                      key={i}
                      className="text-xs bg-gray-100 text-gray-600 px-3 py-1 rounded-full"
                    >
                      {tag}
                    </span>
                  ))}
                </div>
              </div>
            )}

            {/* Certificate */}
            <div className="bg-dark rounded-2xl p-5 text-white">
              <Award size={24} className="mb-2 text-yellow-400" />
              <p className="font-semibold text-sm mb-1">Certificate of Completion</p>
              <p className="text-xs text-gray-300">Earn a certificate when you complete this course</p>
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default CourseDetail;
