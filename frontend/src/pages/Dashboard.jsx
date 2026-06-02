import React, { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { useNavigate } from 'react-router-dom';
import Sidebar from '../components/Sidebar';
import CategoryFilter from '../components/CategoryFilter';
import CourseCard from '../components/CourseCard';
import UserProfilePanel from '../components/UserProfilePanel';
import Navbar from '../components/Navbar';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';
import { Sparkles, TrendingUp } from 'lucide-react';

const CATEGORIES = [
  'All',
  'IT & Software',
  'Media Training',
  'Business',
  'Data Science',
  'Digital Marketing',
  'Entrepreneurship',
  'Digital Citizenship',
];

const CourseCardSkeleton = () => (
  <div className="rounded-2xl overflow-hidden" style={{ backgroundColor: '#f0e8e0' }}>
    <div className="p-5">
      <div className="flex justify-between mb-4">
        <div className="skeleton h-6 w-24 rounded-full" />
        <div className="skeleton h-6 w-12 rounded-full" />
      </div>
      <div className="skeleton h-5 w-full rounded mb-2" />
      <div className="skeleton h-5 w-3/4 rounded mb-4" />
      <div className="skeleton h-5 w-16 rounded-full" />
    </div>
    <div className="px-5 pb-4 flex justify-between">
      <div className="skeleton h-4 w-16 rounded" />
      <div className="skeleton h-4 w-16 rounded" />
      <div className="flex -space-x-2">
        <div className="skeleton w-6 h-6 rounded-full" />
        <div className="skeleton w-6 h-6 rounded-full" />
      </div>
    </div>
  </div>
);

const Dashboard = () => {
  const [courses, setCourses] = useState([]);
  const [filteredCourses, setFilteredCourses] = useState([]);
  const [activeCategory, setActiveCategory] = useState('All');
  const [searchQuery, setSearchQuery] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const { user } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    fetchCourses();
  }, []);

  useEffect(() => {
    filterCourses();
  }, [courses, activeCategory, searchQuery]);

  const fetchCourses = async () => {
    try {
      setLoading(true);
      const response = await api.get('/courses');
      setCourses(response.data.courses || []);
    } catch (err) {
      setError('Failed to load courses');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const filterCourses = () => {
    let filtered = [...courses];
    if (activeCategory !== 'All') {
      filtered = filtered.filter((c) => c.category === activeCategory);
    }
    if (searchQuery) {
      const q = searchQuery.toLowerCase();
      filtered = filtered.filter(
        (c) =>
          c.title.toLowerCase().includes(q) ||
          c.description.toLowerCase().includes(q) ||
          (c.tags || []).some((t) => t.toLowerCase().includes(q))
      );
    }
    setFilteredCourses(filtered);
  };

  const handleCategorySelect = (category) => {
    setActiveCategory(category);
  };

  const handleSearch = (query) => {
    setSearchQuery(query);
  };

  const displayCourses = filteredCourses.slice(0, 4);
  const featuredCourse = courses.find((c) => c.rating >= 4.9);

  return (
    <div className="flex h-screen overflow-hidden bg-edubg">
      {/* Sidebar */}
      <Sidebar />

      {/* Main Content */}
      <main className="flex-1 overflow-y-auto px-6 py-6">
        <Navbar onSearch={handleSearch} />

        {/* Hero */}
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
          className="mb-6"
        >
          <div className="flex items-center gap-2 mb-1">
            <span className="text-sm font-medium text-gray-500">
              Hello, {user?.name?.split(' ')[0] || 'Learner'}! 👋
            </span>
          </div>
          <h1 className="text-3xl font-black text-dark leading-tight">
            Invest in your
            <span className="block text-transparent" style={{
              backgroundImage: 'linear-gradient(135deg, #1a1a2e, #4a4a8a)',
              WebkitBackgroundClip: 'text',
              WebkitTextFillColor: 'transparent',
              backgroundClip: 'text',
            }}>
              education
            </span>
          </h1>
          <p className="text-gray-500 text-sm mt-1">Discover courses that transform your career</p>
        </motion.div>

        {/* Category Filter */}
        <motion.div
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1, duration: 0.4 }}
          className="mb-6"
        >
          <CategoryFilter
            categories={CATEGORIES}
            activeCategory={activeCategory}
            onSelect={handleCategorySelect}
          />
        </motion.div>

        {/* Most Popular Section */}
        <motion.div
          initial={{ opacity: 0, y: 8 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2, duration: 0.4 }}
        >
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-2">
              <TrendingUp size={16} className="text-dark" />
              <h2 className="font-bold text-dark">Most popular</h2>
            </div>
            <span className="text-xs text-gray-400">{filteredCourses.length} courses</span>
          </div>

          {error && (
            <div className="bg-red-50 border border-red-200 text-red-600 text-sm px-4 py-3 rounded-xl mb-4">
              {error}
              <button onClick={fetchCourses} className="ml-2 underline">Retry</button>
            </div>
          )}

          <div className="grid grid-cols-2 gap-4">
            {loading
              ? Array.from({ length: 4 }).map((_, i) => <CourseCardSkeleton key={i} />)
              : displayCourses.length > 0
              ? displayCourses.map((course, index) => (
                  <motion.div
                    key={course._id}
                    initial={{ opacity: 0, y: 16 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: index * 0.08 }}
                  >
                    <CourseCard course={course} />
                  </motion.div>
                ))
              : (
                <div className="col-span-2 text-center py-12 text-gray-400">
                  <p className="text-lg mb-1">No courses found</p>
                  <p className="text-sm">Try a different category or search term</p>
                </div>
              )
            }
          </div>
        </motion.div>

        {/* Featured Course */}
        {featuredCourse && !loading && (
          <motion.div
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
            className="mt-8 mb-4"
          >
            <div className="flex items-center gap-2 mb-4">
              <Sparkles size={16} className="text-yellow-500" />
              <h2 className="font-bold text-dark">Featured course</h2>
            </div>
            <motion.div
              whileHover={{ scale: 1.01 }}
              className="rounded-2xl p-5 cursor-pointer"
              style={{ backgroundColor: featuredCourse.color || '#fde8c0' }}
              onClick={() => navigate(`/courses/${featuredCourse._id}`)}
            >
              <div className="flex items-start justify-between">
                <div className="flex-1">
                  <span className="text-xs font-semibold bg-white bg-opacity-70 px-3 py-1 rounded-full">
                    {featuredCourse.category}
                  </span>
                  <h3 className="font-bold text-dark text-lg mt-2 mb-1">{featuredCourse.title}</h3>
                  <p className="text-sm text-gray-600 line-clamp-2">{featuredCourse.description}</p>
                  <div className="flex items-center gap-4 mt-3">
                    <div className="flex items-center gap-1">
                      <span className="text-yellow-500">★</span>
                      <span className="text-sm font-semibold">{featuredCourse.rating}</span>
                    </div>
                    <span className="text-sm text-gray-500">{featuredCourse.totalStudents?.toLocaleString()} students</span>
                    <span className="text-sm text-gray-500">{featuredCourse.duration}</span>
                  </div>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </main>

      {/* Right Panel */}
      <aside className="px-4 py-6 overflow-y-auto">
        <UserProfilePanel />
      </aside>
    </div>
  );
};

export default Dashboard;
