import React, { useEffect, useState } from 'react';
import { Bell, Settings, ChevronDown } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import ActivityChart from './ActivityChart';
import api from '../services/api';

const UserProfilePanel = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [activityData, setActivityData] = useState([]);
  const [enrolledCourses, setEnrolledCourses] = useState([]);
  const [loading, setLoading] = useState(true);

  const getInitials = (name) => {
    if (!name) return 'U';
    return name.split(' ').map((n) => n[0]).join('').toUpperCase().slice(0, 2);
  };

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [activityRes, enrollmentsRes] = await Promise.all([
          api.get('/users/activity'),
          api.get('/enrollments/my-courses'),
        ]);
        setActivityData(activityRes.data.activityData || []);
        setEnrolledCourses(enrollmentsRes.data.enrollments?.slice(0, 2) || []);
      } catch (err) {
        console.error('Failed to fetch panel data:', err);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  return (
    <div className="w-80 flex-shrink-0 flex flex-col gap-4">
      {/* Top Actions */}
      <div className="flex items-center justify-between">
        <h2 className="text-sm font-semibold text-gray-400 uppercase tracking-wider">My Space</h2>
        <div className="flex items-center gap-2">
          <button className="w-9 h-9 rounded-xl bg-white shadow-sm flex items-center justify-center text-gray-500 hover:text-dark transition-colors">
            <Bell size={16} />
          </button>
          <button
            onClick={() => navigate('/profile')}
            className="w-9 h-9 rounded-xl bg-white shadow-sm flex items-center justify-center text-gray-500 hover:text-dark transition-colors"
          >
            <Settings size={16} />
          </button>
        </div>
      </div>

      {/* Profile Card */}
      <div className="bg-white rounded-2xl p-5 shadow-sm">
        <div className="flex flex-col items-center text-center">
          <div className="relative mb-3">
            <div
              className="w-16 h-16 rounded-full flex items-center justify-center text-lg font-bold text-white cursor-pointer"
              style={{
                background: 'linear-gradient(135deg, #a78bfa, #f472b6)',
                boxShadow: '0 0 0 4px #f5f0e8, 0 0 0 6px #e8dff5',
              }}
              onClick={() => navigate('/profile')}
            >
              {user?.avatar ? (
                <img src={user.avatar} alt={user.name} className="w-full h-full rounded-full object-cover" />
              ) : (
                getInitials(user?.name)
              )}
            </div>
            <div className="absolute bottom-0 right-0 w-4 h-4 bg-green-400 rounded-full border-2 border-white" />
          </div>
          <h3 className="font-bold text-dark text-base">{user?.name || 'Student'}</h3>
          <p className="text-xs text-gray-400 mt-0.5">{user?.email || ''}</p>
          <div className="flex items-center gap-4 mt-3 pt-3 border-t border-gray-100 w-full justify-center">
            <div className="text-center">
              <p className="text-lg font-bold text-dark">{enrolledCourses.length}</p>
              <p className="text-xs text-gray-400">Enrolled</p>
            </div>
            <div className="w-px h-8 bg-gray-100" />
            <div className="text-center">
              <p className="text-lg font-bold text-dark">
                {Math.round(enrolledCourses.reduce((s, e) => s + (e.progress || 0), 0) / Math.max(enrolledCourses.length, 1))}%
              </p>
              <p className="text-xs text-gray-400">Avg Progress</p>
            </div>
          </div>
        </div>
      </div>

      {/* Activity Chart */}
      <div className="bg-white rounded-2xl p-5 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <h4 className="font-semibold text-dark text-sm">Activity</h4>
          <button className="flex items-center gap-1 text-xs text-gray-400 bg-gray-100 px-2 py-1 rounded-lg">
            Year <ChevronDown size={12} />
          </button>
        </div>
        {loading ? (
          <div className="h-28 skeleton rounded-lg" />
        ) : (
          <>
            <ActivityChart data={activityData} />
            <div className="mt-3 flex items-center gap-2">
              <span className="text-lg">👍</span>
              <div>
                <p className="text-xs font-semibold text-dark">Great result!</p>
                <p className="text-xs text-gray-400">
                  {activityData.reduce((s, d) => s + (d.hours || 0), 0).toFixed(1)}h total this year
                </p>
              </div>
            </div>
          </>
        )}
      </div>

      {/* My Courses */}
      <div className="bg-white rounded-2xl p-5 shadow-sm">
        <div className="flex items-center justify-between mb-4">
          <h4 className="font-semibold text-dark text-sm">My Courses</h4>
          <button
            onClick={() => navigate('/courses')}
            className="text-xs text-gray-400 hover:text-dark transition-colors"
          >
            See all
          </button>
        </div>

        {loading ? (
          <div className="space-y-3">
            {[0, 1].map((i) => (
              <div key={i} className="skeleton h-16 rounded-xl" />
            ))}
          </div>
        ) : enrolledCourses.length === 0 ? (
          <div className="text-center py-4">
            <p className="text-xs text-gray-400">No courses enrolled yet</p>
            <button
              onClick={() => navigate('/courses')}
              className="text-xs font-medium text-dark mt-1 hover:underline"
            >
              Browse courses
            </button>
          </div>
        ) : (
          <div className="space-y-3">
            {enrolledCourses.map((enrollment) => (
              <div
                key={enrollment._id}
                className="flex items-center gap-3 p-2 rounded-xl hover:bg-gray-50 cursor-pointer transition-colors"
                onClick={() => navigate(`/courses/${enrollment.course?._id}`)}
              >
                <div
                  className="w-10 h-10 rounded-xl flex-shrink-0"
                  style={{ backgroundColor: enrollment.course?.color || '#f5d5d5' }}
                />
                <div className="flex-1 min-w-0">
                  <p className="text-xs font-semibold text-dark truncate">
                    {enrollment.course?.title || 'Course'}
                  </p>
                  <div className="flex items-center gap-2 mt-1">
                    <div className="flex-1 h-1 bg-gray-100 rounded-full overflow-hidden">
                      <div
                        className="h-full bg-dark rounded-full transition-all"
                        style={{ width: `${enrollment.progress || 0}%` }}
                      />
                    </div>
                    <span className="text-xs text-gray-400">{enrollment.progress || 0}%</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default UserProfilePanel;
