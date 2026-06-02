import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import {
  User,
  Mail,
  Edit2,
  Save,
  X,
  BookOpen,
  Clock,
  Award,
  TrendingUp,
  Camera,
} from 'lucide-react';
import Sidebar from '../components/Sidebar';
import ActivityChart from '../components/ActivityChart';
import CourseCard from '../components/CourseCard';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';

const StatCard = ({ icon: Icon, value, label, color }) => (
  <motion.div
    initial={{ opacity: 0, y: 10 }}
    animate={{ opacity: 1, y: 0 }}
    className="bg-white rounded-2xl p-5 shadow-sm flex items-center gap-4"
  >
    <div
      className="w-12 h-12 rounded-xl flex items-center justify-center"
      style={{ backgroundColor: color }}
    >
      <Icon size={20} className="text-dark" />
    </div>
    <div>
      <p className="text-2xl font-black text-dark">{value}</p>
      <p className="text-xs text-gray-500 mt-0.5">{label}</p>
    </div>
  </motion.div>
);

const Profile = () => {
  const { user, updateUser } = useAuth();
  const navigate = useNavigate();
  const [editing, setEditing] = useState(false);
  const [formData, setFormData] = useState({ name: '', bio: '', avatar: '' });
  const [saving, setSaving] = useState(false);
  const [saveError, setSaveError] = useState('');
  const [saveSuccess, setSaveSuccess] = useState('');
  const [activityData, setActivityData] = useState([]);
  const [enrollments, setEnrollments] = useState([]);
  const [stats, setStats] = useState({ enrolledCourses: 0, hoursLearned: 0, certificates: 0 });
  const [loading, setLoading] = useState(true);

  const getInitials = (name) => {
    if (!name) return 'U';
    return name.split(' ').map((n) => n[0]).join('').toUpperCase().slice(0, 2);
  };

  useEffect(() => {
    if (user) {
      setFormData({ name: user.name || '', bio: user.bio || '', avatar: user.avatar || '' });
    }
    fetchProfileData();
  }, [user]);

  const fetchProfileData = async () => {
    setLoading(true);
    try {
      const [profileRes, activityRes, enrollmentsRes] = await Promise.all([
        api.get('/users/profile'),
        api.get('/users/activity'),
        api.get('/enrollments/my-courses'),
      ]);
      setStats(profileRes.data.stats || {});
      setActivityData(activityRes.data.activityData || []);
      setEnrollments(enrollmentsRes.data.enrollments || []);
    } catch (err) {
      console.error('Failed to load profile data:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleChange = (e) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
    setSaveError('');
  };

  const handleSave = async () => {
    setSaving(true);
    setSaveError('');
    setSaveSuccess('');
    try {
      const res = await api.put('/users/profile', formData);
      updateUser(res.data.user);
      setSaveSuccess('Profile updated successfully!');
      setEditing(false);
      setTimeout(() => setSaveSuccess(''), 3000);
    } catch (err) {
      setSaveError(err.response?.data?.message || 'Failed to update profile');
    } finally {
      setSaving(false);
    }
  };

  const handleCancel = () => {
    setFormData({ name: user?.name || '', bio: user?.bio || '', avatar: user?.avatar || '' });
    setEditing(false);
    setSaveError('');
  };

  return (
    <div className="flex h-screen overflow-hidden bg-edubg">
      <Sidebar />

      <main className="flex-1 overflow-y-auto px-6 py-6">
        <motion.div
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-6"
        >
          <h1 className="text-2xl font-black text-dark">My Profile</h1>
          <p className="text-sm text-gray-500">Manage your account and track your learning</p>
        </motion.div>

        <div className="grid grid-cols-3 gap-6">
          {/* Left Column */}
          <div className="col-span-1 space-y-4">
            {/* Profile Card */}
            <motion.div
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              className="bg-white rounded-2xl p-6 shadow-sm"
            >
              {/* Avatar */}
              <div className="flex flex-col items-center mb-5">
                <div className="relative">
                  <div
                    className="w-20 h-20 rounded-full flex items-center justify-center text-xl font-bold text-white"
                    style={{ background: 'linear-gradient(135deg, #a78bfa, #f472b6)' }}
                  >
                    {user?.avatar ? (
                      <img src={user.avatar} alt={user.name} className="w-full h-full rounded-full object-cover" />
                    ) : (
                      getInitials(user?.name)
                    )}
                  </div>
                  {editing && (
                    <button
                      className="absolute bottom-0 right-0 w-7 h-7 bg-dark text-white rounded-full flex items-center justify-center hover:bg-opacity-80"
                      title="Change avatar (enter URL in bio field)"
                    >
                      <Camera size={12} />
                    </button>
                  )}
                </div>
                <h2 className="font-bold text-dark mt-3 text-lg">{user?.name}</h2>
                <p className="text-xs text-gray-400">{user?.email}</p>
                <span className="mt-2 text-xs bg-gray-100 text-gray-600 px-3 py-1 rounded-full capitalize">
                  {user?.role || 'student'}
                </span>
              </div>

              {/* Edit Form */}
              <AnimatePresence>
                {editing ? (
                  <motion.div
                    initial={{ opacity: 0, height: 0 }}
                    animate={{ opacity: 1, height: 'auto' }}
                    exit={{ opacity: 0, height: 0 }}
                    className="space-y-3"
                  >
                    <div>
                      <label className="text-xs font-medium text-gray-500 mb-1 block">Full Name</label>
                      <div className="relative">
                        <User size={14} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
                        <input
                          name="name"
                          value={formData.name}
                          onChange={handleChange}
                          className="input-field pl-9 text-sm"
                          placeholder="Your name"
                        />
                      </div>
                    </div>
                    <div>
                      <label className="text-xs font-medium text-gray-500 mb-1 block">Bio</label>
                      <textarea
                        name="bio"
                        value={formData.bio}
                        onChange={handleChange}
                        rows={3}
                        className="input-field text-sm resize-none"
                        placeholder="Tell us about yourself..."
                        maxLength={500}
                      />
                      <p className="text-xs text-gray-400 mt-1">{formData.bio.length}/500</p>
                    </div>
                    <div>
                      <label className="text-xs font-medium text-gray-500 mb-1 block">Avatar URL</label>
                      <input
                        name="avatar"
                        value={formData.avatar}
                        onChange={handleChange}
                        className="input-field text-sm"
                        placeholder="https://..."
                      />
                    </div>

                    {saveError && (
                      <p className="text-red-500 text-xs">{saveError}</p>
                    )}

                    <div className="flex gap-2">
                      <motion.button
                        onClick={handleSave}
                        disabled={saving}
                        whileTap={{ scale: 0.97 }}
                        className="flex-1 btn-primary text-sm flex items-center justify-center gap-1"
                      >
                        {saving ? (
                          <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                        ) : (
                          <><Save size={13} /> Save</>
                        )}
                      </motion.button>
                      <button
                        onClick={handleCancel}
                        className="btn-secondary text-sm flex items-center gap-1"
                      >
                        <X size={13} /> Cancel
                      </button>
                    </div>
                  </motion.div>
                ) : (
                  <motion.div
                    initial={{ opacity: 0 }}
                    animate={{ opacity: 1 }}
                  >
                    {user?.bio && (
                      <p className="text-sm text-gray-500 text-center mb-4">{user.bio}</p>
                    )}
                    {saveSuccess && (
                      <p className="text-green-600 text-xs text-center mb-3">{saveSuccess}</p>
                    )}
                    <button
                      onClick={() => setEditing(true)}
                      className="w-full btn-secondary text-sm flex items-center justify-center gap-2"
                    >
                      <Edit2 size={14} /> Edit Profile
                    </button>
                  </motion.div>
                )}
              </AnimatePresence>
            </motion.div>

            {/* Member since */}
            <div className="bg-white rounded-2xl p-4 shadow-sm">
              <p className="text-xs text-gray-500">Member since</p>
              <p className="text-sm font-semibold text-dark mt-1">
                {user?.createdAt
                  ? new Date(user.createdAt).toLocaleDateString('en-US', {
                      year: 'numeric', month: 'long'
                    })
                  : 'Recently joined'}
              </p>
            </div>
          </div>

          {/* Right Columns */}
          <div className="col-span-2 space-y-6">
            {/* Stats */}
            <div className="grid grid-cols-3 gap-4">
              <StatCard
                icon={BookOpen}
                value={loading ? '—' : stats.enrolledCourses || 0}
                label="Courses Enrolled"
                color="#e8dff5"
              />
              <StatCard
                icon={Clock}
                value={loading ? '—' : `${stats.hoursLearned || 0}h`}
                label="Hours Learned"
                color="#fde8c0"
              />
              <StatCard
                icon={Award}
                value={loading ? '—' : stats.certificates || 0}
                label="Certificates"
                color="#d5f5e8"
              />
            </div>

            {/* Activity Chart */}
            <div className="bg-white rounded-2xl p-5 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <h3 className="font-bold text-dark flex items-center gap-2">
                  <TrendingUp size={16} /> Learning Activity
                </h3>
                <span className="text-xs text-gray-400">This year</span>
              </div>
              {loading ? (
                <div className="h-32 skeleton rounded-xl" />
              ) : (
                <ActivityChart data={activityData} />
              )}
            </div>

            {/* Enrolled Courses */}
            <div>
              <h3 className="font-bold text-dark mb-4 flex items-center gap-2">
                <BookOpen size={16} /> My Courses
                <span className="text-sm font-normal text-gray-400">({enrollments.length})</span>
              </h3>

              {loading ? (
                <div className="grid grid-cols-2 gap-4">
                  {[0, 1].map((i) => (
                    <div key={i} className="h-40 skeleton rounded-2xl" />
                  ))}
                </div>
              ) : enrollments.length === 0 ? (
                <div className="bg-white rounded-2xl p-8 text-center shadow-sm">
                  <p className="text-gray-400 mb-3">You haven't enrolled in any courses yet</p>
                  <button
                    onClick={() => navigate('/courses')}
                    className="btn-primary text-sm"
                  >
                    Browse Courses
                  </button>
                </div>
              ) : (
                <div className="grid grid-cols-2 gap-4">
                  {enrollments.map((enrollment, i) => (
                    <motion.div
                      key={enrollment._id}
                      initial={{ opacity: 0, y: 12 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: i * 0.08 }}
                    >
                      {enrollment.course && (
                        <div className="relative">
                          <CourseCard course={enrollment.course} />
                          {/* Progress overlay */}
                          <div className="absolute bottom-0 left-0 right-0 px-4 pb-3">
                            <div className="bg-white bg-opacity-80 rounded-lg px-3 py-2">
                              <div className="flex justify-between text-xs text-gray-600 mb-1">
                                <span>Progress</span>
                                <span className="font-semibold">{enrollment.progress || 0}%</span>
                              </div>
                              <div className="h-1.5 bg-gray-200 rounded-full overflow-hidden">
                                <div
                                  className="h-full bg-dark rounded-full transition-all"
                                  style={{ width: `${enrollment.progress || 0}%` }}
                                />
                              </div>
                            </div>
                          </div>
                        </div>
                      )}
                    </motion.div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      </main>
    </div>
  );
};

export default Profile;
